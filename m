Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C60C43286DC
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 18:17:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237341AbhCARQ4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 12:16:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:37784 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236672AbhCARIk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 12:08:40 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2CDE365014;
        Mon,  1 Mar 2021 16:42:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614616928;
        bh=PJsmq/Ddg+PlM5b97T82Ls8Dq66aWqp2lQVLQHWD2ZE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mVc9uAMNbD7IGlgsoxCfrEQuEtKVcwC/dc2k78baP0XmjelczDAx+YaCGgmcub/2f
         AnP7pJUC8fwX5M52BFCUtLGkUgvxRU61D4Xt04ZQO9MoPktoCFfQ/bJVT7hLLu7qHt
         EYiQ7PCnQkYjJtGOJ98VrZ7m/gjn531aMT6lzS60=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alain Volmat <alain.volmat@foss.st.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 143/247] spi: stm32: properly handle 0 byte transfer
Date:   Mon,  1 Mar 2021 17:12:43 +0100
Message-Id: <20210301161038.671675464@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161031.684018251@linuxfoundation.org>
References: <20210301161031.684018251@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alain Volmat <alain.volmat@foss.st.com>

[ Upstream commit 2269f5a8b1a7b38651d62676b98182828f29d11a ]

On 0 byte transfer request, return straight from the
xfer function after finalizing the transfer.

Fixes: dcbe0d84dfa5 ("spi: add driver for STM32 SPI controller")
Signed-off-by: Alain Volmat <alain.volmat@foss.st.com>
Link: https://lore.kernel.org/r/1612551572-495-2-git-send-email-alain.volmat@foss.st.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-stm32.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/spi/spi-stm32.c b/drivers/spi/spi-stm32.c
index 8eb2644506dd3..8d692f16d90ac 100644
--- a/drivers/spi/spi-stm32.c
+++ b/drivers/spi/spi-stm32.c
@@ -992,6 +992,10 @@ static int stm32_spi_transfer_one(struct spi_master *master,
 	struct stm32_spi *spi = spi_master_get_devdata(master);
 	int ret;
 
+	/* Don't do anything on 0 bytes transfers */
+	if (transfer->len == 0)
+		return 0;
+
 	spi->tx_buf = transfer->tx_buf;
 	spi->rx_buf = transfer->rx_buf;
 	spi->tx_len = spi->tx_buf ? transfer->len : 0;
-- 
2.27.0



