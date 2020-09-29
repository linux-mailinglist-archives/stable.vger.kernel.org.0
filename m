Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BC6227C6D2
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 13:49:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731174AbgI2Lsw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 07:48:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:51368 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730987AbgI2Lsn (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:48:43 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E73A92158C;
        Tue, 29 Sep 2020 11:48:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601380122;
        bh=WCwjatINeXFq0IDOmh9qiS+TABvJtY2nBro1OWYcvcA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=axHdvqDD1eYxj418gVQAPkvFSuU1/1LtOPFdo/87awkNaRR7yRnqqa/vZz9MYcFJH
         aTCe48Fh8FmC+7RXVbQZXjtLjeZlSnXMozrWwvPKWuDbjB3cbt8a6awEHUzKFxWmv/
         KeGhoIvII6A4AzJg7usqzNcQ74nB7DV85b9ZYWOY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Hui Wang <hui.wang@canonical.com>, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.8 77/99] ALSA: hda/realtek: Enable front panel headset LED on Lenovo ThinkStation P520
Date:   Tue, 29 Sep 2020 13:02:00 +0200
Message-Id: <20200929105933.528264235@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929105929.719230296@linuxfoundation.org>
References: <20200929105929.719230296@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kai-Heng Feng <kai.heng.feng@canonical.com>

commit f73bbf639b32acb6b409e188fdde5644b301978f upstream.

On Lenovo P520, the front panel headset LED isn't lit up right now.

Realtek states that the LED needs to be enabled by ALC233's GPIO2, so
let's do it accordingly to light the LED up.

Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
Acked-by: Hui Wang <hui.wang@canonical.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200914070231.13192-1-kai.heng.feng@canonical.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_realtek.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -6066,6 +6066,7 @@ static void alc_fixup_thinkpad_acpi(stru
 #include "hp_x360_helper.c"
 
 enum {
+	ALC269_FIXUP_GPIO2,
 	ALC269_FIXUP_SONY_VAIO,
 	ALC275_FIXUP_SONY_VAIO_GPIO2,
 	ALC269_FIXUP_DELL_M101Z,
@@ -6247,6 +6248,10 @@ enum {
 };
 
 static const struct hda_fixup alc269_fixups[] = {
+	[ALC269_FIXUP_GPIO2] = {
+		.type = HDA_FIXUP_FUNC,
+		.v.func = alc_fixup_gpio2,
+	},
 	[ALC269_FIXUP_SONY_VAIO] = {
 		.type = HDA_FIXUP_PINCTLS,
 		.v.pins = (const struct hda_pintbl[]) {
@@ -7066,6 +7071,8 @@ static const struct hda_fixup alc269_fix
 	[ALC233_FIXUP_LENOVO_MULTI_CODECS] = {
 		.type = HDA_FIXUP_FUNC,
 		.v.func = alc233_alc662_fixup_lenovo_dual_codecs,
+		.chained = true,
+		.chain_id = ALC269_FIXUP_GPIO2
 	},
 	[ALC233_FIXUP_ACER_HEADSET_MIC] = {
 		.type = HDA_FIXUP_VERBS,


