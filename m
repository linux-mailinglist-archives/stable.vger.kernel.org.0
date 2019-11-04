Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C18E3EEFA6
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 23:23:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388053AbfKDVy4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 16:54:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:49952 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388050AbfKDVyz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Nov 2019 16:54:55 -0500
Received: from localhost (6.204-14-84.ripe.coltfrance.com [84.14.204.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8583C217F4;
        Mon,  4 Nov 2019 21:54:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572904495;
        bh=u9Z6lVC4xy0VgeB2bfaZPJz5Y1PJFKbw+LVpl3t3NfA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EoBcEmOwv8K8X5SPRa4QJ1x0qsD497W9dFcKWnL2OrcoU0f4BGDRcDdJG0HAnVFGr
         f5r5ymVU7tgtjW80V/LD3oYgzIXOciQtFSj6j4htlEocoHCOpXKhT1RRNdRZL4gGgc
         PQC/GNFAaysfs2GKOKA4WyIGL0+jbdBko/gSrc0M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kailang Yang <kailang@realtek.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.14 66/95] ALSA: hda/realtek - Add support for ALC623
Date:   Mon,  4 Nov 2019 22:45:04 +0100
Message-Id: <20191104212110.711021892@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191104212038.056365853@linuxfoundation.org>
References: <20191104212038.056365853@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kailang Yang <kailang@realtek.com>

commit f0778871a13889b86a65d4ad34bef8340af9d082 upstream.

Support new codec ALC623.

Signed-off-by: Kailang Yang <kailang@realtek.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/ed97b6a8bd9445ecb48bc763d9aaba7a@realtek.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_realtek.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -375,6 +375,9 @@ static void alc_fill_eapd_coef(struct hd
 	case 0x10ec0672:
 		alc_update_coef_idx(codec, 0xd, 0, 1<<14); /* EAPD Ctrl */
 		break;
+	case 0x10ec0623:
+		alc_update_coef_idx(codec, 0x19, 1<<13, 0);
+		break;
 	case 0x10ec0668:
 		alc_update_coef_idx(codec, 0x7, 3<<13, 0);
 		break;
@@ -2757,6 +2760,7 @@ enum {
 	ALC269_TYPE_ALC225,
 	ALC269_TYPE_ALC294,
 	ALC269_TYPE_ALC300,
+	ALC269_TYPE_ALC623,
 	ALC269_TYPE_ALC700,
 };
 
@@ -2792,6 +2796,7 @@ static int alc269_parse_auto_config(stru
 	case ALC269_TYPE_ALC225:
 	case ALC269_TYPE_ALC294:
 	case ALC269_TYPE_ALC300:
+	case ALC269_TYPE_ALC623:
 	case ALC269_TYPE_ALC700:
 		ssids = alc269_ssids;
 		break;
@@ -7274,6 +7279,9 @@ static int patch_alc269(struct hda_codec
 		spec->codec_variant = ALC269_TYPE_ALC300;
 		spec->gen.mixer_nid = 0; /* no loopback on ALC300 */
 		break;
+	case 0x10ec0623:
+		spec->codec_variant = ALC269_TYPE_ALC623;
+		break;
 	case 0x10ec0700:
 	case 0x10ec0701:
 	case 0x10ec0703:
@@ -8354,6 +8362,7 @@ static const struct hda_device_id snd_hd
 	HDA_CODEC_ENTRY(0x10ec0298, "ALC298", patch_alc269),
 	HDA_CODEC_ENTRY(0x10ec0299, "ALC299", patch_alc269),
 	HDA_CODEC_ENTRY(0x10ec0300, "ALC300", patch_alc269),
+	HDA_CODEC_ENTRY(0x10ec0623, "ALC623", patch_alc269),
 	HDA_CODEC_REV_ENTRY(0x10ec0861, 0x100340, "ALC660", patch_alc861),
 	HDA_CODEC_ENTRY(0x10ec0660, "ALC660-VD", patch_alc861vd),
 	HDA_CODEC_ENTRY(0x10ec0861, "ALC861", patch_alc861),


