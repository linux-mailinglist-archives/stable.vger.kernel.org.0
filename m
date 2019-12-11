Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 538F311AC7D
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 14:53:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728128AbfLKNxs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 08:53:48 -0500
Received: from first.geanix.com ([116.203.34.67]:59712 "EHLO first.geanix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727554AbfLKNxr (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 08:53:47 -0500
Received: from zen.localdomain (unknown [85.184.140.241])
        by first.geanix.com (Postfix) with ESMTPSA id 6F93C490;
        Wed, 11 Dec 2019 13:53:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=geanix.com; s=first;
        t=1576072397; bh=U8QpgxahOSSPGiWpwWNLRPCmOKuTvv6GVTGmkkpGSLw=;
        h=From:To:Cc:Subject:Date;
        b=de/UYgaHJ1/tdR0T0uL0jVQwzlpE7u4RLMdq1vbamUnb+HqoMuwX18vw/3NdsEvuN
         hoAgpSH6WDHpO8+PnoUH2qh2lIMnUHFfQGZe+ocKz0lYvvQSGAl14gE6jC5jx+9kbI
         KuebJshucjJrNgB2SgAh1DXjopvS1r99lf7fZEm9Oy6euWzmi4SPsy94IdS9q8xtR6
         MsxruyoNkl9HGnGXmjclIQsYgrhdF4q9lsawIoYx42XYvynPb7/QoZgXGcw+w+f5/g
         OQNL0OAVl0YR/sQX46iurJfflFgfGy0RGCbRuHm1T8RHQri6+IAyWF2rHH/7UHI9PB
         h9MWvCHXy1W0g==
From:   Sean Nyekjaer <sean@geanix.com>
To:     mkl@pengutronix.de, dmurphy@ti.com, linux-can@vger.kernel.org
Cc:     Sean Nyekjaer <sean@geanix.com>, stable@vger.kernel.org
Subject: [PATCH v6 1/2] can: tcan4x5x: put the device out of standby before register access
Date:   Wed, 11 Dec 2019 14:53:39 +0100
Message-Id: <20191211135340.320004-1-sean@geanix.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=4.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,UNPARSEABLE_RELAY,URIBL_BLOCKED
        autolearn=disabled version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on 8b5b6f358cc9
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The m_can tries to detect if Non ISO Operation is available while in
standby, this function results in the following error:

tcan4x5x spi2.0 (unnamed net_device) (uninitialized): Failed to init module
tcan4x5x spi2.0: m_can device registered (irq=84, version=32)
tcan4x5x spi2.0 can2: TCAN4X5X successfully initialized.

When the tcan device comes out of reset it comes out in standby mode.
The m_can driver tries to access the control register but fails due to
the device is in standby mode.

So this patch will put the tcan device in normal mode before the m_can
driver does the initialization.

Fixes: 5443c226ba91 ("can: tcan4x5x: Add tcan4x5x driver to the kernel")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Nyekjaer <sean@geanix.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
Changes since v3:
 - added reset if the reset_gpio is not avaliable

Changes since v4:
 - added error handling for the SPI I/O

Changes since v5:
 - Removed braces for single statement if's

 drivers/net/can/m_can/tcan4x5x.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/can/m_can/tcan4x5x.c b/drivers/net/can/m_can/tcan4x5x.c
index c1b83dc26c3a..295dbb73c69e 100644
--- a/drivers/net/can/m_can/tcan4x5x.c
+++ b/drivers/net/can/m_can/tcan4x5x.c
@@ -484,6 +484,10 @@ static int tcan4x5x_can_probe(struct spi_device *spi)
 	if (ret)
 		goto out_power;
 
+	ret = tcan4x5x_init(mcan_class);
+	if (ret)
+		goto out_power;
+
 	ret = m_can_class_register(mcan_class);
 	if (ret)
 		goto out_power;
-- 
2.24.0

