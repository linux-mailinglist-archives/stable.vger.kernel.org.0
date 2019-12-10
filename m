Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 39ECD119667
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 22:26:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728644AbfLJVZd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 16:25:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:56608 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729400AbfLJVZc (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Dec 2019 16:25:32 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B42EE20838;
        Tue, 10 Dec 2019 21:25:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576013131;
        bh=U3DpyrRA2XLyMI7ScgE+KagD0uAkQoaCUTFYrTEi90M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w/y05wfKHIen93cmK7qERc+eEpwHbLaEHoo7a3CzFwUtTFWO8ojargZnWnr2GSAW/
         9nWBwE7QcaJaLQKkJsc4dmbf8GMaqVl8dxJXmq0S1BxLGLPt6O3+KFLr/AtgBjcyzU
         MtVan6YGrsAk3nIad8pepZRR6MBZ74hXkoiFQmvI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lukasz Majewski <lukma@denx.de>, Mark Brown <broonie@kernel.org>,
        kbuild test robot <lkp@intel.com>,
        Sasha Levin <sashal@kernel.org>, linux-spi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.3 016/292] spi: Add call to spi_slave_abort() function when spidev driver is released
Date:   Tue, 10 Dec 2019 16:20:35 -0500
Message-Id: <20191210212511.11392-16-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210212511.11392-1-sashal@kernel.org>
References: <20191210212511.11392-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lukasz Majewski <lukma@denx.de>

[ Upstream commit 9f918a728cf86b2757b6a7025e1f46824bfe3155 ]

This change is necessary for spidev devices (e.g. /dev/spidev3.0) working
in the slave mode (like NXP's dspi driver for Vybrid SoC).

When SPI HW works in this mode - the master is responsible for providing
CS and CLK signals. However, when some fault happens - like for example
distortion on SPI lines - the SPI Linux driver needs a chance to recover
from this abnormal situation and prepare itself for next (correct)
transmission.

This change doesn't pose any threat on drivers working in master mode as
spi_slave_abort() function checks if SPI slave mode is supported.

Signed-off-by: Lukasz Majewski <lukma@denx.de>
Link: https://lore.kernel.org/r/20190924110547.14770-2-lukma@denx.de
Signed-off-by: Mark Brown <broonie@kernel.org>
Reported-by: kbuild test robot <lkp@intel.com>
Link: https://lore.kernel.org/r/20190925091143.15468-2-lukma@denx.de
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spidev.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/spi/spidev.c b/drivers/spi/spidev.c
index 255786f2e8447..3ea9d8a3e6e89 100644
--- a/drivers/spi/spidev.c
+++ b/drivers/spi/spidev.c
@@ -627,6 +627,9 @@ static int spidev_release(struct inode *inode, struct file *filp)
 		if (dofree)
 			kfree(spidev);
 	}
+#ifdef CONFIG_SPI_SLAVE
+	spi_slave_abort(spidev->spi);
+#endif
 	mutex_unlock(&device_list_lock);
 
 	return 0;
-- 
2.20.1

