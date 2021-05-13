Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8D0137FB89
	for <lists+stable@lfdr.de>; Thu, 13 May 2021 18:33:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232830AbhEMQeR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 May 2021 12:34:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:35364 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229687AbhEMQeQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 May 2021 12:34:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E2D2D61438;
        Thu, 13 May 2021 16:33:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620923586;
        bh=55ymi2uiRIUa4FJKqbz31Lb2fBkXoN4zUe9td29tyLw=;
        h=Subject:To:From:Date:From;
        b=PXbVPgMSvwHc6VLblfacCgyb2AYXbZYAyi4kT2vooKOB5EEpEcQaJKUoK1ZtE0iVS
         duwcNNS36JFvTplmFUyTiEZiWw7FFqnj59Qan6i9lYAq0mKYJ7t63+Md+atinZxtRf
         Yp5xrJ1i9q/iIYR1xuI7K+Czqinz60PrBO4Bi3VI=
Subject: patch "rapidio: handle create_workqueue() failure" added to char-misc-linus
To:     mail@anirudhrb.com, akpm@linux-foundation.org, alex.bou9@gmail.com,
        gregkh@linuxfoundation.org, mporter@kernel.crashing.org,
        stable@vger.kernel.org, torvalds@linux-foundation.org
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 13 May 2021 18:32:54 +0200
Message-ID: <1620923574866@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    rapidio: handle create_workqueue() failure

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 69ce3ae36dcb03cdf416b0862a45369ddbf50fdf Mon Sep 17 00:00:00 2001
From: Anirudh Rayabharam <mail@anirudhrb.com>
Date: Mon, 3 May 2021 13:57:12 +0200
Subject: rapidio: handle create_workqueue() failure

In case create_workqueue() fails, release all resources and return -ENOMEM
to caller to avoid potential NULL pointer deref later. Move up the
create_workequeue() call to return early and avoid unwinding the call to
riocm_rx_fill().

Cc: Alexandre Bounine <alex.bou9@gmail.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Anirudh Rayabharam <mail@anirudhrb.com>
Link: https://lore.kernel.org/r/20210503115736.2104747-46-gregkh@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/rapidio/rio_cm.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/rapidio/rio_cm.c b/drivers/rapidio/rio_cm.c
index e6c16f04f2b4..db4c265287ae 100644
--- a/drivers/rapidio/rio_cm.c
+++ b/drivers/rapidio/rio_cm.c
@@ -2127,6 +2127,14 @@ static int riocm_add_mport(struct device *dev,
 		return -ENODEV;
 	}
 
+	cm->rx_wq = create_workqueue(DRV_NAME "/rxq");
+	if (!cm->rx_wq) {
+		rio_release_inb_mbox(mport, cmbox);
+		rio_release_outb_mbox(mport, cmbox);
+		kfree(cm);
+		return -ENOMEM;
+	}
+
 	/*
 	 * Allocate and register inbound messaging buffers to be ready
 	 * to receive channel and system management requests
@@ -2137,7 +2145,6 @@ static int riocm_add_mport(struct device *dev,
 	cm->rx_slots = RIOCM_RX_RING_SIZE;
 	mutex_init(&cm->rx_lock);
 	riocm_rx_fill(cm, RIOCM_RX_RING_SIZE);
-	cm->rx_wq = create_workqueue(DRV_NAME "/rxq");
 	INIT_WORK(&cm->rx_work, rio_ibmsg_handler);
 
 	cm->tx_slot = 0;
-- 
2.31.1


