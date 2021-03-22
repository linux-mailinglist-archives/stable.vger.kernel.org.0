Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B564E344129
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 13:31:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231165AbhCVMbK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 08:31:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:53148 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231206AbhCVMaw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 08:30:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 013F961990;
        Mon, 22 Mar 2021 12:30:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616416252;
        bh=YeR17+U8In999M2NfIAYjFnJsPk40ofL5D0qrCRVTSk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MUJI7NhlRJoC50+kPw/Zqy5R7H5Iivvov3+oHW2Z72e8ADdJlx/NDR0dZsIndv4zA
         CU4QrD8fnov4Y57rdK2L/4o3n/yD/CM7mSDMYsF/UIBKPVZI5H4R7FPXDkjoW0curB
         e8RbQX0wFizXJ6u/pIqp2fG34Bm1Ds71h/SWrgKc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jeremy Szu <jeremy.szu@canonical.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.11 008/120] ALSA: hda/realtek: fix mute/micmute LEDs for HP 840 G8
Date:   Mon, 22 Mar 2021 13:26:31 +0100
Message-Id: <20210322121929.935372280@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210322121929.669628946@linuxfoundation.org>
References: <20210322121929.669628946@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jeremy Szu <jeremy.szu@canonical.com>

commit ca6883393f0fa7f13ec8b860dbcef423a759c4a2 upstream.

The HP EliteBook 840 G8 Notebook PC is using ALC285 codec which is
using 0x04 to control mute LED and 0x01 to control micmute LED.
Therefore, add a quirk to make it works.

Signed-off-by: Jeremy Szu <jeremy.szu@canonical.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210316065452.75659-1-jeremy.szu@canonical.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -8048,6 +8048,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x103c, 0x87f4, "HP", ALC287_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x87f5, "HP", ALC287_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x87f7, "HP Spectre x360 14", ALC245_FIXUP_HP_X360_AMP),
+	SND_PCI_QUIRK(0x103c, 0x884c, "HP EliteBook 840 G8 Notebook PC", ALC285_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x1043, 0x103e, "ASUS X540SA", ALC256_FIXUP_ASUS_MIC),
 	SND_PCI_QUIRK(0x1043, 0x103f, "ASUS TX300", ALC282_FIXUP_ASUS_TX300),
 	SND_PCI_QUIRK(0x1043, 0x106d, "Asus K53BE", ALC269_FIXUP_LIMIT_INT_MIC_BOOST),


