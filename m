Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D97826B6C4
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 02:10:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726808AbgIPAKx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 20:10:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:41424 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726942AbgIOO0a (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Sep 2020 10:26:30 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D04E322461;
        Tue, 15 Sep 2020 14:19:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600179575;
        bh=iSNP/g/gkYrX9y+qzXk6nu2y8wWaQxppdnCKxiJwC0o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KDWO1ftxFIA0NK4IbuzfkFwB1bp6/Lap+ol6CwzkydUcTRezqIJ0osonzcDks5uWX
         yXXq1HX4E/yWwfuPRue2kRZTTSQSjAkCICDjZGvZOfYongWiO7sGpcF+HeT/N6riYA
         KugHqbuN6EzFozh45gxVVC6757DFimPcEVFEcR7w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marek Vasut <marex@denx.de>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Amelie Delaunay <amelie.delaunay@st.com>,
        Antonio Borneo <borneo.antonio@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 027/132] spi: stm32: Rate-limit the Communication suspended message
Date:   Tue, 15 Sep 2020 16:12:09 +0200
Message-Id: <20200915140645.462693984@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200915140644.037604909@linuxfoundation.org>
References: <20200915140644.037604909@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marek Vasut <marex@denx.de>

[ Upstream commit ea8be08cc9358f811e4175ba7fa7fea23c5d393e ]

The 'spi_stm32 44004000.spi: Communication suspended' message means that
when using PIO, the kernel did not read the FIFO fast enough and so the
SPI controller paused the transfer. Currently, this is printed on every
single such event, so if the kernel is busy and the controller is pausing
the transfers often, the kernel will be all the more busy scrolling this
message into the log buffer every few milliseconds. That is not helpful.

Instead, rate-limit the message and print it every once in a while. It is
not possible to use the default dev_warn_ratelimited(), because that is
still too verbose, as it prints 10 lines (DEFAULT_RATELIMIT_BURST) every
5 seconds (DEFAULT_RATELIMIT_INTERVAL). The policy here is to print 1 line
every 50 seconds (DEFAULT_RATELIMIT_INTERVAL * 10), because 1 line is more
than enough and the cycles saved on printing are better left to the CPU to
handle the SPI. However, dev_warn_once() is also not useful, as the user
should be aware that this condition is possibly recurring or ongoing. Thus
the custom rate-limit policy.

Finally, turn the message from dev_warn() to dev_dbg(), since the system
does not suffer any sort of malfunction if this message appears, it is
just slowing down. This further reduces the printing into the log buffer
and frees the CPU to do useful work.

Fixes: dcbe0d84dfa5 ("spi: add driver for STM32 SPI controller")
Signed-off-by: Marek Vasut <marex@denx.de>
Cc: Alexandre Torgue <alexandre.torgue@st.com>
Cc: Amelie Delaunay <amelie.delaunay@st.com>
Cc: Antonio Borneo <borneo.antonio@gmail.com>
Cc: Mark Brown <broonie@kernel.org>
Link: https://lore.kernel.org/r/20200905151913.117775-1-marex@denx.de
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-stm32.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/spi/spi-stm32.c b/drivers/spi/spi-stm32.c
index 8146c2d91d307..09b418ff99b16 100644
--- a/drivers/spi/spi-stm32.c
+++ b/drivers/spi/spi-stm32.c
@@ -931,7 +931,11 @@ static irqreturn_t stm32h7_spi_irq_thread(int irq, void *dev_id)
 	}
 
 	if (sr & STM32H7_SPI_SR_SUSP) {
-		dev_warn(spi->dev, "Communication suspended\n");
+		static DEFINE_RATELIMIT_STATE(rs,
+					      DEFAULT_RATELIMIT_INTERVAL * 10,
+					      1);
+		if (__ratelimit(&rs))
+			dev_dbg_ratelimited(spi->dev, "Communication suspended\n");
 		if (!spi->cur_usedma && (spi->rx_buf && (spi->rx_len > 0)))
 			stm32h7_spi_read_rxfifo(spi, false);
 		/*
-- 
2.25.1



