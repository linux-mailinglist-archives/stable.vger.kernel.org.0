Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 609EA2FA8C3
	for <lists+stable@lfdr.de>; Mon, 18 Jan 2021 19:28:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407601AbhARS1G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jan 2021 13:27:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:35868 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390749AbhARLlk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Jan 2021 06:41:40 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id ED5C1221EC;
        Mon, 18 Jan 2021 11:41:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610970084;
        bh=kQ5K9LRgSFa9wdQdxrV3BELlcPxyqcsi5X+6Ur6UzeY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GKwJFAlj+tn9A3EAHQppMDyWgVM2oJfgFHML9ryRIFSwYVQlluMdYPKt9pVzthfzc
         uFDt6yEw82rGB7hkTZt1wWny3VVu/i1pRHJMd8tJVZdax+Ra8+8weArJAOxgOXfbNn
         w7beAwCY6gw36HglIxV/P1VLeGV3CTF545XDZlH8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jeremy Szu <jeremy.szu@canonical.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.10 003/152] ALSA: hda/realtek: fix right sounds and mute/micmute LEDs for HP machines
Date:   Mon, 18 Jan 2021 12:32:58 +0100
Message-Id: <20210118113352.926334865@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210118113352.764293297@linuxfoundation.org>
References: <20210118113352.764293297@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jeremy Szu <jeremy.szu@canonical.com>

commit 91bc156817a3c2007332b64b4f85c32aafbbbea6 upstream.

 * The HP ZBook Fury 15/17 G7 Mobile Workstation are using ALC285 codec
   which is using 0x04 to control mute LED and 0x01 to control micmute LED.

 * The right channel speaker is no sound and it needs to expose GPIO1 for
   initialing AMP.

Add quirks to support them.

Signed-off-by: Jeremy Szu <jeremy.szu@canonical.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210106130549.100532-1-jeremy.szu@canonical.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_realtek.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -7970,6 +7970,10 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x103c, 0x8760, "HP", ALC285_FIXUP_HP_MUTE_LED),
 	SND_PCI_QUIRK(0x103c, 0x877a, "HP", ALC285_FIXUP_HP_MUTE_LED),
 	SND_PCI_QUIRK(0x103c, 0x877d, "HP", ALC236_FIXUP_HP_MUTE_LED),
+	SND_PCI_QUIRK(0x103c, 0x8780, "HP ZBook Fury 17 G7 Mobile Workstation",
+		      ALC285_FIXUP_HP_GPIO_AMP_INIT),
+	SND_PCI_QUIRK(0x103c, 0x8783, "HP ZBook Fury 15 G7 Mobile Workstation",
+		      ALC285_FIXUP_HP_GPIO_AMP_INIT),
 	SND_PCI_QUIRK(0x103c, 0x87c8, "HP", ALC287_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x87f4, "HP", ALC287_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x87f5, "HP", ALC287_FIXUP_HP_GPIO_LED),


