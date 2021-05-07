Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EBD6375EDD
	for <lists+stable@lfdr.de>; Fri,  7 May 2021 04:45:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231241AbhEGCqY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 May 2021 22:46:24 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:57104 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230515AbhEGCqX (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 May 2021 22:46:23 -0400
Received: from [123.112.70.57] (helo=localhost.localdomain)
        by youngberry.canonical.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <hui.wang@canonical.com>)
        id 1leqUP-00058x-VI; Fri, 07 May 2021 02:45:19 +0000
From:   Hui Wang <hui.wang@canonical.com>
To:     alsa-devel@alsa-project.org, tiwai@suse.de, kailang@realtek.com,
        stable@vger.kernel.org
Subject: [PATCH] ALSA: hda/realtek: reset eapd coeff to default value for alc287
Date:   Fri,  7 May 2021 10:44:52 +0800
Message-Id: <20210507024452.8300-1-hui.wang@canonical.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Ubuntu users reported an audio bug on the Lenovo Yoga Slim 7 14IIL05,
he installed dual OS (Windows + Linux), if he booted to the Linux
from Windows, the Speaker can't work well, it has crackling noise,
if he poweroff the machine first after Windows, the Speaker worked
well.

Before rebooting or shutdown from Windows, the Windows changes the
codec eapd coeff value, but the BIOS doesn't re-initialize its value,
when booting into the Linux from Windows, the eapd coeff value is not
correct. To fix it, set the codec default value to that coeff register
in the alsa driver.

BugLink: http://bugs.launchpad.net/bugs/1925057
Suggested-by: Kailang Yang <kailang@realtek.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Hui Wang <hui.wang@canonical.com>
---
 sound/pci/hda/patch_realtek.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 6d58f24c9702..a5f3e78ec04e 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -395,7 +395,6 @@ static void alc_fill_eapd_coef(struct hda_codec *codec)
 	case 0x10ec0282:
 	case 0x10ec0283:
 	case 0x10ec0286:
-	case 0x10ec0287:
 	case 0x10ec0288:
 	case 0x10ec0285:
 	case 0x10ec0298:
@@ -406,6 +405,10 @@ static void alc_fill_eapd_coef(struct hda_codec *codec)
 	case 0x10ec0275:
 		alc_update_coef_idx(codec, 0xe, 0, 1<<0);
 		break;
+	case 0x10ec0287:
+		alc_update_coef_idx(codec, 0x10, 1<<9, 0);
+		alc_write_coef_idx(codec, 0x8, 0x4ab7);
+		break;
 	case 0x10ec0293:
 		alc_update_coef_idx(codec, 0xa, 1<<13, 0);
 		break;
-- 
2.25.1

