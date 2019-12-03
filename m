Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93413111FDF
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 00:16:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727882AbfLCWjs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 17:39:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:50588 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727967AbfLCWjr (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 17:39:47 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7CA062080F;
        Tue,  3 Dec 2019 22:39:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575412786;
        bh=bfJajeQIb8sijPheFihRNFkc21fQtvyr5jOXGk+0Q/Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rgXFbPpAoullQmKd+0BRTaAkHr2eeALRyfrFz1xMUBHTiV4JsgUz9jRCqBpuiOPYL
         OBJvZKIDu5G8Lq2kDezjN9KhumU/WiVpyo7cVCs8bQs8ri0BahNgqR6E7IhR2y34Dm
         +JUc0N8D1ZD7LVcOtcyyCmfx+AIxsOktOovC6QHs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Russell King <rmk+kernel@armlinux.org.uk>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 017/135] ASoC: kirkwood: fix device remove ordering
Date:   Tue,  3 Dec 2019 23:34:17 +0100
Message-Id: <20191203213009.198177109@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191203213005.828543156@linuxfoundation.org>
References: <20191203213005.828543156@linuxfoundation.org>
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
index c323ae314b554..eb38cdb37f0ea 100644
--- a/sound/soc/kirkwood/kirkwood-i2s.c
+++ b/sound/soc/kirkwood/kirkwood-i2s.c
@@ -591,7 +591,7 @@ static int kirkwood_i2s_dev_probe(struct platform_device *pdev)
 		priv->ctl_rec |= KIRKWOOD_RECCTL_BURST_128;
 	}
 
-	err = devm_snd_soc_register_component(&pdev->dev, &kirkwood_soc_component,
+	err = snd_soc_register_component(&pdev->dev, &kirkwood_soc_component,
 					 soc_dai, 2);
 	if (err) {
 		dev_err(&pdev->dev, "snd_soc_register_component failed\n");
@@ -614,6 +614,7 @@ static int kirkwood_i2s_dev_remove(struct platform_device *pdev)
 {
 	struct kirkwood_dma_data *priv = dev_get_drvdata(&pdev->dev);
 
+	snd_soc_unregister_component(&pdev->dev);
 	if (!IS_ERR(priv->extclk))
 		clk_disable_unprepare(priv->extclk);
 	clk_disable_unprepare(priv->clk);
-- 
2.20.1



