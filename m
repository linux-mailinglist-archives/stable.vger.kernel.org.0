Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F251F1F2D5E
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 02:33:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729981AbgFIAcu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 20:32:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:35796 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728658AbgFHXPF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jun 2020 19:15:05 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A170421501;
        Mon,  8 Jun 2020 23:15:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591658105;
        bh=/FtmSA/ghE/J10oWvCHUZzoYJTnDNGFfpHIAFLpEmy4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CNmXSKKRP57cq1a9fHA4krWTBlWHGeLMvnvPqm545iPm7PlNnVetYene/dlv59cW7
         EeONBbjckE2deSzgmrWSCqtLkJCygf08iz/zLSxn66Fvj/l6PJTywqK2tyh3HHudXg
         roJ+UjhUZm3ljiGubwWi6mDqn4iSL2Gmdkm8pS4c=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Christian Lachner <gladiac@gmail.com>,
        Takashi Iwai <tiwai@suse.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.6 145/606] ALSA: hda/realtek - Fix silent output on Gigabyte X570 Aorus Xtreme
Date:   Mon,  8 Jun 2020 19:04:30 -0400
Message-Id: <20200608231211.3363633-145-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608231211.3363633-1-sashal@kernel.org>
References: <20200608231211.3363633-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christian Lachner <gladiac@gmail.com>

commit d9e8fe0cffbfdd18de96fa68ee2a8b667a0b046e upstream.

The Gigabyte X570 Aorus Xtreme motherboard with ALC1220 codec
requires a similar workaround for Clevo laptops to enforce the
DAC/mixer connection path. Set up a quirk entry for that.

BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=205275
Signed-off-by: Christian Lachner <gladiac@gmail.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200518053844.42743-2-gladiac@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index dc2302171a71..23315b69ac38 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -2457,6 +2457,7 @@ static const struct snd_pci_quirk alc882_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1458, 0xa002, "Gigabyte EP45-DS3/Z87X-UD3H", ALC889_FIXUP_FRONT_HP_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1458, 0xa0b8, "Gigabyte AZ370-Gaming", ALC1220_FIXUP_GB_DUAL_CODECS),
 	SND_PCI_QUIRK(0x1458, 0xa0cd, "Gigabyte X570 Aorus Master", ALC1220_FIXUP_CLEVO_P950),
+	SND_PCI_QUIRK(0x1458, 0xa0ce, "Gigabyte X570 Aorus Xtreme", ALC1220_FIXUP_CLEVO_P950),
 	SND_PCI_QUIRK(0x1462, 0x1228, "MSI-GP63", ALC1220_FIXUP_CLEVO_P950),
 	SND_PCI_QUIRK(0x1462, 0x1275, "MSI-GL63", ALC1220_FIXUP_CLEVO_P950),
 	SND_PCI_QUIRK(0x1462, 0x1276, "MSI-GL73", ALC1220_FIXUP_CLEVO_P950),
-- 
2.25.1

