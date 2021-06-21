Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A7AF3AF01C
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 18:44:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231495AbhFUQqT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 12:46:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:37672 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233339AbhFUQoI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Jun 2021 12:44:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2B09D61454;
        Mon, 21 Jun 2021 16:32:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624293135;
        bh=NtMKHikNEMchJUzwx8CdjNO3tpRArTcGzKU5NJGU3j4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AmpHHVQEn1MOOPwqJTUkENTX7RF4EREed8WeTxollO7wSDuv2PiNmy58zqZQlwG5c
         BwKX8mSDMZ3CFSq0SA1kjevolZgDZ97IxtSdRtHdfDJajFaXjk3ul/Oaxhd2JOuqEB
         dHoW9usetEe4gIeRE6GPrBd2FV73BC1CHi7umC0A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nicolas Cavallari <nicolas.cavallari@green-communications.fr>,
        Shengjiu Wang <shengjiu.wang@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 094/178] ASoC: fsl-asoc-card: Set .owner attribute when registering card.
Date:   Mon, 21 Jun 2021 18:15:08 +0200
Message-Id: <20210621154925.935754006@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210621154921.212599475@linuxfoundation.org>
References: <20210621154921.212599475@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index f62f81ceab0d..9dcbe5d5a428 100644
--- a/sound/soc/fsl/fsl-asoc-card.c
+++ b/sound/soc/fsl/fsl-asoc-card.c
@@ -732,6 +732,7 @@ static int fsl_asoc_card_probe(struct platform_device *pdev)
 	/* Initialize sound card */
 	priv->pdev = pdev;
 	priv->card.dev = &pdev->dev;
+	priv->card.owner = THIS_MODULE;
 	ret = snd_soc_of_parse_card_name(&priv->card, "model");
 	if (ret) {
 		snprintf(priv->name, sizeof(priv->name), "%s-audio",
-- 
2.30.2



