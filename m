Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E5EE011A4A6
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 07:42:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727837AbfLKGm0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 01:42:26 -0500
Received: from first.geanix.com ([116.203.34.67]:40034 "EHLO first.geanix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727187AbfLKGmZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 01:42:25 -0500
Received: from zen.localdomain (unknown [85.184.140.241])
        by first.geanix.com (Postfix) with ESMTPSA id 96541449;
        Wed, 11 Dec 2019 06:41:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=geanix.com; s=first;
        t=1576046516; bh=Ka8yEehAlw/RVnhn/75S7P8BwdY+uy2v7ymYZjfA5f0=;
        h=From:To:Cc:Subject:Date;
        b=GaPzrwuXn6SdYVaI6PllYmKoGQl4hufXYDqc7A5/MAQcgbtYweBZ0+d24CSs8Y57n
         BEk6fb3jGAavkdp4oMZjPh07j1vaFcHg+L2VuKGwzHKp7oh59zLLW/Nuj+mhhkl+nh
         jwYwA3f5ID4esGy5hP13G62psP1l30Bx0D50m29ZcXT4g4PlNQWdcu3K2ksXTQ+alR
         CwPTy8Cy+4MJ/dZjDC4bXjPDHF5l+WjfGeI7wCcUWfYKR12liqI/pm9iwIwNG+Kp+c
         QiGc4oPaPD3eh+z1Q7l4VTAPJ/CnL03MbE12jad4UWKK0+Sbp9mBCUxWqF8GdysT+o
         sh/IOYutmugYw==
From:   Sean Nyekjaer <sean@geanix.com>
To:     mkl@pengutronix.de, dmurphy@ti.com, linux-can@vger.kernel.org
Cc:     Sean Nyekjaer <sean@geanix.com>, martin@geanix.com,
        stable@vger.kernel.org
Subject: [PATCH v3 1/2] can: m_can: tcan4x5x: put the device out of standby before register access
Date:   Wed, 11 Dec 2019 07:42:07 +0100
Message-Id: <20191211064208.84656-1-sean@geanix.com>
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

The m_can tries to detect if Non ISO Operation is available while in standby,
this function results in the following error:

tcan4x5x spi2.0 (unnamed net_device) (uninitialized): Failed to init module
tcan4x5x spi2.0: m_can device registered (irq=84, version=32)
tcan4x5x spi2.0 can2: TCAN4X5X successfully initialized.

When the tcan device comes out of reset it comes out in standby mode.
The m_can driver tries to access the control register but fails due to
the device is in standby mode.
So this patch will put the tcan device in normal mode before the m_can
driver does the initialization.

Fixes: a229abeed7f7 ("can: tcan4x5x: Turn on the power before parsing the config")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Nyekjaer <sean@geanix.com>
---
Changes since v2:
 - added error handling for tcan4x5x_init call

 drivers/net/can/m_can/tcan4x5x.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/can/m_can/tcan4x5x.c b/drivers/net/can/m_can/tcan4x5x.c
index b6b2feca9e8f..1f04fec7723d 100644
--- a/drivers/net/can/m_can/tcan4x5x.c
+++ b/drivers/net/can/m_can/tcan4x5x.c
@@ -460,6 +460,10 @@ static int tcan4x5x_can_probe(struct spi_device *spi)
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

