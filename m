Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FB843E25B1
	for <lists+stable@lfdr.de>; Fri,  6 Aug 2021 10:22:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244262AbhHFIV5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Aug 2021 04:21:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:46112 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244143AbhHFIUv (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 6 Aug 2021 04:20:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 28D886120A;
        Fri,  6 Aug 2021 08:20:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628238023;
        bh=xq9vaZuEISXwGZ9amMGFnKhviWUhwICbRCBqRFA/CAw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UMo9HhhIbhoLuQ8EpesrxKnyC8bLXcY6v5cdKhzodWr/ZNzLypLPQdG2OKqST3cFn
         +oWVXJmQAHkmvisG2eUfYshsZawMS/QpOlGP6z/HGTkC0A1/u+07fKtKA5Uxu9/zzt
         YPqRlorr9rSA1wvd/RX2IjMB0NW47AG1RpoIph4E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oder Chiou <oder_chiou@realtek.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 22/35] ASoC: rt5682: Fix the issue of garbled recording after powerd_dbus_suspend
Date:   Fri,  6 Aug 2021 10:17:05 +0200
Message-Id: <20210806081114.458380450@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210806081113.718626745@linuxfoundation.org>
References: <20210806081113.718626745@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oder Chiou <oder_chiou@realtek.com>

[ Upstream commit 6a503e1c455316fd0bfd8188c0a62cce7c5525ca ]

While using the DMIC recording, the garbled data will be captured by the
DMIC. It is caused by the critical power of PLL closed in the jack detect
function.

Signed-off-by: Oder Chiou <oder_chiou@realtek.com>
Link: https://lore.kernel.org/r/20210716085853.20170-1-oder_chiou@realtek.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt5682.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/sound/soc/codecs/rt5682.c b/sound/soc/codecs/rt5682.c
index e4c91571abae..abcd6f483788 100644
--- a/sound/soc/codecs/rt5682.c
+++ b/sound/soc/codecs/rt5682.c
@@ -973,10 +973,14 @@ int rt5682_headset_detect(struct snd_soc_component *component, int jack_insert)
 		rt5682_enable_push_button_irq(component, false);
 		snd_soc_component_update_bits(component, RT5682_CBJ_CTRL_1,
 			RT5682_TRIG_JD_MASK, RT5682_TRIG_JD_LOW);
-		if (!snd_soc_dapm_get_pin_status(dapm, "MICBIAS"))
+		if (!snd_soc_dapm_get_pin_status(dapm, "MICBIAS") &&
+			!snd_soc_dapm_get_pin_status(dapm, "PLL1") &&
+			!snd_soc_dapm_get_pin_status(dapm, "PLL2B"))
 			snd_soc_component_update_bits(component,
 				RT5682_PWR_ANLG_1, RT5682_PWR_MB, 0);
-		if (!snd_soc_dapm_get_pin_status(dapm, "Vref2"))
+		if (!snd_soc_dapm_get_pin_status(dapm, "Vref2") &&
+			!snd_soc_dapm_get_pin_status(dapm, "PLL1") &&
+			!snd_soc_dapm_get_pin_status(dapm, "PLL2B"))
 			snd_soc_component_update_bits(component,
 				RT5682_PWR_ANLG_1, RT5682_PWR_VREF2, 0);
 		snd_soc_component_update_bits(component, RT5682_PWR_ANLG_3,
-- 
2.30.2



