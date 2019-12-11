Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7EE7411ACA3
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 14:59:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729671AbfLKN7F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 08:59:05 -0500
Received: from first.geanix.com ([116.203.34.67]:60074 "EHLO first.geanix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729513AbfLKN7E (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 08:59:04 -0500
Received: from zen.localdomain (unknown [85.184.140.241])
        by first.geanix.com (Postfix) with ESMTPSA id 5C2FF493;
        Wed, 11 Dec 2019 13:58:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=geanix.com; s=first;
        t=1576072714; bh=P9AdXLCyi/6osF9N7RGIs5PjvCgfv3ixgbp9vw4DyIw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=LZmwyzeaz1zN1ZsFfD1xJqi0uqN0b1s6NWn8CeZezJeWoxn4L0jOf0fTrEl9PWkK+
         1RhQzRpAWGM1b+lTqUcF2Lq6UzMNOn1njk1/kstcKYuDlmwRJjo/l2dUxhbkkhKZsT
         1c9WMvjz7KybRFj9XXWcBe03qgfVqbEhIpAe1ke3JnIyWxBOysUZoRS1OgZB9qzPgd
         V0l8Wr+OM9v1LXdd3KK8tPi5lLmze+pY/EnP5ndBPcvQucyg6weps2e7sd4Bo2EJFk
         5dsSRMMDAnKMhDG29maWIWkB3ZDw35VzGhccIppoSGq3Tjf+wPsKWqxj4Cr8bsFQj2
         0lTLpXS9L7GCg==
From:   Sean Nyekjaer <sean@geanix.com>
To:     mkl@pengutronix.de, dmurphy@ti.com, linux-can@vger.kernel.org
Cc:     Sean Nyekjaer <sean@geanix.com>, stable@vger.kernel.org
Subject: [PATCH v6 2/2] can: tcan4x5x: put the device out of standby before register access
Date:   Wed, 11 Dec 2019 14:58:52 +0100
Message-Id: <20191211135852.320650-2-sean@geanix.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191211135852.320650-1-sean@geanix.com>
References: <20191211135852.320650-1-sean@geanix.com>
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
 - Fixed fixes tag

Changes since v4:
 - None

Changes since v5:
 - None

 Sorry for the mess :)

 drivers/net/can/m_can/tcan4x5x.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/can/m_can/tcan4x5x.c b/drivers/net/can/m_can/tcan4x5x.c
index dcfa85edc787..8ed2813f227e 100644
--- a/drivers/net/can/m_can/tcan4x5x.c
+++ b/drivers/net/can/m_can/tcan4x5x.c
@@ -482,6 +482,10 @@ static int tcan4x5x_can_probe(struct spi_device *spi)
 
 	tcan4x5x_power_enable(priv->power, 1);
 
+	ret = tcan4x5x_init(mcan_class);
+	if (ret)
+		goto out_power;
+
 	ret = m_can_class_register(mcan_class);
 	if (ret)
 		goto out_power;
-- 
2.24.0

