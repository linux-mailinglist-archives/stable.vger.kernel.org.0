Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 05FE3126029
	for <lists+stable@lfdr.de>; Thu, 19 Dec 2019 11:58:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726668AbfLSK6H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Dec 2019 05:58:07 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:44381 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726636AbfLSK6H (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 Dec 2019 05:58:07 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 15BD8223F1;
        Thu, 19 Dec 2019 05:58:06 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Thu, 19 Dec 2019 05:58:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=6tAWS/
        2kAOP9SB67TE2xmov78Bczw/rJ1LFk+xESOZM=; b=UBjnIv/A540m3JGo7b795U
        zUOJH1AKf/Gm/6UQZsvBUcOrgPOq2vrohgCrhft5TcyA6yJh42p8t9OMrfOvkk0+
        eP+LTqO7FWYMW2qIPrfaJJ339L892GDYO8RU3dszy525dYULwKYj43FgEUbrdm4i
        T/3ErEuGOhmR4OzAXmjbZnfrH2iCWZU4dvxrhsIIgs4aK8QrALd8rxgPFPXcYkn4
        sbJwssqSkWAam/ysyj4pLK0azWDIWIpfsXu4TCneTjmBCErv3is/9zCgsfS8k8R6
        mqaE2j454itXKxBDGAdCZ9lXX1BDTSBdkRzPXbNOOvNBhKNxSlyv2frk0ps2CS0g
        ==
X-ME-Sender: <xms:vVf7XSLGwS56Ajn25jD8Fx8U9A7RJbfh_xtlMqpRrpXqGK9ov_kA4Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrvdduuddgvddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekfedrkeeirdekledruddtjeenucfrrghrrghmpehmrghilhhfrhhomh
    epghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:vVf7XWfVhuVqc53-eK8Qpq_zYrRKLog3Z5_nJLfEJJh4Hr6Rb0hBvQ>
    <xmx:vVf7XVdwFvrmaBLvkc4YIVYQXRStQ28jlNc10hiLdVr8dX3TtSfozg>
    <xmx:vVf7XZOeQ3_dapwJidR80NQ-NTO9B_aVao8_-AVls8GBBtfRdgJypw>
    <xmx:vlf7XaLEXhbPNtEtqaQ4BjijNTIKFv2iu4_Kox7L_tElBWMAeb6OtA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 96A28306074E;
        Thu, 19 Dec 2019 05:58:05 -0500 (EST)
Subject: FAILED: patch "[PATCH] CIFS: Do not miss cancelled OPEN responses" failed to apply to 4.19-stable tree
To:     pshilov@microsoft.com, lsahlber@redhat.com, sorenson@redhat.com,
        stable@vger.kernel.org, stfrench@microsoft.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 19 Dec 2019 11:58:04 +0100
Message-ID: <157675308417202@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 7b71843fa7028475b052107664cbe120156a2cfc Mon Sep 17 00:00:00 2001
From: Pavel Shilovsky <pshilov@microsoft.com>
Date: Thu, 21 Nov 2019 11:35:14 -0800
Subject: [PATCH] CIFS: Do not miss cancelled OPEN responses

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

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 40b2a173ba0d..a7a026795bc2 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -1237,12 +1237,6 @@ cifs_demultiplex_thread(void *p)
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
diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
index f27842fb9f75..19300e0cf1d6 100644
--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -93,8 +93,14 @@ static void _cifs_mid_q_entry_release(struct kref *refcount)
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
@@ -1119,8 +1125,8 @@ compound_send_recv(const unsigned int xid, struct cifs_ses *ses,
 				 midQ[i]->mid, le16_to_cpu(midQ[i]->command));
 			send_cancel(server, &rqst[i], midQ[i]);
 			spin_lock(&GlobalMid_Lock);
+			midQ[i]->mid_flags |= MID_WAIT_CANCELLED;
 			if (midQ[i]->mid_state == MID_REQUEST_SUBMITTED) {
-				midQ[i]->mid_flags |= MID_WAIT_CANCELLED;
 				midQ[i]->callback = cifs_cancelled_callback;
 				cancelled_mid[i] = true;
 				credits[i].value = 0;

