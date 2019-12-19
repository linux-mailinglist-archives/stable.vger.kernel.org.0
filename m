Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30227126B85
	for <lists+stable@lfdr.de>; Thu, 19 Dec 2019 19:57:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728463AbfLSS50 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Dec 2019 13:57:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:52626 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730775AbfLSS4K (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Dec 2019 13:56:10 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B776F24679;
        Thu, 19 Dec 2019 18:56:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576781769;
        bh=HaRorocpD35JNXQ/vtSF4X4qwl0NGYvERY6bEGeqHVs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TD5F8RFoN95vSPgv6M0uRgeuSRfRBghfHcIF5PgjIm63lt42N/yxmR4dTYYfPy9nA
         /PrKK6aqjuRlOAZEvXdjJJEXuyQ1n0AxBD3C2h10lTyH+X5O9oGScKm3uDppLhHb7w
         jzrVVXIKDqTKTwTJ14VdSrC00Ka11zrIi6tenVNg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Frank Sorenson <sorenson@redhat.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        Pavel Shilovsky <pshilov@microsoft.com>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.4 36/80] CIFS: Do not miss cancelled OPEN responses
Date:   Thu, 19 Dec 2019 19:34:28 +0100
Message-Id: <20191219183107.361460846@linuxfoundation.org>
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

commit 7b71843fa7028475b052107664cbe120156a2cfc upstream.

When an OPEN command is cancelled we mark a mid as
cancelled and let the demultiplex thread process it
by closing an open handle. The problem is there is
a race between a system call thread and the demultiplex
thread and there may be a situation when the mid has
been already processed before it is set as cancelled.

Fix this by processing cancelled requests when mids
are being destroyed which means that there is only
one thread referencing a particular mid. Also set
mids as cancelled unconditionally on their state.

Cc: Stable <stable@vger.kernel.org>
Tested-by: Frank Sorenson <sorenson@redhat.com>
Reviewed-by: Ronnie Sahlberg <lsahlber@redhat.com>
Signed-off-by: Pavel Shilovsky <pshilov@microsoft.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/cifs/connect.c   |    6 ------
 fs/cifs/transport.c |   10 ++++++++--
 2 files changed, 8 insertions(+), 8 deletions(-)

--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -1222,12 +1222,6 @@ next_pdu:
 		for (i = 0; i < num_mids; i++) {
 			if (mids[i] != NULL) {
 				mids[i]->resp_buf_size = server->pdu_size;
-				if ((mids[i]->mid_flags & MID_WAIT_CANCELLED) &&
-				    mids[i]->mid_state == MID_RESPONSE_RECEIVED &&
-				    server->ops->handle_cancelled_mid)
-					server->ops->handle_cancelled_mid(
-							mids[i]->resp_buf,
-							server);
 
 				if (!mids[i]->multiRsp || mids[i]->multiEnd)
 					mids[i]->callback(mids[i]);
--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -93,8 +93,14 @@ static void _cifs_mid_q_entry_release(st
 	__u16 smb_cmd = le16_to_cpu(midEntry->command);
 	unsigned long now;
 	unsigned long roundtrip_time;
-	struct TCP_Server_Info *server = midEntry->server;
 #endif
+	struct TCP_Server_Info *server = midEntry->server;
+
+	if (midEntry->resp_buf && (midEntry->mid_flags & MID_WAIT_CANCELLED) &&
+	    midEntry->mid_state == MID_RESPONSE_RECEIVED &&
+	    server->ops->handle_cancelled_mid)
+		server->ops->handle_cancelled_mid(midEntry->resp_buf, server);
+
 	midEntry->mid_state = MID_FREE;
 	atomic_dec(&midCount);
 	if (midEntry->large_buf)
@@ -1122,8 +1128,8 @@ compound_send_recv(const unsigned int xi
 				 midQ[i]->mid, le16_to_cpu(midQ[i]->command));
 			send_cancel(server, &rqst[i], midQ[i]);
 			spin_lock(&GlobalMid_Lock);
+			midQ[i]->mid_flags |= MID_WAIT_CANCELLED;
 			if (midQ[i]->mid_state == MID_REQUEST_SUBMITTED) {
-				midQ[i]->mid_flags |= MID_WAIT_CANCELLED;
 				midQ[i]->callback = cifs_cancelled_callback;
 				cancelled_mid[i] = true;
 				credits[i].value = 0;


