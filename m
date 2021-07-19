Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7E0F3CCC7C
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 05:02:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233964AbhGSDF5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Jul 2021 23:05:57 -0400
Received: from smtp-relay-canonical-0.canonical.com ([185.125.188.120]:35164
        "EHLO smtp-relay-canonical-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234187AbhGSDF4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 18 Jul 2021 23:05:56 -0400
Received: from localhost.localdomain (unknown [223.104.247.91])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-0.canonical.com (Postfix) with ESMTPSA id 762B7401C0;
        Mon, 19 Jul 2021 03:02:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1626663775;
        bh=FzKKXAxgTJvuH9M/lf6UV/1CISwlRZ4VmxlsEvkpwQ4=;
        h=From:To:Subject:Date:Message-Id:MIME-Version;
        b=RAahdELQpXoz16xOIZJ1RcwjVw1C3GpWWwO0Oh/qTD7U63qgS0MN33nrugP14OKA1
         IeA/8JhZ3R1ya4kpJKlbqr0tV3hRxbO4wdbEk024WHgzZ2Xk9c2rZhwgwDTsNoi1Vr
         rsxZCDHrQlLF1vbi3fjpuHAzxzhZFl9mfz6Xp2Rh0116VQUp+I5lMjimv/cd7HuEmt
         RIf9yW1tr7X3MiB95hf9BY518bU84nxbUKxRpPAxHD+ihntJTY/8pNve2gvOSLQyR5
         Qjt/PYeTM/jdvDoflpdEgTVBOvY1Yfy4l1+UpA3xXRUn6cVmJVDDwRy5p0Ll0JSyq0
         VcnKUNYV6xQ+A==
From:   Hui Wang <hui.wang@canonical.com>
To:     alsa-devel@alsa-project.org, tiwai@suse.de, stable@vger.kernel.org
Subject: [PATCH] ALSA: hda/realtek: Fix pop noise and 2 Front Mic issues on a machine
Date:   Mon, 19 Jul 2021 11:02:31 +0800
Message-Id: <20210719030231.6870-1-hui.wang@canonical.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is a Lenovo ThinkStation machine which uses the codec alc623.
There are 2 issues on this machine, the 1st one is the pop noise in
the lineout, the 2nd one is there are 2 Front Mics and pulseaudio
can't handle them, After applying the fixup of
ALC623_FIXUP_LENOVO_THINKSTATION_P340 to this machine, the 2 issues
are fixed.

Cc: <stable@vger.kernel.org>
Signed-off-by: Hui Wang <hui.wang@canonical.com>
---
 sound/pci/hda/patch_realtek.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 1389cfd5e0db..caaf0e8aac11 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -8626,6 +8626,7 @@ static const struct snd_pci_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x17aa, 0x3151, "ThinkCentre Station", ALC283_FIXUP_HEADSET_MIC),
 	SND_PCI_QUIRK(0x17aa, 0x3176, "ThinkCentre Station", ALC283_FIXUP_HEADSET_MIC),
 	SND_PCI_QUIRK(0x17aa, 0x3178, "ThinkCentre Station", ALC283_FIXUP_HEADSET_MIC),
+	SND_PCI_QUIRK(0x17aa, 0x31af, "ThinkCentre Station", ALC623_FIXUP_LENOVO_THINKSTATION_P340),
 	SND_PCI_QUIRK(0x17aa, 0x3818, "Lenovo C940", ALC298_FIXUP_LENOVO_SPK_VOLUME),
 	SND_PCI_QUIRK(0x17aa, 0x3827, "Ideapad S740", ALC285_FIXUP_IDEAPAD_S740_COEF),
 	SND_PCI_QUIRK(0x17aa, 0x3843, "Yoga 9i", ALC287_FIXUP_IDEAPAD_BASS_SPK_AMP),
-- 
2.25.1

