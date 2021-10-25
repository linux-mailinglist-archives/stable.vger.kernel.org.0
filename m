Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E08FA439C37
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 18:59:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234157AbhJYRCG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 13:02:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:54376 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234151AbhJYRCG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 13:02:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 88B1860F70;
        Mon, 25 Oct 2021 16:59:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635181183;
        bh=kbEddWIL1NYrAVEh/1ugolyuuvy2YQFqSBjvGQyrqPU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bf0wBVheounyFy4nK+AZYdhQhF0UEXhXwPlxQMP7x+tSFB5+7YicujbuUNNncMTNZ
         VqJaMte8cOAcJWcGQVFmto0KECWvPyBChCFfwtI4hey6xIXVBRwbB34JeiKCrNb71o
         /VWg1/9L38T2OLMg2QagLBxHFIo6MbU3giFzjp0SdUhuDx86E1z/gFRW/BdHMVs034
         I/edG9xmgMD1o1EzC0hrG4aB23HKRgTVpEi5uDoS7I5dgj71y0lqpRfGb6Jj+9h+hI
         Y7pKr+Zwjb5y7iCAQRrjs/9CW/J2yjIIzAkK6Zk5UeZYpd4FP/3CzYA6cR684DEkDK
         ZIaXs9uDFQ41w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yang Yingliang <yangyingliang@huawei.com>,
        Hulk Robot <hulkci@huawei.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, lgirdwood@gmail.com,
        perex@perex.cz, tiwai@suse.com, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.14 02/18] ASoC: soc-core: fix null-ptr-deref in snd_soc_del_component_unlocked()
Date:   Mon, 25 Oct 2021 12:59:15 -0400
Message-Id: <20211025165939.1393655-2-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211025165939.1393655-1-sashal@kernel.org>
References: <20211025165939.1393655-1-sashal@kernel.org>
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
index 583f2381cfc8..e926985bb2f8 100644
--- a/sound/soc/soc-core.c
+++ b/sound/soc/soc-core.c
@@ -2599,6 +2599,7 @@ int snd_soc_component_initialize(struct snd_soc_component *component,
 	INIT_LIST_HEAD(&component->dai_list);
 	INIT_LIST_HEAD(&component->dobj_list);
 	INIT_LIST_HEAD(&component->card_list);
+	INIT_LIST_HEAD(&component->list);
 	mutex_init(&component->io_mutex);
 
 	component->name = fmt_single_name(dev, &component->id);
-- 
2.33.0

