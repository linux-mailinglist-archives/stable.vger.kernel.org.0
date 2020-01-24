Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B59D8147CB6
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 10:54:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387561AbgAXJyC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 04:54:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:56920 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730133AbgAXJyA (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 04:54:00 -0500
Received: from localhost (unknown [145.15.244.15])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1B87820718;
        Fri, 24 Jan 2020 09:53:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579859639;
        bh=kKrsRJvjV2pYirmKjjV3sByo0K9LXiyXcWpNm3rB+pE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h+PyHj5GmRvJl7MnGROBMjXW/UrZYCn+nP6Z26pzZDgKJ06oRvf3z0x3REqoXVp1q
         Dgxz/iY6m2JiMP3UDjNaJGsLKDi7+sut5mdjKyR3Tp1x/pdLomUiqUavYql2/fQ8qA
         2y+Din84QsYZWqidTM+S4RTs6jBxc2KAGBdXI8Lc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sowjanya Komatineni <skomatineni@nvidia.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 156/343] spi: tegra114: clear packed bit for unpacked mode
Date:   Fri, 24 Jan 2020 10:29:34 +0100
Message-Id: <20200124092940.493754980@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124092919.490687572@linuxfoundation.org>
References: <20200124092919.490687572@linuxfoundation.org>
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
index 2ad04796ef298..3a6b202dfffe0 100644
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



