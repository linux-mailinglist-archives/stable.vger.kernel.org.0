Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC8D16E6432
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 14:46:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232026AbjDRMq5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 08:46:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232025AbjDRMq4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 08:46:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C96B14F75
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 05:46:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EC7DB633AE
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 12:46:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 045CFC433EF;
        Tue, 18 Apr 2023 12:46:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681822014;
        bh=qD7DoLbDeFsWhvdCSOJ5OAayrjgOYTRWYbMVYo35hrc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qdcQ8BCuucBpKHCfkMNdrjfbNzopILBTDgw01pHkxJop7N7668QsOnYNQgUTTBRdC
         Tyba2W48I0yNihGzL45fZbsT0AlMYyYj+2dTzg+OJl/oOLPAjnPfLvpPQEUpAkQxTD
         nA/ogw1C0/e8JzJye9mhxYwbq/KxqREOMMbOyxXs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Volker Lendecke <vl@samba.org>,
        "Paulo Alcantara (SUSE)" <pc@manguebit.com>,
        David Disseldorp <ddiss@suse.de>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 125/134] cifs: fix negotiate context parsing
Date:   Tue, 18 Apr 2023 14:23:01 +0200
Message-Id: <20230418120317.535756405@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120313.001025904@linuxfoundation.org>
References: <20230418120313.001025904@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Disseldorp <ddiss@suse.de>

[ Upstream commit 5105a7ffce19160e7062aee67fb6b3b8a1b56d78 ]

smb311_decode_neg_context() doesn't properly check against SMB packet
boundaries prior to accessing individual negotiate context entries. This
is due to the length check omitting the eight byte smb2_neg_context
header, as well as incorrect decrementing of len_of_ctxts.

Fixes: 5100d8a3fe03 ("SMB311: Improve checking of negotiate security contexts")
Reported-by: Volker Lendecke <vl@samba.org>
Reviewed-by: Paulo Alcantara (SUSE) <pc@manguebit.com>
Signed-off-by: David Disseldorp <ddiss@suse.de>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/smb2pdu.c | 41 +++++++++++++++++++++++++++++++----------
 1 file changed, 31 insertions(+), 10 deletions(-)

diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index b37379b62cc77..ab59faf8a06a7 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -588,11 +588,15 @@ assemble_neg_contexts(struct smb2_negotiate_req *req,
 
 }
 
+/* If invalid preauth context warn but use what we requested, SHA-512 */
 static void decode_preauth_context(struct smb2_preauth_neg_context *ctxt)
 {
 	unsigned int len = le16_to_cpu(ctxt->DataLength);
 
-	/* If invalid preauth context warn but use what we requested, SHA-512 */
+	/*
+	 * Caller checked that DataLength remains within SMB boundary. We still
+	 * need to confirm that one HashAlgorithms member is accounted for.
+	 */
 	if (len < MIN_PREAUTH_CTXT_DATA_LEN) {
 		pr_warn_once("server sent bad preauth context\n");
 		return;
@@ -611,7 +615,11 @@ static void decode_compress_ctx(struct TCP_Server_Info *server,
 {
 	unsigned int len = le16_to_cpu(ctxt->DataLength);
 
-	/* sizeof compress context is a one element compression capbility struct */
+	/*
+	 * Caller checked that DataLength remains within SMB boundary. We still
+	 * need to confirm that one CompressionAlgorithms member is accounted
+	 * for.
+	 */
 	if (len < 10) {
 		pr_warn_once("server sent bad compression cntxt\n");
 		return;
@@ -633,6 +641,11 @@ static int decode_encrypt_ctx(struct TCP_Server_Info *server,
 	unsigned int len = le16_to_cpu(ctxt->DataLength);
 
 	cifs_dbg(FYI, "decode SMB3.11 encryption neg context of len %d\n", len);
+	/*
+	 * Caller checked that DataLength remains within SMB boundary. We still
+	 * need to confirm that one Cipher flexible array member is accounted
+	 * for.
+	 */
 	if (len < MIN_ENCRYPT_CTXT_DATA_LEN) {
 		pr_warn_once("server sent bad crypto ctxt len\n");
 		return -EINVAL;
@@ -679,6 +692,11 @@ static void decode_signing_ctx(struct TCP_Server_Info *server,
 {
 	unsigned int len = le16_to_cpu(pctxt->DataLength);
 
+	/*
+	 * Caller checked that DataLength remains within SMB boundary. We still
+	 * need to confirm that one SigningAlgorithms flexible array member is
+	 * accounted for.
+	 */
 	if ((len < 4) || (len > 16)) {
 		pr_warn_once("server sent bad signing negcontext\n");
 		return;
@@ -720,14 +738,19 @@ static int smb311_decode_neg_context(struct smb2_negotiate_rsp *rsp,
 	for (i = 0; i < ctxt_cnt; i++) {
 		int clen;
 		/* check that offset is not beyond end of SMB */
-		if (len_of_ctxts == 0)
-			break;
-
 		if (len_of_ctxts < sizeof(struct smb2_neg_context))
 			break;
 
 		pctx = (struct smb2_neg_context *)(offset + (char *)rsp);
-		clen = le16_to_cpu(pctx->DataLength);
+		clen = sizeof(struct smb2_neg_context)
+			+ le16_to_cpu(pctx->DataLength);
+		/*
+		 * 2.2.4 SMB2 NEGOTIATE Response
+		 * Subsequent negotiate contexts MUST appear at the first 8-byte
+		 * aligned offset following the previous negotiate context.
+		 */
+		if (i + 1 != ctxt_cnt)
+			clen = ALIGN(clen, 8);
 		if (clen > len_of_ctxts)
 			break;
 
@@ -748,12 +771,10 @@ static int smb311_decode_neg_context(struct smb2_negotiate_rsp *rsp,
 		else
 			cifs_server_dbg(VFS, "unknown negcontext of type %d ignored\n",
 				le16_to_cpu(pctx->ContextType));
-
 		if (rc)
 			break;
-		/* offsets must be 8 byte aligned */
-		clen = ALIGN(clen, 8);
-		offset += clen + sizeof(struct smb2_neg_context);
+
+		offset += clen;
 		len_of_ctxts -= clen;
 	}
 	return rc;
-- 
2.39.2



