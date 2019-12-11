Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A1D2511B4BD
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 16:50:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732774AbfLKPtu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:49:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:55614 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732242AbfLKPYU (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:24:20 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 15298208C3;
        Wed, 11 Dec 2019 15:24:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077859;
        bh=VJ3ZSSo+cdZLaNLdYnGbcLZnjc2wg5ogFHm11PodyAc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kaIhCSwUe6+w5FYmnp2PyLcmjfwus9GkVxCxGG/WB/xUMNz5tce7H53AuJXZNAzEQ
         MDEo3ZvWpepFml5588mG9W/Fr5JpvTWgD825i10fPP2dXQWeRxjDBDfZNWFVM7EFQQ
         /tnEWdehfLmPXcz1mWKTe41+pqI7CWwbKrN6taU0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jian-Hong Pan <jian-hong@endlessm.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.19 199/243] ALSA: hda/realtek - Enable internal speaker of ASUS UX431FLC
Date:   Wed, 11 Dec 2019 16:06:01 +0100
Message-Id: <20191211150352.613858627@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191211150339.185439726@linuxfoundation.org>
References: <20191211150339.185439726@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jian-Hong Pan <jian-hong@endlessm.com>

commit 436e25505f3458cc92c7f3c985e9cbc198a98209 upstream.

Laptops like ASUS UX431FLC and UX431FL can share the same audio quirks.
But UX431FLC needs one more step to enable the internal speaker: Pull
the GPIO from CODEC to initialize the AMP.

Fixes: 60083f9e94b2 ("ALSA: hda/realtek - Enable internal speaker & headset mic of ASUS UX431FL")
Signed-off-by: Jian-Hong Pan <jian-hong@endlessm.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20191125093405.5702-1-jian-hong@endlessm.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_realtek.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -5701,6 +5701,7 @@ enum {
 	ALC299_FIXUP_PREDATOR_SPK,
 	ALC294_FIXUP_ASUS_INTSPK_HEADSET_MIC,
 	ALC256_FIXUP_MEDION_HEADSET_NO_PRESENCE,
+	ALC294_FIXUP_ASUS_INTSPK_GPIO,
 };
 
 static const struct hda_fixup alc269_fixups[] = {
@@ -6764,6 +6765,13 @@ static const struct hda_fixup alc269_fix
 		.chained = true,
 		.chain_id = ALC256_FIXUP_ASUS_HEADSET_MODE
 	},
+	[ALC294_FIXUP_ASUS_INTSPK_GPIO] = {
+		.type = HDA_FIXUP_FUNC,
+		/* The GPIO must be pulled to initialize the AMP */
+		.v.func = alc_fixup_gpio4,
+		.chained = true,
+		.chain_id = ALC294_FIXUP_ASUS_INTSPK_HEADSET_MIC
+	},
 };
 
 static const struct snd_pci_quirk alc269_fixup_tbl[] = {
@@ -6923,7 +6931,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x1043, 0x1427, "Asus Zenbook UX31E", ALC269VB_FIXUP_ASUS_ZENBOOK),
 	SND_PCI_QUIRK(0x1043, 0x1517, "Asus Zenbook UX31A", ALC269VB_FIXUP_ASUS_ZENBOOK_UX31A),
 	SND_PCI_QUIRK(0x1043, 0x16e3, "ASUS UX50", ALC269_FIXUP_STEREO_DMIC),
-	SND_PCI_QUIRK(0x1043, 0x17d1, "ASUS UX431FL", ALC294_FIXUP_ASUS_INTSPK_HEADSET_MIC),
+	SND_PCI_QUIRK(0x1043, 0x17d1, "ASUS UX431FL", ALC294_FIXUP_ASUS_INTSPK_GPIO),
 	SND_PCI_QUIRK(0x1043, 0x18b1, "Asus MJ401TA", ALC256_FIXUP_ASUS_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1043, 0x1a13, "Asus G73Jw", ALC269_FIXUP_ASUS_G73JW),
 	SND_PCI_QUIRK(0x1043, 0x1a30, "ASUS X705UD", ALC256_FIXUP_ASUS_MIC),


