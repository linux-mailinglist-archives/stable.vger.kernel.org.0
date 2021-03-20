Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17727342B90
	for <lists+stable@lfdr.de>; Sat, 20 Mar 2021 11:51:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229606AbhCTKvY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 20 Mar 2021 06:51:24 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:46712 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229600AbhCTKvQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 20 Mar 2021 06:51:16 -0400
Received: from [123.112.71.70] (helo=localhost.localdomain)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <hui.wang@canonical.com>)
        id 1lNXi2-0001zg-V4; Sat, 20 Mar 2021 09:15:51 +0000
From:   Hui Wang <hui.wang@canonical.com>
To:     alsa-devel@alsa-project.org, tiwai@suse.de, kailang@realtek.com,
        stable@vger.kernel.org
Subject: [PATCH v3 1/2] ALSA: hda/realtek: fix a determine_headset_type issue for a Dell AIO
Date:   Sat, 20 Mar 2021 17:15:41 +0800
Message-Id: <20210320091542.6748-1-hui.wang@canonical.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

We found a recording issue on a Dell AIO, users plug a headset-mic and
select headset-mic from UI, but can't record any sound from
headset-mic. The root cause is the determine_headset_type() returns a
wrong type, e.g. users plug a ctia type headset, but that function
returns omtp type.

On this machine, the internal mic is not connected to the codec, the
"Input Source" is headset mic by default. And when users plug a
headset, the determine_headset_type() will be called immediately, the
codec on this AIO is alc274, the delay time for this codec in the
determine_headset_type() is only 80ms, the delay is too short to
correctly determine the headset type, the fail rate is nearly 99% when
users plug the headset with the normal speed.

Other codecs set several hundred ms delay time, so here I change the
delay time to 850ms for alc2x4 series, after this change, the fail
rate is zero unless users plug the headset slowly on purpose.

Cc: <stable@vger.kernel.org>
Signed-off-by: Hui Wang <hui.wang@canonical.com>
---
 sound/pci/hda/patch_realtek.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 8239e5efc12d..442e555de44c 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -5263,7 +5263,7 @@ static void alc_determine_headset_type(struct hda_codec *codec)
 	case 0x10ec0274:
 	case 0x10ec0294:
 		alc_process_coef_fw(codec, coef0274);
-		msleep(80);
+		msleep(850);
 		val = alc_read_coef_idx(codec, 0x46);
 		is_ctia = (val & 0x00f0) == 0x00f0;
 		break;
-- 
2.25.1

