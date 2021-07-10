Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78BF33C30CA
	for <lists+stable@lfdr.de>; Sat, 10 Jul 2021 04:48:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234496AbhGJCg4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 22:36:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:53380 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234124AbhGJCfe (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 22:35:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ABC48613E4;
        Sat, 10 Jul 2021 02:32:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625884354;
        bh=U3XyAJ4TRtQBnQOuHtoGHvzGvSgBkJEg6w1xIsCvSHU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZLf2yHXO3+AeNx+z0Vjta93t+r14m659XYX4XWPuqjjvOUSqicZe7FRZ3kTAGaBF8
         +8wxVbtL42au3Xge/P487XL/OBocn2SSK2RoJitJFeJXxKekeVj03qUkpTlcWw9XOl
         Hx0s1A4002AwlqhXRaqutbGlOeGoUJrZtAM2olLAoE2kDGeYMHN4MqP2jqeNwUmkmm
         bAgh4AuPhsUf8py7yLaH8JvAaDPl98f043aNbj6w7hloTNqAByl5JA10af1dtAMssd
         BDZWDIj1NEf5LtdRPHUkM1cGFbdTl/7+iEFY3g14IP1V3LYanRACozRBCYjyjFqj/9
         K9CA5gfNsL+LA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yang Yingliang <yangyingliang@huawei.com>,
        Hulk Robot <hulkci@huawei.com>, Takashi Iwai <tiwai@suse.de>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org,
        linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 4.19 24/39] ALSA: ppc: fix error return code in snd_pmac_probe()
Date:   Fri,  9 Jul 2021 22:31:49 -0400
Message-Id: <20210710023204.3171428-24-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710023204.3171428-1-sashal@kernel.org>
References: <20210710023204.3171428-1-sashal@kernel.org>
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
index 33c6be9fb388..7c70ba5e2540 100644
--- a/sound/ppc/powermac.c
+++ b/sound/ppc/powermac.c
@@ -90,7 +90,11 @@ static int snd_pmac_probe(struct platform_device *devptr)
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

