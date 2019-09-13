Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D3BF6B1E77
	for <lists+stable@lfdr.de>; Fri, 13 Sep 2019 15:11:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388764AbfIMNK2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Sep 2019 09:10:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:35286 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388734AbfIMNK1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Sep 2019 09:10:27 -0400
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 853DD206BB;
        Fri, 13 Sep 2019 13:10:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568380227;
        bh=boF61tNb6XatUKNw1ZGpKnGUN8RpjdfWG2vpBkeuOsU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ixtodDtG8X1iU0V7LwvbuazYMYtL4IHK7BSoollsUG77iNRCn3EUk49lAL/UzeZP7
         0z/VAoaBStSdjUHvdsFXP68AedYKkkqIjqP49EcORGe8HKpb/HmFfGWuh6WnUEhaKn
         4+syxWRBrPUvQgEon+ubg4Ffbm3k0VedfXkqgIiw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.14 02/21] ALSA: hda/realtek - Fix overridden device-specific initialization
Date:   Fri, 13 Sep 2019 14:06:55 +0100
Message-Id: <20190913130502.714475863@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190913130501.285837292@linuxfoundation.org>
References: <20190913130501.285837292@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit 89781d0806c2c4f29072d3f00cb2dd4274aabc3d upstream.

The recent change to shuffle the codec initialization procedure for
Realtek via commit 607ca3bd220f ("ALSA: hda/realtek - EAPD turn on
later") caused the silent output on some machines.  This change was
supposed to be safe, but it isn't actually; some devices have quirk
setups to override the EAPD via COEF or BTL in the additional verb
table, which is applied at the beginning of snd_hda_gen_init().  And
this EAPD setup is again overridden in alc_auto_init_amp().

For recovering from the regression, tell snd_hda_gen_init() not to
apply the verbs there by a new flag, then apply the verbs in
alc_init().

BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=204727
Fixes: 607ca3bd220f ("ALSA: hda/realtek - EAPD turn on later")
Cc: <stable@vger.kernel.org>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/hda_generic.c   |    3 ++-
 sound/pci/hda/hda_generic.h   |    1 +
 sound/pci/hda/patch_realtek.c |    2 ++
 3 files changed, 5 insertions(+), 1 deletion(-)

--- a/sound/pci/hda/hda_generic.c
+++ b/sound/pci/hda/hda_generic.c
@@ -5854,7 +5854,8 @@ int snd_hda_gen_init(struct hda_codec *c
 	if (spec->init_hook)
 		spec->init_hook(codec);
 
-	snd_hda_apply_verbs(codec);
+	if (!spec->skip_verbs)
+		snd_hda_apply_verbs(codec);
 
 	init_multi_out(codec);
 	init_extra_out(codec);
--- a/sound/pci/hda/hda_generic.h
+++ b/sound/pci/hda/hda_generic.h
@@ -237,6 +237,7 @@ struct hda_gen_spec {
 	unsigned int indep_hp_enabled:1; /* independent HP enabled */
 	unsigned int have_aamix_ctl:1;
 	unsigned int hp_mic_jack_modes:1;
+	unsigned int skip_verbs:1; /* don't apply verbs at snd_hda_gen_init() */
 
 	/* additional mute flags (only effective with auto_mute_via_amp=1) */
 	u64 mute_bits;
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -781,9 +781,11 @@ static int alc_init(struct hda_codec *co
 	if (spec->init_hook)
 		spec->init_hook(codec);
 
+	spec->gen.skip_verbs = 1; /* applied in below */
 	snd_hda_gen_init(codec);
 	alc_fix_pll(codec);
 	alc_auto_init_amp(codec, spec->init_amp);
+	snd_hda_apply_verbs(codec); /* apply verbs here after own init */
 
 	snd_hda_apply_fixup(codec, HDA_FIXUP_ACT_INIT);
 


