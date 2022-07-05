Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2942B566D5C
	for <lists+stable@lfdr.de>; Tue,  5 Jul 2022 14:24:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236470AbiGEMWY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jul 2022 08:22:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237807AbiGEMTt (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jul 2022 08:19:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93B731DA78;
        Tue,  5 Jul 2022 05:16:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 97D80B817C7;
        Tue,  5 Jul 2022 12:16:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5A76C341C7;
        Tue,  5 Jul 2022 12:16:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657023374;
        bh=ZugFDSQz+fTvcYNX1zn1KG4BhIvAHdRMBg4Yrs99lBU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jxsnB/QxQLb/vU+6rhav0yLPF8qkPPdnOvTkg3EzNxLn8+t9F/70hPEtErqsY8ci9
         gmHfckQHCifb/JL+aNWPvWPlfl/w4L/nx9bxgco/wnlSc6Ftg7mXkAqkDNdyt8EAsV
         H5puM5ANhxBXWjHO7r/uLZo70MLwNX12xUqs8exY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hyunchul Lee <hyc.lee@gmail.com>,
        Namjae Jeon <linkinjeon@kernel.org>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.18 005/102] ksmbd: check invalid FileOffset and BeyondFinalZero in FSCTL_ZERO_DATA
Date:   Tue,  5 Jul 2022 13:57:31 +0200
Message-Id: <20220705115618.567741395@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220705115618.410217782@linuxfoundation.org>
References: <20220705115618.410217782@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Namjae Jeon <linkinjeon@kernel.org>

commit b5e5f9dfc915ff05b41dff56181e1dae101712bd upstream.

FileOffset should not be greater than BeyondFinalZero in FSCTL_ZERO_DATA.
And don't call ksmbd_vfs_zero_data() if length is zero.

Cc: stable@vger.kernel.org
Reviewed-by: Hyunchul Lee <hyc.lee@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ksmbd/smb2pdu.c |   29 ++++++++++++++++++-----------
 1 file changed, 18 insertions(+), 11 deletions(-)

--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -7705,7 +7705,7 @@ int smb2_ioctl(struct ksmbd_work *work)
 	{
 		struct file_zero_data_information *zero_data;
 		struct ksmbd_file *fp;
-		loff_t off, len;
+		loff_t off, len, bfz;
 
 		if (!test_tree_conn_flag(work->tcon, KSMBD_TREE_CONN_FLAG_WRITABLE)) {
 			ksmbd_debug(SMB,
@@ -7722,19 +7722,26 @@ int smb2_ioctl(struct ksmbd_work *work)
 		zero_data =
 			(struct file_zero_data_information *)&req->Buffer[0];
 
-		fp = ksmbd_lookup_fd_fast(work, id);
-		if (!fp) {
-			ret = -ENOENT;
+		off = le64_to_cpu(zero_data->FileOffset);
+		bfz = le64_to_cpu(zero_data->BeyondFinalZero);
+		if (off > bfz) {
+			ret = -EINVAL;
 			goto out;
 		}
 
-		off = le64_to_cpu(zero_data->FileOffset);
-		len = le64_to_cpu(zero_data->BeyondFinalZero) - off;
-
-		ret = ksmbd_vfs_zero_data(work, fp, off, len);
-		ksmbd_fd_put(work, fp);
-		if (ret < 0)
-			goto out;
+		len = bfz - off;
+		if (len) {
+			fp = ksmbd_lookup_fd_fast(work, id);
+			if (!fp) {
+				ret = -ENOENT;
+				goto out;
+			}
+
+			ret = ksmbd_vfs_zero_data(work, fp, off, len);
+			ksmbd_fd_put(work, fp);
+			if (ret < 0)
+				goto out;
+		}
 		break;
 	}
 	case FSCTL_QUERY_ALLOCATED_RANGES:


