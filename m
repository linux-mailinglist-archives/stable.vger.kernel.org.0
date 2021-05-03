Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C40713714D5
	for <lists+stable@lfdr.de>; Mon,  3 May 2021 14:02:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233741AbhECMBj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 May 2021 08:01:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:35750 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233853AbhECMBK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 May 2021 08:01:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D74F361221;
        Mon,  3 May 2021 12:00:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620043215;
        bh=uAZZo7cSdLjSCDJ2h/Cmf2iZAPT4lTtDenzdsC4Goiw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L30B7P3xcaKZ9MWQsBgYe1ov1yM0EDzAJ5nBtkUucxGTTebo/0vMu2Gpd8ZhVQI+q
         USpE9vn1/USqOmflwjcnvYmJ7GIHzLnY9YbeSsV4Rtqo/gZb73hO0Lc0xzZ48Q5pW0
         g0m1KZdpfHqaHpCg3YwDHsr9G+q+8nCBshNoab0c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kangjie Lu <kjlu@umn.edu>,
        Alexandre Bounine <alex.bou9@gmail.com>,
        Matt Porter <mporter@kernel.crashing.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        stable <stable@vger.kernel.org>
Subject: [PATCH 44/69] Revert "rapidio: fix a NULL pointer dereference when create_workqueue() fails"
Date:   Mon,  3 May 2021 13:57:11 +0200
Message-Id: <20210503115736.2104747-45-gregkh@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210503115736.2104747-1-gregkh@linuxfoundation.org>
References: <20210503115736.2104747-1-gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This reverts commit 23015b22e47c5409620b1726a677d69e5cd032ba.

Because of recent interactions with developers from @umn.edu, all
commits from them have been recently re-reviewed to ensure if they were
correct or not.

Upon review, this commit was found to be incorrect for the reasons
below, so it must be reverted.  It will be fixed up "correctly" in a
later kernel change.

The original commit has a memory leak on the error path here, it does
not clean up everything properly.

Cc: Kangjie Lu <kjlu@umn.edu>
Cc: Alexandre Bounine <alex.bou9@gmail.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Fixes: 23015b22e47c ("rapidio: fix a NULL pointer dereference when create_workqueue() fails")
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/rapidio/rio_cm.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/drivers/rapidio/rio_cm.c b/drivers/rapidio/rio_cm.c
index 50ec53d67a4c..e6c16f04f2b4 100644
--- a/drivers/rapidio/rio_cm.c
+++ b/drivers/rapidio/rio_cm.c
@@ -2138,14 +2138,6 @@ static int riocm_add_mport(struct device *dev,
 	mutex_init(&cm->rx_lock);
 	riocm_rx_fill(cm, RIOCM_RX_RING_SIZE);
 	cm->rx_wq = create_workqueue(DRV_NAME "/rxq");
-	if (!cm->rx_wq) {
-		riocm_error("failed to allocate IBMBOX_%d on %s",
-			    cmbox, mport->name);
-		rio_release_outb_mbox(mport, cmbox);
-		kfree(cm);
-		return -ENOMEM;
-	}
-
 	INIT_WORK(&cm->rx_work, rio_ibmsg_handler);
 
 	cm->tx_slot = 0;
-- 
2.31.1

