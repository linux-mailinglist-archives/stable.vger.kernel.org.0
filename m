Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFC87594895
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 02:09:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244724AbiHOXaM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 19:30:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353413AbiHOX2L (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 19:28:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C66AE14E12B;
        Mon, 15 Aug 2022 13:07:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CBA15B81158;
        Mon, 15 Aug 2022 20:07:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D359C433B5;
        Mon, 15 Aug 2022 20:07:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660594052;
        bh=RxDjTeYo2nNQwW/9yi+9WMD7splED4n7H/+zLWc2KMo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QGB5Vn5DjwfOEN/QaAPcP5QcUDf4F0kncXszJkg1gkvIOZToITgqXCjHDG3FSqhml
         vOJbt2JEb4RWEOt5wHJ+KqZcIZrVkH/S7dcDECESMz7OyOnmOlYvLmTZNbxfeO7e1V
         1EralQvYF1zSH4sXpUzkhoroof7UUcEW1GI6gX14=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marios Makassikis <mmakassikis@freebox.fr>,
        Namjae Jeon <linkinjeon@kernel.org>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 1048/1095] ksmbd: validate length in smb2_write()
Date:   Mon, 15 Aug 2022 20:07:27 +0200
Message-Id: <20220815180512.428425284@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marios Makassikis <mmakassikis@freebox.fr>

[ Upstream commit 158a66b245739e15858de42c0ba60fcf3de9b8e6 ]

The SMB2 Write packet contains data that is to be written
to a file or to a pipe. Depending on the client, there may
be padding between the header and the data field.
Currently, the length is validated only in the case padding
is present.

Since the DataOffset field always points to the beginning
of the data, there is no need to have a special case for
padding. By removing this, the length is validated in both
cases.

Signed-off-by: Marios Makassikis <mmakassikis@freebox.fr>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ksmbd/smb2pdu.c |   49 +++++++++++++++++++------------------------------
 1 file changed, 19 insertions(+), 30 deletions(-)

--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -6344,23 +6344,18 @@ static noinline int smb2_write_pipe(stru
 	length = le32_to_cpu(req->Length);
 	id = req->VolatileFileId;
 
-	if (le16_to_cpu(req->DataOffset) ==
-	    offsetof(struct smb2_write_req, Buffer)) {
-		data_buf = (char *)&req->Buffer[0];
-	} else {
-		if ((u64)le16_to_cpu(req->DataOffset) + length >
-		    get_rfc1002_len(work->request_buf)) {
-			pr_err("invalid write data offset %u, smb_len %u\n",
-			       le16_to_cpu(req->DataOffset),
-			       get_rfc1002_len(work->request_buf));
-			err = -EINVAL;
-			goto out;
-		}
-
-		data_buf = (char *)(((char *)&req->hdr.ProtocolId) +
-				le16_to_cpu(req->DataOffset));
+	if ((u64)le16_to_cpu(req->DataOffset) + length >
+	    get_rfc1002_len(work->request_buf)) {
+		pr_err("invalid write data offset %u, smb_len %u\n",
+		       le16_to_cpu(req->DataOffset),
+		       get_rfc1002_len(work->request_buf));
+		err = -EINVAL;
+		goto out;
 	}
 
+	data_buf = (char *)(((char *)&req->hdr.ProtocolId) +
+			   le16_to_cpu(req->DataOffset));
+
 	rpc_resp = ksmbd_rpc_write(work->sess, id, data_buf, length);
 	if (rpc_resp) {
 		if (rpc_resp->flags == KSMBD_RPC_ENOTIMPLEMENTED) {
@@ -6505,22 +6500,16 @@ int smb2_write(struct ksmbd_work *work)
 
 	if (req->Channel != SMB2_CHANNEL_RDMA_V1 &&
 	    req->Channel != SMB2_CHANNEL_RDMA_V1_INVALIDATE) {
-		if (le16_to_cpu(req->DataOffset) ==
-		    offsetof(struct smb2_write_req, Buffer)) {
-			data_buf = (char *)&req->Buffer[0];
-		} else {
-			if ((u64)le16_to_cpu(req->DataOffset) + length >
-			    get_rfc1002_len(work->request_buf)) {
-				pr_err("invalid write data offset %u, smb_len %u\n",
-				       le16_to_cpu(req->DataOffset),
-				       get_rfc1002_len(work->request_buf));
-				err = -EINVAL;
-				goto out;
-			}
-
-			data_buf = (char *)(((char *)&req->hdr.ProtocolId) +
-					le16_to_cpu(req->DataOffset));
+		if ((u64)le16_to_cpu(req->DataOffset) + length >
+		    get_rfc1002_len(work->request_buf)) {
+			pr_err("invalid write data offset %u, smb_len %u\n",
+			       le16_to_cpu(req->DataOffset),
+			       get_rfc1002_len(work->request_buf));
+			err = -EINVAL;
+			goto out;
 		}
+		data_buf = (char *)(((char *)&req->hdr.ProtocolId) +
+				    le16_to_cpu(req->DataOffset));
 
 		ksmbd_debug(SMB, "flags %u\n", le32_to_cpu(req->Flags));
 		if (le32_to_cpu(req->Flags) & SMB2_WRITEFLAG_WRITE_THROUGH)


