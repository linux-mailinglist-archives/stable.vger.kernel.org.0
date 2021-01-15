Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 654812F791C
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 13:34:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732666AbhAOMbc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 07:31:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:36412 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732655AbhAOMbb (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Jan 2021 07:31:31 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7BAC5235F8;
        Fri, 15 Jan 2021 12:31:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610713865;
        bh=T1ZqFLYYqF004QD5vkX34Vl9/pY2PW6cv416TriwQYE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OohF+Zi0Doik54S5g6McjVXzYgDoo3CL9tJo2JYbRHig/51c7dEZ1+Su/1Yqc4ftG
         jH5redHnmirMf6J+7/VdASU3FmzwLLndiWXrzL2q7AI4hqCUJ5v60gb+/60MMS9Bw7
         RTs/dXYCkePbpZLu5wbZxlx7T3+xua2Opk4oxH5k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lorenzo Bianconi <lorenzo@kernel.org>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: [PATCH 4.14 13/28] iio: imu: st_lsm6dsx: fix edge-trigger interrupts
Date:   Fri, 15 Jan 2021 13:27:50 +0100
Message-Id: <20210115121957.413861346@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210115121956.731354372@linuxfoundation.org>
References: <20210115121956.731354372@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lorenzo Bianconi <lorenzo@kernel.org>

commit 3f9bce7a22a3f8ac9d885c9d75bc45569f24ac8b upstream

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
[sudip: manual backport to old irq handler path]
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_buffer.c |   26 ++++++++++++++++++++-----
 1 file changed, 21 insertions(+), 5 deletions(-)

--- a/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_buffer.c
+++ b/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_buffer.c
@@ -395,13 +395,29 @@ static irqreturn_t st_lsm6dsx_handler_ir
 static irqreturn_t st_lsm6dsx_handler_thread(int irq, void *private)
 {
 	struct st_lsm6dsx_hw *hw = private;
-	int count;
+	int fifo_len = 0, len;
 
-	mutex_lock(&hw->fifo_lock);
-	count = st_lsm6dsx_read_fifo(hw);
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
+		len = st_lsm6dsx_read_fifo(hw);
+		mutex_unlock(&hw->fifo_lock);
 
-	return count ? IRQ_HANDLED : IRQ_NONE;
+		if (len > 0)
+			fifo_len += len;
+	} while (len > 0);
+
+	return fifo_len ? IRQ_HANDLED : IRQ_NONE;
 }
 
 static int st_lsm6dsx_buffer_preenable(struct iio_dev *iio_dev)


