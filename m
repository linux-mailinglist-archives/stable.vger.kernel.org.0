Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D01B838EE6D
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 17:49:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233249AbhEXPuz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 11:50:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:35156 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234513AbhEXPrf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 11:47:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C955F61416;
        Mon, 24 May 2021 15:37:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621870632;
        bh=o+GyRoW6tVYJFg5ygPEDk8ouNulvrjmiE7rvNFCY9mc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2QDAN17BRDPG7jBBnHIHwcC1ss3AgAmIH89vUqXWn5r1woaaQbnelZBgN9YdnbXB8
         FGS2OXl6T1aa2XFYAUPYvBmZFwR9wH4lK9mIrk5vGs+RAzrZlNEx9OKx9sCtfpI0Cj
         oGKvIx2VeS4448v3/oZDynOTEpLwRhZKXVvh7LQg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexandre Bounine <alex.bou9@gmail.com>,
        Matt Porter <mporter@kernel.crashing.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Anirudh Rayabharam <mail@anirudhrb.com>
Subject: [PATCH 5.4 35/71] rapidio: handle create_workqueue() failure
Date:   Mon, 24 May 2021 17:25:41 +0200
Message-Id: <20210524152327.608843438@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210524152326.447759938@linuxfoundation.org>
References: <20210524152326.447759938@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anirudh Rayabharam <mail@anirudhrb.com>

commit 69ce3ae36dcb03cdf416b0862a45369ddbf50fdf upstream.

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
 drivers/rapidio/rio_cm.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/drivers/rapidio/rio_cm.c
+++ b/drivers/rapidio/rio_cm.c
@@ -2127,6 +2127,14 @@ static int riocm_add_mport(struct device
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
@@ -2137,7 +2145,6 @@ static int riocm_add_mport(struct device
 	cm->rx_slots = RIOCM_RX_RING_SIZE;
 	mutex_init(&cm->rx_lock);
 	riocm_rx_fill(cm, RIOCM_RX_RING_SIZE);
-	cm->rx_wq = create_workqueue(DRV_NAME "/rxq");
 	INIT_WORK(&cm->rx_work, rio_ibmsg_handler);
 
 	cm->tx_slot = 0;


