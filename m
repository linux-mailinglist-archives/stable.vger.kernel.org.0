Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 340AF3C506E
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:46:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230361AbhGLHcx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:32:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:43378 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345516AbhGLH3z (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:29:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3BF3D611BF;
        Mon, 12 Jul 2021 07:27:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626074827;
        bh=5IFq8QOHAN1CtVTfLpjTLS7c34Yk1vQF4hrSLx2LLRU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KgfJlC/F6wX7Ju8bzFt/d2WI3pRt7MQl2kK3rTLi8jl/UWCZuhc26Ad6t8PH6ArmL
         qam44m0zld5fqHxJxwgEQWHgGp6/H46wqTngtX1j+lVFJ2SvXsvv6nsLWLatz6uwZP
         yCI/jB5fl88A8fkRPKZ0W1xiMlkMETLdWJsodxRs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andy Chi <andy.chi@canonical.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.13 011/800] ALSA: hda/realtek: fix mute/micmute LEDs for HP ProBook 445 G8
Date:   Mon, 12 Jul 2021 08:00:34 +0200
Message-Id: <20210712060914.724863003@linuxfoundation.org>
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

From: Andy Chi <andy.chi@canonical.com>

commit a3b7f9b8fa2967e1b3c2a402301715124c90306b upstream.

The HP ProBook 445 G8 using ALC236 codec.
COEF index 0x34 bit 5 is used to control the playback mute LED, but the
microphone mute LED is controlled using pin VREF instead of a COEF index.
Therefore, add a quirk to make it works.

Signed-off-by: Andy Chi <andy.chi@canonical.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210701091417.9696-2-andy.chi@canonical.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_realtek.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -8344,6 +8344,8 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x103c, 0x8846, "HP EliteBook 850 G8 Notebook PC", ALC285_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x884b, "HP EliteBook 840 Aero G8 Notebook PC", ALC285_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x884c, "HP EliteBook 840 G8 Notebook PC", ALC285_FIXUP_HP_GPIO_LED),
+	SND_PCI_QUIRK(0x103c, 0x8862, "HP ProBook 445 G8 Notebook PC", ALC236_FIXUP_HP_MUTE_LED_MICMUTE_VREF),
+	SND_PCI_QUIRK(0x103c, 0x8863, "HP ProBook 445 G8 Notebook PC", ALC236_FIXUP_HP_MUTE_LED_MICMUTE_VREF),
 	SND_PCI_QUIRK(0x103c, 0x886d, "HP ZBook Fury 17.3 Inch G8 Mobile Workstation PC", ALC285_FIXUP_HP_GPIO_AMP_INIT),
 	SND_PCI_QUIRK(0x103c, 0x8870, "HP ZBook Fury 15.6 Inch G8 Mobile Workstation PC", ALC285_FIXUP_HP_GPIO_AMP_INIT),
 	SND_PCI_QUIRK(0x103c, 0x8873, "HP ZBook Studio 15.6 Inch G8 Mobile Workstation PC", ALC285_FIXUP_HP_GPIO_AMP_INIT),


