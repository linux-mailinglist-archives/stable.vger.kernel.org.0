Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F374C1F2EDA
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 02:46:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727115AbgFIApn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 20:45:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:58772 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728970AbgFHXLp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jun 2020 19:11:45 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4458620C56;
        Mon,  8 Jun 2020 23:11:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591657905;
        bh=T+jPFC0lA+eBgkxLgd3PN4lxPcbqGMXjwaRExUrc1pA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wpauXWF0xUP/EW+swiGrLj8liDsHnL+S8AW+VkjDO6s4bdx0HuNWU5Hh1wE3UH3zT
         Wm1Jo/Z7KcgH2KrLcp2Fs23m/huH3apgLJuPORLQZ76sj8c7V7kWChy53jIbQ7h7MX
         dnM3cgwWSf+JmyDFlzXruaJFpbkLMUdgOyU0yaSw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Angelo Dureghello <angelo.dureghello@timesys.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-spi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.7 257/274] spi: spi-fsl-dspi: fix native data copy
Date:   Mon,  8 Jun 2020 19:05:50 -0400
Message-Id: <20200608230607.3361041-257-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608230607.3361041-1-sashal@kernel.org>
References: <20200608230607.3361041-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Angelo Dureghello <angelo.dureghello@timesys.com>

[ Upstream commit 263b81dc6c932c8bc550d5e7bfc178d2b3fc491e ]

ColdFire is a big-endian cpu with a big-endian dspi hw module,
so, it uses native access, but memcpy breaks the endianness.

So, if i understand properly, by native copy we would mean
be(cpu)->be(dspi) or le(cpu)->le(dspi) accesses, so my fix
shouldn't break anything, but i couldn't test it on LS family,
so every test is really appreciated.

Fixes: 53fadb4d90c7 ("spi: spi-fsl-dspi: Simplify bytes_per_word gymnastics")
Signed-off-by: Angelo Dureghello <angelo.dureghello@timesys.com>
Tested-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Link: https://lore.kernel.org/r/20200529195756.184677-1-angelo.dureghello@timesys.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-fsl-dspi.c | 24 ++++++++++++++++++++++--
 1 file changed, 22 insertions(+), 2 deletions(-)

diff --git a/drivers/spi/spi-fsl-dspi.c b/drivers/spi/spi-fsl-dspi.c
index 50e41f66a2d7..2e9f9adc5900 100644
--- a/drivers/spi/spi-fsl-dspi.c
+++ b/drivers/spi/spi-fsl-dspi.c
@@ -246,13 +246,33 @@ struct fsl_dspi {
 
 static void dspi_native_host_to_dev(struct fsl_dspi *dspi, u32 *txdata)
 {
-	memcpy(txdata, dspi->tx, dspi->oper_word_size);
+	switch (dspi->oper_word_size) {
+	case 1:
+		*txdata = *(u8 *)dspi->tx;
+		break;
+	case 2:
+		*txdata = *(u16 *)dspi->tx;
+		break;
+	case 4:
+		*txdata = *(u32 *)dspi->tx;
+		break;
+	}
 	dspi->tx += dspi->oper_word_size;
 }
 
 static void dspi_native_dev_to_host(struct fsl_dspi *dspi, u32 rxdata)
 {
-	memcpy(dspi->rx, &rxdata, dspi->oper_word_size);
+	switch (dspi->oper_word_size) {
+	case 1:
+		*(u8 *)dspi->rx = rxdata;
+		break;
+	case 2:
+		*(u16 *)dspi->rx = rxdata;
+		break;
+	case 4:
+		*(u32 *)dspi->rx = rxdata;
+		break;
+	}
 	dspi->rx += dspi->oper_word_size;
 }
 
-- 
2.25.1

