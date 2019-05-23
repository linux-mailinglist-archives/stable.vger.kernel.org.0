Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7FC1D28953
	for <lists+stable@lfdr.de>; Thu, 23 May 2019 21:42:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391007AbfEWTeE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 May 2019 15:34:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:40936 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390480AbfEWT2U (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 May 2019 15:28:20 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1265D2133D;
        Thu, 23 May 2019 19:28:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558639699;
        bh=bN8c66YMo+ds7IH0flsHZO1my5TznSzb5kCnhbmqVKc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EtGdZlygvqrSdX/0+m7ULYl+TZFGqOVe8VLEMP51JgIyhxjrpqVqrrLpW8dzPVWpL
         nG/POav5421H6Hbu9aUexzHgsNJI7FHE1Icjg3+pMvb1JAm+wzIYDxVbbFsZOhSlRb
         S5MgHRRnuKu0fG+lFFsUphlPyfILgn0EhQWtD4cI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ronnie Sahlberg <lsahlber@redhat.com>,
        Pavel Shilovsky <pshilov@microsoft.com>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.1 046/122] cifs: fix credits leak for SMB1 oplock breaks
Date:   Thu, 23 May 2019 21:06:08 +0200
Message-Id: <20190523181710.786134323@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190523181705.091418060@linuxfoundation.org>
References: <20190523181705.091418060@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ronnie Sahlberg <lsahlber@redhat.com>

commit d69cb728e70c40268762182a62f5d5d6fa51c5b2 upstream.

For SMB1 oplock breaks we would grab one credit while sending the PDU
but we would never relese the credit back since we will never receive a
response to this from the server. Eventuallt this would lead to a hang
once all credits are leaked.

Fix this by defining a new flag CIFS_NO_SRV_RSP which indicates that there
is no server response to this command and thus we need to add any credits back
immediately after sending the PDU.

CC: Stable <stable@vger.kernel.org> #v5.0+
Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
Reviewed-by: Pavel Shilovsky <pshilov@microsoft.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/cifs/cifsglob.h  |    1 +
 fs/cifs/cifssmb.c   |    2 +-
 fs/cifs/transport.c |   10 +++++-----
 3 files changed, 7 insertions(+), 6 deletions(-)

--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -1687,6 +1687,7 @@ static inline bool is_retryable_error(in
 
 #define   CIFS_HAS_CREDITS 0x0400    /* already has credits */
 #define   CIFS_TRANSFORM_REQ 0x0800    /* transform request before sending */
+#define   CIFS_NO_SRV_RSP    0x1000    /* there is no server response */
 
 /* Security Flags: indicate type of session setup needed */
 #define   CIFSSEC_MAY_SIGN	0x00001
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -2540,7 +2540,7 @@ CIFSSMBLock(const unsigned int xid, stru
 
 	if (lockType == LOCKING_ANDX_OPLOCK_RELEASE) {
 		/* no response expected */
-		flags = CIFS_ASYNC_OP | CIFS_OBREAK_OP;
+		flags = CIFS_NO_SRV_RSP | CIFS_ASYNC_OP | CIFS_OBREAK_OP;
 		pSMB->Timeout = 0;
 	} else if (waitFlag) {
 		flags = CIFS_BLOCKING_OP; /* blocking operation, no timeout */
--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -1054,8 +1054,11 @@ compound_send_recv(const unsigned int xi
 
 	mutex_unlock(&ses->server->srv_mutex);
 
-	if (rc < 0) {
-		/* Sending failed for some reason - return credits back */
+	/*
+	 * If sending failed for some reason or it is an oplock break that we
+	 * will not receive a response to - return credits back
+	 */
+	if (rc < 0 || (flags & CIFS_NO_SRV_RSP)) {
 		for (i = 0; i < num_rqst; i++)
 			add_credits(ses->server, &credits[i], optype);
 		goto out;
@@ -1076,9 +1079,6 @@ compound_send_recv(const unsigned int xi
 		smb311_update_preauth_hash(ses, rqst[0].rq_iov,
 					   rqst[0].rq_nvec);
 
-	if ((flags & CIFS_TIMEOUT_MASK) == CIFS_ASYNC_OP)
-		goto out;
-
 	for (i = 0; i < num_rqst; i++) {
 		rc = wait_for_response(ses->server, midQ[i]);
 		if (rc != 0)


