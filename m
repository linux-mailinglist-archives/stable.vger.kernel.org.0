Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A0CE623C6
	for <lists+stable@lfdr.de>; Mon,  8 Jul 2019 17:38:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732090AbfGHPa1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jul 2019 11:30:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:59446 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389558AbfGHPa1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jul 2019 11:30:27 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C724120645;
        Mon,  8 Jul 2019 15:30:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562599826;
        bh=a19q6HBJseF2Wd1PAwtLqB5gVl5woajPfylehEwf/b4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SuX5QP2HCSfgQltgomT891aOcxR58l4NZV6RTgWgyMsw5+Hoz24mPNP/2pzIq7oD7
         o40KjyvPUH4aL2O3XGXZPJ4y4uAkYdY1vtgTVqCxBUNjzhXMEPco5jopR05hBsV/Gd
         PA0Oex7DJge97U/OvpXRQcclmyLnwYn0NpLL5m0w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Richard Sailer <rs@tuxedocomputers.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.19 48/90] ALSA: hda/realtek: Add quirks for several Clevo notebook barebones
Date:   Mon,  8 Jul 2019 17:13:15 +0200
Message-Id: <20190708150524.985403927@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190708150521.829733162@linuxfoundation.org>
References: <20190708150521.829733162@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Richard Sailer <rs@tuxedocomputers.com>

commit 503d90b30602a3295978e46d844ccc8167400fe6 upstream.

This adds 4 SND_PCI_QUIRK(...) lines for several barebone models of the ODM
Clevo. The model names are written in regex syntax to describe/match all clevo
models that are similar enough and use the same PCI SSID that this fixup works
for them.

Additionally the lines regarding SSID 0x96e1 and 0x97e1 didn't fix audio for the
all our Clevo notebooks using these SSIDs (models Clevo P960* and P970*) since
ALC1220_FIXP_CLEVO_PB51ED_PINS swapped pins that are not necesarry to be
swapped. This patch initiates ALC1220_FIXUP_CLEVO_P950 instead for these model
and fixes the audio.

Fixes: 80690a276f44 ("ALSA: hda/realtek - Add quirk for Tuxedo XC 1509")
Signed-off-by: Richard Sailer <rs@tuxedocomputers.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_realtek.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -2443,9 +2443,10 @@ static const struct snd_pci_quirk alc882
 	SND_PCI_QUIRK(0x1558, 0x9501, "Clevo P950HR", ALC1220_FIXUP_CLEVO_P950),
 	SND_PCI_QUIRK(0x1558, 0x95e1, "Clevo P95xER", ALC1220_FIXUP_CLEVO_P950),
 	SND_PCI_QUIRK(0x1558, 0x95e2, "Clevo P950ER", ALC1220_FIXUP_CLEVO_P950),
-	SND_PCI_QUIRK(0x1558, 0x96e1, "System76 Oryx Pro (oryp5)", ALC1220_FIXUP_CLEVO_PB51ED_PINS),
-	SND_PCI_QUIRK(0x1558, 0x97e1, "System76 Oryx Pro (oryp5)", ALC1220_FIXUP_CLEVO_PB51ED_PINS),
-	SND_PCI_QUIRK(0x1558, 0x65d1, "Tuxedo Book XC1509", ALC1220_FIXUP_CLEVO_PB51ED_PINS),
+	SND_PCI_QUIRK(0x1558, 0x96e1, "Clevo P960[ER][CDFN]-K", ALC1220_FIXUP_CLEVO_P950),
+	SND_PCI_QUIRK(0x1558, 0x97e1, "Clevo P970[ER][CDFN]", ALC1220_FIXUP_CLEVO_P950),
+	SND_PCI_QUIRK(0x1558, 0x65d1, "Clevo PB51[ER][CDF]", ALC1220_FIXUP_CLEVO_PB51ED_PINS),
+	SND_PCI_QUIRK(0x1558, 0x67d1, "Clevo PB71[ER][CDF]", ALC1220_FIXUP_CLEVO_PB51ED_PINS),
 	SND_PCI_QUIRK_VENDOR(0x1558, "Clevo laptop", ALC882_FIXUP_EAPD),
 	SND_PCI_QUIRK(0x161f, 0x2054, "Medion laptop", ALC883_FIXUP_EAPD),
 	SND_PCI_QUIRK(0x17aa, 0x3a0d, "Lenovo Y530", ALC882_FIXUP_LENOVO_Y530),


