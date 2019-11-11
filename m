Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BACABF8070
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 20:49:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727053AbfKKTtJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 14:49:09 -0500
Received: from heliosphere.sirena.org.uk ([172.104.155.198]:50328 "EHLO
        heliosphere.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726946AbfKKTtJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Nov 2019 14:49:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sirena.org.uk; s=20170815-heliosphere; h=Date:Message-Id:In-Reply-To:
        Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:References:
        List-Id:List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:
        List-Archive; bh=xlxRJ7eQ2hoWBNWiw5OQy4FAPQxSog2xIp1mf5n6J1Q=; b=qWY/Z3ogFpgE
        WO6W2d8bShpmUmf2IhB/qFCwk1w0Mo/LYxhZESl7RHlfuSEtRWCmHgC8LXLMy/D14o+zx9PdlBovE
        xYRLpGDUa+uK4HPiuxTSjIJ1EVWCNzwiq1zKxqB0y76ltcvYH93B7dwDbARPp65PUsaKhtlq7SjfV
        E2JRM=;
Received: from cpc102320-sgyl38-2-0-cust46.18-2.cable.virginm.net ([82.37.168.47] helo=ypsilon.sirena.org.uk)
        by heliosphere.sirena.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <broonie@sirena.co.uk>)
        id 1iUFgN-0005NW-Qr; Mon, 11 Nov 2019 19:49:03 +0000
Received: by ypsilon.sirena.org.uk (Postfix, from userid 1000)
        id 3FB1E27429EB; Mon, 11 Nov 2019 19:49:03 +0000 (GMT)
From:   Mark Brown <broonie@kernel.org>
To:     Jacob Rasmussen <jacobraz@chromium.org>
Cc:     alsa-devel@alsa-project.org, Jacob Rasmussen <jacobraz@google.com>,
        Mark Brown <broonie@kernel.org>, stable@vger.kernel.org
Subject: Applied "ASoC: rt5645: Fixed buddy jack support." to the asoc tree
In-Reply-To: 
X-Patchwork-Hint: ignore
Message-Id: <20191111194903.3FB1E27429EB@ypsilon.sirena.org.uk>
Date:   Mon, 11 Nov 2019 19:49:03 +0000 (GMT)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The patch

   ASoC: rt5645: Fixed buddy jack support.

has been applied to the asoc tree at

   https://git.kernel.org/pub/scm/linux/kernel/git/broonie/sound.git 

All being well this means that it will be integrated into the linux-next
tree (usually sometime in the next 24 hours) and sent to Linus during
the next merge window (or sooner if it is a bug fix), however if
problems are discovered then the patch may be dropped or reverted.  

You may get further e-mails resulting from automated or manual testing
and review of the tree, please engage with people reporting problems and
send followup patches addressing any issues that are reported if needed.

If any updates are required or you are submitting further changes they
should be sent as incremental updates against current git, existing
patches will not be replaced.

Please add any relevant lists and maintainers to the CCs when replying
to this mail.

Thanks,
Mark

From e7cfd867fd9842f346688f28412eb83dec342900 Mon Sep 17 00:00:00 2001
From: Jacob Rasmussen <jacobraz@chromium.org>
Date: Mon, 11 Nov 2019 11:59:57 -0700
Subject: [PATCH] ASoC: rt5645: Fixed buddy jack support.

The headphone jack on buddy was broken with the following commit:
commit 6b5da66322c5 ("ASoC: rt5645: read jd1_1 status for jd
detection").
This changes the jd_mode for buddy to 4 so buddy can read from the same
register that was used in the working version of this driver without
affecting any other devices that might use this, since no other device uses
jd_mode = 4. To test this I plugged and uplugged the headphone jack, verifying
audio works.

Signed-off-by: Jacob Rasmussen <jacobraz@google.com>
Reviewed-by: Ross Zwisler <zwisler@google.com>
Link: https://lore.kernel.org/r/20191111185957.217244-1-jacobraz@google.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Cc: stable@vger.kernel.org
---
 sound/soc/codecs/rt5645.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/sound/soc/codecs/rt5645.c b/sound/soc/codecs/rt5645.c
index 1c06b3b9218c..902ac98a3fbe 100644
--- a/sound/soc/codecs/rt5645.c
+++ b/sound/soc/codecs/rt5645.c
@@ -3270,6 +3270,9 @@ static void rt5645_jack_detect_work(struct work_struct *work)
 		snd_soc_jack_report(rt5645->mic_jack,
 				    report, SND_JACK_MICROPHONE);
 		return;
+	case 4:
+		val = snd_soc_component_read32(rt5645->component, RT5645_A_JD_CTRL1) & 0x002;
+		break;
 	default: /* read rt5645 jd1_1 status */
 		val = snd_soc_component_read32(rt5645->component, RT5645_INT_IRQ_ST) & 0x1000;
 		break;
@@ -3603,7 +3606,7 @@ static const struct rt5645_platform_data intel_braswell_platform_data = {
 static const struct rt5645_platform_data buddy_platform_data = {
 	.dmic1_data_pin = RT5645_DMIC_DATA_GPIO5,
 	.dmic2_data_pin = RT5645_DMIC_DATA_IN2P,
-	.jd_mode = 3,
+	.jd_mode = 4,
 	.level_trigger_irq = true,
 };
 
@@ -3999,6 +4002,7 @@ static int rt5645_i2c_probe(struct i2c_client *i2c,
 					   RT5645_JD1_MODE_1);
 			break;
 		case 3:
+		case 4:
 			regmap_update_bits(rt5645->regmap, RT5645_A_JD_CTRL1,
 					   RT5645_JD1_MODE_MASK,
 					   RT5645_JD1_MODE_2);
-- 
2.20.1

