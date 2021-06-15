Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 852213A84AE
	for <lists+stable@lfdr.de>; Tue, 15 Jun 2021 17:49:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232063AbhFOPvh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Jun 2021 11:51:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:45964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232072AbhFOPvW (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Jun 2021 11:51:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C66E1617ED;
        Tue, 15 Jun 2021 15:49:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623772157;
        bh=EheN55RV15pxgeIQu4DP1PTRSoQC4OUgOyikc4uj/g8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZK2Q5K9U1a+PX1+Q54IvkiR9ljKxxNTUdAHnju5RD12C++GukoX9W1V2L8NrZeem3
         6X+aQgcOenFa54LpuAf+qZlFPRMvyzg4GyL6YbiGOMdrUoM/QsiPPyMOw3U4P3UY8C
         lsiejMZf9Ph1zTl2fLWVzg+aQgwsII1XES79cyp9iefuwoYkW2M6mFoqRVVpAzuq9r
         G8ny4XpEx5+ZpPNdGGqlrbFbMz9qK8DdP/+mq8eXtF2rZMuqNf/NLibwyqIsEBNmPy
         0gnjeuqssgDylnPEsAqCzaDok2WZLOrTw9HB8wH0IDj1lhzQQnjVDMhVtnJHvB/ehz
         bSf8rdoN6nYRg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nicolas Cavallari <nicolas.cavallari@green-communications.fr>,
        Shengjiu Wang <shengjiu.wang@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org,
        linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 5.10 07/30] ASoC: fsl-asoc-card: Set .owner attribute when registering card.
Date:   Tue, 15 Jun 2021 11:48:44 -0400
Message-Id: <20210615154908.62388-7-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210615154908.62388-1-sashal@kernel.org>
References: <20210615154908.62388-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicolas Cavallari <nicolas.cavallari@green-communications.fr>

[ Upstream commit a8437f05384cb472518ec21bf4fffbe8f0a47378 ]

Otherwise, when compiled as module, a WARN_ON is triggered:

WARNING: CPU: 0 PID: 5 at sound/core/init.c:208 snd_card_new+0x310/0x39c [snd]
[...]
CPU: 0 PID: 5 Comm: kworker/0:0 Not tainted 5.10.39 #1
Hardware name: Freescale i.MX6 Quad/DualLite (Device Tree)
Workqueue: events deferred_probe_work_func
[<c0111988>] (unwind_backtrace) from [<c010c8ac>] (show_stack+0x10/0x14)
[<c010c8ac>] (show_stack) from [<c092784c>] (dump_stack+0xdc/0x104)
[<c092784c>] (dump_stack) from [<c0129710>] (__warn+0xd8/0x114)
[<c0129710>] (__warn) from [<c0922a48>] (warn_slowpath_fmt+0x5c/0xc4)
[<c0922a48>] (warn_slowpath_fmt) from [<bf0496f8>] (snd_card_new+0x310/0x39c [snd])
[<bf0496f8>] (snd_card_new [snd]) from [<bf1d7df8>] (snd_soc_bind_card+0x334/0x9c4 [snd_soc_core])
[<bf1d7df8>] (snd_soc_bind_card [snd_soc_core]) from [<bf1e9cd8>] (devm_snd_soc_register_card+0x30/0x6c [snd_soc_core])
[<bf1e9cd8>] (devm_snd_soc_register_card [snd_soc_core]) from [<bf22d964>] (fsl_asoc_card_probe+0x550/0xcc8 [snd_soc_fsl_asoc_card])
[<bf22d964>] (fsl_asoc_card_probe [snd_soc_fsl_asoc_card]) from [<c060c930>] (platform_drv_probe+0x48/0x98)
[...]

Signed-off-by: Nicolas Cavallari <nicolas.cavallari@green-communications.fr>
Acked-by: Shengjiu Wang <shengjiu.wang@gmail.com>
Link: https://lore.kernel.org/r/20210527163409.22049-1-nicolas.cavallari@green-communications.fr
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/fsl/fsl-asoc-card.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/fsl/fsl-asoc-card.c b/sound/soc/fsl/fsl-asoc-card.c
index a2dd3b6b7fec..7cd14d6b9436 100644
--- a/sound/soc/fsl/fsl-asoc-card.c
+++ b/sound/soc/fsl/fsl-asoc-card.c
@@ -720,6 +720,7 @@ static int fsl_asoc_card_probe(struct platform_device *pdev)
 	/* Initialize sound card */
 	priv->pdev = pdev;
 	priv->card.dev = &pdev->dev;
+	priv->card.owner = THIS_MODULE;
 	ret = snd_soc_of_parse_card_name(&priv->card, "model");
 	if (ret) {
 		snprintf(priv->name, sizeof(priv->name), "%s-audio",
-- 
2.30.2

