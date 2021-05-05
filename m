Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B523D3743AA
	for <lists+stable@lfdr.de>; Wed,  5 May 2021 19:46:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235400AbhEEQv0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 May 2021 12:51:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:49510 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235945AbhEEQsq (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 May 2021 12:48:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D459761958;
        Wed,  5 May 2021 16:37:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620232630;
        bh=osxeUbBdYlxAMFzDHWxn+ZyfynLoHDigqa0Nh2hjomc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BydM3jT3LEtLHzIlGOcbHZGrpRf82U82e/AwU/lDSTrVBEtiqFpmuPscV3/OqVHfr
         7V9VdZBS4OJckANIevzIrVYlWaT1hJDM8eDmTh6eL2sXJXFesqVut/VyN/1b4JcH5p
         6yvwZxKtl074KPQA2xnIRAS0uOOzDSx/FIgw1csHs+oEaBjm23G04iUuLYPYl3WvUE
         YUNaZT3IsI2BYSC3WgUbUs0gx1uo4GAZGg7lHWeMbC752TaJTzpeqyFGdrppln2Zcu
         3qlYd+GWh3Usu/Fal6E3Yx9f0qlUI09okjbaT8mbW0SrT3axkbKg8U0RE+Oyam0y5x
         QYKRfWjk3gWdQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tong Zhang <ztong0001@gmail.com>, Takashi Iwai <tiwai@suse.de>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.10 15/85] ALSA: hdspm: don't disable if not enabled
Date:   Wed,  5 May 2021 12:35:38 -0400
Message-Id: <20210505163648.3462507-15-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210505163648.3462507-1-sashal@kernel.org>
References: <20210505163648.3462507-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tong Zhang <ztong0001@gmail.com>

[ Upstream commit 790f5719b85e12e10c41753b864e74249585ed08 ]

hdspm wants to disable a not enabled pci device, which makes kernel
throw a warning. Make sure the device is enabled before calling disable.

[    1.786391] snd_hdspm 0000:00:03.0: disabling already-disabled device
[    1.786400] WARNING: CPU: 0 PID: 182 at drivers/pci/pci.c:2146 pci_disable_device+0x91/0xb0
[    1.795181] Call Trace:
[    1.795320]  snd_hdspm_card_free+0x58/0xa0 [snd_hdspm]
[    1.795595]  release_card_device+0x4b/0x80 [snd]
[    1.795860]  device_release+0x3b/0xa0
[    1.796072]  kobject_put+0x94/0x1b0
[    1.796260]  put_device+0x13/0x20
[    1.796438]  snd_card_free+0x61/0x90 [snd]
[    1.796659]  snd_hdspm_probe+0x97b/0x1440 [snd_hdspm]

Suggested-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Tong Zhang <ztong0001@gmail.com>
Link: https://lore.kernel.org/r/20210321153840.378226-3-ztong0001@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/rme9652/hdspm.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/sound/pci/rme9652/hdspm.c b/sound/pci/rme9652/hdspm.c
index 4a1f576dd9cf..51c3c6a08a1c 100644
--- a/sound/pci/rme9652/hdspm.c
+++ b/sound/pci/rme9652/hdspm.c
@@ -6891,7 +6891,8 @@ static int snd_hdspm_free(struct hdspm * hdspm)
 	if (hdspm->port)
 		pci_release_regions(hdspm->pci);
 
-	pci_disable_device(hdspm->pci);
+	if (pci_is_enabled(hdspm->pci))
+		pci_disable_device(hdspm->pci);
 	return 0;
 }
 
-- 
2.30.2

