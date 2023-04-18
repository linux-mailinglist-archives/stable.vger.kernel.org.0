Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69E806E64F2
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 14:53:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232210AbjDRMxs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 08:53:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232233AbjDRMxn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 08:53:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 747E516F84
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 05:53:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0C843629B0
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 12:53:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20C39C4339B;
        Tue, 18 Apr 2023 12:53:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681822394;
        bh=+dnhBPc/YfgR9BLsubh3mk4uFixd5cRxmk+2Yv1vbGY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jwTW9lZXT+BBXYZQF+2vKhY0fdGwu0bag5XXPRdnoX8EC0KihKq8h0sjPrcQhSrvI
         wWVBU+3wGJY2XhDslN8DtCB49LZ4QEa0wuI4tMs/PYK4bdSHL58H915tPwMfdJhcjw
         F6mMsRQL2A3mCXhe1Iod8YGQoGX7JCQffIH6M0v8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, David Disseldorp <ddiss@suse.de>,
        Namjae Jeon <linkinjeon@kernel.org>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.2 103/139] ksmbd: avoid out of bounds access in decode_preauth_ctxt()
Date:   Tue, 18 Apr 2023 14:22:48 +0200
Message-Id: <20230418120317.665282002@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120313.725598495@linuxfoundation.org>
References: <20230418120313.725598495@linuxfoundation.org>
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

commit e7067a446264a7514fa1cfaa4052cdb6803bc6a2 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ksmbd/smb2pdu.c |   23 ++++++++++++++---------
 1 file changed, 14 insertions(+), 9 deletions(-)

--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -872,17 +872,21 @@ static void assemble_neg_contexts(struct
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
@@ -1010,7 +1014,8 @@ static __le32 deassemble_neg_contexts(st
 				break;
 
 			status = decode_preauth_ctxt(conn,
-						     (struct smb2_preauth_neg_context *)pctx);
+						     (struct smb2_preauth_neg_context *)pctx,
+						     len_of_ctxts);
 			if (status != STATUS_SUCCESS)
 				break;
 		} else if (pctx->ContextType == SMB2_ENCRYPTION_CAPABILITIES) {


