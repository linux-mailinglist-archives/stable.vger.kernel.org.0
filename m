Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF4C538EDC9
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 17:41:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233296AbhEXPmE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 11:42:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:58038 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233583AbhEXPkQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 11:40:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 52B6661430;
        Mon, 24 May 2021 15:34:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621870447;
        bh=gAC8X44v/DAW6Ft4kgj+eMny2o3mMGv0TRRVGZTyjj0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HE7buHkBWHXqeLH1rf5RLi01OMhbRIYkQFpBXsJvMXT58uOAcMaiLhGHWxl6MBDC+
         QWKQrVi7L+wCkuVGwyClhL0cw6oogmR848olWQk+a6YgdUWFYYWn56qAN1XHpsOxJS
         qL+Gm8Yc/jiwAstDrR84T5ivhw+DvccNJ64okFZk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kangjie Lu <kjlu@umn.edu>,
        Alexandre Bounine <alex.bou9@gmail.com>,
        Matt Porter <mporter@kernel.crashing.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.14 11/37] Revert "rapidio: fix a NULL pointer dereference when create_workqueue() fails"
Date:   Mon, 24 May 2021 17:25:15 +0200
Message-Id: <20210524152324.576543251@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210524152324.199089755@linuxfoundation.org>
References: <20210524152324.199089755@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit 5e68b86c7b7c059c0f0ec4bf8adabe63f84a61eb upstream.

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
Link: https://lore.kernel.org/r/20210503115736.2104747-45-gregkh@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/rapidio/rio_cm.c |    8 --------
 1 file changed, 8 deletions(-)

--- a/drivers/rapidio/rio_cm.c
+++ b/drivers/rapidio/rio_cm.c
@@ -2147,14 +2147,6 @@ static int riocm_add_mport(struct device
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


