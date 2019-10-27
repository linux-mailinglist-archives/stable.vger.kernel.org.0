Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F1E22E6740
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 22:19:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731456AbfJ0VTV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 17:19:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:39666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731452AbfJ0VTV (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Oct 2019 17:19:21 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2AA2E205C9;
        Sun, 27 Oct 2019 21:19:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572211160;
        bh=Htv05VN3kJsdeDZwi8YBPXw24VJr2khxFpXcM28opdU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HSMQrnDfvIVV+VVxfR6QUW2YwgsQ1+LOimr7p/a/J+u+86+rA2YRtj1vvalvr8seT
         YhGflVISzcsoG1sZcsIadUNjXk1Orao8fi9/nAMq5CsZsaQQpOqlusvRWyIQGF1Le7
         ZiMOgl5IlCHpXi44Lq7/fq/8vYbjUyNofNLsoT1w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrea Merello <andrea.merello@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 054/197] net: phy: allow for reset line to be tied to a sleepy GPIO controller
Date:   Sun, 27 Oct 2019 21:59:32 +0100
Message-Id: <20191027203354.593849810@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191027203351.684916567@linuxfoundation.org>
References: <20191027203351.684916567@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrea Merello <andrea.merello@gmail.com>

[ Upstream commit ea977d19d918324ad5b66953f051a6ed07d0a3c5 ]

mdio_device_reset() makes use of the atomic-pretending API flavor for
handling the PHY reset GPIO line.

I found no hint that mdio_device_reset() is called from atomic context
and indeed it uses usleep_range() since long time, so I would assume that
it is OK to sleep there.

This patch switch to gpiod_set_value_cansleep() in mdio_device_reset().
This is relevant if e.g. the PHY reset line is tied to a I2C GPIO
controller.

This has been tested on a ZynqMP board running an upstream 4.19 kernel and
then hand-ported on current kernel tree.

Signed-off-by: Andrea Merello <andrea.merello@gmail.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/mdio_device.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/phy/mdio_device.c b/drivers/net/phy/mdio_device.c
index e282600bd83e2..c1d345c3cab35 100644
--- a/drivers/net/phy/mdio_device.c
+++ b/drivers/net/phy/mdio_device.c
@@ -121,7 +121,7 @@ void mdio_device_reset(struct mdio_device *mdiodev, int value)
 		return;
 
 	if (mdiodev->reset_gpio)
-		gpiod_set_value(mdiodev->reset_gpio, value);
+		gpiod_set_value_cansleep(mdiodev->reset_gpio, value);
 
 	if (mdiodev->reset_ctrl) {
 		if (value)
-- 
2.20.1



