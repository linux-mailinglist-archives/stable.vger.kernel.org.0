Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7758D20DB75
	for <lists+stable@lfdr.de>; Mon, 29 Jun 2020 22:15:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388457AbgF2UG2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 16:06:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:40580 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732960AbgF2Ta1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 15:30:27 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3B0982483E;
        Mon, 29 Jun 2020 15:35:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593444918;
        bh=z77SdcrfBoCekimAFpuRxPZN2t99snKoUYwdFfx/VJk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=coDdb9BsLWHgUa/qNXoWV30raz+b6VSPZFxadYErDbuNG9IvuY7isXeLycSwM9OoA
         cs7gr7kXS3dwQ/rP2AdmS6t/T6Su0G8QagMJ2/bsgUKmYz0i7jyoOZLcBk9YZ5E9lD
         fUvn4mFPdyi9wJWHJGGK42DDqu3HZ57T6J3Zuxak=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 015/131] ALSA: hda/realtek - Enable micmute LED on and HP system
Date:   Mon, 29 Jun 2020 11:33:06 -0400
Message-Id: <20200629153502.2494656-16-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629153502.2494656-1-sashal@kernel.org>
References: <20200629153502.2494656-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.131-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.131-rc1
X-KernelTest-Deadline: 2020-07-01T15:34+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kai-Heng Feng <kai.heng.feng@canonical.com>

[ Upstream commit 3e0650ab26e2010ee312311612e40e076ed1feca ]

Though the system uses DMIC, headset mic still uses the HDA, let's use
GPIO 0x1 to control the micmute LED.

The micmute LED GPIO has a different polarity to the mute LED GPIO, we
can use the newly added micmute_led_polarity to indicate that.

Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
Link: https://lore.kernel.org/r/20200430083255.5093-2-kai.heng.feng@canonical.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 3103f990299c9..54887a87bddb1 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -3921,7 +3921,11 @@ static void alc269_fixup_hp_gpio_led(struct hda_codec *codec,
 static void alc285_fixup_hp_gpio_led(struct hda_codec *codec,
 				const struct hda_fixup *fix, int action)
 {
-	alc_fixup_hp_gpio_led(codec, action, 0x04, 0x00);
+	struct alc_spec *spec = codec->spec;
+
+	spec->micmute_led_polarity = 1;
+
+	alc_fixup_hp_gpio_led(codec, action, 0x04, 0x01);
 }
 
 static void alc286_fixup_hp_gpio_led(struct hda_codec *codec,
-- 
2.25.1

