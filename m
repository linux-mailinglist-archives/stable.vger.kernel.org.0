Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CAB222EF29
	for <lists+stable@lfdr.de>; Mon, 27 Jul 2020 16:14:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730445AbgG0ON7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jul 2020 10:13:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:39226 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730032AbgG0ON6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Jul 2020 10:13:58 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 112FD2083E;
        Mon, 27 Jul 2020 14:13:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595859237;
        bh=iINv9F84Bgoo99yjFob1WezwwZvaTlQYEjVwF0s72S8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oiBnAK/3rAbuP7/gIFAurk2IeWzu990t6IvzslhK+822sv3UPNEa3Z2bpAOULYR9V
         CgfqSu89EZyjhdAPSvQfLR4UKcBMOUc9y81jnuylz6kZSLIHt7v7SwT10koMcDarMf
         XMeMo8akTBTDTWfYA9YrwbKc2I19imfXrWkaHDR8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Joonho Wohn <doomsheart@gmail.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.4 030/138] ALSA: hda/realtek: Fixed ALC298 sound bug by adding quirk for Samsung Notebook Pen S
Date:   Mon, 27 Jul 2020 16:03:45 +0200
Message-Id: <20200727134926.878102514@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200727134925.228313570@linuxfoundation.org>
References: <20200727134925.228313570@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Joonho Wohn <doomsheart@gmail.com>

commit 568e4e82128aac2c62c2c359ebebb6007fd794f9 upstream.

Fixed no headphone sound bug on laptop Samsung Notebook Pen S
(950SBE-951SBE), by using existing patch in Linus' tree, commit
14425f1f521f (ALSA: hda/realtek: Add quirk for Samsung Notebook).
This laptop uses the same ALC298 but different subsystem id 0x144dc812.
I added SND_PCI_QUIRK at sound/pci/hda/patch_realtek.c

Signed-off-by: Joonho Wohn <doomsheart@gmail.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/CAHcbMh291aWDKiWSZoxXB4-Eru6OYRwGA4AVEdCZeYmVLo5ZxQ@mail.gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -7551,6 +7551,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x144d, 0xc169, "Samsung Notebook 9 Pen (NP930SBE-K01US)", ALC298_FIXUP_SAMSUNG_HEADPHONE_VERY_QUIET),
 	SND_PCI_QUIRK(0x144d, 0xc176, "Samsung Notebook 9 Pro (NP930MBE-K04US)", ALC298_FIXUP_SAMSUNG_HEADPHONE_VERY_QUIET),
 	SND_PCI_QUIRK(0x144d, 0xc740, "Samsung Ativ book 8 (NP870Z5G)", ALC269_FIXUP_ATIV_BOOK_8),
+	SND_PCI_QUIRK(0x144d, 0xc812, "Samsung Notebook Pen S (NT950SBE-X58)", ALC298_FIXUP_SAMSUNG_HEADPHONE_VERY_QUIET),
 	SND_PCI_QUIRK(0x1458, 0xfa53, "Gigabyte BXBT-2807", ALC283_FIXUP_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1462, 0xb120, "MSI Cubi MS-B120", ALC283_FIXUP_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1462, 0xb171, "Cubi N 8GL (MS-B171)", ALC283_FIXUP_HEADSET_MIC),


