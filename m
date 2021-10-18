Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65180431DD4
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 15:53:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233119AbhJRNzP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 09:55:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:49664 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233343AbhJRNvX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Oct 2021 09:51:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9DB8F61212;
        Mon, 18 Oct 2021 13:38:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634564293;
        bh=QzaxEhbFDUPCJRZZCLQuPX6P0fyQo325U595C7kjpmI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AeywZiELf/auQB5XRCrvMSAtiCLJak4RzqGjIiOVVxsVErvRL842CIMfruAEeMbU4
         lxir0QEtnumg5HiK69PG9lLwZOk1Z2qxFkGtdJ2Cun6vs5PlRCI1Y2su/ksxfjYBhF
         3sEUdZyzfKcqdhyxBqrf9YOtdgmUJ7QyzFoqa1TI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chris Chiu <chris.chiu@canonical.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.14 006/151] ALSA: hda - Enable headphone mic on Dell Latitude laptops with ALC3254
Date:   Mon, 18 Oct 2021 15:23:05 +0200
Message-Id: <20211018132340.892616202@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211018132340.682786018@linuxfoundation.org>
References: <20211018132340.682786018@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Chiu <chris.chiu@canonical.com>

commit 2b987fe84429361c7f189568c476d1bd00d2ff7e upstream.

The headphone mic is not working on Dell Latitude laptops with ALC3254.
The codec vendor id is 0x10ec0295 and share the same pincfg as defined
in ALC295_STANDARD_PINS. So the ALC269_FIXUP_DELL1_MIC_NO_PRESENCE will
be applied per alc269_pin_fixup_tbl[] but actually the headphone mic is
using NID 0x1b instead of 0x1a. The ALC269_FIXUP_DELL4_MIC_NO_PRESENCE
need to be applied instead.

Use ALC269_FIXUP_DELL4_MIC_NO_PRESENCE for particular models before
a generic fixup comes out.

Signed-off-by: Chris Chiu <chris.chiu@canonical.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20211001062856.1037901-1-chris.chiu@canonical.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -8466,6 +8466,8 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x1028, 0x0a58, "Dell", ALC255_FIXUP_DELL_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1028, 0x0a61, "Dell XPS 15 9510", ALC289_FIXUP_DUAL_SPK),
 	SND_PCI_QUIRK(0x1028, 0x0a62, "Dell Precision 5560", ALC289_FIXUP_DUAL_SPK),
+	SND_PCI_QUIRK(0x1028, 0x0a9d, "Dell Latitude 5430", ALC269_FIXUP_DELL4_MIC_NO_PRESENCE),
+	SND_PCI_QUIRK(0x1028, 0x0a9e, "Dell Latitude 5430", ALC269_FIXUP_DELL4_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1028, 0x164a, "Dell", ALC293_FIXUP_DELL1_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1028, 0x164b, "Dell", ALC293_FIXUP_DELL1_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x103c, 0x1586, "HP", ALC269_FIXUP_HP_MUTE_LED_MIC2),


