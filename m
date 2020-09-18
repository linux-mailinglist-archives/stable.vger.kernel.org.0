Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3104A26EE9C
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 04:29:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728695AbgIRC3j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 22:29:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:43566 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729142AbgIRCPB (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 22:15:01 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 275962395C;
        Fri, 18 Sep 2020 02:15:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600395300;
        bh=BMzq0/0NCndOWOdqo2rIqMgNbKC5F0OgLFJz6fP2/1U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I3BYl4BuScPIDrX+FfvztSsdIO+p5nQCJf7683gDhFyaJFKaUvlQuX0r3q/TH8q5i
         gdh1f22Fg58h9Q5X3lwKFVYqQlKGJe/2QOqJIaZmHHKjKNrTAB5r5DZL5zEI61OG2O
         H1Ohs++JvZIoLb4VqnnBVcWzRyh9IUWSXgDFbes0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Russell King <rmk+kernel@armlinux.org.uk>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 4.9 04/90] ASoC: kirkwood: fix IRQ error handling
Date:   Thu, 17 Sep 2020 22:13:29 -0400
Message-Id: <20200918021455.2067301-4-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918021455.2067301-1-sashal@kernel.org>
References: <20200918021455.2067301-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Russell King <rmk+kernel@armlinux.org.uk>

[ Upstream commit 175fc928198236037174e5c5c066fe3c4691903e ]

Propagate the error code from request_irq(), rather than returning
-EBUSY.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Link: https://lore.kernel.org/r/E1iNIqh-0000tW-EZ@rmk-PC.armlinux.org.uk
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/kirkwood/kirkwood-dma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/kirkwood/kirkwood-dma.c b/sound/soc/kirkwood/kirkwood-dma.c
index dafd22e874e99..e655425e4819e 100644
--- a/sound/soc/kirkwood/kirkwood-dma.c
+++ b/sound/soc/kirkwood/kirkwood-dma.c
@@ -136,7 +136,7 @@ static int kirkwood_dma_open(struct snd_pcm_substream *substream)
 		err = request_irq(priv->irq, kirkwood_dma_irq, IRQF_SHARED,
 				  "kirkwood-i2s", priv);
 		if (err)
-			return -EBUSY;
+			return err;
 
 		/*
 		 * Enable Error interrupts. We're only ack'ing them but
-- 
2.25.1

