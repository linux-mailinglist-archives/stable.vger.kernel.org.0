Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 32188103C8
	for <lists+stable@lfdr.de>; Wed,  1 May 2019 04:03:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727083AbfEACDw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Apr 2019 22:03:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43444 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726115AbfEACDw (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 30 Apr 2019 22:03:52 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 1553330832C2;
        Wed,  1 May 2019 02:03:52 +0000 (UTC)
Received: from test1135.test.redhat.com (vpn2-54-54.bne.redhat.com [10.64.54.54])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6E48318A46;
        Wed,  1 May 2019 02:03:51 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>, Stable <stable@vger.kernel.org>,
        Pavel Shilovsky <pshilov@microsoft.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>
Subject: [PATCH] cifs: fix credits leak for SMB1 oplock breaks
Date:   Wed,  1 May 2019 12:03:41 +1000
Message-Id: <20190501020341.9146-1-lsahlber@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.44]); Wed, 01 May 2019 02:03:52 +0000 (UTC)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
---
 fs/cifs/cifsglob.h  |  1 +
 fs/cifs/cifssmb.c   |  2 +-
 fs/cifs/transport.c | 10 +++++-----
 3 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 621640195713..7a65124f70f9 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -1701,6 +1701,7 @@ static inline bool is_retryable_error(int error)
 
 #define   CIFS_HAS_CREDITS 0x0400    /* already has credits */
 #define   CIFS_TRANSFORM_REQ 0x0800    /* transform request before sending */
+#define   CIFS_NO_SRV_RSP    0x1000    /* there is no server response */
 
 /* Security Flags: indicate type of session setup needed */
 #define   CIFSSEC_MAY_SIGN	0x00001
diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index f43747c062a7..6050851edcb8 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -2540,7 +2540,7 @@ CIFSSMBLock(const unsigned int xid, struct cifs_tcon *tcon,
 
 	if (lockType == LOCKING_ANDX_OPLOCK_RELEASE) {
 		/* no response expected */
-		flags = CIFS_ASYNC_OP | CIFS_OBREAK_OP;
+		flags = CIFS_NO_SRV_RSP | CIFS_ASYNC_OP | CIFS_OBREAK_OP;
 		pSMB->Timeout = 0;
 	} else if (waitFlag) {
 		flags = CIFS_BLOCKING_OP; /* blocking operation, no timeout */
diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
index 5c59c498f56a..5573e38b13f3 100644
--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -1073,8 +1073,11 @@ compound_send_recv(const unsigned int xid, struct cifs_ses *ses,
 
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
@@ -1095,9 +1098,6 @@ compound_send_recv(const unsigned int xid, struct cifs_ses *ses,
 		smb311_update_preauth_hash(ses, rqst[0].rq_iov,
 					   rqst[0].rq_nvec);
 
-	if ((flags & CIFS_TIMEOUT_MASK) == CIFS_ASYNC_OP)
-		goto out;
-
 	for (i = 0; i < num_rqst; i++) {
 		rc = wait_for_response(ses->server, midQ[i]);
 		if (rc != 0)
-- 
2.13.6

