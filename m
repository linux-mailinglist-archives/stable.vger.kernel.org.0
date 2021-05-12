Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 614A037C121
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 16:55:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232356AbhELO4w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 10:56:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:46434 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231776AbhELOzl (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 10:55:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1D65D6143B;
        Wed, 12 May 2021 14:54:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620831273;
        bh=JTrFYSsC5haewjzAXnCR3r8DO1NbeALdtUpeuASFmBs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DySQUvYY2ujRYClLQsVxXmRbhHLMYKPGNEe0LHLDoyMO3GRHQhV3ZKRw9j4CwuPDp
         R7t6yEt6fDMiDO2d8SAlCLMGpVUkzwQisoP6aoStkjE+ussXFkQgGiuF1UKNEFHxY/
         FiD+ixWP4RMVJEI7iX1JcAw2XQ0MYWiZan3RRZ5c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.4 054/244] ALSA: hda/realtek: Remove redundant entry for ALC861 Haier/Uniwill devices
Date:   Wed, 12 May 2021 16:47:05 +0200
Message-Id: <20210512144744.777609834@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144743.039977287@linuxfoundation.org>
References: <20210512144743.039977287@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit defce244b01ee12534910a4544e11be5eb927d25 upstream.

The quirk entry for Uniwill ECS M31EI is with the PCI SSID device 0,
which means matching with all.  That is, it's essentially equivalent
with SND_PCI_QUIRK_VENDOR(0x1584), which also matches with the
previous entry for Haier W18 applying the very same quirk.

Let's unify them with the single vendor-quirk entry.

Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210428112704.23967-13-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -9084,8 +9084,7 @@ static const struct snd_pci_quirk alc861
 	SND_PCI_QUIRK(0x1043, 0x1393, "ASUS A6Rp", ALC861_FIXUP_ASUS_A6RP),
 	SND_PCI_QUIRK_VENDOR(0x1043, "ASUS laptop", ALC861_FIXUP_AMP_VREF_0F),
 	SND_PCI_QUIRK(0x1462, 0x7254, "HP DX2200", ALC861_FIXUP_NO_JACK_DETECT),
-	SND_PCI_QUIRK(0x1584, 0x2b01, "Haier W18", ALC861_FIXUP_AMP_VREF_0F),
-	SND_PCI_QUIRK(0x1584, 0x0000, "Uniwill ECS M31EI", ALC861_FIXUP_AMP_VREF_0F),
+	SND_PCI_QUIRK_VENDOR(0x1584, "Haier/Uniwill", ALC861_FIXUP_AMP_VREF_0F),
 	SND_PCI_QUIRK(0x1734, 0x10c7, "FSC Amilo Pi1505", ALC861_FIXUP_FSC_AMILO_PI1505),
 	{}
 };


