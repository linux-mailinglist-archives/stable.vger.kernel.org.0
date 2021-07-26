Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D5833D6263
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:16:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237000AbhGZPfv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:35:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:51634 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237134AbhGZPea (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:34:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DED5260F5B;
        Mon, 26 Jul 2021 16:14:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627316098;
        bh=Kqnq1X5w8wza3ZjKmw45U4X3R1Wx6dmimZNnOiADIbM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tK5yZvrPIUd40oQc7pROd4+3UCJK61Qi/+kSx1tIojA6nVsKFSyaKrni+D6RZ+fVJ
         kYztobQ1SkU2q5gdoCa4/sMZ6TeUNrPFUYKlrPJFV4myWy93wrHKMg148xIg53DoxB
         RvjarKIE0fGKGOhZYR8SxELwaXo1iJyvKMI9rI0Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hui Wang <hui.wang@canonical.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.13 151/223] ALSA: hda/realtek: Fix pop noise and 2 Front Mic issues on a machine
Date:   Mon, 26 Jul 2021 17:39:03 +0200
Message-Id: <20210726153851.168345736@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153846.245305071@linuxfoundation.org>
References: <20210726153846.245305071@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hui Wang <hui.wang@canonical.com>

commit e4efa82660e6d80338c554e45e903714e1b2c27b upstream.

This is a Lenovo ThinkStation machine which uses the codec alc623.
There are 2 issues on this machine, the 1st one is the pop noise in
the lineout, the 2nd one is there are 2 Front Mics and pulseaudio
can't handle them, After applying the fixup of
ALC623_FIXUP_LENOVO_THINKSTATION_P340 to this machine, the 2 issues
are fixed.

Cc: <stable@vger.kernel.org>
Signed-off-by: Hui Wang <hui.wang@canonical.com>
Link: https://lore.kernel.org/r/20210719030231.6870-1-hui.wang@canonical.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -8566,6 +8566,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x17aa, 0x3151, "ThinkCentre Station", ALC283_FIXUP_HEADSET_MIC),
 	SND_PCI_QUIRK(0x17aa, 0x3176, "ThinkCentre Station", ALC283_FIXUP_HEADSET_MIC),
 	SND_PCI_QUIRK(0x17aa, 0x3178, "ThinkCentre Station", ALC283_FIXUP_HEADSET_MIC),
+	SND_PCI_QUIRK(0x17aa, 0x31af, "ThinkCentre Station", ALC623_FIXUP_LENOVO_THINKSTATION_P340),
 	SND_PCI_QUIRK(0x17aa, 0x3818, "Lenovo C940", ALC298_FIXUP_LENOVO_SPK_VOLUME),
 	SND_PCI_QUIRK(0x17aa, 0x3827, "Ideapad S740", ALC285_FIXUP_IDEAPAD_S740_COEF),
 	SND_PCI_QUIRK(0x17aa, 0x3843, "Yoga 9i", ALC287_FIXUP_IDEAPAD_BASS_SPK_AMP),


