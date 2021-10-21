Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57A9E43579B
	for <lists+stable@lfdr.de>; Thu, 21 Oct 2021 02:26:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232439AbhJUA1O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Oct 2021 20:27:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:45728 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232468AbhJUA0N (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 20 Oct 2021 20:26:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B4EF16121E;
        Thu, 21 Oct 2021 00:23:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634775837;
        bh=u17dEBACuhhNVBqaU2GsXt7cKqeBlviZJa2K65iEX3A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rlnRBjSrmzDrFVH/PSJI9J4IpxuBYesxBzyKwueLL1MNcqqvJ4RWY3H3PPWNmwOYk
         lrOix99EtFNoXZcNyq8EmPtaPUJ8DFtqEaqJ6HNudAJ/v73bNG3SxDsZBQbUQ6PF5k
         E7K+5idqaUvpsw6hK1owc1AKO68FpJxwZFzmxK/xZXcV9fNLVQuaI7r8hDy+KZP/xG
         ERaxj55FBxLs+HKPqi5lVIiytouget4IXPqAbXwtdLT/nzCEFCsp1KYqSn5bf9ABgm
         lu0q7Utna36QjqZ+YwpTmJlt8luQ5J9DGd1NMa5VA1qvVbRZkAwb+Ep3dXH3XMUYJu
         uammQKQ4hMuqg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kai Vehmanen <kai.vehmanen@linux.intel.com>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>,
        perex@perex.cz, tiwai@suse.com, broonie@kernel.org,
        ranjani.sridharan@linux.intel.com, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 4.14 8/9] ALSA: hda: avoid write to STATESTS if controller is in reset
Date:   Wed, 20 Oct 2021 20:23:32 -0400
Message-Id: <20211021002333.1129824-8-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211021002333.1129824-1-sashal@kernel.org>
References: <20211021002333.1129824-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kai Vehmanen <kai.vehmanen@linux.intel.com>

[ Upstream commit b37a15188eae9d4c49c5bb035e0c8d4058e4d9b3 ]

The snd_hdac_bus_reset_link() contains logic to clear STATESTS register
before performing controller reset. This code dates back to an old
bugfix in commit e8a7f136f5ed ("[ALSA] hda-intel - Improve HD-audio
codec probing robustness"). Originally the code was added to
azx_reset().

The code was moved around in commit a41d122449be ("ALSA: hda - Embed bus
into controller object") and ended up to snd_hdac_bus_reset_link() and
called primarily via snd_hdac_bus_init_chip().

The logic to clear STATESTS is correct when snd_hdac_bus_init_chip() is
called when controller is not in reset. In this case, STATESTS can be
cleared. This can be useful e.g. when forcing a controller reset to retry
codec probe. A normal non-power-on reset will not clear the bits.

However, this old logic is problematic when controller is already in
reset. The HDA specification states that controller must be taken out of
reset before writing to registers other than GCTL.CRST (1.0a spec,
3.3.7). The write to STATESTS in snd_hdac_bus_reset_link() will be lost
if the controller is already in reset per the HDA specification mentioned.

This has been harmless on older hardware. On newer generation of Intel
PCIe based HDA controllers, if configured to report issues, this write
will emit an unsupported request error. If ACPI Platform Error Interface
(APEI) is enabled in kernel, this will end up to kernel log.

Fix the code in snd_hdac_bus_reset_link() to only clear the STATESTS if
the function is called when controller is not in reset. Otherwise
clearing the bits is not possible and should be skipped.

Signed-off-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Link: https://lore.kernel.org/r/20211012142935.3731820-1-kai.vehmanen@linux.intel.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/hda/hdac_controller.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/sound/hda/hdac_controller.c b/sound/hda/hdac_controller.c
index 778b42ba90b8..5ae72134159a 100644
--- a/sound/hda/hdac_controller.c
+++ b/sound/hda/hdac_controller.c
@@ -389,8 +389,9 @@ int snd_hdac_bus_reset_link(struct hdac_bus *bus, bool full_reset)
 	if (!full_reset)
 		goto skip_reset;
 
-	/* clear STATESTS */
-	snd_hdac_chip_writew(bus, STATESTS, STATESTS_INT_MASK);
+	/* clear STATESTS if not in reset */
+	if (snd_hdac_chip_readb(bus, GCTL) & AZX_GCTL_RESET)
+		snd_hdac_chip_writew(bus, STATESTS, STATESTS_INT_MASK);
 
 	/* reset controller */
 	snd_hdac_bus_enter_link_reset(bus);
-- 
2.33.0

