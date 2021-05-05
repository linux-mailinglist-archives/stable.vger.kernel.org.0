Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 523F73744A3
	for <lists+stable@lfdr.de>; Wed,  5 May 2021 19:48:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236401AbhEEQ6w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 May 2021 12:58:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:46988 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237062AbhEEQ4V (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 May 2021 12:56:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 97DB2614A7;
        Wed,  5 May 2021 16:39:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620232748;
        bh=itsFaItEQgusV1deU/5OCuBOnGoXV0pjO8IfRlcyiUc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D7H1GwSkNFcpaiBxZGOdWbX5LZvws1j+kglbBIgqO7lrmb0Se3KpAzbjQpXOZqOcu
         XRI70+FPN9KMUPIRUIyX8LcljxcjJ0bXcRY1hts1K6fTd5p2kahGosqt9bOPeL15K5
         ukyLsSbWEH1RKha866GJlE1edxguhjr2v2L61k6DIpsCflc0hDoPyTb/mcNAh/Hcj8
         GHKJwfbCxYcJW1w6ImAiGbcSK5Mg7DU5rQs3LGS3EYKX1XjyAMTyrzgqz9odtiCF8S
         WSzIlhpKuPEapv2KFF9uZR3CFe2/gP86XY/oFo4yKXIlqrTi0Sg/HGK8gsx8Wj+MSJ
         MwTHotqx2RgUA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tong Zhang <ztong0001@gmail.com>, Takashi Iwai <tiwai@suse.de>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.4 08/46] ALSA: hdspm: don't disable if not enabled
Date:   Wed,  5 May 2021 12:38:18 -0400
Message-Id: <20210505163856.3463279-8-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210505163856.3463279-1-sashal@kernel.org>
References: <20210505163856.3463279-1-sashal@kernel.org>
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
index 81a6f4b2bd3c..e34f07c9ff47 100644
--- a/sound/pci/rme9652/hdspm.c
+++ b/sound/pci/rme9652/hdspm.c
@@ -6889,7 +6889,8 @@ static int snd_hdspm_free(struct hdspm * hdspm)
 	if (hdspm->port)
 		pci_release_regions(hdspm->pci);
 
-	pci_disable_device(hdspm->pci);
+	if (pci_is_enabled(hdspm->pci))
+		pci_disable_device(hdspm->pci);
 	return 0;
 }
 
-- 
2.30.2

