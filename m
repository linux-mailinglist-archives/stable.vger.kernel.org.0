Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6FB23C2E9B
	for <lists+stable@lfdr.de>; Sat, 10 Jul 2021 04:27:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233691AbhGJC1q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 22:27:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:43326 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233728AbhGJC1H (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 22:27:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BDA1E613E4;
        Sat, 10 Jul 2021 02:24:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625883853;
        bh=Wc+8IUEWEbx56kg+jURITthTR5thKLxkWh0FSVlJrVk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R7js9x72hBbk8INvcrpn3dcCupFVsm7rBDYmuCLLXU/EOm4vsoUokqcPAocg1Fc4+
         gdy6Ritl7bD7RUXklKh4bBe3i7QHKbuVD2QrOBsXwsEmti8w/rTyHHBV1kftRZH2//
         yRYxlELctSUUGm9T/Z0PyJU6AxTKh4F14KWA9tKJ98aI6cJXLJujZcSwpSnjyUHzun
         37AxMuF1Ui2bxI66SC24H+gaTnrB6PxQGUhPtml6J1nYOPuZtJEjNVpYXyCRx+HMbc
         AIZZrCWBt27andXw28u257iT4U9PRFkIM2PVtA183sKg2CU2szcZTu1i69BObGPWql
         jNPiQ17D/oXGQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Takashi Sakamoto <o-takashi@sakamocchi.jp>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>,
        alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.12 096/104] ALSA: firewire-motu: fix detection for S/PDIF source on optical interface in v2 protocol
Date:   Fri,  9 Jul 2021 22:21:48 -0400
Message-Id: <20210710022156.3168825-96-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710022156.3168825-1-sashal@kernel.org>
References: <20210710022156.3168825-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Sakamoto <o-takashi@sakamocchi.jp>

[ Upstream commit fa4db23233eb912234bdfb0b26a38be079c6b5ea ]

The devices in protocol version 2 has a register with flag for IEC 60958
signal detection as source of sampling clock without discrimination
between coaxial and optical interfaces. On the other hand, current
implementation of driver manage to interpret type of signal on optical
interface instead.

This commit fixes the detection of optical/coaxial interface for S/PDIF
signal.

Signed-off-by: Takashi Sakamoto <o-takashi@sakamocchi.jp>
Link: https://lore.kernel.org/r/20210623075941.72562-2-o-takashi@sakamocchi.jp
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/firewire/motu/motu-protocol-v2.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/sound/firewire/motu/motu-protocol-v2.c b/sound/firewire/motu/motu-protocol-v2.c
index e59e69ab1538..f0d478c5edc8 100644
--- a/sound/firewire/motu/motu-protocol-v2.c
+++ b/sound/firewire/motu/motu-protocol-v2.c
@@ -86,24 +86,23 @@ static int detect_clock_source_optical_model(struct snd_motu *motu, u32 data,
 		*src = SND_MOTU_CLOCK_SOURCE_INTERNAL;
 		break;
 	case 1:
+		*src = SND_MOTU_CLOCK_SOURCE_ADAT_ON_OPT;
+		break;
+	case 2:
 	{
 		__be32 reg;
 
 		// To check the configuration of optical interface.
-		int err = snd_motu_transaction_read(motu, V2_IN_OUT_CONF_OFFSET,
-						    &reg, sizeof(reg));
+		int err = snd_motu_transaction_read(motu, V2_IN_OUT_CONF_OFFSET, &reg, sizeof(reg));
 		if (err < 0)
 			return err;
 
-		if (be32_to_cpu(reg) & 0x00000200)
+		if (((data & V2_OPT_IN_IFACE_MASK) >> V2_OPT_IN_IFACE_SHIFT) == V2_OPT_IFACE_MODE_SPDIF)
 			*src = SND_MOTU_CLOCK_SOURCE_SPDIF_ON_OPT;
 		else
-			*src = SND_MOTU_CLOCK_SOURCE_ADAT_ON_OPT;
+			*src = SND_MOTU_CLOCK_SOURCE_SPDIF_ON_COAX;
 		break;
 	}
-	case 2:
-		*src = SND_MOTU_CLOCK_SOURCE_SPDIF_ON_COAX;
-		break;
 	case 3:
 		*src = SND_MOTU_CLOCK_SOURCE_SPH;
 		break;
-- 
2.30.2

