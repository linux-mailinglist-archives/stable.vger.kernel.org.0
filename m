Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 065AC6E41D0
	for <lists+stable@lfdr.de>; Mon, 17 Apr 2023 09:58:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230139AbjDQH6b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Apr 2023 03:58:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230445AbjDQH6G (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Apr 2023 03:58:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C15413D
        for <stable@vger.kernel.org>; Mon, 17 Apr 2023 00:58:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BA85560F8A
        for <stable@vger.kernel.org>; Mon, 17 Apr 2023 07:58:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DF7CC433EF;
        Mon, 17 Apr 2023 07:58:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681718281;
        bh=O5u9afjGa3Nc7jUaKpuhfRd9PR3I9Qc/3JgdDWIJsAU=;
        h=Subject:To:Cc:From:Date:From;
        b=Uy47erUPFIUcfD2cyuFNuzc9LmrUgjwunB1jUH7DfxIsOKZ6WZCgrh6TlneuelVBw
         HtrPq1r/xoEbdIIkRy4nyz66Z7M18EMoceuZoCCbNKmjgQhuYT1ltr9PkSckfj8fOA
         4QE7b8hMhyjVNCLj89i9FlAA5ugr6RK87gK7NTWA=
Subject: FAILED: patch "[PATCH] ksmbd: avoid out of bounds access in decode_preauth_ctxt()" failed to apply to 5.15-stable tree
To:     ddiss@suse.de, linkinjeon@kernel.org, stable@vger.kernel.org,
        stfrench@microsoft.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 17 Apr 2023 09:57:54 +0200
Message-ID: <2023041754-retread-approach-96af@gregkh>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

To reproduce the conflict and resubmit, you may use the following commands:

git fetch https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/ linux-5.15.y
git checkout FETCH_HEAD
git cherry-pick -x e7067a446264a7514fa1cfaa4052cdb6803bc6a2
# <resolve conflicts, build, test, etc.>
git commit -s
git send-email --to '<stable@vger.kernel.org>' --in-reply-to '2023041754-retread-approach-96af@gregkh' --subject-prefix 'PATCH 5.15.y' HEAD^..

Possible dependencies:

e7067a446264 ("ksmbd: avoid out of bounds access in decode_preauth_ctxt()")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From e7067a446264a7514fa1cfaa4052cdb6803bc6a2 Mon Sep 17 00:00:00 2001
From: David Disseldorp <ddiss@suse.de>
Date: Thu, 13 Apr 2023 23:49:57 +0900
Subject: [PATCH] ksmbd: avoid out of bounds access in decode_preauth_ctxt()

Confirm that the accessed pneg_ctxt->HashAlgorithms address sits within
the SMB request boundary; deassemble_neg_contexts() only checks that the
eight byte smb2_neg_context header + (client controlled) DataLength are
within the packet boundary, which is insufficient.

Checking for sizeof(struct smb2_preauth_neg_context) is overkill given
that the type currently assumes SMB311_SALT_SIZE bytes of trailing Salt.

Signed-off-by: David Disseldorp <ddiss@suse.de>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>

diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index 8af939a181be..67b7e766a06b 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -876,17 +876,21 @@ static void assemble_neg_contexts(struct ksmbd_conn *conn,
 }
 
 static __le32 decode_preauth_ctxt(struct ksmbd_conn *conn,
-				  struct smb2_preauth_neg_context *pneg_ctxt)
+				  struct smb2_preauth_neg_context *pneg_ctxt,
+				  int len_of_ctxts)
 {
-	__le32 err = STATUS_NO_PREAUTH_INTEGRITY_HASH_OVERLAP;
+	/*
+	 * sizeof(smb2_preauth_neg_context) assumes SMB311_SALT_SIZE Salt,
+	 * which may not be present. Only check for used HashAlgorithms[1].
+	 */
+	if (len_of_ctxts < MIN_PREAUTH_CTXT_DATA_LEN)
+		return STATUS_INVALID_PARAMETER;
 
-	if (pneg_ctxt->HashAlgorithms == SMB2_PREAUTH_INTEGRITY_SHA512) {
-		conn->preauth_info->Preauth_HashId =
-			SMB2_PREAUTH_INTEGRITY_SHA512;
-		err = STATUS_SUCCESS;
-	}
+	if (pneg_ctxt->HashAlgorithms != SMB2_PREAUTH_INTEGRITY_SHA512)
+		return STATUS_NO_PREAUTH_INTEGRITY_HASH_OVERLAP;
 
-	return err;
+	conn->preauth_info->Preauth_HashId = SMB2_PREAUTH_INTEGRITY_SHA512;
+	return STATUS_SUCCESS;
 }
 
 static void decode_encrypt_ctxt(struct ksmbd_conn *conn,
@@ -1014,7 +1018,8 @@ static __le32 deassemble_neg_contexts(struct ksmbd_conn *conn,
 				break;
 
 			status = decode_preauth_ctxt(conn,
-						     (struct smb2_preauth_neg_context *)pctx);
+						     (struct smb2_preauth_neg_context *)pctx,
+						     len_of_ctxts);
 			if (status != STATUS_SUCCESS)
 				break;
 		} else if (pctx->ContextType == SMB2_ENCRYPTION_CAPABILITIES) {

