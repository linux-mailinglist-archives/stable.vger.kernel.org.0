Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D09A27806
	for <lists+stable@lfdr.de>; Thu, 23 May 2019 10:33:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726310AbfEWIdL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 May 2019 04:33:11 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:36733 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725814AbfEWIdL (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 May 2019 04:33:11 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 1901B2DE7D;
        Thu, 23 May 2019 04:33:10 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Thu, 23 May 2019 04:33:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=bsb2wN
        4u7WVAYsD7uSmtLjGk9WAHppEQqF16EFshjdI=; b=AzbKzWg7R7fGn1LOrc3sRF
        OlRxuf8yQVLlmhrSrqVi5VUXBFmMxMj1VGLrg1Dyj1njsPq2pqGQ9Cm/0wk2wyXe
        wk8cGUrqNWO99A7gQ80x0/9rkP9XXMdT04wfmw3Bq5TsNfeK/eNuc+BxIuUAaSNK
        VZ8Q2V3o8IZjbM623/BuVdZWh3TVt9XoIcwcRG7KUAidCMirUIw6Os8Wz8EMKiGy
        Pgl4CWT2Ml8R1lCDA0qND/enFuwQgwT5H6Ti1WCddhezgh/ClFObEP//odjE35Kc
        e6nXWqmWpW3iO/gyMz3u8VLTfT359T8t37GI5TkGPKqHRdY+WL4G+Jx/bUaOuE8g
        ==
X-ME-Sender: <xms:xVrmXJ9IG07DkmugjJnJWG8HglTDhmac3c7MyGyknQmqSZyOQX894g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddruddugedgtdeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekfedrkeeirdekledruddtjeenucfrrghrrghmpehmrghilhhfrhhomh
    epghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:xVrmXM4VjoW2yA-kMp2tKVU8F3HB_w5h9atefWHBJkIk4jXSyDfP5A>
    <xmx:xVrmXNO5cMPYbvZ37qe0BI9C7YQytbr6sODHCtJLUUSM5Pml-W1E5g>
    <xmx:xVrmXO_6K4AkGMf9pJI8V96fO_PPiHd-sa8Gr8KuCSHGfa99v_R-Ow>
    <xmx:xlrmXOXkzAhR0DV7qBNFdHBAwsKtwqEjyPOwBSJ51ucQzA9jOkBO5Q>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 2802638008A;
        Thu, 23 May 2019 04:33:08 -0400 (EDT)
Subject: FAILED: patch "[PATCH] cifs: fix credits leak for SMB1 oplock breaks" failed to apply to 5.0-stable tree
To:     lsahlber@redhat.com, pshilov@microsoft.com, stable@vger.kernel.org,
        stfrench@microsoft.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 23 May 2019 10:33:07 +0200
Message-ID: <155860038724087@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.0-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From d69cb728e70c40268762182a62f5d5d6fa51c5b2 Mon Sep 17 00:00:00 2001
From: Ronnie Sahlberg <lsahlber@redhat.com>
Date: Wed, 1 May 2019 12:03:41 +1000
Subject: [PATCH] cifs: fix credits leak for SMB1 oplock breaks

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

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 5ffe0e538cec..65faad3aa69a 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -1703,6 +1703,7 @@ static inline bool is_retryable_error(int error)
 
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

