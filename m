Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF0BB37454C
	for <lists+stable@lfdr.de>; Wed,  5 May 2021 19:50:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238013AbhEEREh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 May 2021 13:04:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:60728 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237924AbhEERBk (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 May 2021 13:01:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D2E5C61C19;
        Wed,  5 May 2021 16:40:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620232859;
        bh=2yVv66ORtp3I0H7NgUJ9D7pHsQDEf/7FRXuB7kH07dI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CzRv6y2H+igxkTIMW3VuKDDxAPE1IfUXvXwSAajznmKOhhoAue+EA9ilHGAQB3Z2m
         bavjaXxahPuZNIDH28/ZVX1bvDdx3N8LWGmi+oANZ/CB9VDPygu/T40ThImYUSQC6X
         F8v09tJ4LcF0mQSPzboDT/5/rVk/hYjtDQqTxmU1/F+8Gt1LchRspKRw7+d9Voj5JY
         vrrF83gqzpG78R6DLjTC7s3IIPTrhD97e2uDrZ+BJCXbj5OYPRs0PmLRAQg6skCVmH
         TP6F2EZLbi5Bpm0+DoS1Uxx7LNvRHhuw3lsYxV5zLxxto8RK9wAimMAnabsJANKfNS
         NEGYgXxpWgcLw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tong Zhang <ztong0001@gmail.com>, Takashi Iwai <tiwai@suse.de>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 4.14 05/25] ALSA: hdspm: don't disable if not enabled
Date:   Wed,  5 May 2021 12:40:31 -0400
Message-Id: <20210505164051.3464020-5-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210505164051.3464020-1-sashal@kernel.org>
References: <20210505164051.3464020-1-sashal@kernel.org>
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
index 343f533906ba..5bbbbba0817b 100644
--- a/sound/pci/rme9652/hdspm.c
+++ b/sound/pci/rme9652/hdspm.c
@@ -6913,7 +6913,8 @@ static int snd_hdspm_free(struct hdspm * hdspm)
 	if (hdspm->port)
 		pci_release_regions(hdspm->pci);
 
-	pci_disable_device(hdspm->pci);
+	if (pci_is_enabled(hdspm->pci))
+		pci_disable_device(hdspm->pci);
 	return 0;
 }
 
-- 
2.30.2

