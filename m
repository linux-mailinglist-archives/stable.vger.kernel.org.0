Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DD803C3111
	for <lists+stable@lfdr.de>; Sat, 10 Jul 2021 04:48:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232756AbhGJCkF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 22:40:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:58366 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235785AbhGJCjq (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 22:39:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AD29361411;
        Sat, 10 Jul 2021 02:35:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625884548;
        bh=mg/dBNjmOrN16CbWPwjsPBTSuVAxaYt3Ce/hTeTt/RE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ruNS+ntoQajiU0iasZckCEW3R9TzlajofRlpQ2xz7G5OHAdzxcspnvT7LCJirVdWH
         Yi8k0ye+q99vM2AXcTCzUICQdcnjuke2kQRDSWI7PAfvdOUSGkCzdvXEXfls+6B1Dh
         pNN0CaKs7Hv7KBXjZ6SHsKSdIM3YGls3uIUeVK9nvWKybDqLVKrm+uIjgC6T8mDhLg
         YCcfZ/NJ7JY4YIFIcIzPsSQ1cN377zgIRSKUm0keRlXP2q5hslRkLZ+/sYkCiDUsfX
         d7Cw8rC5EWfJTFgCjitKUVjP+D18h0AfHuP1V53U15+cbr613P1CR0wJ5LOUDq/lZl
         VNC6VlrxRFM+Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zhen Lei <thunder.leizhen@huawei.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 4.14 22/33] ASoC: soc-core: Fix the error return code in snd_soc_of_parse_audio_routing()
Date:   Fri,  9 Jul 2021 22:35:04 -0400
Message-Id: <20210710023516.3172075-22-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710023516.3172075-1-sashal@kernel.org>
References: <20210710023516.3172075-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhen Lei <thunder.leizhen@huawei.com>

[ Upstream commit 7d3865a10b9ff2669c531d5ddd60bf46b3d48f1e ]

When devm_kcalloc() fails, the error code -ENOMEM should be returned
instead of -EINVAL.

Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
Link: https://lore.kernel.org/r/20210617103729.1918-1-thunder.leizhen@huawei.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/soc-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/soc-core.c b/sound/soc/soc-core.c
index 42c2a3065b77..2a172de37466 100644
--- a/sound/soc/soc-core.c
+++ b/sound/soc/soc-core.c
@@ -4046,7 +4046,7 @@ int snd_soc_of_parse_audio_routing(struct snd_soc_card *card,
 	if (!routes) {
 		dev_err(card->dev,
 			"ASoC: Could not allocate DAPM route table\n");
-		return -EINVAL;
+		return -ENOMEM;
 	}
 
 	for (i = 0; i < num_routes; i++) {
-- 
2.30.2

