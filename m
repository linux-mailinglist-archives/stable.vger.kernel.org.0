Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4979966CC2C
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 18:22:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234582AbjAPRWw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 12:22:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234493AbjAPRW3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 12:22:29 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87FE45AB65
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 09:00:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 407C0B81091
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 17:00:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93159C433EF;
        Mon, 16 Jan 2023 17:00:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673888414;
        bh=yUWQ/c+/o3PIEMThAQSymkSkEeJsyKZHykM4WKNMFiM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Tr7nPJefYRd+JD9LBEq3scIELq0IptHGb0Ljyf/2TaBATWl7c6wWHASJPboQvgwof
         KmYciJwt9Ll6iIAqJ/5kZgRhxOFYoM5CfD1sT/53R2lAPtednUTHkNAiaIEkKdN2HR
         CpY66i+pI2Q4buWhVMgCrl8K78cJ1sUKMcHns9Ak=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Takashi Iwai <tiwai@suse.de>,
        Sergey 'Jin' Bostandzhyan <jin@mediatomb.cc>
Subject: [PATCH 4.19 518/521] ALSA: hda/realtek - Fix inverted bass GPIO pin on Acer 8951G
Date:   Mon, 16 Jan 2023 16:53:00 +0100
Message-Id: <20230116154910.375033757@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154847.246743274@linuxfoundation.org>
References: <20230116154847.246743274@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
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
@@ -8539,6 +8539,8 @@ static void alc662_fixup_aspire_ethos_hp
 	case HDA_FIXUP_ACT_PRE_PROBE:
 		snd_hda_jack_detect_enable_callback(codec, 0x1b,
 				alc662_aspire_ethos_mute_speakers);
+		/* subwoofer needs an extra GPIO setting to become audible */
+		alc_setup_gpio(codec, 0x02);
 		break;
 	case HDA_FIXUP_ACT_INIT:
 		/* Make sure to start in a correct state, i.e. if
@@ -8676,7 +8678,6 @@ enum {
 	ALC662_FIXUP_USI_HEADSET_MODE,
 	ALC662_FIXUP_LENOVO_MULTI_CODECS,
 	ALC669_FIXUP_ACER_ASPIRE_ETHOS,
-	ALC669_FIXUP_ACER_ASPIRE_ETHOS_SUBWOOFER,
 	ALC669_FIXUP_ACER_ASPIRE_ETHOS_HEADSET,
 	ALC671_FIXUP_HP_HEADSET_MIC2,
 	ALC662_FIXUP_ACER_X2660G_HEADSET_MODE,
@@ -9019,18 +9020,6 @@ static const struct hda_fixup alc662_fix
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
@@ -9040,7 +9029,7 @@ static const struct hda_fixup alc662_fix
 			{ }
 		},
 		.chained = true,
-		.chain_id = ALC669_FIXUP_ACER_ASPIRE_ETHOS_SUBWOOFER
+		.chain_id = ALC669_FIXUP_ACER_ASPIRE_ETHOS_HEADSET
 	},
 	[ALC671_FIXUP_HP_HEADSET_MIC2] = {
 		.type = HDA_FIXUP_FUNC,


