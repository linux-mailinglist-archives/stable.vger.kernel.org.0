Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65CFD24B738
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 12:50:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731022AbgHTKPI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 06:15:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:34072 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728648AbgHTKPF (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 06:15:05 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5052120724;
        Thu, 20 Aug 2020 10:15:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597918503;
        bh=NnsOgkFkY5IHESmBT5t/41GWPFnhKjY1FN9F62r2EOw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pn1YH+AP2UwqrlJ98L0pgTD8M5G9bzOTCWQTrnYOmM8ENRbuuT36rvrDJA6YJ40nn
         XogaxFq6B8G1GkweY5FFv2AN02ZI8GkbMbQNdVswP48FPW0QiOLWG5BHZGYEitpoeh
         /bAIMhRlbygzwM1E04pnW4QS3WzNHEToi7Q8wMrU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Charles Keepax <ckeepax@opensource.cirrus.com>,
        Lee Jones <lee.jones@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 195/228] mfd: arizona: Ensure 32k clock is put on driver unbind and error
Date:   Thu, 20 Aug 2020 11:22:50 +0200
Message-Id: <20200820091617.309030781@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091607.532711107@linuxfoundation.org>
References: <20200820091607.532711107@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Charles Keepax <ckeepax@opensource.cirrus.com>

[ Upstream commit ddff6c45b21d0437ce0c85f8ac35d7b5480513d7 ]

Whilst it doesn't matter if the internal 32k clock register settings
are cleaned up on exit, as the part will be turned off losing any
settings, hence the driver hasn't historially bothered. The external
clock should however be cleaned up, as it could cause clocks to be
left on, and will at best generate a warning on unbind.

Add clean up on both the probe error path and unbind for the 32k
clock.

Fixes: cdd8da8cc66b ("mfd: arizona: Add gating of external MCLKn clocks")
Signed-off-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/arizona-core.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/mfd/arizona-core.c b/drivers/mfd/arizona-core.c
index ad8a5296c50ba..9aa33141e7f14 100644
--- a/drivers/mfd/arizona-core.c
+++ b/drivers/mfd/arizona-core.c
@@ -1528,6 +1528,15 @@ int arizona_dev_init(struct arizona *arizona)
 	arizona_irq_exit(arizona);
 err_pm:
 	pm_runtime_disable(arizona->dev);
+
+	switch (arizona->pdata.clk32k_src) {
+	case ARIZONA_32KZ_MCLK1:
+	case ARIZONA_32KZ_MCLK2:
+		arizona_clk32k_disable(arizona);
+		break;
+	default:
+		break;
+	}
 err_reset:
 	arizona_enable_reset(arizona);
 	regulator_disable(arizona->dcvdd);
@@ -1550,6 +1559,15 @@ int arizona_dev_exit(struct arizona *arizona)
 	regulator_disable(arizona->dcvdd);
 	regulator_put(arizona->dcvdd);
 
+	switch (arizona->pdata.clk32k_src) {
+	case ARIZONA_32KZ_MCLK1:
+	case ARIZONA_32KZ_MCLK2:
+		arizona_clk32k_disable(arizona);
+		break;
+	default:
+		break;
+	}
+
 	mfd_remove_devices(arizona->dev);
 	arizona_free_irq(arizona, ARIZONA_IRQ_UNDERCLOCKED, arizona);
 	arizona_free_irq(arizona, ARIZONA_IRQ_OVERCLOCKED, arizona);
-- 
2.25.1



