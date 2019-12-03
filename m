Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D8739111F49
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 00:10:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729140AbfLCWq7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 17:46:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:36986 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728366AbfLCWq7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 17:46:59 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0B77C20803;
        Tue,  3 Dec 2019 22:46:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575413218;
        bh=qvDtTc3Vuf1laHs5xdQeAbaLlbOV42pcKchtRwzj0EE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=veuj4Zd475CByoPTuciudBt03pOxRBHE+d5N603VOAK+rqhn3z2C4ltnwKqsdNguj
         V/SmTGUG6CybUcEzda2b4DiDk9Z/O7WYVfUuv37H6rPtZ+IxLOCbYeoMeMrw8Ehbjr
         xO++h0Wer3q+uxJvKgUBpW+0k0pvc5G7aHpEc384=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Russell King <rmk+kernel@armlinux.org.uk>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 007/321] ASoC: kirkwood: fix external clock probe defer
Date:   Tue,  3 Dec 2019 23:31:13 +0100
Message-Id: <20191203223427.503442423@linuxfoundation.org>
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

[ Upstream commit 4523817d51bc3b2ef38da768d004fda2c8bc41de ]

When our call to get the external clock fails, we forget to clean up
the enabled internal clock correctly.  Enable the clock after we have
obtained all our resources.

Fixes: 84aac6c79bfd ("ASoC: kirkwood: fix loss of external clock at probe time")
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Link: https://lore.kernel.org/r/E1iNGyK-0004oF-6A@rmk-PC.armlinux.org.uk
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/kirkwood/kirkwood-i2s.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/sound/soc/kirkwood/kirkwood-i2s.c b/sound/soc/kirkwood/kirkwood-i2s.c
index 9a2777b72dcd0..b84a504168473 100644
--- a/sound/soc/kirkwood/kirkwood-i2s.c
+++ b/sound/soc/kirkwood/kirkwood-i2s.c
@@ -563,10 +563,6 @@ static int kirkwood_i2s_dev_probe(struct platform_device *pdev)
 		return PTR_ERR(priv->clk);
 	}
 
-	err = clk_prepare_enable(priv->clk);
-	if (err < 0)
-		return err;
-
 	priv->extclk = devm_clk_get(&pdev->dev, "extclk");
 	if (IS_ERR(priv->extclk)) {
 		if (PTR_ERR(priv->extclk) == -EPROBE_DEFER)
@@ -582,6 +578,10 @@ static int kirkwood_i2s_dev_probe(struct platform_device *pdev)
 		}
 	}
 
+	err = clk_prepare_enable(priv->clk);
+	if (err < 0)
+		return err;
+
 	/* Some sensible defaults - this reflects the powerup values */
 	priv->ctl_play = KIRKWOOD_PLAYCTL_SIZE_24;
 	priv->ctl_rec = KIRKWOOD_RECCTL_SIZE_24;
-- 
2.20.1



