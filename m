Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60F5011759E
	for <lists+stable@lfdr.de>; Mon,  9 Dec 2019 20:24:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726975AbfLITYq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Dec 2019 14:24:46 -0500
Received: from first.geanix.com ([116.203.34.67]:43958 "EHLO first.geanix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726637AbfLITYq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Dec 2019 14:24:46 -0500
Received: from zen.localdomain (unknown [85.184.140.241])
        by first.geanix.com (Postfix) with ESMTPSA id 8AE87406;
        Mon,  9 Dec 2019 19:24:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=geanix.com; s=first;
        t=1575919463; bh=QjFCVSAPy2ARG9bNtnMJwUs/JlDCCyMo7x7gCr7K2sI=;
        h=From:To:Cc:Subject:Date;
        b=IYtvEpy9iny1PUpxURu0mWMv74AMjeUYApWejNQpn2IBNEiLmENsth7ksA0oiqzSr
         LtpsyxOdTbssUboWWn6TWE7ntrP2P4z0/0eGwIpx7qlT4XR063t6NFkajD3vkV/VWv
         YsX1gkM053Y735cZm/HQ0TzLuVX2BaOcaTAGIfB8Sp4E0gyN1NmUQ0yZplhlobEZFz
         CaPKS7YPs+YgvOtzeqAqRJWkS7gqfu7C0e52v1yQ3Vjx6XUltG1vQkwb+HmFbzitqe
         WJ2EecPVAhZMvmlr95gioqaZ3MfppwLYIT17Y+Gmu4wx4JHnzqsEooLelAQLQHSo1L
         cSKmIy6UNFHLg==
From:   Sean Nyekjaer <sean@geanix.com>
To:     mkl@pengutronix.de, dmurphy@ti.com, linux-can@vger.kernel.org
Cc:     Sean Nyekjaer <sean@geanix.com>, martin@geanix.com,
        stable@vger.kernel.org
Subject: [PATCH v2 1/2] can: m_can: tcan4x5x: put the device out of standby before register access
Date:   Mon,  9 Dec 2019 20:24:39 +0100
Message-Id: <20191209192440.998659-1-sean@geanix.com>
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

The m_can tries to detect of niso (canfd) is available while in standby,
this function results in the following error:

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
---
tcan4x5x_init will now be called from probe and the m_can call.
Would it be better to move the mode switch only to the probe function?

 drivers/net/can/m_can/tcan4x5x.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/can/m_can/tcan4x5x.c b/drivers/net/can/m_can/tcan4x5x.c
index 4e1789ea2bc3..3c30209ca84c 100644
--- a/drivers/net/can/m_can/tcan4x5x.c
+++ b/drivers/net/can/m_can/tcan4x5x.c
@@ -455,6 +455,8 @@ static int tcan4x5x_can_probe(struct spi_device *spi)
 	if (ret)
 		goto out_clk;
 
+	tcan4x5x_init(mcan_class);
+
 	tcan4x5x_power_enable(priv->power, 1);
 
 	ret = m_can_class_register(mcan_class);
-- 
2.24.0

