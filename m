Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5417F1714CB
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 11:12:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728645AbgB0KMe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 05:12:34 -0500
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:47065 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728454AbgB0KMe (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Feb 2020 05:12:34 -0500
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id 7B7AF741;
        Thu, 27 Feb 2020 05:12:33 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Thu, 27 Feb 2020 05:12:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=oyWR7y
        aMFxkC2zsixnoB870kFxYsH7iJv/T/nZmEHus=; b=iaQpzIWT2fo0Sp2Zt+T1GX
        Xr7wXBqiNLYgk27IhB5CIS7tfUGpQSrtftvVJqkxfw3LGYVimgj8ZFMFxCKN3inK
        7NbaLpCgpeJJVUosBvasM0+uXbEa57nzZclqr5D2/6+7r4ciEDHz9aNV9Uuux5Iu
        XGUo+sT5JfqO165i5I5GokELIKjYYRxOE0wxVDcxbgujb67KNHnffxMcGZ/WBZ04
        mvPgbyby8LwgU2ppgepmO7yEnGjuvOiWE1pBQCiaPLkqab77UBYeeLLIfbPIDDYr
        jtE7/Rts3BL06bY/8Ftw+UbOk+FdqJre+UfMslgOPEt7AEDL5e8q3vNsDZQSWPAw
        ==
X-ME-Sender: <xms:EJZXXmyU1rr33dEZ3qGV-ZH8ew3grc5Oa1VYkOFt0j1HxydGpgqZcA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrleeigddugecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepkeefrdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgeptdenuc
    frrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:EJZXXmgva3PAU7u4ch58WKgoPN1f_kzvzqmShKvdf1S4PmvdKIlwMw>
    <xmx:EJZXXjWMxRaJHVz6-os80OZVEKWiZQ7rFBHOpjedGPlKktqht8sz-A>
    <xmx:EJZXXg1a73OBgfM2tYAAMpGRE66PVAeM5lZU1IuFbwXOHMCyaglPAg>
    <xmx:EZZXXhX1rl5unh0VyCoH5_5e5u1Ppy7BP8BiBrAD5ix9Y85GZRRAtQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 4A3993060FCB;
        Thu, 27 Feb 2020 05:12:32 -0500 (EST)
Subject: FAILED: patch "[PATCH] io_uring: prevent sq_thread from spinning when it should stop" failed to apply to 5.4-stable tree
To:     sgarzare@redhat.com, axboe@kernel.dk
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 27 Feb 2020 11:12:30 +0100
Message-ID: <1582798350247106@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 7143b5ac5750f404ff3a594b34fdf3fc2f99f828 Mon Sep 17 00:00:00 2001
From: Stefano Garzarella <sgarzare@redhat.com>
Date: Fri, 21 Feb 2020 16:42:16 +0100
Subject: [PATCH] io_uring: prevent sq_thread from spinning when it should stop

This patch drops 'cur_mm' before calling cond_resched(), to prevent
the sq_thread from spinning even when the user process is finished.

Before this patch, if the user process ended without closing the
io_uring fd, the sq_thread continues to spin until the
'sq_thread_idle' timeout ends.

In the worst case where the 'sq_thread_idle' parameter is bigger than
INT_MAX, the sq_thread will spin forever.

Fixes: 6c271ce2f1d5 ("io_uring: add submission polling")
Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 6e249aa97ba3..b43467b3a8dc 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5142,6 +5142,18 @@ static int io_sq_thread(void *data)
 		 * to enter the kernel to reap and flush events.
 		 */
 		if (!to_submit || ret == -EBUSY) {
+			/*
+			 * Drop cur_mm before scheduling, we can't hold it for
+			 * long periods (or over schedule()). Do this before
+			 * adding ourselves to the waitqueue, as the unuse/drop
+			 * may sleep.
+			 */
+			if (cur_mm) {
+				unuse_mm(cur_mm);
+				mmput(cur_mm);
+				cur_mm = NULL;
+			}
+
 			/*
 			 * We're polling. If we're within the defined idle
 			 * period, then let us spin without work before going
@@ -5156,18 +5168,6 @@ static int io_sq_thread(void *data)
 				continue;
 			}
 
-			/*
-			 * Drop cur_mm before scheduling, we can't hold it for
-			 * long periods (or over schedule()). Do this before
-			 * adding ourselves to the waitqueue, as the unuse/drop
-			 * may sleep.
-			 */
-			if (cur_mm) {
-				unuse_mm(cur_mm);
-				mmput(cur_mm);
-				cur_mm = NULL;
-			}
-
 			prepare_to_wait(&ctx->sqo_wait, &wait,
 						TASK_INTERRUPTIBLE);
 

