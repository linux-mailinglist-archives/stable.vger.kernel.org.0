Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2E0B480080
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 16:46:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236544AbhL0Pql (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 10:46:41 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:39920 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239758AbhL0PnO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 10:43:14 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 466D361120;
        Mon, 27 Dec 2021 15:43:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CCD4C36AEA;
        Mon, 27 Dec 2021 15:43:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640619793;
        bh=7a37G4SVGE3ybwpnf8s8vzNmebbx0iohX3umpzpzkA8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XmCgZEedx7KTTCYp7IN32s5FDYs5VAD5nU7n01ykNABpBsxh9uQT+ocynW8XWuNcS
         tyiEN/2gWQ+rOYw2zAkmg40Sp6VS4SFXHqqEn/ZRmWOr6BAyuNwDLrxeFPwMaJd53J
         m90YBnpEnEIKzBlne/6yNSvQFRT6a/ULQcD/fG44=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jeremy Szu <jeremy.szu@canonical.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.15 071/128] ALSA: hda/realtek: fix mute/micmute LEDs for a HP ProBook
Date:   Mon, 27 Dec 2021 16:30:46 +0100
Message-Id: <20211227151333.855979353@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211227151331.502501367@linuxfoundation.org>
References: <20211227151331.502501367@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jeremy Szu <jeremy.szu@canonical.com>

commit f7ac570d0f026cf5475d4cc4d8040bd947980b3a upstream.

There is a HP ProBook which using ALC236 codec and need the
ALC236_FIXUP_HP_MUTE_LED_MICMUTE_VREF quirk to make mute LED and
micmute LED work.

Signed-off-by: Jeremy Szu <jeremy.szu@canonical.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20211214164156.49711-1-jeremy.szu@canonical.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -8706,6 +8706,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x103c, 0x8896, "HP EliteBook 855 G8 Notebook PC", ALC285_FIXUP_HP_MUTE_LED),
 	SND_PCI_QUIRK(0x103c, 0x8898, "HP EliteBook 845 G8 Notebook PC", ALC285_FIXUP_HP_LIMIT_INT_MIC_BOOST),
 	SND_PCI_QUIRK(0x103c, 0x88d0, "HP Pavilion 15-eh1xxx (mainboard 88D0)", ALC287_FIXUP_HP_GPIO_LED),
+	SND_PCI_QUIRK(0x103c, 0x89ca, "HP", ALC236_FIXUP_HP_MUTE_LED_MICMUTE_VREF),
 	SND_PCI_QUIRK(0x1043, 0x103e, "ASUS X540SA", ALC256_FIXUP_ASUS_MIC),
 	SND_PCI_QUIRK(0x1043, 0x103f, "ASUS TX300", ALC282_FIXUP_ASUS_TX300),
 	SND_PCI_QUIRK(0x1043, 0x106d, "Asus K53BE", ALC269_FIXUP_LIMIT_INT_MIC_BOOST),


