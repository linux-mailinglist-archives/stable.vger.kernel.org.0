Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8860023681
	for <lists+stable@lfdr.de>; Mon, 20 May 2019 14:46:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388630AbfETMZ3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 May 2019 08:25:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:40594 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388518AbfETMZ2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 May 2019 08:25:28 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 847A720815;
        Mon, 20 May 2019 12:25:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558355128;
        bh=+Ma5oZ5zYnu+nJqNe7Q9IlJZhaRa2nN1Ozk47otlomg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LI1tebXr4mHcXONJMEGG8xgHyJCzxGpK3nLt6bIqGPtSk+hf05VRBCAHsY301LJCu
         5j8fCDalaHLYeO0f+JP0x07beMa1N3eCoUGT6hPzb2IJQbEOeQY2WzGtPqET1Z6heV
         LYPeUpzJk026JKOxw7J9gaC4Cx7Ml6LfkUXPhqkE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Micha=C5=82=20Wadowski?= <wadosm@gmail.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.19 091/105] ALSA: hda/realtek - Fix for Lenovo B50-70 inverted internal microphone bug
Date:   Mon, 20 May 2019 14:14:37 +0200
Message-Id: <20190520115253.550778617@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190520115247.060821231@linuxfoundation.org>
References: <20190520115247.060821231@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michał Wadowski <wadosm@gmail.com>

commit 56df90b631fc027fe28b70d41352d820797239bb upstream.

Add patch for realtek codec in Lenovo B50-70 that fixes inverted
internal microphone channel.
Device IdeaPad Y410P has the same PCI SSID as Lenovo B50-70,
but first one is about fix the noise and it didn't seem help in a
later kernel version.
So I replaced IdeaPad Y410P device description with B50-70 and apply
inverted microphone fix.

Bugzilla: https://bugs.launchpad.net/ubuntu/+source/alsa-driver/+bug/1524215
Signed-off-by: Michał Wadowski <wadosm@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_realtek.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -6898,7 +6898,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x17aa, 0x313c, "ThinkCentre Station", ALC294_FIXUP_LENOVO_MIC_LOCATION),
 	SND_PCI_QUIRK(0x17aa, 0x3902, "Lenovo E50-80", ALC269_FIXUP_DMIC_THINKPAD_ACPI),
 	SND_PCI_QUIRK(0x17aa, 0x3977, "IdeaPad S210", ALC283_FIXUP_INT_MIC),
-	SND_PCI_QUIRK(0x17aa, 0x3978, "IdeaPad Y410P", ALC269_FIXUP_NO_SHUTUP),
+	SND_PCI_QUIRK(0x17aa, 0x3978, "Lenovo B50-70", ALC269_FIXUP_DMIC_THINKPAD_ACPI),
 	SND_PCI_QUIRK(0x17aa, 0x5013, "Thinkpad", ALC269_FIXUP_LIMIT_INT_MIC_BOOST),
 	SND_PCI_QUIRK(0x17aa, 0x501a, "Thinkpad", ALC283_FIXUP_INT_MIC),
 	SND_PCI_QUIRK(0x17aa, 0x501e, "Thinkpad L440", ALC292_FIXUP_TPT440_DOCK),


