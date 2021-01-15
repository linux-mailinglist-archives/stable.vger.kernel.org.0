Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA8482F7A04
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 13:45:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733043AbhAOMnx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 07:43:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:45834 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388180AbhAOMib (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Jan 2021 07:38:31 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 467E12333E;
        Fri, 15 Jan 2021 12:37:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610714270;
        bh=2DumoSoK0ts5kEj+K+baCwD9KOoXvoyr57lf/mVXoL4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BLV3SmMF8p1OyiUyS6J2XDCiky16OPOMOzIADCBRXBg+BmMLvVuWHE3IMPUItC2hT
         C4jD2aM0+KTIsWn7hnbT6lfmktRV5BokTsymRlEUqtwX4CeyEd2qvTBM25jpl3m4xO
         qYB2PgnBZNaKUJNFGR3FuqHvGS7uG07snyOndoVY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Douglas Anderson <dianders@chromium.org>,
        Stephen Boyd <swboyd@chromium.org>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.10 059/103] spi: spi-geni-qcom: Fail new xfers if xfer/cancel/abort pending
Date:   Fri, 15 Jan 2021 13:27:52 +0100
Message-Id: <20210115122008.904751215@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210115122006.047132306@linuxfoundation.org>
References: <20210115122006.047132306@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Douglas Anderson <dianders@chromium.org>

commit 690d8b917bbe64772cb0b652311bcd50908aea6b upstream.

If we got a timeout when trying to send an abort command then it means
that we just got 3 timeouts in a row:

1. The original timeout that caused handle_fifo_timeout() to be
   called.
2. A one second timeout waiting for the cancel command to finish.
3. A one second timeout waiting for the abort command to finish.

SPI is clocked by the controller, so nothing (aside from a hardware
fault or a totally broken sequencer) should be causing the actual
commands to fail in hardware.  However, even though the hardware
itself is not expected to fail (and it'd be hard to predict how we
should handle things if it did), it's easy to hit the timeout case by
simply blocking our interrupt handler from running for a long period
of time.  Obviously the system is in pretty bad shape if a interrupt
handler is blocked for > 2 seconds, but there are certainly bugs (even
bugs in other unrelated drivers) that can make this happen.

Let's make things a bit more robust against this case.  If we fail to
abort we'll set a flag and then we'll block all future transfers until
we have no more interrupts pending.

Fixes: 561de45f72bd ("spi: spi-geni-qcom: Add SPI driver support for GENI based QUP")
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Reviewed-by: Stephen Boyd <swboyd@chromium.org>
Link: https://lore.kernel.org/r/20201217142842.v3.2.Ibade998ed587e070388b4bf58801f1107a40eb53@changeid
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/spi/spi-geni-qcom.c |   59 ++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 57 insertions(+), 2 deletions(-)

--- a/drivers/spi/spi-geni-qcom.c
+++ b/drivers/spi/spi-geni-qcom.c
@@ -83,6 +83,7 @@ struct spi_geni_master {
 	spinlock_t lock;
 	int irq;
 	bool cs_flag;
+	bool abort_failed;
 };
 
 static int get_spi_clk_cfg(unsigned int speed_hz,
@@ -141,8 +142,49 @@ static void handle_fifo_timeout(struct s
 	spin_unlock_irq(&mas->lock);
 
 	time_left = wait_for_completion_timeout(&mas->abort_done, HZ);
-	if (!time_left)
+	if (!time_left) {
 		dev_err(mas->dev, "Failed to cancel/abort m_cmd\n");
+
+		/*
+		 * No need for a lock since SPI core has a lock and we never
+		 * access this from an interrupt.
+		 */
+		mas->abort_failed = true;
+	}
+}
+
+static bool spi_geni_is_abort_still_pending(struct spi_geni_master *mas)
+{
+	struct geni_se *se = &mas->se;
+	u32 m_irq, m_irq_en;
+
+	if (!mas->abort_failed)
+		return false;
+
+	/*
+	 * The only known case where a transfer times out and then a cancel
+	 * times out then an abort times out is if something is blocking our
+	 * interrupt handler from running.  Avoid starting any new transfers
+	 * until that sorts itself out.
+	 */
+	spin_lock_irq(&mas->lock);
+	m_irq = readl(se->base + SE_GENI_M_IRQ_STATUS);
+	m_irq_en = readl(se->base + SE_GENI_M_IRQ_EN);
+	spin_unlock_irq(&mas->lock);
+
+	if (m_irq & m_irq_en) {
+		dev_err(mas->dev, "Interrupts pending after abort: %#010x\n",
+			m_irq & m_irq_en);
+		return true;
+	}
+
+	/*
+	 * If we're here the problem resolved itself so no need to check more
+	 * on future transfers.
+	 */
+	mas->abort_failed = false;
+
+	return false;
 }
 
 static void spi_geni_set_cs(struct spi_device *slv, bool set_flag)
@@ -158,9 +200,15 @@ static void spi_geni_set_cs(struct spi_d
 	if (set_flag == mas->cs_flag)
 		return;
 
+	pm_runtime_get_sync(mas->dev);
+
+	if (spi_geni_is_abort_still_pending(mas)) {
+		dev_err(mas->dev, "Can't set chip select\n");
+		goto exit;
+	}
+
 	mas->cs_flag = set_flag;
 
-	pm_runtime_get_sync(mas->dev);
 	spin_lock_irq(&mas->lock);
 	reinit_completion(&mas->cs_done);
 	if (set_flag)
@@ -173,6 +221,7 @@ static void spi_geni_set_cs(struct spi_d
 	if (!time_left)
 		handle_fifo_timeout(spi, NULL);
 
+exit:
 	pm_runtime_put(mas->dev);
 }
 
@@ -280,6 +329,9 @@ static int spi_geni_prepare_message(stru
 	int ret;
 	struct spi_geni_master *mas = spi_master_get_devdata(spi);
 
+	if (spi_geni_is_abort_still_pending(mas))
+		return -EBUSY;
+
 	ret = setup_fifo_params(spi_msg->spi, spi);
 	if (ret)
 		dev_err(mas->dev, "Couldn't select mode %d\n", ret);
@@ -495,6 +547,9 @@ static int spi_geni_transfer_one(struct
 {
 	struct spi_geni_master *mas = spi_master_get_devdata(spi);
 
+	if (spi_geni_is_abort_still_pending(mas))
+		return -EBUSY;
+
 	/* Terminate and return success for 0 byte length transfer */
 	if (!xfer->len)
 		return 0;


