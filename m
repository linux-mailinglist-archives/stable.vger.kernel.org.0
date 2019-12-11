Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AEF1111AECF
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 16:08:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730333AbfLKPIV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:08:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:55852 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729278AbfLKPIV (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:08:21 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 869A42173E;
        Wed, 11 Dec 2019 15:08:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576076900;
        bh=PEXbdbcTwz9Yf1jmvGdpVO3r9pHGV6EuGPob3XgPlvU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Sx5/I0fjr1P0XFba7270EhboWlJkblQXxkfVRyjSX32pEslx5LJUnR0FlnS/QDPHS
         QOnUXBnKPL8Q/qXzEfoZO0NVT/DlIben3ivURbF3hsWbjLcSo8RmniE/MPHMv591ys
         gtx2L0grkX8ohsYKbUFf/7RFxjLaA58GX4Bjp/yQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
        Sergey 'Jin' Bostandzhyan <jin@mediatomb.cc>
Subject: [PATCH 5.4 32/92] ALSA: hda/realtek - Fix inverted bass GPIO pin on Acer 8951G
Date:   Wed, 11 Dec 2019 16:05:23 +0100
Message-Id: <20191211150236.134053100@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191211150221.977775294@linuxfoundation.org>
References: <20191211150221.977775294@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit 336820c4374bc065317f247dc2bb37c0e41b64a6 upstream.

We've added the bass speaker support on Acer 8951G by the commit
00066e9733f6 ("Add Acer Aspire Ethos 8951G model quirk"), but it seems
that the GPIO pin was wrongly set: while the commit turns off the bit
to power up the amp, the actual hardware reacts other way round,
i.e. GPIO bit on = amp on.

So this patch fixes the bug, turning on the GPIO bit 0x02 as default.
Since turning on the GPIO bit can be more easily managed with
alc_setup_gpio() call, we simplify the quirk code by integrating the
GPIO setup into the existing alc662_fixup_aspire_ethos_hp() and
dropping the whole ALC669_FIXUP_ACER_ASPIRE_ETHOS_SUBWOOFER quirk.

Fixes: 00066e9733f6 ("Add Acer Aspire Ethos 8951G model quirk")
Reported-and-tested-by: Sergey 'Jin' Bostandzhyan <jin@mediatomb.cc>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20191128202630.6626-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_realtek.c |   17 +++--------------
 1 file changed, 3 insertions(+), 14 deletions(-)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -8467,6 +8467,8 @@ static void alc662_fixup_aspire_ethos_hp
 	case HDA_FIXUP_ACT_PRE_PROBE:
 		snd_hda_jack_detect_enable_callback(codec, 0x1b,
 				alc662_aspire_ethos_mute_speakers);
+		/* subwoofer needs an extra GPIO setting to become audible */
+		alc_setup_gpio(codec, 0x02);
 		break;
 	case HDA_FIXUP_ACT_INIT:
 		/* Make sure to start in a correct state, i.e. if
@@ -8549,7 +8551,6 @@ enum {
 	ALC662_FIXUP_USI_HEADSET_MODE,
 	ALC662_FIXUP_LENOVO_MULTI_CODECS,
 	ALC669_FIXUP_ACER_ASPIRE_ETHOS,
-	ALC669_FIXUP_ACER_ASPIRE_ETHOS_SUBWOOFER,
 	ALC669_FIXUP_ACER_ASPIRE_ETHOS_HEADSET,
 };
 
@@ -8881,18 +8882,6 @@ static const struct hda_fixup alc662_fix
 		.type = HDA_FIXUP_FUNC,
 		.v.func = alc662_fixup_aspire_ethos_hp,
 	},
-	[ALC669_FIXUP_ACER_ASPIRE_ETHOS_SUBWOOFER] = {
-		.type = HDA_FIXUP_VERBS,
-		/* subwoofer needs an extra GPIO setting to become audible */
-		.v.verbs = (const struct hda_verb[]) {
-			{0x01, AC_VERB_SET_GPIO_MASK, 0x02},
-			{0x01, AC_VERB_SET_GPIO_DIRECTION, 0x02},
-			{0x01, AC_VERB_SET_GPIO_DATA, 0x00},
-			{ }
-		},
-		.chained = true,
-		.chain_id = ALC669_FIXUP_ACER_ASPIRE_ETHOS_HEADSET
-	},
 	[ALC669_FIXUP_ACER_ASPIRE_ETHOS] = {
 		.type = HDA_FIXUP_PINS,
 		.v.pins = (const struct hda_pintbl[]) {
@@ -8902,7 +8891,7 @@ static const struct hda_fixup alc662_fix
 			{ }
 		},
 		.chained = true,
-		.chain_id = ALC669_FIXUP_ACER_ASPIRE_ETHOS_SUBWOOFER
+		.chain_id = ALC669_FIXUP_ACER_ASPIRE_ETHOS_HEADSET
 	},
 };
 


