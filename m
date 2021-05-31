Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF8993960F8
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:32:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233901AbhEaOdt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:33:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:59608 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233489AbhEaObf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:31:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 304B861C3F;
        Mon, 31 May 2021 13:49:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622468972;
        bh=m+CjzashLPOcBDWZS2rYKTTOPmnQkXL0Z2BYJpGq8qg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zFBL9lw0OfiK0W8KhLHDYOvpPxTC6axRqJHiN3DfEln9mRh0ifk4LXzgw4BNS4up0
         6PI15GhGaYDTNHr/MLhtXm1Zb57D+wCl+moQZpVY0ojSNbooXJ5QgKt2Py+i7PKxF5
         uRH9upoE3/y9HmRdTBXRkeCRWUTt10P+Y4BGVAJw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jeremy Szu <jeremy.szu@canonical.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.12 005/296] ALSA: hda/realtek: fix mute/micmute LEDs and speaker for HP Zbook G8
Date:   Mon, 31 May 2021 15:11:00 +0200
Message-Id: <20210531130703.950614922@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130703.762129381@linuxfoundation.org>
References: <20210531130703.762129381@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jeremy Szu <jeremy.szu@canonical.com>

commit bbe183e07817a46cf8d3d7fc88093df81d23a957 upstream.

The HP ZBook Studio 15.6 Inch G8 is using ALC285 codec which is
using 0x04 to control mute LED and 0x01 to control micmute LED.
In the other hand, there is no output from right channel of speaker.
Therefore, add a quirk to make it works.

Signed-off-by: Jeremy Szu <jeremy.szu@canonical.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210519170357.58410-2-jeremy.szu@canonical.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -8314,6 +8314,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x103c, 0x87f7, "HP Spectre x360 14", ALC245_FIXUP_HP_X360_AMP),
 	SND_PCI_QUIRK(0x103c, 0x8846, "HP EliteBook 850 G8 Notebook PC", ALC285_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x884c, "HP EliteBook 840 G8 Notebook PC", ALC285_FIXUP_HP_GPIO_LED),
+	SND_PCI_QUIRK(0x103c, 0x8873, "HP ZBook Studio 15.6 Inch G8 Mobile Workstation PC", ALC285_FIXUP_HP_GPIO_AMP_INIT),
 	SND_PCI_QUIRK(0x103c, 0x8896, "HP EliteBook 855 G8 Notebook PC", ALC285_FIXUP_HP_MUTE_LED),
 	SND_PCI_QUIRK(0x1043, 0x103e, "ASUS X540SA", ALC256_FIXUP_ASUS_MIC),
 	SND_PCI_QUIRK(0x1043, 0x103f, "ASUS TX300", ALC282_FIXUP_ASUS_TX300),


