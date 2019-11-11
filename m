Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A3138F76DB
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 15:45:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727023AbfKKOp0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 09:45:26 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:50185 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726871AbfKKOp0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Nov 2019 09:45:26 -0500
Received: from [114.253.244.234] (helo=localhost.localdomain)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <hui.wang@canonical.com>)
        id 1iUAwV-0001nK-8A; Mon, 11 Nov 2019 14:45:23 +0000
From:   Hui Wang <hui.wang@canonical.com>
To:     alsa-devel@alsa-project.org, tiwai@suse.de
Cc:     stable@vger.kernel.org
Subject: [PATCH] ALSA: hda/hdmi - add a parameter to let users decide if checking the eld_valid
Date:   Mon, 11 Nov 2019 22:45:02 +0800
Message-Id: <20191111144502.22910-1-hui.wang@canonical.com>
X-Mailer: git-send-email 2.17.1
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

With the commit 7f641e26a6df ("ALSA: hda/hdmi - Consider eld_valid
when reporting jack event"), the driver checks eld_valid before
reporting Jack state, this fixes the 4 HDMI/DP audio devices issue.

But recently some users complained that the hdmi audio on their
machines couldn't work anymore with this commit. On their machines,
the monitor_present is 1 while the eld_valid is 0 when plugging a
monitor, and the hdmi audio could work even the eld_valid is 0.

To make the hdmi audio work again on those machines, adding a module
parameter, if usrs want to skip the checking eld_valid, they
could set checking_eld_valid=0 when loading the module. And this
parameter only applies to sense_via_verbs, for those getting eld via
component, no need to apply this parameter since it is impossible
that present is 1 while eld_valid is 0.

BugLink: https://bugs.launchpad.net/bugs/1834771
Fixes: 7f641e26a6df ("ALSA: hda/hdmi - Consider eld_valid when reporting jack event")
Cc: <stable@vger.kernel.org>
Signed-off-by: Hui Wang <hui.wang@canonical.com>
---
 sound/pci/hda/patch_hdmi.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/sound/pci/hda/patch_hdmi.c b/sound/pci/hda/patch_hdmi.c
index be8a977fc684..d70fca4f4411 100644
--- a/sound/pci/hda/patch_hdmi.c
+++ b/sound/pci/hda/patch_hdmi.c
@@ -37,6 +37,11 @@ static bool static_hdmi_pcm;
 module_param(static_hdmi_pcm, bool, 0644);
 MODULE_PARM_DESC(static_hdmi_pcm, "Don't restrict PCM parameters per ELD info");
 
+static bool checking_eld_valid = true;
+module_param(checking_eld_valid, bool, 0644);
+MODULE_PARM_DESC(checking_eld_valid, "Checking eld_valid before reporting Jack "
+		 "state (default = 1, using verbs only)");
+
 #define is_haswell(codec)  ((codec)->core.vendor_id == 0x80862807)
 #define is_broadwell(codec)    ((codec)->core.vendor_id == 0x80862808)
 #define is_skylake(codec) ((codec)->core.vendor_id == 0x80862809)
@@ -1557,8 +1562,9 @@ static bool hdmi_present_sense_via_verbs(struct hdmi_spec_per_pin *per_pin,
 	jack = snd_hda_jack_tbl_get(codec, pin_nid);
 	if (jack) {
 		jack->block_report = !ret;
-		jack->pin_sense = (eld->monitor_present && eld->eld_valid) ?
-			AC_PINSENSE_PRESENCE : 0;
+		if (checking_eld_valid)
+			jack->pin_sense = (eld->monitor_present && eld->eld_valid) ?
+				AC_PINSENSE_PRESENCE : 0;
 	}
 	mutex_unlock(&per_pin->lock);
 	return ret;
-- 
2.17.1

