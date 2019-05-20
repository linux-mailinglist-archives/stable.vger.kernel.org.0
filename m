Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C998823593
	for <lists+stable@lfdr.de>; Mon, 20 May 2019 14:45:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391186AbfETMf6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 May 2019 08:35:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:54858 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391174AbfETMf5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 May 2019 08:35:57 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A0A1F20815;
        Mon, 20 May 2019 12:35:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558355757;
        bh=9ju6xrxxbWPj8hEI7Lte3wmlQmVwMXLWNIzQZ40UEtM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2Lpy/qTi6IAJFE8q2JOCTvmVLbO6NojRMyot1kVFk1qffEXqJasxylmZ3M4sK6SNk
         GWEMRA1Aq84W1UHIUo8aj+6dk6nOi+VmqRnINYt85ad1z0gMgcztEP0TXLKAFUmPhj
         jiyQOwK54VSrvNJ7tssQXeAs3706jzsmVyR/Ulug=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Micha=C5=82=20Wadowski?= <wadosm@gmail.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.1 113/128] ALSA: hda/realtek - Fix for Lenovo B50-70 inverted internal microphone bug
Date:   Mon, 20 May 2019 14:15:00 +0200
Message-Id: <20190520115256.519237616@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190520115249.449077487@linuxfoundation.org>
References: <20190520115249.449077487@linuxfoundation.org>
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
@@ -6990,7 +6990,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x17aa, 0x313c, "ThinkCentre Station", ALC294_FIXUP_LENOVO_MIC_LOCATION),
 	SND_PCI_QUIRK(0x17aa, 0x3902, "Lenovo E50-80", ALC269_FIXUP_DMIC_THINKPAD_ACPI),
 	SND_PCI_QUIRK(0x17aa, 0x3977, "IdeaPad S210", ALC283_FIXUP_INT_MIC),
-	SND_PCI_QUIRK(0x17aa, 0x3978, "IdeaPad Y410P", ALC269_FIXUP_NO_SHUTUP),
+	SND_PCI_QUIRK(0x17aa, 0x3978, "Lenovo B50-70", ALC269_FIXUP_DMIC_THINKPAD_ACPI),
 	SND_PCI_QUIRK(0x17aa, 0x5013, "Thinkpad", ALC269_FIXUP_LIMIT_INT_MIC_BOOST),
 	SND_PCI_QUIRK(0x17aa, 0x501a, "Thinkpad", ALC283_FIXUP_INT_MIC),
 	SND_PCI_QUIRK(0x17aa, 0x501e, "Thinkpad L440", ALC292_FIXUP_TPT440_DOCK),


