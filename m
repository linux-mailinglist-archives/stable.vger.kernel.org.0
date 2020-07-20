Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC45B226376
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 17:38:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726389AbgGTPha (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 11:37:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:55576 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728448AbgGTPh2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 11:37:28 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7F00F22CB2;
        Mon, 20 Jul 2020 15:37:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595259448;
        bh=3AQAN1Qxu/m9Dtqgi0RZiG7hIv+XF0YYpsIK7Wz9AgQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SohF6jMqMXyCvT/WMA8rPuwD5FctOs2r5MsNe6RuK2bdNMTZwEMJ750fTIZ/2CZV1
         JjSQLJR0hKXieyTAFFox5JP9gJTSySrViu2IKCs18hWXBeCzfsCefMMK1SPh1Vv2o9
         7GdsLJRzJzfFukfLc+WttvhowiEEBo5t7jwVT+HQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhenzhong Duan <zhenzhong.duan@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 03/58] spi: spidev: fix a potential use-after-free in spidev_release()
Date:   Mon, 20 Jul 2020 17:36:19 +0200
Message-Id: <20200720152747.297093674@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152747.127988571@linuxfoundation.org>
References: <20200720152747.127988571@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
@@ -635,15 +635,20 @@ err_find_dev:
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



