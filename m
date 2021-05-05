Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F1EE37402A
	for <lists+stable@lfdr.de>; Wed,  5 May 2021 18:34:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234247AbhEEQdC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 May 2021 12:33:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:52900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234258AbhEEQcs (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 May 2021 12:32:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 677E9613FC;
        Wed,  5 May 2021 16:31:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620232312;
        bh=wioNhMzppS8WG30UBK94WGWL04I2LjgQaWPOFepXexs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GuBZdFODxbW00PutKra5iLQw19cT0u8x+MrfQbltccBtntAohxkzuTq/xbrr6L8te
         DnrnIV+n0mJd8P/bobmtjRKvEjnzYcZtc8tCtQ4WsA5Z6xKaeAMWsv8lsRpNlB+Q2j
         SXItCuQRaC5hWTyQRw5XpQj/fwEZPCUuAHV/shKH0B/uF8GekkzPDNELFVNZe1vL2f
         WNK35Dwl5mfzyQEEkD2rUccGqxZpkbBZUGrHw98R/I7LYYcV0owRU/xib529KYtm7b
         Xhlhloq5sj8VMweaWeKOe4IB0de25NeWaynxeQ3zjc+xu/q/guQN65lmcMkTzpOell
         +UBeQmaav3VcA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tong Zhang <ztong0001@gmail.com>, Takashi Iwai <tiwai@suse.de>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.12 020/116] ALSA: hdspm: don't disable if not enabled
Date:   Wed,  5 May 2021 12:29:48 -0400
Message-Id: <20210505163125.3460440-20-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210505163125.3460440-1-sashal@kernel.org>
References: <20210505163125.3460440-1-sashal@kernel.org>
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
index 8d900c132f0f..97a0bff96b28 100644
--- a/sound/pci/rme9652/hdspm.c
+++ b/sound/pci/rme9652/hdspm.c
@@ -6883,7 +6883,8 @@ static int snd_hdspm_free(struct hdspm * hdspm)
 	if (hdspm->port)
 		pci_release_regions(hdspm->pci);
 
-	pci_disable_device(hdspm->pci);
+	if (pci_is_enabled(hdspm->pci))
+		pci_disable_device(hdspm->pci);
 	return 0;
 }
 
-- 
2.30.2

