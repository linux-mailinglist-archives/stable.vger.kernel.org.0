Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E9454991B0
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 21:14:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355354AbiAXUNa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:13:30 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:38048 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243990AbiAXUL2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:11:28 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D3BB86091B;
        Mon, 24 Jan 2022 20:11:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5947C36AF9;
        Mon, 24 Jan 2022 20:11:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643055086;
        bh=MM6JVk+Uapq/hQtW5GIQkGoyXljUX4rnKq+QBWgsLxM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H6Pp1LZVksR5zuhOG0640yByXnlB9T2lA3R3ovtVB1C+ddwTdoXX/sYauBzQPJSzz
         d7atiUyynKaak+TAIVH+6NmaGZv/Rh8OV/MPE8N2ghg5BrIscILnK8tSoWr0aLY5Tp
         YVHK8+2+bwzx4G0KrljwQKn2GNYTFvVAgksSZhSE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Namjae Jeon <linkinjeon@kernel.org>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.15 035/846] ksmbd: fix guest connection failure with nautilus
Date:   Mon, 24 Jan 2022 19:32:32 +0100
Message-Id: <20220124184102.155872424@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Namjae Jeon <linkinjeon@kernel.org>

commit ac090d9c90b087d6fb714e54b2a6dd1e6c373ed6 upstream.

MS-SMB2 describe session sign like the following.
Session.SigningRequired MUST be set to TRUE under the following conditions:
 - If the SMB2_NEGOTIATE_SIGNING_REQUIRED bit is set in the SecurityMode
   field of the client request.
 - If the SMB2_SESSION_FLAG_IS_GUEST bit is not set in the SessionFlags
   field and Session.IsAnonymous is FALSE and either Connection.ShouldSign
   or global RequireMessageSigning is TRUE.

When trying guest account connection using nautilus, The login failure
happened on session setup. ksmbd does not allow this connection
when the user is a guest and the connection sign is set. Just do not set
session sign instead of error response as described in the specification.
And this change improves the guest connection in Nautilus.

Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Cc: stable@vger.kernel.org # v5.15+
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ksmbd/smb2pdu.c |   64 ++++++++++++++++++++++++-----------------------------
 1 file changed, 30 insertions(+), 34 deletions(-)

--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -1457,11 +1457,6 @@ static int ntlm_authenticate(struct ksmb
 
 	sess->user = user;
 	if (user_guest(sess->user)) {
-		if (conn->sign) {
-			ksmbd_debug(SMB, "Guest login not allowed when signing enabled\n");
-			return -EPERM;
-		}
-
 		rsp->SessionFlags = SMB2_SESSION_FLAG_IS_GUEST_LE;
 	} else {
 		struct authenticate_message *authblob;
@@ -1474,38 +1469,39 @@ static int ntlm_authenticate(struct ksmb
 			ksmbd_debug(SMB, "authentication failed\n");
 			return -EPERM;
 		}
+	}
 
-		/*
-		 * If session state is SMB2_SESSION_VALID, We can assume
-		 * that it is reauthentication. And the user/password
-		 * has been verified, so return it here.
-		 */
-		if (sess->state == SMB2_SESSION_VALID) {
-			if (conn->binding)
-				goto binding_session;
-			return 0;
-		}
+	/*
+	 * If session state is SMB2_SESSION_VALID, We can assume
+	 * that it is reauthentication. And the user/password
+	 * has been verified, so return it here.
+	 */
+	if (sess->state == SMB2_SESSION_VALID) {
+		if (conn->binding)
+			goto binding_session;
+		return 0;
+	}
 
-		if ((conn->sign || server_conf.enforced_signing) ||
-		    (req->SecurityMode & SMB2_NEGOTIATE_SIGNING_REQUIRED))
-			sess->sign = true;
-
-		if (smb3_encryption_negotiated(conn) &&
-		    !(req->Flags & SMB2_SESSION_REQ_FLAG_BINDING)) {
-			rc = conn->ops->generate_encryptionkey(sess);
-			if (rc) {
-				ksmbd_debug(SMB,
-					    "SMB3 encryption key generation failed\n");
-				return -EINVAL;
-			}
-			sess->enc = true;
-			rsp->SessionFlags = SMB2_SESSION_FLAG_ENCRYPT_DATA_LE;
-			/*
-			 * signing is disable if encryption is enable
-			 * on this session
-			 */
-			sess->sign = false;
+	if ((rsp->SessionFlags != SMB2_SESSION_FLAG_IS_GUEST_LE &&
+	     (conn->sign || server_conf.enforced_signing)) ||
+	    (req->SecurityMode & SMB2_NEGOTIATE_SIGNING_REQUIRED))
+		sess->sign = true;
+
+	if (smb3_encryption_negotiated(conn) &&
+			!(req->Flags & SMB2_SESSION_REQ_FLAG_BINDING)) {
+		rc = conn->ops->generate_encryptionkey(sess);
+		if (rc) {
+			ksmbd_debug(SMB,
+					"SMB3 encryption key generation failed\n");
+			return -EINVAL;
 		}
+		sess->enc = true;
+		rsp->SessionFlags = SMB2_SESSION_FLAG_ENCRYPT_DATA_LE;
+		/*
+		 * signing is disable if encryption is enable
+		 * on this session
+		 */
+		sess->sign = false;
 	}
 
 binding_session:


