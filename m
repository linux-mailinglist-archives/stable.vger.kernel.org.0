Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B46B49127C
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 00:52:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233263AbiAQXww (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 18:52:52 -0500
Received: from mail-pl1-f174.google.com ([209.85.214.174]:44954 "EHLO
        mail-pl1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231768AbiAQXwu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 18:52:50 -0500
Received: by mail-pl1-f174.google.com with SMTP id v2so7885199ply.11;
        Mon, 17 Jan 2022 15:52:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=E3Vs4IXxZ1o53P+v4lST9asSyi4iNaTfykJHulxAP6I=;
        b=38Yw2iTO6o3QAQGw/srBNIoeGQ+tvzTIOOzpN0EPdlQa66302aMLRXCP5KjTPNonWo
         l0QavEZFwSLpJPj7p1xCO+RG+ZmECkqNzFV6852nri0IUAYXx8Qjk78ytLiVzNWL6sBu
         LHXOJpkU7fVCaROKUSw1LTE+PTTo3FCqKXN+XvZzuDQG/zfdufPSk+iUw8v9SMixmAo1
         xC5C/Z/yAGmaEnvOQNVI8Rb8JPy5b+AV9UphkkWxcgWvAZtUsPhKqYIzGYURlFmeuh39
         YXNmDq3Ti1ls3q7nfzd6rKWblpk2+J/d+2ZcxFOw4gj0lTxcwR1jHg57vdpXD9a887LV
         jKrw==
X-Gm-Message-State: AOAM5303/XuJuHEKhpemxomAwTgYyG2nLOX330FpJZeEdOwllUSm+8Pu
        VrKM+y2ZPJ7SkUs+HnXoCGp2fIl53t4=
X-Google-Smtp-Source: ABdhPJz4ZuSC9e8w3+8LhUWLe9QPlc2LklE09KfjXKRJLZVfJd2L4Hj4kOSjzkoNHa8F+bDJ71z6qg==
X-Received: by 2002:a17:902:8d82:b0:149:a740:d8d0 with SMTP id v2-20020a1709028d8200b00149a740d8d0mr25253359plo.5.1642463570215;
        Mon, 17 Jan 2022 15:52:50 -0800 (PST)
Received: from localhost.localdomain ([61.74.27.164])
        by smtp.gmail.com with ESMTPSA id x6sm12883412pge.50.2022.01.17.15.52.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Jan 2022 15:52:49 -0800 (PST)
From:   Namjae Jeon <linkinjeon@kernel.org>
To:     linux-cifs@vger.kernel.org
Cc:     Namjae Jeon <linkinjeon@kernel.org>, stable@vger.kernel.org
Subject: [PATCH] ksmbd: fix guest connection failure with nautilus
Date:   Tue, 18 Jan 2022 08:52:42 +0900
Message-Id: <20220117235242.9385-1-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
---
 fs/ksmbd/smb2pdu.c | 62 ++++++++++++++++++++++------------------------
 1 file changed, 29 insertions(+), 33 deletions(-)

diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index 15f331dbe17a..1866c81c5c99 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -1464,11 +1464,6 @@ static int ntlm_authenticate(struct ksmbd_work *work)
 	}
 
 	if (user_guest(sess->user)) {
-		if (conn->sign) {
-			ksmbd_debug(SMB, "Guest login not allowed when signing enabled\n");
-			return -EPERM;
-		}
-
 		rsp->SessionFlags = SMB2_SESSION_FLAG_IS_GUEST_LE;
 	} else {
 		struct authenticate_message *authblob;
@@ -1481,38 +1476,39 @@ static int ntlm_authenticate(struct ksmbd_work *work)
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
+	if ((rsp->SessionFlags != SMB2_SESSION_FLAG_IS_GUEST_LE &&
+	     (conn->sign || server_conf.enforced_signing)) ||
+	    (req->SecurityMode & SMB2_NEGOTIATE_SIGNING_REQUIRED))
+		sess->sign = true;
 
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
-- 
2.25.1

