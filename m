Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD01C374522
	for <lists+stable@lfdr.de>; Wed,  5 May 2021 19:49:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237139AbhEEREB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 May 2021 13:04:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:60302 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237669AbhEERA4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 May 2021 13:00:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 785DC61585;
        Wed,  5 May 2021 16:40:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620232816;
        bh=BKZByb+bMQrTyrLgjdFq3/qR+nFiiFhVqTM4UmzAeCc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MIot8mQ+A33rI2r5qDd9Iaq8et4pPiMrtbRXsVUCHQdlU/j5vIP2xpR/Li3wEf7Wu
         WRoAQ5oZM4F/2+/iLtw1zYAPptJ2dxTE7hlcUqg1ezqsGkH7jx1hsjemlmZRs5ntVd
         oTENWVY0drHaPfF3RgJdXVda1zIUwDztypavw5SINYjXBn91MoNcv3OuLiX6Kooi17
         BM5zyQ57tl0mBuZb+hfRMs6jTEoEVyxhHHjm5cmcdxIBxpRphio9hdTlHLrfys0gJ+
         BQSUoe9JterQtJ+hLcrtxeN8PkhJjPzN/hUD5eIACLAcZNl5ed33LBssIEA5o+5x8c
         QtahPqWeT+rXQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tong Zhang <ztong0001@gmail.com>, Takashi Iwai <tiwai@suse.de>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 4.19 08/32] ALSA: rme9652: don't disable if not enabled
Date:   Wed,  5 May 2021 12:39:40 -0400
Message-Id: <20210505164004.3463707-8-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210505164004.3463707-1-sashal@kernel.org>
References: <20210505164004.3463707-1-sashal@kernel.org>
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
index edd765e22377..f82fa5be7d33 100644
--- a/sound/pci/rme9652/rme9652.c
+++ b/sound/pci/rme9652/rme9652.c
@@ -1761,7 +1761,8 @@ static int snd_rme9652_free(struct snd_rme9652 *rme9652)
 	if (rme9652->port)
 		pci_release_regions(rme9652->pci);
 
-	pci_disable_device(rme9652->pci);
+	if (pci_is_enabled(rme9652->pci))
+		pci_disable_device(rme9652->pci);
 	return 0;
 }
 
-- 
2.30.2

