Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AF752062A7
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 23:10:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390393AbgFWVGO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 17:06:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:59228 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387856AbgFWUgO (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:36:14 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9FF3920781;
        Tue, 23 Jun 2020 20:36:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592944575;
        bh=9qkimgA+IjwOptJjlbPUYsi2L+se0R1w8i0Q8H4QLeo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QaaoF5Wsv+CCN3A9YHeJ3QsWaSuaKjyRWNCacfF7/ylmzu1zsEu4ssXNzMroqzx7C
         4Xkx+fxUBwWYPMfq3EEt34pCIUdv+0mM/wNBHq2YDp5TDa2JcyveA43JKJcapVEyOM
         mv0flSJrAcT/H8qu3rP+r8A0sY6TXzA+2XmXf1qg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Pavel Machek (CIP)" <pavel@denx.de>,
        Jerome Brunet <jbrunet@baylibre.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 043/206] ASoC: meson: add missing free_irq() in error path
Date:   Tue, 23 Jun 2020 21:56:11 +0200
Message-Id: <20200623195319.106632520@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195316.864547658@linuxfoundation.org>
References: <20200623195316.864547658@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Machek (CIP) <pavel@denx.de>

[ Upstream commit 3b8a299a58b2afce464ae11324b59dcf0f1d10a7 ]

free_irq() is missing in case of error, fix that.

Signed-off-by: Pavel Machek (CIP) <pavel@denx.de>
Reviewed-by: Jerome Brunet <jbrunet@baylibre.com>

Link: https://lore.kernel.org/r/20200606153103.GA17905@amd
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/meson/axg-fifo.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/sound/soc/meson/axg-fifo.c b/sound/soc/meson/axg-fifo.c
index 0e4f65e654c4b..b229c182b7c3d 100644
--- a/sound/soc/meson/axg-fifo.c
+++ b/sound/soc/meson/axg-fifo.c
@@ -209,7 +209,7 @@ static int axg_fifo_pcm_open(struct snd_pcm_substream *ss)
 	/* Enable pclk to access registers and clock the fifo ip */
 	ret = clk_prepare_enable(fifo->pclk);
 	if (ret)
-		return ret;
+		goto free_irq;
 
 	/* Setup status2 so it reports the memory pointer */
 	regmap_update_bits(fifo->map, FIFO_CTRL1,
@@ -229,8 +229,14 @@ static int axg_fifo_pcm_open(struct snd_pcm_substream *ss)
 	/* Take memory arbitror out of reset */
 	ret = reset_control_deassert(fifo->arb);
 	if (ret)
-		clk_disable_unprepare(fifo->pclk);
+		goto free_clk;
+
+	return 0;
 
+free_clk:
+	clk_disable_unprepare(fifo->pclk);
+free_irq:
+	free_irq(fifo->irq, ss);
 	return ret;
 }
 
-- 
2.25.1



