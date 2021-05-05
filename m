Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CADB374233
	for <lists+stable@lfdr.de>; Wed,  5 May 2021 18:47:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234993AbhEEQqE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 May 2021 12:46:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:38090 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235447AbhEEQlw (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 May 2021 12:41:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 77D0F616EA;
        Wed,  5 May 2021 16:34:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620232483;
        bh=xiLMgV3JWHy1zcRe+lLh2fP2RJ6mVRo6FGGHrg0eZgg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W7yq9hF46biCjOVAwSQhrakjJ2vCQ8FqOzQfrpL9Yfy6b69z3YfdWRLuUvUzPtAYf
         SK7Lf2Vluw1ie8e1u2aMZoCChPCuZfz8TuBCS337IPTgaCp62ppmiyQt6AwwyzcRgL
         mv8jw+anHHhTKnkP0N+ktS6Y3Rys3Novmv/KurwlMA7HkioyBV7YU1zJSwF6sc9Vft
         SW/3tZjsJWT7CDmjkWNCh/FrPrG1YVwOwKfUf2xASW0PmBlI+WRbcIziXcq5ll0mmK
         lAhLDI+F4c6oTUla5sNicNvTnunTNfZDFDEuljFdPMlbfSTrXG7dd9SJzM3iOGV1YN
         CCdiq1Pn1vDjg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tong Zhang <ztong0001@gmail.com>, Takashi Iwai <tiwai@suse.de>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.11 021/104] ALSA: rme9652: don't disable if not enabled
Date:   Wed,  5 May 2021 12:32:50 -0400
Message-Id: <20210505163413.3461611-21-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210505163413.3461611-1-sashal@kernel.org>
References: <20210505163413.3461611-1-sashal@kernel.org>
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
index 012fbec5e6a7..0f4ab86a29f6 100644
--- a/sound/pci/rme9652/rme9652.c
+++ b/sound/pci/rme9652/rme9652.c
@@ -1733,7 +1733,8 @@ static int snd_rme9652_free(struct snd_rme9652 *rme9652)
 	if (rme9652->port)
 		pci_release_regions(rme9652->pci);
 
-	pci_disable_device(rme9652->pci);
+	if (pci_is_enabled(rme9652->pci))
+		pci_disable_device(rme9652->pci);
 	return 0;
 }
 
-- 
2.30.2

