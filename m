Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D2AB374498
	for <lists+stable@lfdr.de>; Wed,  5 May 2021 19:48:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235245AbhEEQ6f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 May 2021 12:58:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:47626 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235914AbhEEQ4f (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 May 2021 12:56:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DCB2261435;
        Wed,  5 May 2021 16:39:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620232749;
        bh=mftLdTNfiVHfpoenSsW8WngsR+Rnld+I/UEzJR8VRkE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZiuDqmNSKE9VhxsIEYOhFRtCdNNLIsst8XLitLqgVV3RpfZJm+gqFOMePUq5MtSyg
         CPSjtB9BiB3b6egpH/UjPv/T3eGYUAggA+wh2otg3xQRu+Pn8cFYA2tfsfCYWM6Pii
         CUIzP7jVX9vjVZWNCmZ546QiF49hnv+g8NywWUZ7g6d83X1hR5HKAoin+hbO3Yk2TR
         aFIRg10311Pe/U6yrvO0eENhzV5+GqywJbZe2GuRXZmq33XPRQS9iJnd9hTLSrKMnV
         KeMM3lGRddcAOu5Jyo4DlY7bs2jiPW8YiMnWexrZ0MNSRzaaf6sJWIHFU67I4wrZj9
         fcS/j0EsSqQDg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tong Zhang <ztong0001@gmail.com>, Takashi Iwai <tiwai@suse.de>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.4 09/46] ALSA: rme9652: don't disable if not enabled
Date:   Wed,  5 May 2021 12:38:19 -0400
Message-Id: <20210505163856.3463279-9-sashal@kernel.org>
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

[ Upstream commit f57a741874bb6995089020e97a1dcdf9b165dcbe ]

rme9652 wants to disable a not enabled pci device, which makes kernel
throw a warning. Make sure the device is enabled before calling disable.

[    1.751595] snd_rme9652 0000:00:03.0: disabling already-disabled device
[    1.751605] WARNING: CPU: 0 PID: 174 at drivers/pci/pci.c:2146 pci_disable_device+0x91/0xb0
[    1.759968] Call Trace:
[    1.760145]  snd_rme9652_card_free+0x76/0xa0 [snd_rme9652]
[    1.760434]  release_card_device+0x4b/0x80 [snd]
[    1.760679]  device_release+0x3b/0xa0
[    1.760874]  kobject_put+0x94/0x1b0
[    1.761059]  put_device+0x13/0x20
[    1.761235]  snd_card_free+0x61/0x90 [snd]
[    1.761454]  snd_rme9652_probe+0x3be/0x700 [snd_rme9652]

Suggested-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Tong Zhang <ztong0001@gmail.com>
Link: https://lore.kernel.org/r/20210321153840.378226-4-ztong0001@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/rme9652/rme9652.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/sound/pci/rme9652/rme9652.c b/sound/pci/rme9652/rme9652.c
index 4c851f8dcaf8..73ad6e74aac9 100644
--- a/sound/pci/rme9652/rme9652.c
+++ b/sound/pci/rme9652/rme9652.c
@@ -1745,7 +1745,8 @@ static int snd_rme9652_free(struct snd_rme9652 *rme9652)
 	if (rme9652->port)
 		pci_release_regions(rme9652->pci);
 
-	pci_disable_device(rme9652->pci);
+	if (pci_is_enabled(rme9652->pci))
+		pci_disable_device(rme9652->pci);
 	return 0;
 }
 
-- 
2.30.2

