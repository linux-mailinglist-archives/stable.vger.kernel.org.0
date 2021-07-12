Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77B1D3C5055
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:45:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347058AbhGLHcD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:32:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:46644 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345751AbhGLHaI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:30:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BF65E6052B;
        Mon, 12 Jul 2021 07:27:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626074840;
        bh=EUGPeWEvCmJt0cO0HnlW6ltlwGfsjYG0NtKb1rZGhcs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=THjMz6TcatddxYryLi4909S/FMhyvCnleLIxG0F5+7K+dkUVvO/dnE8c/y2Zx1HJ8
         G/VDjCh7/uwO/a3sZNWhsue9YskIcfa+rFQvQv8ElCgQS2YutF8IA5LGJMGjYO6IkK
         659jf8wljEFPvaBt9CzGPryppYkR1r1kw6TayP1A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Elia Devito <eliadevito@gmail.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.13 015/800] ALSA: hda/realtek: Improve fixup for HP Spectre x360 15-df0xxx
Date:   Mon, 12 Jul 2021 08:00:38 +0200
Message-Id: <20210712060915.322607435@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
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
@@ -6354,6 +6354,24 @@ static void alc_fixup_no_int_mic(struct
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
 
@@ -8138,13 +8156,8 @@ static const struct hda_fixup alc269_fix
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
 	[ALC287_FIXUP_IDEAPAD_BASS_SPK_AMP] = {
 		.type = HDA_FIXUP_FUNC,


