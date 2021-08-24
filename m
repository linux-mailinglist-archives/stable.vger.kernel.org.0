Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0A403F6626
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:20:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231986AbhHXRU4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 13:20:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:55624 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238767AbhHXRSy (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 13:18:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AF96961AD1;
        Tue, 24 Aug 2021 17:03:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824581;
        bh=r96vHC86Y2bXWDYzoPukiUPUe4HKP48t4e4w71DbyD0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oZsAjq/32VJZQRmGSnn+nd4ZeVbg+PiVS0U/W5fpywRnr3mPMnemse9Fh/+0yL3ia
         tsl2kveaO/wIt2kguE7xxfvuAg6/L/aQtA5ueQfGsRM3PsrBsk3VyvGyZz6+ft7ROV
         mbAGn95z0hqEqSCIVhOwQ4DJBawyUA5b1ELUtMoN/JgoSyQJr1v83pS1ZVUG+itrnx
         G5UTuSYU4dCgY4/bvEeIfLlZgpaBXRTXF8KzorQMz6gmMPn8SDmNXjYS7XAAyG1R5w
         onHJLgPE4awp8iH+6rtKIUL/CJCZCyhd10CbOkCP9HWoy7xSee6tLLl1IKIiEkw9E5
         xdt8UjRy1dQdg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Richard Fitzgerald <rf@opensource.cirrus.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 09/84] ASoC: cs42l42: Don't allow SND_SOC_DAIFMT_LEFT_J
Date:   Tue, 24 Aug 2021 13:01:35 -0400
Message-Id: <20210824170250.710392-10-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824170250.710392-1-sashal@kernel.org>
References: <20210824170250.710392-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.205-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.205-rc1
X-KernelTest-Deadline: 2021-08-26T17:02+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Richard Fitzgerald <rf@opensource.cirrus.com>

[ Upstream commit 64324bac750b84ca54711fb7d332132fcdb87293 ]

The driver has no support for left-justified protocol so it should
not have been allowing this to be passed to cs42l42_set_dai_fmt().

Signed-off-by: Richard Fitzgerald <rf@opensource.cirrus.com>
Fixes: 2c394ca79604 ("ASoC: Add support for CS42L42 codec")
Link: https://lore.kernel.org/r/20210729170929.6589-2-rf@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/cs42l42.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/sound/soc/codecs/cs42l42.c b/sound/soc/codecs/cs42l42.c
index 6a58c666776a..ca6541ac59e1 100644
--- a/sound/soc/codecs/cs42l42.c
+++ b/sound/soc/codecs/cs42l42.c
@@ -773,7 +773,6 @@ static int cs42l42_set_dai_fmt(struct snd_soc_dai *codec_dai, unsigned int fmt)
 	/* interface format */
 	switch (fmt & SND_SOC_DAIFMT_FORMAT_MASK) {
 	case SND_SOC_DAIFMT_I2S:
-	case SND_SOC_DAIFMT_LEFT_J:
 		break;
 	default:
 		return -EINVAL;
-- 
2.30.2

