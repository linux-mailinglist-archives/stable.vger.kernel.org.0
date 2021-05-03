Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69CBB3714D7
	for <lists+stable@lfdr.de>; Mon,  3 May 2021 14:02:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233771AbhECMBl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 May 2021 08:01:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:35076 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233745AbhECMBP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 May 2021 08:01:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3EFAC6137D;
        Mon,  3 May 2021 12:00:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620043217;
        bh=UrknPItb2AbCNnahCklZXeZnyfWxAgAVFiRoW5gXZLI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z3GWTfGg1P0eH0lCpTdcSp+wlKoCXjEFyyNu4cdJmAjhizo/gK3k7vzZGvAIOX0f7
         a0MtSr+6YPfdiS+l3V4SBl4NPRhqrq+/in+ftRwOMM1TnKSIUXmecfUyptOMXgAgz9
         y5JcbHVEbJGJLPRRZNpBSpKUT6aQpUrne62FT1Hc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Anirudh Rayabharam <mail@anirudhrb.com>,
        Alexandre Bounine <alex.bou9@gmail.com>,
        Matt Porter <mporter@kernel.crashing.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        stable <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 45/69] rapidio: handle create_workqueue() failure
Date:   Mon,  3 May 2021 13:57:12 +0200
Message-Id: <20210503115736.2104747-46-gregkh@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210503115736.2104747-1-gregkh@linuxfoundation.org>
References: <20210503115736.2104747-1-gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anirudh Rayabharam <mail@anirudhrb.com>

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

