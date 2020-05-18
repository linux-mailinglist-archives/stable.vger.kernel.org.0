Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 684F21D8292
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 19:57:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731807AbgERR5e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 13:57:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:32894 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731508AbgERRzf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 13:55:35 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DA67A20674;
        Mon, 18 May 2020 17:55:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589824535;
        bh=MvciCjxqbATbF9bVFNFSQoSFaxr/QAeTiCBmuMcVyko=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TvKcSlQHWgrxbYFTVdW7ek1TJ2RBw9uxtp7mVUQy7rcZovQvvA92Vkx9ygvs9dGiG
         UYqFTr0XwnyRCKHF1/oRbx5rfNtV+Kw+dlD0cmR4ZFoxOICyrplOzTSDsgDACIzEsb
         VAhHphEdsehwWfLLWQRpwAQIvS2t99r6KKQweGQY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 051/147] ALSA: hda/realtek - Fix S3 pop noise on Dell Wyse
Date:   Mon, 18 May 2020 19:36:14 +0200
Message-Id: <20200518173520.322944614@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173513.009514388@linuxfoundation.org>
References: <20200518173513.009514388@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kai-Heng Feng <kai.heng.feng@canonical.com>

[ Upstream commit 52e4e36807aeac1cdd07b14e509c8a64101e1a09 ]

Commit 317d9313925c ("ALSA: hda/realtek - Set default power save node to
0") makes the ALC225 have pop noise on S3 resume and cold boot.

The previous fix enable power save node universally for ALC225, however
it makes some ALC225 systems unable to produce any sound.

So let's only enable power save node for the affected Dell Wyse
platform.

Fixes: 317d9313925c ("ALSA: hda/realtek - Set default power save node to 0")
BugLink: https://bugs.launchpad.net/bugs/1866357
Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
Link: https://lore.kernel.org/r/20200503152449.22761-2-kai.heng.feng@canonical.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 64270983ab7db..1a01e7c5b6d0a 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -5743,6 +5743,15 @@ static void alc233_alc662_fixup_lenovo_dual_codecs(struct hda_codec *codec,
 	}
 }
 
+static void alc225_fixup_s3_pop_noise(struct hda_codec *codec,
+				      const struct hda_fixup *fix, int action)
+{
+	if (action != HDA_FIXUP_ACT_PRE_PROBE)
+		return;
+
+	codec->power_save_node = 1;
+}
+
 /* Forcibly assign NID 0x03 to HP/LO while NID 0x02 to SPK for EQ */
 static void alc274_fixup_bind_dacs(struct hda_codec *codec,
 				    const struct hda_fixup *fix, int action)
@@ -5932,6 +5941,7 @@ enum {
 	ALC233_FIXUP_ACER_HEADSET_MIC,
 	ALC294_FIXUP_LENOVO_MIC_LOCATION,
 	ALC225_FIXUP_DELL_WYSE_MIC_NO_PRESENCE,
+	ALC225_FIXUP_S3_POP_NOISE,
 	ALC700_FIXUP_INTEL_REFERENCE,
 	ALC274_FIXUP_DELL_BIND_DACS,
 	ALC274_FIXUP_DELL_AIO_LINEOUT_VERB,
@@ -6817,6 +6827,12 @@ static const struct hda_fixup alc269_fixups[] = {
 			{ }
 		},
 		.chained = true,
+		.chain_id = ALC225_FIXUP_S3_POP_NOISE
+	},
+	[ALC225_FIXUP_S3_POP_NOISE] = {
+		.type = HDA_FIXUP_FUNC,
+		.v.func = alc225_fixup_s3_pop_noise,
+		.chained = true,
 		.chain_id = ALC269_FIXUP_HEADSET_MODE_NO_HP_MIC
 	},
 	[ALC700_FIXUP_INTEL_REFERENCE] = {
-- 
2.20.1



