Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 460758CA18
	for <lists+stable@lfdr.de>; Wed, 14 Aug 2019 06:09:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726383AbfHNEJc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Aug 2019 00:09:32 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:48885 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725816AbfHNEJc (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Aug 2019 00:09:32 -0400
Received: from [114.254.46.119] (helo=localhost.localdomain)
        by youngberry.canonical.com with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
        (Exim 4.76)
        (envelope-from <hui.wang@canonical.com>)
        id 1hxkbJ-0000CA-3b; Wed, 14 Aug 2019 04:09:29 +0000
From:   Hui Wang <hui.wang@canonical.com>
To:     alsa-devel@alsa-project.org, tiwai@suse.de
Cc:     stable@vger.kernel.org
Subject: [PATCH 1/2] ALSA: hda - Let all conexant codec enter D3 when rebooting
Date:   Wed, 14 Aug 2019 12:09:07 +0800
Message-Id: <20190814040908.9758-1-hui.wang@canonical.com>
X-Mailer: git-send-email 2.17.1
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

We have 3 new lenovo laptops which have conexant codec 0x14f11f86,
these 3 laptops also have the noise issue when rebooting, after
letting the codec enter D3 before rebooting or poweroff, the noise
disappers.

Instead of adding a new ID again in the reboot_notify(), let us make
this function apply to all conexant codec. In theory make codec enter
D3 before rebooting or poweroff is harmless, and I tested this change
on a couple of other Lenovo laptops which have different conexant
codecs, there is no side effect so far.

Cc: stable@vger.kernel.org
Signed-off-by: Hui Wang <hui.wang@canonical.com>
---
 sound/pci/hda/patch_conexant.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/sound/pci/hda/patch_conexant.c b/sound/pci/hda/patch_conexant.c
index f299f137eaea..93a303676aea 100644
--- a/sound/pci/hda/patch_conexant.c
+++ b/sound/pci/hda/patch_conexant.c
@@ -163,15 +163,6 @@ static void cx_auto_reboot_notify(struct hda_codec *codec)
 {
 	struct conexant_spec *spec = codec->spec;
 
-	switch (codec->core.vendor_id) {
-	case 0x14f12008: /* CX8200 */
-	case 0x14f150f2: /* CX20722 */
-	case 0x14f150f4: /* CX20724 */
-		break;
-	default:
-		return;
-	}
-
 	/* Turn the problematic codec into D3 to avoid spurious noises
 	   from the internal speaker during (and after) reboot */
 	cx_auto_turn_eapd(codec, spec->num_eapds, spec->eapds, false);
-- 
2.17.1

