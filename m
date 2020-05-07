Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB5671C900A
	for <lists+stable@lfdr.de>; Thu,  7 May 2020 16:37:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727970AbgEGOhI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 May 2020 10:37:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:54212 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727935AbgEGO2E (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 7 May 2020 10:28:04 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8736220870;
        Thu,  7 May 2020 14:28:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588861684;
        bh=xPB7rG39DnqHbcXBx1ABXclwQRBCgUnQoo0IUaw0wZY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XTH1+TlNWFWbqIifQcaWYRqviY005wyZCDMbA8Am/BJ4LvgFKfwzTnEcw6wwuGZPL
         t+ipxeHjo/Y2OeBx7qJ5/zNPAvnJJqCN/sqj8C9NJ+/j39I2W33lHvP4yKtRQDUZ26
         FiriAw+vHr/d7ml4YMrXthLEa0StDQwsgURaBrek=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kai Vehmanen <kai.vehmanen@linux.intel.com>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>,
        alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.6 30/50] ALSA: hda/hdmi: fix race in monitor detection during probe
Date:   Thu,  7 May 2020 10:27:06 -0400
Message-Id: <20200507142726.25751-30-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200507142726.25751-1-sashal@kernel.org>
References: <20200507142726.25751-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kai Vehmanen <kai.vehmanen@linux.intel.com>

[ Upstream commit ca76282b6faffc83601c25bd2a95f635c03503ef ]

A race exists between build_pcms() and build_controls() phases of codec
setup. Build_pcms() sets up notifier for jack events. If a monitor event
is received before build_controls() is run, the initial jack state is
lost and never reported via mixer controls.

The problem can be hit at least with SOF as the controller driver. SOF
calls snd_hda_codec_build_controls() in its workqueue-based probe and
this can be delayed enough to hit the race condition.

Fix the issue by invalidating the per-pin ELD information when
build_controls() is called. The existing call to hdmi_present_sense()
will update the ELD contents. This ensures initial monitor state is
correctly reflected via mixer controls.

BugLink: https://github.com/thesofproject/linux/issues/1687
Signed-off-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Link: https://lore.kernel.org/r/20200428123836.24512-1-kai.vehmanen@linux.intel.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_hdmi.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/pci/hda/patch_hdmi.c b/sound/pci/hda/patch_hdmi.c
index 8bc4d66ff986b..ebcb19b135f0d 100644
--- a/sound/pci/hda/patch_hdmi.c
+++ b/sound/pci/hda/patch_hdmi.c
@@ -2318,7 +2318,9 @@ static int generic_hdmi_build_controls(struct hda_codec *codec)
 
 	for (pin_idx = 0; pin_idx < spec->num_pins; pin_idx++) {
 		struct hdmi_spec_per_pin *per_pin = get_pin(spec, pin_idx);
+		struct hdmi_eld *pin_eld = &per_pin->sink_eld;
 
+		pin_eld->eld_valid = false;
 		hdmi_present_sense(per_pin, 0);
 	}
 
-- 
2.20.1

