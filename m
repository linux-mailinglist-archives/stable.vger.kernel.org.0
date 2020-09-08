Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FD51261BF0
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 21:11:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731348AbgIHTLe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 15:11:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:53548 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731215AbgIHQFW (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Sep 2020 12:05:22 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 95A25223BF;
        Tue,  8 Sep 2020 15:45:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599579942;
        bh=bl8TPa95uXGbmuaoAsisss6iAN69oNKgUN5fJQOWL+E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=033rvkgd0CVoP60HPP8w9Ko7/XqJSFTVUzgP2ou4x9PLKcij8e3JPdYW51JDKjXdu
         elmqNe960TyLkF8y5R+Ysxfa3t8FayNEXNX4g52hNpjwext1seE31BTBWmwm0Ex9rK
         3+W0U+vM3uMUqMgmCLOHMOAWjnHc2ux2p/WS0SE0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Crawford <dnlcrwfrd@gmail.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.4 095/129] ALSA: hda - Fix silent audio output and corrupted input on MSI X570-A PRO
Date:   Tue,  8 Sep 2020 17:25:36 +0200
Message-Id: <20200908152234.516221231@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200908152229.689878733@linuxfoundation.org>
References: <20200908152229.689878733@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Crawford <dnlcrwfrd@gmail.com>

commit 15cbff3fbbc631952c346744f862fb294504b5e2 upstream.

Following Christian Lachner's patch for Gigabyte X570-based motherboards,
also patch the MSI X570-A PRO motherboard; the ALC1220 codec requires the
same workaround for Clevo laptops to enforce the DAC/mixer connection
path. Set up a quirk entry for that.

I suspect most if all X570 motherboards will require similar patches.

[ The entries reordered in the SSID order -- tiwai ]

Related buglink: https://bugzilla.kernel.org/show_bug.cgi?id=205275
Signed-off-by: Dan Crawford <dnlcrwfrd@gmail.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200829024946.5691-1-dnlcrwfrd@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -2466,6 +2466,7 @@ static const struct snd_pci_quirk alc882
 	SND_PCI_QUIRK(0x1462, 0x1276, "MSI-GL73", ALC1220_FIXUP_CLEVO_P950),
 	SND_PCI_QUIRK(0x1462, 0x1293, "MSI-GP65", ALC1220_FIXUP_CLEVO_P950),
 	SND_PCI_QUIRK(0x1462, 0x7350, "MSI-7350", ALC889_FIXUP_CD),
+	SND_PCI_QUIRK(0x1462, 0x9c37, "MSI X570-A PRO", ALC1220_FIXUP_CLEVO_P950),
 	SND_PCI_QUIRK(0x1462, 0xda57, "MSI Z270-Gaming", ALC1220_FIXUP_GB_DUAL_CODECS),
 	SND_PCI_QUIRK_VENDOR(0x1462, "MSI", ALC882_FIXUP_GPIO3),
 	SND_PCI_QUIRK(0x147b, 0x107a, "Abit AW9D-MAX", ALC882_FIXUP_ABIT_AW9D_MAX),


