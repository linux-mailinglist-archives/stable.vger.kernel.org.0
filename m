Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D72E452509
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 02:43:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381270AbhKPBqa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 20:46:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:33156 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241582AbhKOSX1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:23:27 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E50586341F;
        Mon, 15 Nov 2021 17:53:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636998819;
        bh=n2Cq+FzxlBWFFeLCd5RMawxnYSh9BBvL6mFvPeqKQWU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KTgeLLmffQXUAWt0IH8nHzm0OG8abB7f1y6/vaahbbTNE740kQj+x7VgT3/Le+CX4
         ctO5aTcnQqGu7Vo4f3Bhye6d38XGmos6r7fHmCkO2W04mcv/vK6j23C5j4H/fhgyED
         kqQRWcTkCOlyUc+rtAXk1d3e+KcXNApgJNSI8KVA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.14 030/849] ALSA: hda/realtek: Add a quirk for HP OMEN 15 mute LED
Date:   Mon, 15 Nov 2021 17:51:53 +0100
Message-Id: <20211115165421.020307687@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit 375f8426ed994addd2be4d76febc946a6fdd8280 upstream.

HP OMEN 15 laptop requires the quirk to fiddle with COEF 0x0b bit 2
for toggling the mute LED.  It's already implemented for other HP
laptops, and we just need to add a proper fixup entry.

BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=214735
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20211028070911.18891-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -8604,6 +8604,7 @@ static const struct snd_pci_quirk alc269
 		      ALC285_FIXUP_HP_GPIO_AMP_INIT),
 	SND_PCI_QUIRK(0x103c, 0x8783, "HP ZBook Fury 15 G7 Mobile Workstation",
 		      ALC285_FIXUP_HP_GPIO_AMP_INIT),
+	SND_PCI_QUIRK(0x103c, 0x8788, "HP OMEN 15", ALC285_FIXUP_HP_MUTE_LED),
 	SND_PCI_QUIRK(0x103c, 0x87c8, "HP", ALC287_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x87e5, "HP ProBook 440 G8 Notebook PC", ALC236_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x87e7, "HP ProBook 450 G8 Notebook PC", ALC236_FIXUP_HP_GPIO_LED),


