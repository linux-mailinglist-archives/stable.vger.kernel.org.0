Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83637475EAE
	for <lists+stable@lfdr.de>; Wed, 15 Dec 2021 18:25:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245342AbhLORXz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Dec 2021 12:23:55 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:44094 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245343AbhLORXW (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Dec 2021 12:23:22 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 130FD61A1E;
        Wed, 15 Dec 2021 17:23:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF4C6C36AE4;
        Wed, 15 Dec 2021 17:23:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639589001;
        bh=DZXMIF+OEY1uELNTkn4ftoL8YdEPy7GtZ/kmBT6WmGI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=huoeTDEwooiZHIZcLljGvBGQsTWu12QBDR51GhM6lVmZX9O9xZsBrigG6LIy0Pz9X
         uruMXf1CUENIPV6C4VkccJf8eDrgBzS8If+sO+fMRIxUH5l6OV6Cbu6Ce+xKxYo4Ha
         J4SI7EPju+asKjXAvNhqt3MpiRKnCJ798BOt6bAI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Uma Shankar <uma.shankar@intel.com>,
        Kai Vehmanen <kai.vehmanen@linux.intel.com>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 28/42] ALSA: hda: Add Intel DG2 PCI ID and HDMI codec vid
Date:   Wed, 15 Dec 2021 18:21:09 +0100
Message-Id: <20211215172027.629822992@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211215172026.641863587@linuxfoundation.org>
References: <20211215172026.641863587@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kai Vehmanen <kai.vehmanen@linux.intel.com>

[ Upstream commit d85ffff5302b1509efc482e8877c253b0a668b33 ]

Add HD Audio PCI ID and HDMI codec vendor ID for Intel DG2.

Reviewed-by: Uma Shankar <uma.shankar@intel.com>
Signed-off-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Link: https://lore.kernel.org/r/20211130124732.696896-1-kai.vehmanen@linux.intel.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/hda_intel.c  | 12 +++++++++++-
 sound/pci/hda/patch_hdmi.c |  1 +
 2 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/sound/pci/hda/hda_intel.c b/sound/pci/hda/hda_intel.c
index 90e9263ac0bd7..21fec82489bd7 100644
--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -335,7 +335,10 @@ enum {
 					((pci)->device == 0x0c0c) || \
 					((pci)->device == 0x0d0c) || \
 					((pci)->device == 0x160c) || \
-					((pci)->device == 0x490d))
+					((pci)->device == 0x490d) || \
+					((pci)->device == 0x4f90) || \
+					((pci)->device == 0x4f91) || \
+					((pci)->device == 0x4f92))
 
 #define IS_BXT(pci) ((pci)->vendor == 0x8086 && (pci)->device == 0x5a98)
 
@@ -2472,6 +2475,13 @@ static const struct pci_device_id azx_ids[] = {
 	/* DG1 */
 	{ PCI_DEVICE(0x8086, 0x490d),
 	  .driver_data = AZX_DRIVER_SKL | AZX_DCAPS_INTEL_SKYLAKE},
+	/* DG2 */
+	{ PCI_DEVICE(0x8086, 0x4f90),
+	  .driver_data = AZX_DRIVER_SKL | AZX_DCAPS_INTEL_SKYLAKE},
+	{ PCI_DEVICE(0x8086, 0x4f91),
+	  .driver_data = AZX_DRIVER_SKL | AZX_DCAPS_INTEL_SKYLAKE},
+	{ PCI_DEVICE(0x8086, 0x4f92),
+	  .driver_data = AZX_DRIVER_SKL | AZX_DCAPS_INTEL_SKYLAKE},
 	/* Alderlake-S */
 	{ PCI_DEVICE(0x8086, 0x7ad0),
 	  .driver_data = AZX_DRIVER_SKL | AZX_DCAPS_INTEL_SKYLAKE},
diff --git a/sound/pci/hda/patch_hdmi.c b/sound/pci/hda/patch_hdmi.c
index 65d2c55399195..98633d2684deb 100644
--- a/sound/pci/hda/patch_hdmi.c
+++ b/sound/pci/hda/patch_hdmi.c
@@ -4382,6 +4382,7 @@ HDA_CODEC_ENTRY(0x80862814, "DG1 HDMI",	patch_i915_tgl_hdmi),
 HDA_CODEC_ENTRY(0x80862815, "Alderlake HDMI",	patch_i915_tgl_hdmi),
 HDA_CODEC_ENTRY(0x8086281c, "Alderlake-P HDMI", patch_i915_tgl_hdmi),
 HDA_CODEC_ENTRY(0x80862816, "Rocketlake HDMI",	patch_i915_tgl_hdmi),
+HDA_CODEC_ENTRY(0x80862819, "DG2 HDMI",	patch_i915_tgl_hdmi),
 HDA_CODEC_ENTRY(0x8086281a, "Jasperlake HDMI",	patch_i915_icl_hdmi),
 HDA_CODEC_ENTRY(0x8086281b, "Elkhartlake HDMI",	patch_i915_icl_hdmi),
 HDA_CODEC_ENTRY(0x80862880, "CedarTrail HDMI",	patch_generic_hdmi),
-- 
2.33.0



