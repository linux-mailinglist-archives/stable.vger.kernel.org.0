Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C907F31F15
	for <lists+stable@lfdr.de>; Sat,  1 Jun 2019 15:41:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728360AbfFANlk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 1 Jun 2019 09:41:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:46224 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728054AbfFANTD (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 1 Jun 2019 09:19:03 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5A3C027280;
        Sat,  1 Jun 2019 13:19:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559395142;
        bh=VJXdiM0UCZ55BzcrYVIp2IYpcyvmtSQqPebIULr9+q8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wF0iOvE0lxF6NtYRK12cIsNsKe5cVagjbpSqv8WKAfMopjd8demoELRH1E6ujrBVL
         jjWZxLZo6regZMRY6Jpfaxhelc6+WHl4neQ/yRPvC83fBfBfbWAOTso9Wjw8emqdK7
         mnO1Q/BtRg8wV+K592tqCmDJAScFKNr9wYfXr3go=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ronnie Sahlberg <lsahlber@redhat.com>,
        Pavel Shilovsky <pshilov@microsoft.com>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>, linux-cifs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.1 062/186] cifs: fix credits leak for SMB1 oplock breaks
Date:   Sat,  1 Jun 2019 09:14:38 -0400
Message-Id: <20190601131653.24205-62-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190601131653.24205-1-sashal@kernel.org>
References: <20190601131653.24205-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ronnie Sahlberg <lsahlber@redhat.com>

[ Upstream commit d69cb728e70c40268762182a62f5d5d6fa51c5b2 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/cifsglob.h  |  1 +
 fs/cifs/cifssmb.c   |  2 +-
 fs/cifs/transport.c | 10 +++++-----
 3 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 585ad3207cb12..607468948f72b 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -1687,6 +1687,7 @@ static inline bool is_retryable_error(int error)
 
 #define   CIFS_HAS_CREDITS 0x0400    /* already has credits */
 #define   CIFS_TRANSFORM_REQ 0x0800    /* transform request before sending */
+#define   CIFS_NO_SRV_RSP    0x1000    /* there is no server response */
 
 /* Security Flags: indicate type of session setup needed */
 #define   CIFSSEC_MAY_SIGN	0x00001
diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index f43747c062a70..6050851edcb82 100644
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
index 1de8e996e566f..72e242c49ca11 100644
--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -1054,8 +1054,11 @@ compound_send_recv(const unsigned int xid, struct cifs_ses *ses,
 
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
@@ -1076,9 +1079,6 @@ compound_send_recv(const unsigned int xid, struct cifs_ses *ses,
 		smb311_update_preauth_hash(ses, rqst[0].rq_iov,
 					   rqst[0].rq_nvec);
 
-	if ((flags & CIFS_TIMEOUT_MASK) == CIFS_ASYNC_OP)
-		goto out;
-
 	for (i = 0; i < num_rqst; i++) {
 		rc = wait_for_response(ses->server, midQ[i]);
 		if (rc != 0)
-- 
2.20.1

