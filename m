Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36DDB3C30A5
	for <lists+stable@lfdr.de>; Sat, 10 Jul 2021 04:47:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235191AbhGJCgB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 22:36:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:53382 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235707AbhGJCfA (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 22:35:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 39FFF613D3;
        Sat, 10 Jul 2021 02:32:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625884335;
        bh=AoD/7CWDXvR+9ak/sKEZmG77jR/GQC1p+n/HlENlaC4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O/SFGDVeo/SsBOA3ZyAK2JfixOFQSDo5mW1uZCreJA9u9MhlnTgoQotO31F/YD6si
         gR4esTJS4zc2pTG89P7MwAvwCq7c6LErGLDKm9GsTj+jZW34ErosGfpCw1t3szb5bZ
         wgoKUqZSc2LSwjVJTSfaZ3DI+hluPPeaoFTddem7jZjmn/+zdjpcVkLL6L8L9RjYGQ
         e3tblEAeDDxG01L5vkcl/x5Pg0fx3zB2cmZRAk/gYKKy/izhu2HvgbQc0IvEmVOq8t
         OsCsE+WbR9dwgx9RIi02amp0SmEH55LXDLKJzbfu7LP1v+EYYLLNifXWppSn74nyrV
         T1zn1ifARlQEA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yufen Yu <yuyufen@huawei.com>, Hulk Robot <hulkci@huawei.com>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>,
        alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 4.19 09/39] ALSA: ac97: fix PM reference leak in ac97_bus_remove()
Date:   Fri,  9 Jul 2021 22:31:34 -0400
Message-Id: <20210710023204.3171428-9-sashal@kernel.org>
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

From: Yufen Yu <yuyufen@huawei.com>

[ Upstream commit a38e93302ee25b2ca6f4ee76c6c974cf3637985e ]

pm_runtime_get_sync will increment pm usage counter even it failed.
Forgetting to putting operation will result in reference leak here.
Fix it by replacing it with pm_runtime_resume_and_get to keep usage
counter balanced.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Yufen Yu <yuyufen@huawei.com>
Link: https://lore.kernel.org/r/20210524093811.612302-1-yuyufen@huawei.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/ac97/bus.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/ac97/bus.c b/sound/ac97/bus.c
index ca50ff444796..d8b227e6d4cf 100644
--- a/sound/ac97/bus.c
+++ b/sound/ac97/bus.c
@@ -523,7 +523,7 @@ static int ac97_bus_remove(struct device *dev)
 	struct ac97_codec_driver *adrv = to_ac97_driver(dev->driver);
 	int ret;
 
-	ret = pm_runtime_get_sync(dev);
+	ret = pm_runtime_resume_and_get(dev);
 	if (ret < 0)
 		return ret;
 
-- 
2.30.2

