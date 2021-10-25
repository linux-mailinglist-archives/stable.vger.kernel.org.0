Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD528439C66
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 19:01:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234334AbhJYRDL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 13:03:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:55354 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234346AbhJYRCs (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 13:02:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BDB1260FE8;
        Mon, 25 Oct 2021 17:00:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635181225;
        bh=3ZBUCgv8vwftNjRmDQRSK/5b+G6e6GPnvXqg+8+Ek0I=;
        h=From:To:Cc:Subject:Date:From;
        b=gvAwim3ERrHtLsrG8eN4QeVlPtsAE44rYZFR/s1RyjS0TFH4rktCcWcrmFTaxGwk8
         b9wxtJAi8wn0dKuPJBXx4BKxsNc20XTNebddvC32hqxYf5HHg3NI4Z9tuxAs/yd1bg
         2jX/JbP8ywsKjA9qMJalVPCV5VHlh8uwO2p+DZLjocqxkJ0hu6aLZ2Mr+vahDjTU+m
         O8m1eN/U+tRFvzLYXhW3VJrRfzni9J3D8N+3KUSv/c1cUc4fvl9+F9Sr730/8l1FW4
         Dxr7p1Hq3whuZThI/1DGWBQvP2Tx+QLuYcDAEFLMSr8OGG4z17Z+oxNokw+WUgW3AA
         ZLgOcd6EXeJ9A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yang Yingliang <yangyingliang@huawei.com>,
        Hulk Robot <hulkci@huawei.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, lgirdwood@gmail.com,
        perex@perex.cz, tiwai@suse.com, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.10 01/13] ASoC: soc-core: fix null-ptr-deref in snd_soc_del_component_unlocked()
Date:   Mon, 25 Oct 2021 13:00:10 -0400
Message-Id: <20211025170023.1394358-1-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit c448b7aa3e66042fc0f849d9a0fb90d1af82e948 ]

'component' is allocated in snd_soc_register_component(), but component->list
is not initalized, this may cause snd_soc_del_component_unlocked() deref null
ptr in the error handing case.

KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
RIP: 0010:__list_del_entry_valid+0x81/0xf0
Call Trace:
 snd_soc_del_component_unlocked+0x69/0x1b0 [snd_soc_core]
 snd_soc_add_component.cold+0x54/0x6c [snd_soc_core]
 snd_soc_register_component+0x70/0x90 [snd_soc_core]
 devm_snd_soc_register_component+0x5e/0xd0 [snd_soc_core]
 tas2552_probe+0x265/0x320 [snd_soc_tas2552]
 ? tas2552_component_probe+0x1e0/0x1e0 [snd_soc_tas2552]
 i2c_device_probe+0xa31/0xbe0

Fix by adding INIT_LIST_HEAD() to snd_soc_component_initialize().

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Link: https://lore.kernel.org/r/20211009065840.3196239-1-yangyingliang@huawei.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/soc-core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/soc-core.c b/sound/soc/soc-core.c
index e677422c1058..133296596864 100644
--- a/sound/soc/soc-core.c
+++ b/sound/soc/soc-core.c
@@ -2454,6 +2454,7 @@ int snd_soc_component_initialize(struct snd_soc_component *component,
 	INIT_LIST_HEAD(&component->dai_list);
 	INIT_LIST_HEAD(&component->dobj_list);
 	INIT_LIST_HEAD(&component->card_list);
+	INIT_LIST_HEAD(&component->list);
 	mutex_init(&component->io_mutex);
 
 	component->name = fmt_single_name(dev, &component->id);
-- 
2.33.0

