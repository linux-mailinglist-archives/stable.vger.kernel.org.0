Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BB444998CA
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:39:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1453357AbiAXVaB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:30:01 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:38090 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1448683AbiAXVTO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:19:14 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 48920B81061;
        Mon, 24 Jan 2022 21:19:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CF92C340E4;
        Mon, 24 Jan 2022 21:19:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643059148;
        bh=HXJV0jhVF0YnUWsRplcUKIX+Ihje/JCzSZtYZ+p4VdI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tCgvKrLWMc9Wl9xqbOPjcAi9TMATx7qj0HA6RlBSgaOAJfcAgU00Jx4MrIzeMC9+o
         PFWaesm/UpFhyahH1Oho+kZcJmVjic7CplqK/jj3rA6IFModh+yjctOSb7St+PpQZf
         LEq3hfk2j+n12NhyfDiRJCUREI0Jh9tLEeY6J9tE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Christian A. Ehrhardt" <lk@c--e.de>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0520/1039] ALSA: hda/cs8409: Fix Jack detection after resume
Date:   Mon, 24 Jan 2022 19:38:29 +0100
Message-Id: <20220124184142.769715347@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christian A. Ehrhardt <lk@c--e.de>

[ Upstream commit 57f234248ff925d88caedf4019ec84e6ecb83909 ]

The suspend code unconditionally sets ->hp_jack_in and ->mic_jack_in
to zero but without reporting this status change to the HDA core.
To compensate for this, always assume a status change on the
first unsol event after boot or resume.

Fixes: 424e531b47f8 ("ALSA: hda/cs8409: Ensure Type Detection is only run on startup when necessary")
Signed-off-by: Christian A. Ehrhardt <lk@c--e.de>
Link: https://lore.kernel.org/r/20211231134432.atwmuzeceqiklcoa@cae.in-ulm.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_cs8409-tables.c | 3 +++
 sound/pci/hda/patch_cs8409.c        | 5 ++++-
 sound/pci/hda/patch_cs8409.h        | 1 +
 3 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/sound/pci/hda/patch_cs8409-tables.c b/sound/pci/hda/patch_cs8409-tables.c
index 0fb0a428428b4..df0b4522babf7 100644
--- a/sound/pci/hda/patch_cs8409-tables.c
+++ b/sound/pci/hda/patch_cs8409-tables.c
@@ -252,6 +252,7 @@ struct sub_codec cs8409_cs42l42_codec = {
 	.init_seq_num = ARRAY_SIZE(cs42l42_init_reg_seq),
 	.hp_jack_in = 0,
 	.mic_jack_in = 0,
+	.force_status_change = 1,
 	.paged = 1,
 	.suspended = 1,
 	.no_type_dect = 0,
@@ -443,6 +444,7 @@ struct sub_codec dolphin_cs42l42_0 = {
 	.init_seq_num = ARRAY_SIZE(dolphin_c0_init_reg_seq),
 	.hp_jack_in = 0,
 	.mic_jack_in = 0,
+	.force_status_change = 1,
 	.paged = 1,
 	.suspended = 1,
 	.no_type_dect = 0,
@@ -456,6 +458,7 @@ struct sub_codec dolphin_cs42l42_1 = {
 	.init_seq_num = ARRAY_SIZE(dolphin_c1_init_reg_seq),
 	.hp_jack_in = 0,
 	.mic_jack_in = 0,
+	.force_status_change = 1,
 	.paged = 1,
 	.suspended = 1,
 	.no_type_dect = 1,
diff --git a/sound/pci/hda/patch_cs8409.c b/sound/pci/hda/patch_cs8409.c
index bf5d7f0c6ba55..aff2b5abb81ea 100644
--- a/sound/pci/hda/patch_cs8409.c
+++ b/sound/pci/hda/patch_cs8409.c
@@ -636,7 +636,9 @@ static void cs42l42_run_jack_detect(struct sub_codec *cs42l42)
 
 static int cs42l42_handle_tip_sense(struct sub_codec *cs42l42, unsigned int reg_ts_status)
 {
-	int status_changed = 0;
+	int status_changed = cs42l42->force_status_change;
+
+	cs42l42->force_status_change = 0;
 
 	/* TIP_SENSE INSERT/REMOVE */
 	switch (reg_ts_status) {
@@ -791,6 +793,7 @@ static void cs42l42_suspend(struct sub_codec *cs42l42)
 	cs42l42->last_page = 0;
 	cs42l42->hp_jack_in = 0;
 	cs42l42->mic_jack_in = 0;
+	cs42l42->force_status_change = 1;
 
 	/* Put CS42L42 into Reset */
 	gpio_data = snd_hda_codec_read(codec, CS8409_PIN_AFG, 0, AC_VERB_GET_GPIO_DATA, 0);
diff --git a/sound/pci/hda/patch_cs8409.h b/sound/pci/hda/patch_cs8409.h
index ade2b838590cf..d0b725c7285b6 100644
--- a/sound/pci/hda/patch_cs8409.h
+++ b/sound/pci/hda/patch_cs8409.h
@@ -305,6 +305,7 @@ struct sub_codec {
 
 	unsigned int hp_jack_in:1;
 	unsigned int mic_jack_in:1;
+	unsigned int force_status_change:1;
 	unsigned int suspended:1;
 	unsigned int paged:1;
 	unsigned int last_page;
-- 
2.34.1



