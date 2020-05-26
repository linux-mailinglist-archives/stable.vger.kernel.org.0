Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4A241E2D55
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 21:24:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391270AbgEZTIK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 15:08:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:37058 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391753AbgEZTIJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 May 2020 15:08:09 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 59F8220873;
        Tue, 26 May 2020 19:08:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590520088;
        bh=k0bFd9vKn9byI//9D0YidIEqZAdyOb4Mw921FKbzjDk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FI3F6xJobaoFcXnC8q4Q5daLhYvVdjDw6nI+GsGv5cWp9PxNZaB/rusN7J95T7b53
         STAIMKbepPUEeutumLrfbBDX3cKKtX7bmtxXD30do53ka2kVwyklLxNkt1pFaO/UL3
         X5n8mAUBIcn3Z8MNdRsxlRCrsYHxAqZQgMsK4PcM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chris Chiu <chiu@endlessm.com>,
        Daniel Drake <drake@endlessm.com>,
        Jian-Hong Pan <jian-hong@endlessm.com>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 054/111] ALSA: hda/realtek - Enable headset mic of ASUS GL503VM with ALC295
Date:   Tue, 26 May 2020 20:53:12 +0200
Message-Id: <20200526183937.968369966@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200526183932.245016380@linuxfoundation.org>
References: <20200526183932.245016380@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Chiu <chiu@endlessm.com>

[ Upstream commit 9e43342b464f1de570a3ad8256ac77645749ef45 ]

The ASUS laptop GL503VM with ALC295 can't detect the headset microphone.
The headset microphone does not work until pin 0x19 is enabled for it.

Signed-off-by: Chris Chiu <chiu@endlessm.com>
Signed-off-by: Daniel Drake <drake@endlessm.com>
Signed-off-by: Jian-Hong Pan <jian-hong@endlessm.com>
Link: https://lore.kernel.org/r/20200512061525.133985-1-jian-hong@endlessm.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 736ddab16512..bc2352a3baba 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -6096,6 +6096,7 @@ enum {
 	ALC285_FIXUP_HP_MUTE_LED,
 	ALC236_FIXUP_HP_MUTE_LED,
 	ALC298_FIXUP_SAMSUNG_HEADPHONE_VERY_QUIET,
+	ALC295_FIXUP_ASUS_MIC_NO_PRESENCE,
 };
 
 static const struct hda_fixup alc269_fixups[] = {
@@ -7259,6 +7260,15 @@ static const struct hda_fixup alc269_fixups[] = {
 			{ }
 		},
 	},
+	[ALC295_FIXUP_ASUS_MIC_NO_PRESENCE] = {
+		.type = HDA_FIXUP_PINS,
+		.v.pins = (const struct hda_pintbl[]) {
+			{ 0x19, 0x01a1913c }, /* use as headset mic, without its own jack detect */
+			{ }
+		},
+		.chained = true,
+		.chain_id = ALC269_FIXUP_HEADSET_MODE
+	},
 };
 
 static const struct snd_pci_quirk alc269_fixup_tbl[] = {
@@ -8072,6 +8082,14 @@ static const struct snd_hda_pin_quirk alc269_pin_fixup_tbl[] = {
 		{0x12, 0x90a60130},
 		{0x17, 0x90170110},
 		{0x21, 0x03211020}),
+	SND_HDA_PIN_QUIRK(0x10ec0295, 0x1043, "ASUS", ALC295_FIXUP_ASUS_MIC_NO_PRESENCE,
+		{0x12, 0x90a60130},
+		{0x17, 0x90170110},
+		{0x21, 0x03211020}),
+	SND_HDA_PIN_QUIRK(0x10ec0295, 0x1043, "ASUS", ALC295_FIXUP_ASUS_MIC_NO_PRESENCE,
+		{0x12, 0x90a60130},
+		{0x17, 0x90170110},
+		{0x21, 0x03211020}),
 	SND_HDA_PIN_QUIRK(0x10ec0295, 0x1028, "Dell", ALC269_FIXUP_DELL4_MIC_NO_PRESENCE,
 		{0x14, 0x90170110},
 		{0x21, 0x04211020}),
-- 
2.25.1



