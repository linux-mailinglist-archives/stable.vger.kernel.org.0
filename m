Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D40D28D64
	for <lists+stable@lfdr.de>; Fri, 24 May 2019 00:47:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387688AbfEWWrx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 May 2019 18:47:53 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:38481 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387546AbfEWWrx (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 May 2019 18:47:53 -0400
Received: by mail-pl1-f193.google.com with SMTP id f97so3324520plb.5
        for <stable@vger.kernel.org>; Thu, 23 May 2019 15:47:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=RkptR1FUH+sxG7wzcynSy1/Q9Fpv8dCEH+Bxdf3qSag=;
        b=Soa7f3aKCbXnRmdn5YVnYy5xi3Tj8Let+H+/RsZh5BN52b2xz4M2Lk7ncFKQNrRLef
         LlmSSMWk/N2+m8WQX00l6IqEzU40RGSd4h4xcpSRLuBU63wKa5vMEMfzGi59kTtLfebR
         mPYOsljQyEoUEgXET4omWyr5FmE5kKgszmHeN5jWQjaM+J4jxOucszHu/TRbdKmNaAi8
         /0BV4lkRJ52sFQ3G77f1eWGXsEKgmoeSK/ekGMHJuLmxRyqIvM6MQycB/kdmA/kQTmL7
         6CSDLz0NSJepByKn+zLJ8qLE+HaZMAlSQ6y3SZF1tcfiKd2nwOchYkpTijgRv3LhqVMR
         hPsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=RkptR1FUH+sxG7wzcynSy1/Q9Fpv8dCEH+Bxdf3qSag=;
        b=eHef9TkJgFzg1g0nPW/nqWYxpM7q+Al2LvaC87hSGn242LSS4nnXkGUou0t+Q9cMAE
         JOU9Q57GKOQe3/yGkNtDYsqlfhLC+tY6YalRWsV3dMWwqnxuFhxJIQgrX0CBNK8sFvpx
         dGmfP55aS5+R9UigQh9EuS5G3xqByXliNTbE49wJnU4iSm5WJqT/ed2IVthKvDdXiD/1
         WUm8wBXTnK53aKzpL/jbGGdIsbcDjocTCiEUdHeJ8w+LDcwM5842+Cg6cYItiGEzJWMO
         FaS6GAFPZN6XluU4RB3QOR5w6LuDPZUHWVcos0mPpH4YYJ+qaro08c7MO9xWd55A7fqi
         vkIA==
X-Gm-Message-State: APjAAAVGrRHWYo3U8UY1pMhFUk7/jV2wYtlmcdCPKmi9AkGhouPuIT23
        Ckr+f3SWOnW65hwM1rfuNd54JQU=
X-Google-Smtp-Source: APXvYqynrqtkMCgMw59k38krnChCf5iJUDK/bKL1YI6Ea4KtTFAoLHS4lHW6VHDORif2E7Qki1sSfg==
X-Received: by 2002:a17:902:9a07:: with SMTP id v7mr102715416plp.180.1558651671732;
        Thu, 23 May 2019 15:47:51 -0700 (PDT)
Received: from ubuntu-vm.mshome.net ([131.107.147.234])
        by smtp.gmail.com with ESMTPSA id g8sm488914pfk.83.2019.05.23.15.47.50
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Thu, 23 May 2019 15:47:50 -0700 (PDT)
From:   Pavel Shilovsky <piastryyy@gmail.com>
X-Google-Original-From: Pavel Shilovsky <pshilov@microsoft.com>
To:     stable@vger.kernel.org
Cc:     Ronnie Sahlberg <lsahlber@redhat.com>,
        Pavel Shilovsky <pshilov@microsoft.com>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH] cifs: fix credits leak for SMB1 oplock breaks
Date:   Thu, 23 May 2019 15:47:44 -0700
Message-Id: <1558651664-25756-1-git-send-email-pshilov@microsoft.com>
X-Mailer: git-send-email 2.7.4
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ronnie Sahlberg <lsahlber@redhat.com>

Commit d69cb728e70c ("cifs: fix credits leak for SMB1 oplock breaks").

For SMB1 oplock breaks we would grab one credit while sending the PDU
but we would never relese the credit back since we will never receive a
response to this from the server. Eventuallt this would lead to a hang
once all credits are leaked.

Fix this by defining a new flag CIFS_NO_SRV_RSP which indicates that there
is no server response to this command and thus we need to add any credits
back immediately after sending the PDU.

CC: Stable <stable@vger.kernel.org> #v5.0+
Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
Reviewed-by: Pavel Shilovsky <pshilov@microsoft.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/cifs/cifsglob.h  |  1 +
 fs/cifs/cifssmb.c   |  2 +-
 fs/cifs/transport.c | 10 +++++-----
 3 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 10ead04..8c295e3 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -1657,6 +1657,7 @@ static inline bool is_retryable_error(int error)
 
 #define   CIFS_HAS_CREDITS 0x0400    /* already has credits */
 #define   CIFS_TRANSFORM_REQ 0x0800    /* transform request before sending */
+#define   CIFS_NO_SRV_RSP    0x1000    /* there is no server response */
 
 /* Security Flags: indicate type of session setup needed */
 #define   CIFSSEC_MAY_SIGN	0x00001
diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index 551924b..f91e714 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -2533,7 +2533,7 @@ CIFSSMBLock(const unsigned int xid, struct cifs_tcon *tcon,
 
 	if (lockType == LOCKING_ANDX_OPLOCK_RELEASE) {
 		/* no response expected */
-		flags = CIFS_ASYNC_OP | CIFS_OBREAK_OP;
+		flags = CIFS_NO_SRV_RSP | CIFS_ASYNC_OP | CIFS_OBREAK_OP;
 		pSMB->Timeout = 0;
 	} else if (waitFlag) {
 		flags = CIFS_BLOCKING_OP; /* blocking operation, no timeout */
diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
index 9544eb9..95f3be9 100644
--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -906,8 +906,11 @@ compound_send_recv(const unsigned int xid, struct cifs_ses *ses,
 
 	mutex_unlock(&ses->server->srv_mutex);
 
-	if (rc < 0) {
-		/* Sending failed for some reason - return credits back */
+	/*
+	 * If sending failed for some reason or it is an oplock break that we
+	 * will not receive a response to - return credits back
+	 */
+	if (rc < 0 || (flags & CIFS_NO_SRV_RSP)) {
 		for (i = 0; i < num_rqst; i++)
 			add_credits(ses->server, credits[i], optype);
 		goto out;
@@ -928,9 +931,6 @@ compound_send_recv(const unsigned int xid, struct cifs_ses *ses,
 		smb311_update_preauth_hash(ses, rqst[0].rq_iov,
 					   rqst[0].rq_nvec);
 
-	if (timeout == CIFS_ASYNC_OP)
-		goto out;
-
 	for (i = 0; i < num_rqst; i++) {
 		rc = wait_for_response(ses->server, midQ[i]);
 		if (rc != 0)
-- 
2.7.4

