Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8874450F49
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 19:26:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241443AbhKOS3W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 13:29:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:36792 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241751AbhKOSZC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:25:02 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 647FE632C3;
        Mon, 15 Nov 2021 17:55:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636998912;
        bh=0W78csnPPymzxkYfoPJfgUuvD0zV08eSX/jdzmvw2kY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QF4kZKYSqBJ4GCjDMAWV7ROReeRpwQB5s1o2oFvX/23D4Frq9k1z/uHfdndlXUZg3
         gvsI6rUsnf2udy58WX7cOJpDsLmlQTKAP/ImHmV/YntdXRl+jGmpU9v2XBqnqDkYV/
         2XLz24/dl+4euortJi+2sWFCbFvB4TRkmYKb8zeo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Russ Weight <russell.h.weight@intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 075/849] spi: altera: Change to dynamic allocation of spi id
Date:   Mon, 15 Nov 2021 17:52:38 +0100
Message-Id: <20211115165422.592051419@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Russ Weight <russell.h.weight@intel.com>

[ Upstream commit f09f6dfef8ce7b70a240cf83811e2b1909c3e47b ]

The spi-altera driver has two flavors: platform and dfl. I'm seeing
a case where I have both device types in the same machine, and they
are conflicting on the SPI ID:

... kernel: couldn't get idr
... kernel: WARNING: CPU: 28 PID: 912 at drivers/spi/spi.c:2920 spi_register_controller.cold+0x84/0xc0a

Both the platform and dfl drivers use the parent's driver ID as the SPI
ID. In the error case, the parent devices are dfl_dev.4 and
subdev_spi_altera.4.auto. When the second spi-master is created, the
failure occurs because the SPI ID of 4 has already been allocated.

Change the ID allocation to dynamic (by initializing bus_num to -1) to
avoid duplicate SPI IDs.

Signed-off-by: Russ Weight <russell.h.weight@intel.com>
Link: https://lore.kernel.org/r/20211019002401.24041-1-russell.h.weight@intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-altera-dfl.c      | 2 +-
 drivers/spi/spi-altera-platform.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/spi/spi-altera-dfl.c b/drivers/spi/spi-altera-dfl.c
index 39a3e1a032e04..59a5b42c71226 100644
--- a/drivers/spi/spi-altera-dfl.c
+++ b/drivers/spi/spi-altera-dfl.c
@@ -140,7 +140,7 @@ static int dfl_spi_altera_probe(struct dfl_device *dfl_dev)
 	if (!master)
 		return -ENOMEM;
 
-	master->bus_num = dfl_dev->id;
+	master->bus_num = -1;
 
 	hw = spi_master_get_devdata(master);
 
diff --git a/drivers/spi/spi-altera-platform.c b/drivers/spi/spi-altera-platform.c
index f7a7c14e36790..65147aae82a1a 100644
--- a/drivers/spi/spi-altera-platform.c
+++ b/drivers/spi/spi-altera-platform.c
@@ -48,7 +48,7 @@ static int altera_spi_probe(struct platform_device *pdev)
 		return err;
 
 	/* setup the master state. */
-	master->bus_num = pdev->id;
+	master->bus_num = -1;
 
 	if (pdata) {
 		if (pdata->num_chipselect > ALTERA_SPI_MAX_CS) {
-- 
2.33.0



