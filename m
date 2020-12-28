Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 581682E3EB6
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:32:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503680AbgL1Obz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:31:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:38964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2504401AbgL1ObY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:31:24 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A24ED207B2;
        Mon, 28 Dec 2020 14:31:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165869;
        bh=W7pSCyKOlJXrAxmKWRx59qwpgcKSPHu8XN2FiSUblOM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qYbNfi9nuik6GZ5HXiwI1QN3TnDFP7046TdSWH5NnNXsXy8Pfyn/xM/7HE42ayuP+
         t80F5I89mCR5Uh4GUAvQFZ4/q5uA/t4VeeAFBi6g7IBRVrPE2d/n+UFHMlFoNNotEE
         jULyiS/AmaG4xV3xf/F6JAikMKWAZ3TBYwFzZTp0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lorenzo Bianconi <lorenzo@kernel.org>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.10 676/717] iio: imu: st_lsm6dsx: fix edge-trigger interrupts
Date:   Mon, 28 Dec 2020 13:51:14 +0100
Message-Id: <20201228125053.370159550@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lorenzo Bianconi <lorenzo@kernel.org>

commit 3f9bce7a22a3f8ac9d885c9d75bc45569f24ac8b upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_core.c |   26 +++++++++++++++++++++-----
 1 file changed, 21 insertions(+), 5 deletions(-)

--- a/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_core.c
+++ b/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_core.c
@@ -2255,19 +2255,35 @@ st_lsm6dsx_report_motion_event(struct st
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
 
-	return count || event ? IRQ_HANDLED : IRQ_NONE;
+		if (len > 0)
+			fifo_len += len;
+	} while (len > 0);
+
+	return fifo_len || event ? IRQ_HANDLED : IRQ_NONE;
 }
 
 static int st_lsm6dsx_irq_setup(struct st_lsm6dsx_hw *hw)


