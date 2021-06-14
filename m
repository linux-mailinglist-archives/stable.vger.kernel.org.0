Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C16B3A62DD
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 13:04:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234238AbhFNLFz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 07:05:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:39540 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233537AbhFNLDj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 07:03:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9989D611C1;
        Mon, 14 Jun 2021 10:44:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623667463;
        bh=Y4GepoBGy3IMv2faAQj2zfnwyNallRPTXK13Vh+jl/E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Esl7l+lvye5lyIiZUbOEQeaEji43uZdFur0WoWHI++ZBf0VUSELgDoml7oWnogz3m
         2RoVoTt/992aKqg0XgzyTyy0mdczPeqoUxSdCsv4qD1WbT5gP09oaiUEWpuoQTvu0g
         qnN3CLWojrG3BuhDy9yjMUTHF8xUpelkHBL6aAzE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jeremy Szu <jeremy.szu@canonical.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.10 048/131] ALSA: hda/realtek: fix mute/micmute LEDs and speaker for HP Elite Dragonfly G2
Date:   Mon, 14 Jun 2021 12:26:49 +0200
Message-Id: <20210614102654.658302703@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210614102652.964395392@linuxfoundation.org>
References: <20210614102652.964395392@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jeremy Szu <jeremy.szu@canonical.com>

commit 15d295b560e6dd45f839a53ae69e4f63b54eb32f upstream.

The HP Elite Dragonfly G2 using ALC285 codec which using 0x04 to control
mute LED and 0x01 to control micmute LED.
In the other hand, there is no output from right channel of speaker.
Therefore, add a quirk to make it works.

Signed-off-by: Jeremy Szu <jeremy.szu@canonical.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210605082539.41797-1-jeremy.szu@canonical.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -8307,6 +8307,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x103c, 0x8519, "HP Spectre x360 15-df0xxx", ALC285_FIXUP_HP_SPECTRE_X360),
 	SND_PCI_QUIRK(0x103c, 0x869d, "HP", ALC236_FIXUP_HP_MUTE_LED),
 	SND_PCI_QUIRK(0x103c, 0x86c7, "HP Envy AiO 32", ALC274_FIXUP_HP_ENVY_GPIO),
+	SND_PCI_QUIRK(0x103c, 0x8716, "HP Elite Dragonfly G2 Notebook PC", ALC285_FIXUP_HP_GPIO_AMP_INIT),
 	SND_PCI_QUIRK(0x103c, 0x8724, "HP EliteBook 850 G7", ALC285_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8729, "HP", ALC285_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8730, "HP ProBook 445 G7", ALC236_FIXUP_HP_MUTE_LED_MICMUTE_VREF),


