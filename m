Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8FBF914B6F6
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 15:10:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729081AbgA1OJ5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 09:09:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:58500 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729075AbgA1OJ5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 09:09:57 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5773A24681;
        Tue, 28 Jan 2020 14:09:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580220596;
        bh=JKu0dhzvjzrLtzvtJGee9t8K2qFBno9QeXygxZ12YYs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EJCrP8zB8jdV+tFVKb9PWTXtC86ezVkuBYVBPKR61eM/FOvnmdhMD10HReXdcZ2H7
         PBb8jzE7UUsH8/NsA20cxiOhSYrUwbTorX539L8rPSkXXj57WO5I17Y62nbHzJ9I3D
         y2UEpR7DRsSjGIEJx9zW+coaTSV63VEIlzytWvCg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sowjanya Komatineni <skomatineni@nvidia.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 069/183] spi: tegra114: clear packed bit for unpacked mode
Date:   Tue, 28 Jan 2020 15:04:48 +0100
Message-Id: <20200128135836.919265338@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200128135829.486060649@linuxfoundation.org>
References: <20200128135829.486060649@linuxfoundation.org>
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



