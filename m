Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B33D435766
	for <lists+stable@lfdr.de>; Thu, 21 Oct 2021 02:25:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232449AbhJUA0J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Oct 2021 20:26:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:43720 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232109AbhJUAZM (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 20 Oct 2021 20:25:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C883C6121E;
        Thu, 21 Oct 2021 00:22:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634775777;
        bh=0ib/fyncMVs4ScXTsWlrVN7bq7ulpIxKD7GDX5t04zY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X5bZPD9TWoGslJmEUBDWD+h/S/tN3eNqyyqqgJcoZKeZgds6N2iuCn4HZrCDfxZis
         svvKr4TxxyPXgSK00t205lovmPwTVU2JYRmuRvsr7NKRR8syaVbwDhZeToiP3G4pAN
         qFxrfjFfOdN0VOrrUKpegjylHP/biIIVD2qXxBxgiQa5L0htuOIsaW345fx2Itwect
         turL9Tu5iIj/wU9sd69CdcPzG1vLL0iW77noTghaNPuy6cLMjbKYHD0YsGlK0EnXdT
         cKqSqZo12PXDdqEzWPm+vUrfJlv/QZvIVByi6Ih5sMQIc6dc+5hQ36QkV3fkcyVOR0
         4jP+g+2vn0Sbw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kai Vehmanen <kai.vehmanen@linux.intel.com>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>,
        perex@perex.cz, tiwai@suse.com, ranjani.sridharan@linux.intel.com,
        broonie@kernel.org, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.4 09/11] ALSA: hda: avoid write to STATESTS if controller is in reset
Date:   Wed, 20 Oct 2021 20:22:35 -0400
Message-Id: <20211021002238.1129482-9-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211021002238.1129482-1-sashal@kernel.org>
References: <20211021002238.1129482-1-sashal@kernel.org>
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
index 7e7be8e4dcf9..87ba66dcfd47 100644
--- a/sound/hda/hdac_controller.c
+++ b/sound/hda/hdac_controller.c
@@ -395,8 +395,9 @@ int snd_hdac_bus_reset_link(struct hdac_bus *bus, bool full_reset)
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

