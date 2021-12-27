Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F3374803D5
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 20:06:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232592AbhL0TFy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 14:05:54 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:40778 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232743AbhL0TFY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 14:05:24 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4EC5861159;
        Mon, 27 Dec 2021 19:05:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74142C36AEA;
        Mon, 27 Dec 2021 19:05:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640631923;
        bh=pO/rl7HrNa5vSRkMi1ckvEdlUf5LuUoBlse3bhh2jXg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Mc0azZpaQEyB9NZw4WwwoWoPZ7vCpszftmwX3asYxqAEBP30FOb87uAE9/XwzXuAg
         +uHmiGrtxNkr6LZ5IUd5nEkLkND3KBQPO8Hl7WxMOZ3ThzSZpwchGHKfXzdD93C3ze
         fUDB9nyxneZRM8P48w41hgPTsoq1upk7W67JmFYczFDXaFI+EA8hBowaD6ZXkr6CLC
         L8U4/eY4o484wkYsaCZVRpPlWBeyhLBN9QlGm4kbplFSu8O7hMg/5bcXIu4p8iNLwV
         zRJwQq2+BSCAHZ7CC59hQEFYxb0jQOZRkbLNjysuWIqhQJ0K55FuO70vzpfclXXUen
         xb4f+hwV6h+qw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Martin=20Povi=C5=A1er?= <povik@protonmail.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, lgirdwood@gmail.com,
        perex@perex.cz, tiwai@suse.com, kuninori.morimoto.gx@renesas.com,
        pierre-louis.bossart@linux.intel.com, yebin10@huawei.com,
        alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.10 07/14] ASoC: tas2770: Fix setting of high sample rates
Date:   Mon, 27 Dec 2021 14:04:45 -0500
Message-Id: <20211227190452.1042714-7-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211227190452.1042714-1-sashal@kernel.org>
References: <20211227190452.1042714-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Martin Povišer <povik@protonmail.com>

[ Upstream commit 80d5be1a057e05f01d66e986cfd34d71845e5190 ]

Although the codec advertises support for 176.4 and 192 ksps, without
this fix setting those sample rates fails with EINVAL at hw_params time.

Signed-off-by: Martin Povišer <povik@protonmail.com>
Link: https://lore.kernel.org/r/20211206224529.74656-1-povik@protonmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/tas2770.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/codecs/tas2770.c b/sound/soc/codecs/tas2770.c
index a91a0a31e74d1..61c3238bc2656 100644
--- a/sound/soc/codecs/tas2770.c
+++ b/sound/soc/codecs/tas2770.c
@@ -291,11 +291,11 @@ static int tas2770_set_samplerate(struct tas2770_priv *tas2770, int samplerate)
 		ramp_rate_val = TAS2770_TDM_CFG_REG0_SMP_44_1KHZ |
 				TAS2770_TDM_CFG_REG0_31_88_2_96KHZ;
 		break;
-	case 19200:
+	case 192000:
 		ramp_rate_val = TAS2770_TDM_CFG_REG0_SMP_48KHZ |
 				TAS2770_TDM_CFG_REG0_31_176_4_192KHZ;
 		break;
-	case 17640:
+	case 176400:
 		ramp_rate_val = TAS2770_TDM_CFG_REG0_SMP_44_1KHZ |
 				TAS2770_TDM_CFG_REG0_31_176_4_192KHZ;
 		break;
-- 
2.34.1

