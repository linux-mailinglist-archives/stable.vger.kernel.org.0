Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 198483C2D70
	for <lists+stable@lfdr.de>; Sat, 10 Jul 2021 04:20:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233089AbhGJCWq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 22:22:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:38804 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232589AbhGJCWT (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 22:22:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C9BF4613B7;
        Sat, 10 Jul 2021 02:19:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625883569;
        bh=H65BQimBAwbH5n7kbcYzCOuiT8nnBa5h2f5AOhcpIMw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N5fKqCtBoSv2maue9+0qlOgqnMvetaBeAaGBJr5bWneS34KfwzlhqHZq1m6ApXHOe
         7+IWHjKvXkzvSpvrP+PSeEgCFloc8tFPH9Z7VLuQB/01RWNoSRp4mlWNYYX0Mek5BG
         23Bpw41AVM58SzfMOhxhsnSXybISMEO91C2Ybd4T6xq9pzh0PiTobGU+At4JD1I8GH
         EoW4m0v2q0LR9Psv8wvsMlytfb8kxNO9xsm/HuxZgq72zx9ds9IOcqBJZ4+S97ah5G
         vJmc3f6xkZWmnLL25ceX0eHeNhKtXQ2nf0dUEVRldA46umOwRNf86TLLu/+RpbRSeO
         bVQMw/WTt5NLw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yang Yingliang <yangyingliang@huawei.com>,
        Hulk Robot <hulkci@huawei.com>, Takashi Iwai <tiwai@suse.de>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org,
        linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 5.13 075/114] ALSA: ppc: fix error return code in snd_pmac_probe()
Date:   Fri,  9 Jul 2021 22:17:09 -0400
Message-Id: <20210710021748.3167666-75-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710021748.3167666-1-sashal@kernel.org>
References: <20210710021748.3167666-1-sashal@kernel.org>
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

