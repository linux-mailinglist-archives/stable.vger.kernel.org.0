Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 41726126B68
	for <lists+stable@lfdr.de>; Thu, 19 Dec 2019 19:57:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727903AbfLSS4R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Dec 2019 13:56:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:52784 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730791AbfLSS4R (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Dec 2019 13:56:17 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0FAE9206EC;
        Thu, 19 Dec 2019 18:56:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576781776;
        bh=BahGp/WcvJzSgRLqgRvYNiiQbWUBKF2w/g8tzngIBnw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NdFRQq3L+VZRXlbVAM++tUdiftVhk56eb4Ci1+FKYSLeI3OBEyXAN2Lwefmek0VvN
         3bmh+AZzmj1dySJpzE0/Lgd4hBGHhBKCuQsUFaVxNcIUEsBHr5SdzlH5sHE65D8NJy
         sgEezNPB4Y3gMyADgkecXivJTE2Y1LrqXg4GW1rE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Frank Sorenson <sorenson@redhat.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        Pavel Shilovsky <pshilov@microsoft.com>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.4 37/80] CIFS: Fix NULL pointer dereference in mid callback
Date:   Thu, 19 Dec 2019 19:34:29 +0100
Message-Id: <20191219183107.612439697@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191219183031.278083125@linuxfoundation.org>
References: <20191219183031.278083125@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Shilovsky <pshilov@microsoft.com>

commit 86a7964be7afaf3df6b64faaa10a7032d2444e51 upstream.

There is a race between a system call processing thread
and the demultiplex thread when mid->resp_buf becomes NULL
and later is being accessed to get credits. It happens when
the 1st thread wakes up before a mid callback is called in
the 2nd one but the mid state has already been set to
MID_RESPONSE_RECEIVED. This causes NULL pointer dereference
in mid callback.

Fix this by saving credits from the response before we
update the mid state and then use this value in the mid
callback rather then accessing a response buffer.

Cc: Stable <stable@vger.kernel.org>
Fixes: ee258d79159afed5 ("CIFS: Move credit processing to mid callbacks for SMB3")
Tested-by: Frank Sorenson <sorenson@redhat.com>
Reviewed-by: Ronnie Sahlberg <lsahlber@redhat.com>
Signed-off-by: Pavel Shilovsky <pshilov@microsoft.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/cifs/cifsglob.h |    1 +
 fs/cifs/connect.c  |   15 +++++++++++++++
 fs/cifs/smb2ops.c  |    8 +-------
 3 files changed, 17 insertions(+), 7 deletions(-)

--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -1524,6 +1524,7 @@ struct mid_q_entry {
 	struct TCP_Server_Info *server;	/* server corresponding to this mid */
 	__u64 mid;		/* multiplex id */
 	__u16 credits;		/* number of credits consumed by this mid */
+	__u16 credits_received;	/* number of credits from the response */
 	__u32 pid;		/* process id */
 	__u32 sequence_number;  /* for CIFS signing */
 	unsigned long when_alloc;  /* when mid was created */
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -905,6 +905,20 @@ dequeue_mid(struct mid_q_entry *mid, boo
 	spin_unlock(&GlobalMid_Lock);
 }
 
+static unsigned int
+smb2_get_credits_from_hdr(char *buffer, struct TCP_Server_Info *server)
+{
+	struct smb2_sync_hdr *shdr = (struct smb2_sync_hdr *)buffer;
+
+	/*
+	 * SMB1 does not use credits.
+	 */
+	if (server->vals->header_preamble_size)
+		return 0;
+
+	return le16_to_cpu(shdr->CreditRequest);
+}
+
 static void
 handle_mid(struct mid_q_entry *mid, struct TCP_Server_Info *server,
 	   char *buf, int malformed)
@@ -912,6 +926,7 @@ handle_mid(struct mid_q_entry *mid, stru
 	if (server->ops->check_trans2 &&
 	    server->ops->check_trans2(mid, server, buf, malformed))
 		return;
+	mid->credits_received = smb2_get_credits_from_hdr(buf, server);
 	mid->resp_buf = buf;
 	mid->large_buf = server->large_buf;
 	/* Was previous buf put in mpx struct for multi-rsp? */
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -151,13 +151,7 @@ smb2_get_credits_field(struct TCP_Server
 static unsigned int
 smb2_get_credits(struct mid_q_entry *mid)
 {
-	struct smb2_sync_hdr *shdr = (struct smb2_sync_hdr *)mid->resp_buf;
-
-	if (mid->mid_state == MID_RESPONSE_RECEIVED
-	    || mid->mid_state == MID_RESPONSE_MALFORMED)
-		return le16_to_cpu(shdr->CreditRequest);
-
-	return 0;
+	return mid->credits_received;
 }
 
 static int


