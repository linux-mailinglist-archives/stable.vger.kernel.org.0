Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B5F014BA3E
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 15:38:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730495AbgA1OTa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 09:19:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:43872 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730885AbgA1OT3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 09:19:29 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A23D02468F;
        Tue, 28 Jan 2020 14:19:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580221169;
        bh=JKu0dhzvjzrLtzvtJGee9t8K2qFBno9QeXygxZ12YYs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FvV8yJ8C9jOhZ5qUfn32BTaIeT49MlJR2sCNb5fBz1sjmqHXpDkPYGp/wIsXOvNuU
         lc4kNyWM7c3FXyVxRJAVcfAyOmnnjefLum3zfkGsHq4IlEo+hRpSISPrsjhNtMipcX
         /j66eUJaDbDfq1p4JcI8d1d+IlyUlYYjkzj3GdH8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sowjanya Komatineni <skomatineni@nvidia.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 109/271] spi: tegra114: clear packed bit for unpacked mode
Date:   Tue, 28 Jan 2020 15:04:18 +0100
Message-Id: <20200128135900.691060975@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200128135852.449088278@linuxfoundation.org>
References: <20200128135852.449088278@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sowjanya Komatineni <skomatineni@nvidia.com>

[ Upstream commit 7b3d10cdf54b8bc1dc0da21faed9789ac4da3684 ]

Fixes: Clear packed bit when not using packed mode.

Packed bit is not cleared when not using packed mode. This results
in transfer timeouts for the unpacked mode transfers followed by the
packed mode transfers.

Signed-off-by: Sowjanya Komatineni <skomatineni@nvidia.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-tegra114.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/spi/spi-tegra114.c b/drivers/spi/spi-tegra114.c
index 705f515863d4f..d98c502a9c478 100644
--- a/drivers/spi/spi-tegra114.c
+++ b/drivers/spi/spi-tegra114.c
@@ -730,6 +730,8 @@ static int tegra_spi_start_transfer_one(struct spi_device *spi,
 
 	if (tspi->is_packed)
 		command1 |= SPI_PACKED;
+	else
+		command1 &= ~SPI_PACKED;
 
 	command1 &= ~(SPI_CS_SEL_MASK | SPI_TX_EN | SPI_RX_EN);
 	tspi->cur_direction = 0;
-- 
2.20.1



