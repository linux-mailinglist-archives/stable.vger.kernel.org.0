Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77AEF451F09
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 01:36:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352871AbhKPAiU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 19:38:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:45408 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344520AbhKOTYy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:24:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 04FE263322;
        Mon, 15 Nov 2021 18:59:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637002750;
        bh=SOoSpzREKN29T5NoK7DWwkcHIszVyimxW0AnHBQuNK4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IKzKRgS493u7RM2am7fIMyNeGd+rYyQ2faXoV0SMB5D5Q9c0uaUzP15CBJ3sCu385
         67RlWtGqEtHcKJ4XvOdhoQh0HbsC3XLN6tgdASsIqHgpPu3NK2g+ytf5APnqcCP5kz
         N9OkapO4OvBepP9ORkWlIRXEVU1DR+dMMoKnNfz4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Richard Fitzgerald <rf@opensource.cirrus.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 683/917] ASoC: cs42l42: Correct configuring of switch inversion from ts-inv
Date:   Mon, 15 Nov 2021 18:02:58 +0100
Message-Id: <20211115165452.060873867@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Richard Fitzgerald <rf@opensource.cirrus.com>

[ Upstream commit 778a0cbef5fb76bf506f84938517bb77e7a1c478 ]

The setting from the cirrus,ts-inv property should be applied to the
TIP_SENSE_INV bit, as this is the one that actually affects the jack
detect block. The TS_INV bit only swaps the meaning of the PLUG and
UNPLUG interrupts and should always be 1 for the interrupts to have
the normal meaning.

Due to some misunderstanding the driver had been implemented to
configure the TS_INV bit based on the jack switch polarity. This made
the interrupts behave the correct way around, but left the jack detect
block, button detect and analogue circuits always interpreting an open
switch as unplugged.

The signal chain inside the codec is:

SENSE pin -> TIP_SENSE_INV -> TS_INV -> (invert) -> interrupts
                  |
                  v
             Jack detect,
          button detect and
            analog control

As the TIP_SENSE_INV already performs the necessary inversion the
TS_INV bit never needs to change. It must always be 1 to yield the
expected interrupt behaviour.

Some extra confusion has arisen because of the additional invert in the
interrupt path, meaning that a value applied to the TS_INV bit produces
the opposite effect of applying it to the TIP_SENSE_INV bit. The ts-inv
property has therefore always had the opposite effect to what might be
expected (0 = inverted, 1 = not inverted). To maintain the meaning of
the ts-inv property it must be inverted when applied to TIP_SENSE_INV.

Signed-off-by: Richard Fitzgerald <rf@opensource.cirrus.com>
Fixes: 2c394ca79604 ("ASoC: Add support for CS42L42 codec")
Link: https://lore.kernel.org/r/20211028140902.11786-3-rf@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/cs42l42.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/sound/soc/codecs/cs42l42.c b/sound/soc/codecs/cs42l42.c
index 6034e439d3132..762d9de73dbc2 100644
--- a/sound/soc/codecs/cs42l42.c
+++ b/sound/soc/codecs/cs42l42.c
@@ -1684,12 +1684,15 @@ static void cs42l42_setup_hs_type_detect(struct cs42l42_private *cs42l42)
 			(1 << CS42L42_HS_CLAMP_DISABLE_SHIFT));
 
 	/* Enable the tip sense circuit */
+	regmap_update_bits(cs42l42->regmap, CS42L42_TSENSE_CTL,
+			   CS42L42_TS_INV_MASK, CS42L42_TS_INV_MASK);
+
 	regmap_update_bits(cs42l42->regmap, CS42L42_TIPSENSE_CTL,
 			CS42L42_TIP_SENSE_CTRL_MASK |
 			CS42L42_TIP_SENSE_INV_MASK |
 			CS42L42_TIP_SENSE_DEBOUNCE_MASK,
 			(3 << CS42L42_TIP_SENSE_CTRL_SHIFT) |
-			(0 << CS42L42_TIP_SENSE_INV_SHIFT) |
+			(!cs42l42->ts_inv << CS42L42_TIP_SENSE_INV_SHIFT) |
 			(2 << CS42L42_TIP_SENSE_DEBOUNCE_SHIFT));
 
 	/* Save the initial status of the tip sense */
@@ -1733,10 +1736,6 @@ static int cs42l42_handle_device_data(struct device *dev,
 		cs42l42->ts_inv = CS42L42_TS_INV_DIS;
 	}
 
-	regmap_update_bits(cs42l42->regmap, CS42L42_TSENSE_CTL,
-			CS42L42_TS_INV_MASK,
-			(cs42l42->ts_inv << CS42L42_TS_INV_SHIFT));
-
 	ret = device_property_read_u32(dev, "cirrus,ts-dbnc-rise", &val);
 	if (!ret) {
 		switch (val) {
-- 
2.33.0



