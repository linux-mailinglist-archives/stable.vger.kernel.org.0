Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0FBA27C671
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 13:45:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730302AbgI2LpR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 07:45:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:44930 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730945AbgI2LpP (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:45:15 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B3FDB20702;
        Tue, 29 Sep 2020 11:45:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601379913;
        bh=Fjd+qrSiNHS4O9k0/sEotJDUizzL/aeCH1SIYodH7jM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R4gFzcp0XA/47AKRHl/OANSDb3eeFMKe+g74rsXlT1MYDbNO1+9o2OGnHXoIcIsxy
         QSnIA1xS0+hRpz1Fbl3ujyxCtsxq9OTuDZH3UL5h9YA2ezPG+uHkM3dqE+imVuPJYY
         vohG2ubB+3erHo1kqH/eRy+sZWQgLcVouQjQKUI0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Hui Wang <hui.wang@canonical.com>, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.4 372/388] ALSA: hda/realtek: Enable front panel headset LED on Lenovo ThinkStation P520
Date:   Tue, 29 Sep 2020 13:01:43 +0200
Message-Id: <20200929110028.473436978@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929110010.467764689@linuxfoundation.org>
References: <20200929110010.467764689@linuxfoundation.org>
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
@@ -6036,6 +6036,7 @@ static void alc_fixup_thinkpad_acpi(stru
 #include "hp_x360_helper.c"
 
 enum {
+	ALC269_FIXUP_GPIO2,
 	ALC269_FIXUP_SONY_VAIO,
 	ALC275_FIXUP_SONY_VAIO_GPIO2,
 	ALC269_FIXUP_DELL_M101Z,
@@ -6217,6 +6218,10 @@ enum {
 };
 
 static const struct hda_fixup alc269_fixups[] = {
+	[ALC269_FIXUP_GPIO2] = {
+		.type = HDA_FIXUP_FUNC,
+		.v.func = alc_fixup_gpio2,
+	},
 	[ALC269_FIXUP_SONY_VAIO] = {
 		.type = HDA_FIXUP_PINCTLS,
 		.v.pins = (const struct hda_pintbl[]) {
@@ -7036,6 +7041,8 @@ static const struct hda_fixup alc269_fix
 	[ALC233_FIXUP_LENOVO_MULTI_CODECS] = {
 		.type = HDA_FIXUP_FUNC,
 		.v.func = alc233_alc662_fixup_lenovo_dual_codecs,
+		.chained = true,
+		.chain_id = ALC269_FIXUP_GPIO2
 	},
 	[ALC233_FIXUP_ACER_HEADSET_MIC] = {
 		.type = HDA_FIXUP_VERBS,


