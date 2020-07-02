Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6037721187B
	for <lists+stable@lfdr.de>; Thu,  2 Jul 2020 03:29:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728252AbgGBB2k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Jul 2020 21:28:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:59558 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729523AbgGBB1f (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Jul 2020 21:27:35 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 48770214DB;
        Thu,  2 Jul 2020 01:27:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593653255;
        bh=0vnJHi7I4mSS3PdnRFOQhlL/sfCDWyOgU9S8BIfpm3s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0bpHakVkPAYYzuwmVCbuy/zC1QP9OfITutAIPSfhA9rQT+qVboTJ0694KrV0QAjBe
         QC5U0WirgKPzLX9HeEP0+eJbC3ymfYBUMONe/b4jcKxr/SuH4aKaSDnZsUp5tI8ciR
         tjFNbhv68v4hT0cX42dh2jxiTuB+O9lriENhdoyo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zhenzhong Duan <zhenzhong.duan@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-spi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 4/7] spi: spidev: fix a potential use-after-free in spidev_release()
Date:   Wed,  1 Jul 2020 21:27:26 -0400
Message-Id: <20200702012729.2702141-4-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200702012729.2702141-1-sashal@kernel.org>
References: <20200702012729.2702141-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhenzhong Duan <zhenzhong.duan@gmail.com>

[ Upstream commit 06096cc6c5a84ced929634b0d79376b94c65a4bd ]

If an spi device is unbounded from the driver before the release
process, there will be an NULL pointer reference when it's
referenced in spi_slave_abort().

Fix it by checking it's already freed before reference.

Signed-off-by: Zhenzhong Duan <zhenzhong.duan@gmail.com>
Link: https://lore.kernel.org/r/20200618032125.4650-2-zhenzhong.duan@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spidev.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/spi/spidev.c b/drivers/spi/spidev.c
index 80beb8406f200..7969f5484aee8 100644
--- a/drivers/spi/spidev.c
+++ b/drivers/spi/spidev.c
@@ -635,15 +635,20 @@ static int spidev_open(struct inode *inode, struct file *filp)
 static int spidev_release(struct inode *inode, struct file *filp)
 {
 	struct spidev_data	*spidev;
+	int			dofree;
 
 	mutex_lock(&device_list_lock);
 	spidev = filp->private_data;
 	filp->private_data = NULL;
 
+	spin_lock_irq(&spidev->spi_lock);
+	/* ... after we unbound from the underlying device? */
+	dofree = (spidev->spi == NULL);
+	spin_unlock_irq(&spidev->spi_lock);
+
 	/* last close? */
 	spidev->users--;
 	if (!spidev->users) {
-		int		dofree;
 
 		kfree(spidev->tx_buffer);
 		spidev->tx_buffer = NULL;
@@ -651,19 +656,14 @@ static int spidev_release(struct inode *inode, struct file *filp)
 		kfree(spidev->rx_buffer);
 		spidev->rx_buffer = NULL;
 
-		spin_lock_irq(&spidev->spi_lock);
-		if (spidev->spi)
-			spidev->speed_hz = spidev->spi->max_speed_hz;
-
-		/* ... after we unbound from the underlying device? */
-		dofree = (spidev->spi == NULL);
-		spin_unlock_irq(&spidev->spi_lock);
-
 		if (dofree)
 			kfree(spidev);
+		else
+			spidev->speed_hz = spidev->spi->max_speed_hz;
 	}
 #ifdef CONFIG_SPI_SLAVE
-	spi_slave_abort(spidev->spi);
+	if (!dofree)
+		spi_slave_abort(spidev->spi);
 #endif
 	mutex_unlock(&device_list_lock);
 
-- 
2.25.1

