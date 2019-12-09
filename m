Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A14D116890
	for <lists+stable@lfdr.de>; Mon,  9 Dec 2019 09:48:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727239AbfLIIsS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Dec 2019 03:48:18 -0500
Received: from first.geanix.com ([116.203.34.67]:40322 "EHLO first.geanix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727047AbfLIIsR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Dec 2019 03:48:17 -0500
Received: from zen.localdomain (unknown [85.184.140.241])
        by first.geanix.com (Postfix) with ESMTPSA id 018A2407;
        Mon,  9 Dec 2019 08:47:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=geanix.com; s=first;
        t=1575881277; bh=5qvVngsdCaGpF7c/Q9za07YjIDaSfUns+Y+IvPzxjDo=;
        h=From:To:Cc:Subject:Date;
        b=MjDAWG8DkxuyjgJ3E09hSt0Jy8ro+53F6TAK4FIf4hgdjETFTpBKDvzqIvZ50OxPT
         BBWoDn4SBCjmUiqbNn9UTYVMW7VX8rW+UNAOtVPEa75Sx3bEMyjG8M4zxx2HekJJ1f
         PZUH1WioAeZC+7Yp0gGs6Aqpj9ObEobdSM7vXZXPNuS+OylsLsouBl+rNNjsbo0wQX
         /moHBZ1eeV8peeDSVBMpUS8aOfrYsc2b28vd/mIQVnwzJvolScEbmHFSDLPMnz9swm
         nhX1c1okI77VlP3NofHFMyZzNOmd0RrquuaCfq5wSuC8C3fS9evFhgWgCBWvfPpvrq
         f6TTjvwryhFBA==
From:   Sean Nyekjaer <sean@geanix.com>
To:     mkl@pengutronix.de, dmurphy@ti.com, linux-can@vger.kernel.org
Cc:     Sean Nyekjaer <sean@geanix.com>, martin@geanix.com,
        stable@vger.kernel.org
Subject: [PATCH 1/2] can: m_can: tcan4x5x: put the device out of standby before register access
Date:   Mon,  9 Dec 2019 09:48:07 +0100
Message-Id: <20191209084808.908116-1-sean@geanix.com>
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
index cb5fdb695ec9..7f26c2d53f8c 100644
--- a/drivers/net/can/m_can/tcan4x5x.c
+++ b/drivers/net/can/m_can/tcan4x5x.c
@@ -456,6 +456,8 @@ static int tcan4x5x_can_probe(struct spi_device *spi)
 	if (ret)
 		goto out_clk;
 
+	tcan4x5x_init(mcan_class);
+
 	tcan4x5x_power_enable(priv->power, 1);
 
 	ret = m_can_class_register(mcan_class);
-- 
2.24.0

