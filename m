Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF7922CFD79
	for <lists+stable@lfdr.de>; Sat,  5 Dec 2020 19:53:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726600AbgLESed (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 5 Dec 2020 13:34:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:58736 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726658AbgLESe2 (ORCPT <rfc822;Stable@vger.kernel.org>);
        Sat, 5 Dec 2020 13:34:28 -0500
Subject: patch "iio: imu: st_lsm6dsx: fix edge-trigger interrupts" added to staging-next
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1607183321;
        bh=TFBNMuuIy2mnh2VlW8Dv3fYqlLqAP9lqBTpaHx2ykPQ=;
        h=To:From:Date:From;
        b=c7ALxsbi1NK5aMWAq4R+5du5GO0AO0ptvzS9X9EDC+6rVJtEwitiSLPRPiSmT0dV1
         +WfUMZAPm6lFcZHPpSk92aPS+Hiyw6xJQiuDmv5ELvQBUg2kDZYrAf67xzpZg9vjpf
         Tp/tq3M52HfUORvxKOv7Wo1UbD/gDFBFBJW6JNwI=
To:     lorenzo@kernel.org, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 05 Dec 2020 16:46:12 +0100
Message-ID: <1607183172112214@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio: imu: st_lsm6dsx: fix edge-trigger interrupts

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-next branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will also be merged in the next major kernel release
during the merge window.

If you have any questions about this process, please let me know.


From 3f9bce7a22a3f8ac9d885c9d75bc45569f24ac8b Mon Sep 17 00:00:00 2001
From: Lorenzo Bianconi <lorenzo@kernel.org>
Date: Sat, 14 Nov 2020 19:39:05 +0100
Subject: iio: imu: st_lsm6dsx: fix edge-trigger interrupts

If we are using edge IRQs, new samples can arrive while processing
current interrupt since there are no hw guarantees the irq line
stays "low" long enough to properly detect the new interrupt.
In this case the new sample will be missed.
Polling FIFO status register in st_lsm6dsx_handler_thread routine
allow us to read new samples even if the interrupt arrives while
processing previous data and the timeslot where the line is "low"
is too short to be properly detected.

Fixes: 89ca88a7cdf2 ("iio: imu: st_lsm6dsx: support active-low interrupts")
Fixes: 290a6ce11d93 ("iio: imu: add support to lsm6dsx driver")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Link: https://lore.kernel.org/r/5e93cda7dc1e665f5685c53ad8e9ea71dbae782d.1605378871.git.lorenzo@kernel.org
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_core.c | 26 ++++++++++++++++----
 1 file changed, 21 insertions(+), 5 deletions(-)

diff --git a/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_core.c b/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_core.c
index 467214e2e77c..7cedaab096a7 100644
--- a/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_core.c
+++ b/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_core.c
@@ -2069,19 +2069,35 @@ st_lsm6dsx_report_motion_event(struct st_lsm6dsx_hw *hw)
 static irqreturn_t st_lsm6dsx_handler_thread(int irq, void *private)
 {
 	struct st_lsm6dsx_hw *hw = private;
+	int fifo_len = 0, len;
 	bool event;
-	int count;
 
 	event = st_lsm6dsx_report_motion_event(hw);
 
 	if (!hw->settings->fifo_ops.read_fifo)
 		return event ? IRQ_HANDLED : IRQ_NONE;
 
-	mutex_lock(&hw->fifo_lock);
-	count = hw->settings->fifo_ops.read_fifo(hw);
-	mutex_unlock(&hw->fifo_lock);
+	/*
+	 * If we are using edge IRQs, new samples can arrive while
+	 * processing current interrupt since there are no hw
+	 * guarantees the irq line stays "low" long enough to properly
+	 * detect the new interrupt. In this case the new sample will
+	 * be missed.
+	 * Polling FIFO status register allow us to read new
+	 * samples even if the interrupt arrives while processing
+	 * previous data and the timeslot where the line is "low" is
+	 * too short to be properly detected.
+	 */
+	do {
+		mutex_lock(&hw->fifo_lock);
+		len = hw->settings->fifo_ops.read_fifo(hw);
+		mutex_unlock(&hw->fifo_lock);
+
+		if (len > 0)
+			fifo_len += len;
+	} while (len > 0);
 
-	return count || event ? IRQ_HANDLED : IRQ_NONE;
+	return fifo_len || event ? IRQ_HANDLED : IRQ_NONE;
 }
 
 static int st_lsm6dsx_irq_setup(struct st_lsm6dsx_hw *hw)
-- 
2.29.2


