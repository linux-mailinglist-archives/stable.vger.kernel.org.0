Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 172602FC7D9
	for <lists+stable@lfdr.de>; Wed, 20 Jan 2021 03:29:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727392AbhATC2C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jan 2021 21:28:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:46136 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726588AbhATB0s (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Jan 2021 20:26:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 231592312D;
        Wed, 20 Jan 2021 01:26:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611105967;
        bh=zf06WvKE26zV5ow8VlxcqUjx0V17nDRZjEQZpv7wDKA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g+K6tIkcOuUT2H3Q8bi8+0E7Gnr6eid0G3GU9XNm+XS/6R1K10julL2sBtvSDnOcs
         FUU9V9ERptDk7Kqa5pSF5fgpIVd97CVdSRU5pGQpZh6cKtA8QvTqpv/+Dpyx0KyOQq
         RURSxwKZ/8IefjKhqYWx3dFzIJMUpIm+ZgKPJlzmc+LuZj/5pMIJGmjNNi2Z5dQan8
         OsvD88XalDaeNTDNMcOEZlCKzYZUnT+FTAUuighHUFf71Ss2FPln1cua3HdBnCKsns
         LH7dAZyBhIyaAQYlWaKvSa3jicGuN64xClhRiRq3Z1bfelUdc9YJ5TnHw54r4VcCeQ
         Gn1ODgipgr5Sw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jaroslav Kysela <perex@perex.cz>,
        Eliot Blennerhassett <eliot@blennerhassett.gen.nz>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.10 04/45] ASoC: AMD Renoir - add DMI entry for Lenovo ThinkPad E14 Gen 2
Date:   Tue, 19 Jan 2021 20:25:21 -0500
Message-Id: <20210120012602.769683-4-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210120012602.769683-1-sashal@kernel.org>
References: <20210120012602.769683-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jaroslav Kysela <perex@perex.cz>

[ Upstream commit 275565997ade6fc32be9cd49a910ba996bcb4797 ]

The ThinkPad E14 Gen 2 latop does not have the internal digital
microphone connected to the AMD's ACP bridge, but it's advertised
via BIOS. The internal microphone is connected to the HDA codec.

Use DMI to block the microphone PCM device for this platform.

Reported-by: Eliot Blennerhassett <eliot@blennerhassett.gen.nz>
Signed-off-by: Jaroslav Kysela <perex@perex.cz>
Link: https://lore.kernel.org/r/20201227164037.269893-1-perex@perex.cz
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/renoir/rn-pci-acp3x.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/sound/soc/amd/renoir/rn-pci-acp3x.c b/sound/soc/amd/renoir/rn-pci-acp3x.c
index 338b78c514ec9..c006fec7ef351 100644
--- a/sound/soc/amd/renoir/rn-pci-acp3x.c
+++ b/sound/soc/amd/renoir/rn-pci-acp3x.c
@@ -171,6 +171,13 @@ static const struct dmi_system_id rn_acp_quirk_table[] = {
 			DMI_EXACT_MATCH(DMI_BOARD_NAME, "LNVNB161216"),
 		}
 	},
+	{
+		/* Lenovo ThinkPad E14 Gen 2 */
+		.matches = {
+			DMI_EXACT_MATCH(DMI_BOARD_VENDOR, "LENOVO"),
+			DMI_EXACT_MATCH(DMI_BOARD_NAME, "20T6CTO1WW"),
+		}
+	},
 	{}
 };
 
-- 
2.27.0

