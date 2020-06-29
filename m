Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE7EF20E709
	for <lists+stable@lfdr.de>; Tue, 30 Jun 2020 00:10:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730265AbgF2VxL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 17:53:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:56910 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726617AbgF2Sfj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 14:35:39 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 35EA2246CD;
        Mon, 29 Jun 2020 15:20:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593444019;
        bh=+E0bitveH20osE1qAh7Cun30LPerQPCMAvFAgZcslfA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XtQZU/Elr104a8VI7ZdOU0+Wzl1T6ISwXkQFRWJE6+tuGZDeXGVEPEHDW8JQvQJjz
         ZlHuvwZ3F0qIJZnnVDTXgZomEUB78iP6KrA2eLBzRks6BG9DiJbeWqCmALi8MMUJH5
         qWI4qkotAn3gjcSynB40FLAxwOr8BeXbVSsY+wGE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Charles Keepax <ckeepax@opensource.cirrus.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 126/265] regmap: Fix memory leak from regmap_register_patch
Date:   Mon, 29 Jun 2020 11:15:59 -0400
Message-Id: <20200629151818.2493727-127-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629151818.2493727-1-sashal@kernel.org>
References: <20200629151818.2493727-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.7.7-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.7.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.7.7-rc1
X-KernelTest-Deadline: 2020-07-01T15:14+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Charles Keepax <ckeepax@opensource.cirrus.com>

[ Upstream commit 95b2c3ec4cb1689db2389c251d39f64490ba641c ]

When a register patch is registered the reg_sequence is copied but the
memory allocated is never freed. Add a kfree in regmap_exit to clean it
up.

Fixes: 22f0d90a3482 ("regmap: Support register patch sets")
Signed-off-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://lore.kernel.org/r/20200617152129.19655-1-ckeepax@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/regmap/regmap.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index 59f911e577192..508bbd6ea4396 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -1356,6 +1356,7 @@ void regmap_exit(struct regmap *map)
 	if (map->hwlock)
 		hwspin_lock_free(map->hwlock);
 	kfree_const(map->name);
+	kfree(map->patch);
 	kfree(map);
 }
 EXPORT_SYMBOL_GPL(regmap_exit);
-- 
2.25.1

