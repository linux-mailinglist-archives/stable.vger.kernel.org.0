Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FD062C0857
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 14:16:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732879AbgKWMtM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 07:49:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:33802 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732844AbgKWMsn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:48:43 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F33CB21D7E;
        Mon, 23 Nov 2020 12:48:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606135705;
        bh=Le1NjB692iaLJZwnQ1ioohPuDjjXYWQ4Y0kdUTfhgaM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HTQGQ6O2WsugWZjPxHi4cL0GOvRjMkR/UO4q3OyFkuvLk8KSDy6DTXWWgeLBajC3G
         fSydUENPTq+PkNmfg23Ddw0RtXx4UOs45PnFK2jay6bzZv2le8AXW//q9s2WBeW9V0
         fIxJqVsl5ww0rSfhrPdfHUwrfq8g85EMI37tFo3U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Brent Lu <brent.lu@intel.com>,
        Curtis Malainey <cujomalainey@chromium.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 165/252] ASOC: Intel: kbl_rt5663_rt5514_max98927: Do not try to disable disabled clock
Date:   Mon, 23 Nov 2020 13:21:55 +0100
Message-Id: <20201123121843.555249840@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121835.580259631@linuxfoundation.org>
References: <20201123121835.580259631@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guenter Roeck <linux@roeck-us.net>

[ Upstream commit 879ee8b6f2bae0cc4a25536f8841db1dbc969523 ]

In kabylake_set_bias_level(), enabling mclk may fail if the clock has
already been enabled by the firmware. Attempts to disable that clock
later will fail with a warning backtrace.

mclk already disabled
WARNING: CPU: 2 PID: 108 at drivers/clk/clk.c:952 clk_core_disable+0x1b6/0x1cf
...
Call Trace:
 clk_disable+0x2d/0x3a
 kabylake_set_bias_level+0x72/0xfd [snd_soc_kbl_rt5663_rt5514_max98927]
 snd_soc_card_set_bias_level+0x2b/0x6f
 snd_soc_dapm_set_bias_level+0xe1/0x209
 dapm_pre_sequence_async+0x63/0x96
 async_run_entry_fn+0x3d/0xd1
 process_one_work+0x2a9/0x526
...

Only disable the clock if it has been enabled.

Fixes: 15747a802075 ("ASoC: eve: implement set_bias_level function for rt5514")
Cc: Brent Lu <brent.lu@intel.com>
Cc: Curtis Malainey <cujomalainey@chromium.org>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Link: https://lore.kernel.org/r/20201111205434.207610-1-linux@roeck-us.net
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/boards/kbl_rt5663_rt5514_max98927.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/soc/intel/boards/kbl_rt5663_rt5514_max98927.c b/sound/soc/intel/boards/kbl_rt5663_rt5514_max98927.c
index 922cd0176e1ff..f95546c184aae 100644
--- a/sound/soc/intel/boards/kbl_rt5663_rt5514_max98927.c
+++ b/sound/soc/intel/boards/kbl_rt5663_rt5514_max98927.c
@@ -700,6 +700,8 @@ static int kabylake_set_bias_level(struct snd_soc_card *card,
 	switch (level) {
 	case SND_SOC_BIAS_PREPARE:
 		if (dapm->bias_level == SND_SOC_BIAS_ON) {
+			if (!__clk_is_enabled(priv->mclk))
+				return 0;
 			dev_dbg(card->dev, "Disable mclk");
 			clk_disable_unprepare(priv->mclk);
 		} else {
-- 
2.27.0



