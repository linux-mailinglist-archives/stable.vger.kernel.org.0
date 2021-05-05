Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BC743743A9
	for <lists+stable@lfdr.de>; Wed,  5 May 2021 19:46:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234114AbhEEQv0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 May 2021 12:51:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:49544 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236302AbhEEQsv (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 May 2021 12:48:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 240D261955;
        Wed,  5 May 2021 16:37:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620232631;
        bh=jGtQgUn2vNkge3mKKjDUjWarxCTlm5TBwooV62SAl/E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WYXkOqcsr91tGq16UMQ6HQmWe+bXKA2k0T8zhP7qnanIwc6p6JT8XemuJJqvlyBIE
         nJgRaM10iwQGFiBx4GOd6YNqb60gzH+at4/PvQp07D0RG0qy8Y9mGr7a3VXDfETFHF
         RYFYmNKT20lJiifrqqaYsIpp/8ZvZhtN7lQqjb6JViJ/OQ0BRGln4GDXej079fLPUs
         3ym8RdfLIgpZlvBqZj8WoHhsoa2rvqfoOH0pV5lDbHalnwLa3t3ciFrc6YopuwOJ3Q
         +Y0hI+JwihCKzoYPYLgKd9QBQTD2ct7lqKTvrdesW8/pEnTP1cTM+qXPDyCpvVoL7v
         8Ib7F2PGtmUgw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tong Zhang <ztong0001@gmail.com>, Takashi Iwai <tiwai@suse.de>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.10 16/85] ALSA: rme9652: don't disable if not enabled
Date:   Wed,  5 May 2021 12:35:39 -0400
Message-Id: <20210505163648.3462507-16-sashal@kernel.org>
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
index 7ab10028d9fa..8def24673f35 100644
--- a/sound/pci/rme9652/rme9652.c
+++ b/sound/pci/rme9652/rme9652.c
@@ -1740,7 +1740,8 @@ static int snd_rme9652_free(struct snd_rme9652 *rme9652)
 	if (rme9652->port)
 		pci_release_regions(rme9652->pci);
 
-	pci_disable_device(rme9652->pci);
+	if (pci_is_enabled(rme9652->pci))
+		pci_disable_device(rme9652->pci);
 	return 0;
 }
 
-- 
2.30.2

