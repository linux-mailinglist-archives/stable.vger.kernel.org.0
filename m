Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 859A34525CB
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 02:56:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381991AbhKPB6P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 20:58:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:53198 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240541AbhKOSKe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:10:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 707D6633B6;
        Mon, 15 Nov 2021 17:47:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636998429;
        bh=3nzzdDkjlvkobx2nCQ2lwoLG4aVMCtPKUMiv5U6CBqI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TvrISc/ZCFEakmJ9l9CIG15NWI19vdbX4+KyfqaL+86oG4neL1wrfRqQGc4YEwyJ4
         MYCu0RAphcmeAM9YJ3Ykpa6Q0jZJ1zJRoGqrAGw7Ieg84lz7R2Yq2GK4rhVzSrkgL0
         KcMeKKbLMyDdETPyWADTEPygYUfFY+uRScaKgu0E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Richard Fitzgerald <rf@opensource.cirrus.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 463/575] ASoC: cs42l42: Correct configuring of switch inversion from ts-inv
Date:   Mon, 15 Nov 2021 18:03:08 +0100
Message-Id: <20211115165359.746265673@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165343.579890274@linuxfoundation.org>
References: <20211115165343.579890274@linuxfoundation.org>
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
index e56d3c9c39756..54c1ede59b8b7 100644
--- a/sound/soc/codecs/cs42l42.c
+++ b/sound/soc/codecs/cs42l42.c
@@ -1529,12 +1529,15 @@ static void cs42l42_setup_hs_type_detect(struct cs42l42_private *cs42l42)
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
@@ -1578,10 +1581,6 @@ static int cs42l42_handle_device_data(struct device *dev,
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



