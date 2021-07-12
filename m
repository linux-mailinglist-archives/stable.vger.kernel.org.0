Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 394B63C4449
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 08:20:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233559AbhGLGSR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:18:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:36572 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233516AbhGLGSL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:18:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 392C4610A6;
        Mon, 12 Jul 2021 06:15:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626070522;
        bh=wwmiMhpNVP6iTEQ6cl8tW30kdJ51L/SlJb0A80+MixE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gMmDgRkpbXtpu6fbIaNwyBM0aKcYeb0/DGHTCPt0rA+j0iB/OLE0Y1XwewPPYJamv
         1iByEOvaliveRVhvUeLw1qOymPZyTG83vNR+6WF4eKFDoWnoSN5QHK6oADiy4EmHBT
         Av4yU2Ie4VIi0jnejAroSTp3g8bjCLA6zC5sKhX8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Elia Devito <eliadevito@gmail.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.4 006/348] ALSA: hda/realtek: Improve fixup for HP Spectre x360 15-df0xxx
Date:   Mon, 12 Jul 2021 08:06:30 +0200
Message-Id: <20210712060700.924571964@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060659.886176320@linuxfoundation.org>
References: <20210712060659.886176320@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Elia Devito <eliadevito@gmail.com>

commit 434591b2a77def0e78abfa38e5d7c4bca954e68a upstream.

On HP Spectre x360 15-df0xxx, after system boot with plugged headset, the
headset mic are not detected.
Moving pincfg and DAC's config to single fixup function fix this.

[ The actual bug in the original code was that it used a chain to
  ALC286_FIXUP_SPEAKER2_TO_DAC1, and it contains not only the DAC1
  route fix but also another chain to ALC269_FIXUP_THINKPAD_ACPI.
  I thought the latter one is harmless for non-Thinkpad, but it
  doesn't seem so; it contains again yet another chain to
  ALC269_FIXUP_SKI_IGNORE, and this might be bad for some machines,
  including this HP machine.  -- tiwai ]

Signed-off-by: Elia Devito <eliadevito@gmail.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210619204105.5682-1-eliadevito@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_realtek.c |   27 ++++++++++++++++++++-------
 1 file changed, 20 insertions(+), 7 deletions(-)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -6218,6 +6218,24 @@ static void alc274_fixup_hp_headset_mic(
 	}
 }
 
+static void alc285_fixup_hp_spectre_x360(struct hda_codec *codec,
+					  const struct hda_fixup *fix, int action)
+{
+	static const hda_nid_t conn[] = { 0x02 };
+	static const struct hda_pintbl pincfgs[] = {
+		{ 0x14, 0x90170110 },  /* rear speaker */
+		{ }
+	};
+
+	switch (action) {
+	case HDA_FIXUP_ACT_PRE_PROBE:
+		snd_hda_apply_pincfgs(codec, pincfgs);
+		/* force front speaker to DAC1 */
+		snd_hda_override_conn_list(codec, 0x17, ARRAY_SIZE(conn), conn);
+		break;
+	}
+}
+
 /* for hda_fixup_thinkpad_acpi() */
 #include "thinkpad_helper.c"
 
@@ -7916,13 +7934,8 @@ static const struct hda_fixup alc269_fix
 		.chain_id = ALC269_FIXUP_HP_LINE1_MIC1_LED,
 	},
 	[ALC285_FIXUP_HP_SPECTRE_X360] = {
-		.type = HDA_FIXUP_PINS,
-		.v.pins = (const struct hda_pintbl[]) {
-			{ 0x14, 0x90170110 }, /* enable top speaker */
-			{}
-		},
-		.chained = true,
-		.chain_id = ALC285_FIXUP_SPEAKER2_TO_DAC1,
+		.type = HDA_FIXUP_FUNC,
+		.v.func = alc285_fixup_hp_spectre_x360,
 	},
 };
 


