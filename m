Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A2202B634D
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:37:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732192AbgKQNhE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:37:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:47776 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732651AbgKQNgo (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:36:44 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 20571207BC;
        Tue, 17 Nov 2020 13:36:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605620203;
        bh=UUm7ZRBD3wqBUSjjgBLp7IAVuFPn4r1LeIH++zy3xtw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yod9E3GAhThFM+VkmnR8lnps9rxv+tV4L7miJixsXsGFeIgfSL6ER7udZ1HxNPY4w
         eMJEmN3WG9M+2MIePNR5xRAg0gdW/DbOExjJT9FiBoKt3zB+4Gi6qHjjDXdKhHxYl6
         5mv+0LDQXaZh7kNXfQwmv5+SLmac/SeFOcilk+1I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Wu <michael.wu@vatics.com>,
        Jarkko Nikula <jarkko.nikula@linux.intel.com>,
        Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 123/255] i2c: designware: call i2c_dw_read_clear_intrbits_slave() once
Date:   Tue, 17 Nov 2020 14:04:23 +0100
Message-Id: <20201117122144.929255726@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122138.925150709@linuxfoundation.org>
References: <20201117122138.925150709@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Wu <michael.wu@vatics.com>

[ Upstream commit 66b92313e2ca9208b5f3ebf5d86e9a818299d8fa ]

If some bits were cleared by i2c_dw_read_clear_intrbits_slave() in
i2c_dw_isr_slave() and not handled immediately, those cleared bits would
not be shown again by later i2c_dw_read_clear_intrbits_slave(). They
therefore were forgotten to be handled.

i2c_dw_read_clear_intrbits_slave() should be called once in an ISR and take
its returned state for all later handlings.

Signed-off-by: Michael Wu <michael.wu@vatics.com>
Acked-by: Jarkko Nikula <jarkko.nikula@linux.intel.com>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-designware-slave.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/i2c/busses/i2c-designware-slave.c b/drivers/i2c/busses/i2c-designware-slave.c
index 44974b53a6268..13de01a0f75f0 100644
--- a/drivers/i2c/busses/i2c-designware-slave.c
+++ b/drivers/i2c/busses/i2c-designware-slave.c
@@ -159,7 +159,6 @@ static int i2c_dw_irq_handler_slave(struct dw_i2c_dev *dev)
 	u32 raw_stat, stat, enabled, tmp;
 	u8 val = 0, slave_activity;
 
-	regmap_read(dev->map, DW_IC_INTR_STAT, &stat);
 	regmap_read(dev->map, DW_IC_ENABLE, &enabled);
 	regmap_read(dev->map, DW_IC_RAW_INTR_STAT, &raw_stat);
 	regmap_read(dev->map, DW_IC_STATUS, &tmp);
@@ -168,6 +167,7 @@ static int i2c_dw_irq_handler_slave(struct dw_i2c_dev *dev)
 	if (!enabled || !(raw_stat & ~DW_IC_INTR_ACTIVITY) || !dev->slave)
 		return 0;
 
+	stat = i2c_dw_read_clear_intrbits_slave(dev);
 	dev_dbg(dev->dev,
 		"%#x STATUS SLAVE_ACTIVITY=%#x : RAW_INTR_STAT=%#x : INTR_STAT=%#x\n",
 		enabled, slave_activity, raw_stat, stat);
@@ -188,11 +188,9 @@ static int i2c_dw_irq_handler_slave(struct dw_i2c_dev *dev)
 						 val);
 				}
 				regmap_read(dev->map, DW_IC_CLR_RD_REQ, &tmp);
-				stat = i2c_dw_read_clear_intrbits_slave(dev);
 			} else {
 				regmap_read(dev->map, DW_IC_CLR_RD_REQ, &tmp);
 				regmap_read(dev->map, DW_IC_CLR_RX_UNDER, &tmp);
-				stat = i2c_dw_read_clear_intrbits_slave(dev);
 			}
 			if (!i2c_slave_event(dev->slave,
 					     I2C_SLAVE_READ_REQUESTED,
@@ -207,7 +205,6 @@ static int i2c_dw_irq_handler_slave(struct dw_i2c_dev *dev)
 			regmap_read(dev->map, DW_IC_CLR_RX_DONE, &tmp);
 
 		i2c_slave_event(dev->slave, I2C_SLAVE_STOP, &val);
-		stat = i2c_dw_read_clear_intrbits_slave(dev);
 		return 1;
 	}
 
@@ -219,7 +216,6 @@ static int i2c_dw_irq_handler_slave(struct dw_i2c_dev *dev)
 			dev_vdbg(dev->dev, "Byte %X acked!", val);
 	} else {
 		i2c_slave_event(dev->slave, I2C_SLAVE_STOP, &val);
-		stat = i2c_dw_read_clear_intrbits_slave(dev);
 	}
 
 	return 1;
@@ -230,7 +226,6 @@ static irqreturn_t i2c_dw_isr_slave(int this_irq, void *dev_id)
 	struct dw_i2c_dev *dev = dev_id;
 	int ret;
 
-	i2c_dw_read_clear_intrbits_slave(dev);
 	ret = i2c_dw_irq_handler_slave(dev);
 	if (ret > 0)
 		complete(&dev->cmd_complete);
-- 
2.27.0



