Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C1229111CBD
	for <lists+stable@lfdr.de>; Tue,  3 Dec 2019 23:47:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727918AbfLCWrD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 17:47:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:37048 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729263AbfLCWrC (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 17:47:02 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1F19720656;
        Tue,  3 Dec 2019 22:47:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575413221;
        bh=p8Vp5uNKjcNilaqcwYrNFRcA9gpBPwD+1ufKOzif0mI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TpY8UuuUjZpo1uOFvBNb2hsBeJtXoX108bVfAOT9X4mcQmgC/j7AIPR4rLXIf4mJO
         yI1NuSK0AVdAvrmosKBoUZ7VHxZJVB4XbIQ0Bx9Xpbg2yFkL4Tegjqt8sjT9LLKrBM
         q+LWDzRJX+xlwY0aYg3gIhO3zWptOw+ULV3yzn3Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Russell King <rmk+kernel@armlinux.org.uk>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 008/321] ASoC: kirkwood: fix device remove ordering
Date:   Tue,  3 Dec 2019 23:31:14 +0100
Message-Id: <20191203223427.554244186@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191203223427.103571230@linuxfoundation.org>
References: <20191203223427.103571230@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Russell King <rmk+kernel@armlinux.org.uk>

[ Upstream commit dc39596a906d5b604f4e64597b6e904fc14625e8 ]

The devm conversion of kirkwood was incorrect; on removal, devm takes
effect after the "remove" function has returned.  So, the effect of
the conversion was to change the order during remove from:

  - snd_soc_unregister_component() (unpublishes interfaces)
  - clk_disable_unprepare()
  - cleanup resources

After the conversion, this became:

  - clk_disable_unprepare() - while the device may still be active
  - snd_soc_unregister_component()
  - cleanup resources

Hence, it introduces a bug, where the internal clock for the device
may be shut down before the device itself has been shut down.  It is
known that Marvell SoCs, including Dove, locks up if registers for a
peripheral that has its clocks disabled are accessed.

Fixes: f98fc0f8154e ("ASoC: kirkwood: replace platform to component")
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Link: https://lore.kernel.org/r/E1iNGyP-0004oN-BA@rmk-PC.armlinux.org.uk
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/kirkwood/kirkwood-i2s.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/sound/soc/kirkwood/kirkwood-i2s.c b/sound/soc/kirkwood/kirkwood-i2s.c
index b84a504168473..4395bb7029a06 100644
--- a/sound/soc/kirkwood/kirkwood-i2s.c
+++ b/sound/soc/kirkwood/kirkwood-i2s.c
@@ -595,7 +595,7 @@ static int kirkwood_i2s_dev_probe(struct platform_device *pdev)
 		priv->ctl_rec |= KIRKWOOD_RECCTL_BURST_128;
 	}
 
-	err = devm_snd_soc_register_component(&pdev->dev, &kirkwood_soc_component,
+	err = snd_soc_register_component(&pdev->dev, &kirkwood_soc_component,
 					 soc_dai, 2);
 	if (err) {
 		dev_err(&pdev->dev, "snd_soc_register_component failed\n");
@@ -618,6 +618,7 @@ static int kirkwood_i2s_dev_remove(struct platform_device *pdev)
 {
 	struct kirkwood_dma_data *priv = dev_get_drvdata(&pdev->dev);
 
+	snd_soc_unregister_component(&pdev->dev);
 	if (!IS_ERR(priv->extclk))
 		clk_disable_unprepare(priv->extclk);
 	clk_disable_unprepare(priv->clk);
-- 
2.20.1



