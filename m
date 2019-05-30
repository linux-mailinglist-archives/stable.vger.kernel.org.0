Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A4C952F3E8
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:34:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729491AbfE3EdQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 00:33:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:58800 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729481AbfE3DNa (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:13:30 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3FD1C24558;
        Thu, 30 May 2019 03:13:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186009;
        bh=zS/mtP419U35zPbFURmoEAfOjtToTryk78bmtyeQoqc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U5JXNo3MlXgC0dWdmA1tjJuBHGAZrdw0PO3qNq4Gtanpc8TpaCTiAyNycjJ5Yn7Yd
         dkYtizKS7N/pcGCZT5sRRxx2Q7PlspXoOQUv5tmLwhMoIYc3AHSSMgY+mHH6aFTbhv
         JaDqfOb47sUzfKtkJjMuTp0VU9doQ/eyRKaw8tUY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ronnie Sahlberg <lsahlber@redhat.com>,
        Pavel Shilovsky <pshilov@microsoft.com>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.0 024/346] cifs: fix credits leak for SMB1 oplock breaks
Date:   Wed, 29 May 2019 20:01:37 -0700
Message-Id: <20190530030541.955558148@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030540.363386121@linuxfoundation.org>
References: <20190530030540.363386121@linuxfoundation.org>
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
@@ -1657,6 +1657,7 @@ static inline bool is_retryable_error(in
 
 #define   CIFS_HAS_CREDITS 0x0400    /* already has credits */
 #define   CIFS_TRANSFORM_REQ 0x0800    /* transform request before sending */
+#define   CIFS_NO_SRV_RSP    0x1000    /* there is no server response */
 
 /* Security Flags: indicate type of session setup needed */
 #define   CIFSSEC_MAY_SIGN	0x00001
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -2533,7 +2533,7 @@ CIFSSMBLock(const unsigned int xid, stru
 
 	if (lockType == LOCKING_ANDX_OPLOCK_RELEASE) {
 		/* no response expected */
-		flags = CIFS_ASYNC_OP | CIFS_OBREAK_OP;
+		flags = CIFS_NO_SRV_RSP | CIFS_ASYNC_OP | CIFS_OBREAK_OP;
 		pSMB->Timeout = 0;
 	} else if (waitFlag) {
 		flags = CIFS_BLOCKING_OP; /* blocking operation, no timeout */
--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -906,8 +906,11 @@ compound_send_recv(const unsigned int xi
 
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
@@ -928,9 +931,6 @@ compound_send_recv(const unsigned int xi
 		smb311_update_preauth_hash(ses, rqst[0].rq_iov,
 					   rqst[0].rq_nvec);
 
-	if (timeout == CIFS_ASYNC_OP)
-		goto out;
-
 	for (i = 0; i < num_rqst; i++) {
 		rc = wait_for_response(ses->server, midQ[i]);
 		if (rc != 0)


