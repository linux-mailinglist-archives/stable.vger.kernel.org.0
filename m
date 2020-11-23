Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34AA62C09B1
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 14:18:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387786AbgKWNKf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 08:10:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:60866 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732503AbgKWMrH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:47:07 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B41E220732;
        Mon, 23 Nov 2020 12:47:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606135626;
        bh=nUwjvUuvRfgHtitVOBNA/84Qa48eljszewsRKcfaxpM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HJ+ozr2jCTPZsUjAAfgxgtFDSM9ye4YzWqojW8bcxi1L1Vl8eyS2SI++gfbosHTeA
         ZEPX+IuY0xbj4+L8MKrODR74TKSBs0lOwswhkI8EyqpUUGcl5VkeMQdWvfiqDJz21c
         3yCPoWoi1UDg+McRnLF4ObredhzQQl0ivFM/9QW0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Enric Balletbo i Serra <enric.balletbo@collabora.com>,
        Dan Murphy <dmurphy@ti.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 136/252] can: tcan4x5x: replace depends on REGMAP_SPI with depends on SPI
Date:   Mon, 23 Nov 2020 13:21:26 +0100
Message-Id: <20201123121842.159331486@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121835.580259631@linuxfoundation.org>
References: <20201123121835.580259631@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Enric Balletbo i Serra <enric.balletbo@collabora.com>

[ Upstream commit 3fcce133f0d9a50d3a23f8e2bc950197b4e03900 ]

regmap is a library function that gets selected by drivers that need it. No
driver modules should depend on it. Instead depends on SPI and select
REGMAP_SPI. Depending on REGMAP_SPI makes this driver only build if another
driver already selected REGMAP_SPI, as the symbol can't be selected through the
menu kernel configuration.

Signed-off-by: Enric Balletbo i Serra <enric.balletbo@collabora.com>
Link: http://lore.kernel.org/r/20200413141013.506613-1-enric.balletbo@collabora.com
Reviewed-by: Dan Murphy <dmurphy@ti.com>
Fixes: 5443c226ba91 ("can: tcan4x5x: Add tcan4x5x driver to the kernel")
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/m_can/Kconfig | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/can/m_can/Kconfig b/drivers/net/can/m_can/Kconfig
index d9216147ca93f..3acedb766c48c 100644
--- a/drivers/net/can/m_can/Kconfig
+++ b/drivers/net/can/m_can/Kconfig
@@ -16,7 +16,8 @@ config CAN_M_CAN_PLATFORM
 
 config CAN_M_CAN_TCAN4X5X
 	depends on CAN_M_CAN
-	depends on REGMAP_SPI
+	depends on SPI
+	select REGMAP_SPI
 	tristate "TCAN4X5X M_CAN device"
 	help
 	  Say Y here if you want support for Texas Instruments TCAN4x5x
-- 
2.27.0



