Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D076112ED56
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 23:28:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729720AbgABW1S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 17:27:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:55398 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729715AbgABW1O (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jan 2020 17:27:14 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5E4FC21835;
        Thu,  2 Jan 2020 22:27:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578004033;
        bh=MSTZ94r89EHHY4WmSqK9lUuQzwQQFWDe2kPN7S+IW6U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1yGbZmv0Bax3EnsHeq51FUIuHXJWKNrPtCGf/IjvLBY7U2ruBpOy3FP7bP7tSISov
         BcZjycqM7RlUCOedt0Ox/gJtBXZOPeB+AKgS4eH+3gyuQnS86hkxGRVCMsW6HT8WUZ
         ifrdl9vvu9PxPEqjF7HRNfvvOCwVZijhW9+pIV+E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lukasz Majewski <lukma@denx.de>,
        Mark Brown <broonie@kernel.org>,
        kbuild test robot <lkp@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 010/171] spi: Add call to spi_slave_abort() function when spidev driver is released
Date:   Thu,  2 Jan 2020 23:05:41 +0100
Message-Id: <20200102220548.403262985@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200102220546.960200039@linuxfoundation.org>
References: <20200102220546.960200039@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index f4ea286b0121..a685c6114a8d 100644
--- a/drivers/spi/spidev.c
+++ b/drivers/spi/spidev.c
@@ -663,6 +663,9 @@ static int spidev_release(struct inode *inode, struct file *filp)
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



