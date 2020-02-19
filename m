Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0BB48163C76
	for <lists+stable@lfdr.de>; Wed, 19 Feb 2020 06:23:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726001AbgBSFXZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Feb 2020 00:23:25 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:49469 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725819AbgBSFXZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Feb 2020 00:23:25 -0500
Received: from [222.130.141.161] (helo=localhost.localdomain)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <hui.wang@canonical.com>)
        id 1j4HpR-0005y0-Tl; Wed, 19 Feb 2020 05:23:22 +0000
From:   Hui Wang <hui.wang@canonical.com>
To:     alsa-devel@alsa-project.org, tiwai@suse.de, stable@vger.kernel.org
Subject: [PATCH] ALSA: hda/realtek - Fix a regression for mute led on Lenovo Carbon X1
Date:   Wed, 19 Feb 2020 13:23:06 +0800
Message-Id: <20200219052306.24935-1-hui.wang@canonical.com>
X-Mailer: git-send-email 2.17.1
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Need to chain the THINKPAD_ACPI, otherwise the mute led will not
work.

Fixes: d2cd795c4ece ("ALSA: hda - fixup for the bass speaker on Lenovo Carbon X1 7th gen")
Cc: <stable@vger.kernel.org>
Signed-off-by: Hui Wang <hui.wang@canonical.com>
---
 sound/pci/hda/patch_realtek.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 477589e7ec1d..31bee0512334 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -6684,6 +6684,8 @@ static const struct hda_fixup alc269_fixups[] = {
 	[ALC285_FIXUP_SPEAKER2_TO_DAC1] = {
 		.type = HDA_FIXUP_FUNC,
 		.v.func = alc285_fixup_speaker2_to_dac1,
+		.chained = true,
+		.chain_id = ALC269_FIXUP_THINKPAD_ACPI
 	},
 	[ALC256_FIXUP_DELL_INSPIRON_7559_SUBWOOFER] = {
 		.type = HDA_FIXUP_PINS,
-- 
2.17.1

