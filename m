Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A09243C2E57
	for <lists+stable@lfdr.de>; Sat, 10 Jul 2021 04:27:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233141AbhGJC0z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 22:26:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:41746 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232785AbhGJC0Y (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 22:26:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0F62D613D6;
        Sat, 10 Jul 2021 02:23:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625883804;
        bh=H65BQimBAwbH5n7kbcYzCOuiT8nnBa5h2f5AOhcpIMw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RQlozIujoDD1Q/+9t6qErabHd1cZ2AkgfqZIlITX3FOgi0xxi1MR924p6zvpTlwBy
         SN5BpU89vcapoQzXoKbDYTxOVNKbaUFfjwKPLV4+FB3oXSO8BjhDEN8laHcNPQluSh
         rX/7r6cEa/CawR1Mf33W0iaKqHDPF4s0LCmvIui0SZ8sJFpkHDhu4ADaBMZTA9S3hk
         tqL4UNSeGBTasbWG4TW/fufR8G5FSMOgHRjZUET5EPOjM9xJgjb+rvHCrt38388Z98
         TwaogTeIgriobPuUg0O3QORAEnj/IPH1o0flL+1zvs3x7Q/Y1T1T2h5WI6G1F3hKxM
         j/cAxWe853+KQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yang Yingliang <yangyingliang@huawei.com>,
        Hulk Robot <hulkci@huawei.com>, Takashi Iwai <tiwai@suse.de>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org,
        linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 5.12 067/104] ALSA: ppc: fix error return code in snd_pmac_probe()
Date:   Fri,  9 Jul 2021 22:21:19 -0400
Message-Id: <20210710022156.3168825-67-sashal@kernel.org>
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

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit 80b9c1be567c3c6bbe0d4b290af578e630485b5d ]

If snd_pmac_tumbler_init() or snd_pmac_tumbler_post_init() fails,
snd_pmac_probe() need return error code.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Link: https://lore.kernel.org/r/20210616021121.1991502-1-yangyingliang@huawei.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/ppc/powermac.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/sound/ppc/powermac.c b/sound/ppc/powermac.c
index 9fb51ebafde1..8088f77d5a74 100644
--- a/sound/ppc/powermac.c
+++ b/sound/ppc/powermac.c
@@ -76,7 +76,11 @@ static int snd_pmac_probe(struct platform_device *devptr)
 		sprintf(card->shortname, "PowerMac %s", name_ext);
 		sprintf(card->longname, "%s (Dev %d) Sub-frame %d",
 			card->shortname, chip->device_id, chip->subframe);
-		if ( snd_pmac_tumbler_init(chip) < 0 || snd_pmac_tumbler_post_init() < 0)
+		err = snd_pmac_tumbler_init(chip);
+		if (err < 0)
+			goto __error;
+		err = snd_pmac_tumbler_post_init();
+		if (err < 0)
 			goto __error;
 		break;
 	case PMAC_AWACS:
-- 
2.30.2

