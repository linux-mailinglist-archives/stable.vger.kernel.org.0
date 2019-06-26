Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B2C8156037
	for <lists+stable@lfdr.de>; Wed, 26 Jun 2019 05:47:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727534AbfFZDqS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jun 2019 23:46:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:57896 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727242AbfFZDqP (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 25 Jun 2019 23:46:15 -0400
Received: from sasha-vm.mshome.net (mobile-107-77-172-82.mobile.att.net [107.77.172.82])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3DAF520B7C;
        Wed, 26 Jun 2019 03:46:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561520774;
        bh=gDCNEqQy1JUz7bw/phgVJ/JlespFp+YqP6Dz1mJSYYI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tV+k2EB1Rzpdf6d3Nx92cwPpo/L9nD660SDkTxc1d7IhXcx7NV9/BLNqvsEJdjWU9
         ULXIO/dwnWYWdhm5A+KlP1ikBtOLYMRsxlM06swefGIUjj+9kVk6AtrFBKhuxKpw7G
         KReQ5rIP2PxdkTASS5Alx61Z29dvi1ncp+v3Q+RA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Georgii Staroselskii <georgii.staroselskii@emlid.com>,
        Chen-Yu Tsai <wens@csie.org>, Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.9 04/11] ASoC: sun4i-codec: fix first delay on Speaker
Date:   Tue, 25 Jun 2019 23:45:54 -0400
Message-Id: <20190626034602.24367-4-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190626034602.24367-1-sashal@kernel.org>
References: <20190626034602.24367-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Georgii Staroselskii <georgii.staroselskii@emlid.com>

[ Upstream commit 1f2675f6655838aaf910f911fd0abc821e3ff3df ]

Allwinner DAC seems to have a delay in the Speaker audio routing. When
playing a sound for the first time, the sound gets chopped. On a second
play the sound is played correctly. After some time (~5s) the issue gets
back.

This commit seems to be fixing the same issue as bf14da7 but
for another codepath.

This is the DTS that was used to debug the problem.

&codec {
        allwinner,pa-gpios = <&r_pio 0 11 GPIO_ACTIVE_HIGH>; /* PL11 */
        allwinner,audio-routing =
                "Speaker", "LINEOUT";

        status = "okay";
}

Signed-off-by: Georgii Staroselskii <georgii.staroselskii@emlid.com>
Reviewed-by: Chen-Yu Tsai <wens@csie.org>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sunxi/sun4i-codec.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/sound/soc/sunxi/sun4i-codec.c b/sound/soc/sunxi/sun4i-codec.c
index 56ed9472e89f..6099adea68c6 100644
--- a/sound/soc/sunxi/sun4i-codec.c
+++ b/sound/soc/sunxi/sun4i-codec.c
@@ -747,6 +747,15 @@ static int sun4i_codec_spk_event(struct snd_soc_dapm_widget *w,
 		gpiod_set_value_cansleep(scodec->gpio_pa,
 					 !!SND_SOC_DAPM_EVENT_ON(event));
 
+	if (SND_SOC_DAPM_EVENT_ON(event)) {
+		/*
+		 * Need a delay to wait for DAC to push the data. 700ms seems
+		 * to be the best compromise not to feel this delay while
+		 * playing a sound.
+		 */
+		msleep(700);
+	}
+
 	return 0;
 }
 
-- 
2.20.1

