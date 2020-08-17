Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12BAC247638
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 21:35:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732238AbgHQTfA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 15:35:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:49048 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730131AbgHQP3n (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:29:43 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CA1EE2395B;
        Mon, 17 Aug 2020 15:29:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597678183;
        bh=BuJEaREvInwyPxaAcnGoOa/f2RTigPclr2JZ8rA+a6Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KkbC00oPTHFIT6I/0pS/XC/sKSNXi3W5ZGX4r8M0xyBSZSCO4fqEexvgTJKWFh/OO
         hGCtj2ICsLB2xVFf7W/znue3vZt+Qob3m1bINq97fGCy6I3Flq9nho0fqUZS1qUUD5
         IrVYNwcfRKCMt27eKPuO64nbWcGtHqBpEVnW2UxM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jing Xiangfeng <jingxiangfeng@huawei.com>,
        Jerome Brunet <jbrunet@baylibre.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 246/464] ASoC: meson: fixes the missed kfree() for axg_card_add_tdm_loopback
Date:   Mon, 17 Aug 2020 17:13:19 +0200
Message-Id: <20200817143845.580630640@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143833.737102804@linuxfoundation.org>
References: <20200817143833.737102804@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jing Xiangfeng <jingxiangfeng@huawei.com>

[ Upstream commit bd054ece7d9cdd88e900df6625e951a01d9f655e ]

axg_card_add_tdm_loopback() misses to call kfree() in an error path. We
can use devm_kasprintf() to fix the issue, also improve maintainability.
So use it instead.

Fixes: c84836d7f650 ("ASoC: meson: axg-card: use modern dai_link style")
Signed-off-by: Jing Xiangfeng <jingxiangfeng@huawei.com>
Reviewed-by: Jerome Brunet <jbrunet@baylibre.com>
Link: https://lore.kernel.org/r/20200717082242.130627-1-jingxiangfeng@huawei.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/meson/axg-card.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/meson/axg-card.c b/sound/soc/meson/axg-card.c
index 89f7f64747cd0..47f2d93224fea 100644
--- a/sound/soc/meson/axg-card.c
+++ b/sound/soc/meson/axg-card.c
@@ -116,7 +116,7 @@ static int axg_card_add_tdm_loopback(struct snd_soc_card *card,
 
 	lb = &card->dai_link[*index + 1];
 
-	lb->name = kasprintf(GFP_KERNEL, "%s-lb", pad->name);
+	lb->name = devm_kasprintf(card->dev, GFP_KERNEL, "%s-lb", pad->name);
 	if (!lb->name)
 		return -ENOMEM;
 
-- 
2.25.1



