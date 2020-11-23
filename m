Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 692872C09AD
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 14:18:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732801AbgKWNKe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 08:10:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:60894 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732583AbgKWMrJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:47:09 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7C4A320857;
        Mon, 23 Nov 2020 12:47:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606135629;
        bh=et80sD5oEzPCgJtO9zM02+IN/6kKNmSTY/xd8l6rcjY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TG8PEnvVFDPSNkTjYRj1eYEiGPWo/fpyq1w4qnL0SjmRvhmcD9Fjob852RScEMfO7
         9csPNrLnjsJVXsSBJEIgW5vM7Cl/8wPNEUKNfMIO3h1fvfKqd02SRvwBn7CPIkzsED
         WT2dOn1firMz9ZVTnQIm0lU+PpcG7QjF7fAunJds=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Murphy <dmurphy@ti.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 137/252] can: tcan4x5x: tcan4x5x_can_probe(): add missing error checking for devm_regmap_init()
Date:   Mon, 23 Nov 2020 13:21:27 +0100
Message-Id: <20201123121842.207809439@linuxfoundation.org>
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

From: Marc Kleine-Budde <mkl@pengutronix.de>

[ Upstream commit 1ff203badbbf1738027c8395d5b40b0d462b6e4d ]

This patch adds the missing error checking when initializing the regmap
interface fails.

Fixes: 5443c226ba91 ("can: tcan4x5x: Add tcan4x5x driver to the kernel")
Cc: Dan Murphy <dmurphy@ti.com>
Link: http://lore.kernel.org/r/20201019154233.1262589-7-mkl@pengutronix.de
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/m_can/tcan4x5x.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/can/m_can/tcan4x5x.c b/drivers/net/can/m_can/tcan4x5x.c
index eacd428e07e9f..f058bd9104e99 100644
--- a/drivers/net/can/m_can/tcan4x5x.c
+++ b/drivers/net/can/m_can/tcan4x5x.c
@@ -487,6 +487,10 @@ static int tcan4x5x_can_probe(struct spi_device *spi)
 
 	priv->regmap = devm_regmap_init(&spi->dev, &tcan4x5x_bus,
 					&spi->dev, &tcan4x5x_regmap);
+	if (IS_ERR(priv->regmap)) {
+		ret = PTR_ERR(priv->regmap);
+		goto out_clk;
+	}
 
 	ret = tcan4x5x_power_enable(priv->power, 1);
 	if (ret)
-- 
2.27.0



