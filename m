Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C040B4417A1
	for <lists+stable@lfdr.de>; Mon,  1 Nov 2021 10:37:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233200AbhKAJiA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 05:38:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:43594 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233199AbhKAJfr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Nov 2021 05:35:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5FD4D610CC;
        Mon,  1 Nov 2021 09:26:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635758760;
        bh=MrlPpx7DvVJXpmBB1vpvxboB4PpqCFjyFXwqMbtxq5o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=akbfDeev8zdwsYv0ALyQcgv/C8oPrDfMQp7jNe2eNqpLu0pII6E3IVr3OOFoI4pON
         PE0oVeN6A2HacH9le1TsCGqVzdRGww9MScM453jrc6FpYZ5ZWWl4Yfbp1F0NBIQdW6
         eIllW/c2Tmj3MgWOE/PXARnYiZRccI6yfUCI/PhY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.10 48/77] regmap: Fix possible double-free in regcache_rbtree_exit()
Date:   Mon,  1 Nov 2021 10:17:36 +0100
Message-Id: <20211101082521.877125303@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211101082511.254155853@linuxfoundation.org>
References: <20211101082511.254155853@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Yingliang <yangyingliang@huawei.com>

commit 55e6d8037805b3400096d621091dfbf713f97e83 upstream.

In regcache_rbtree_insert_to_block(), when 'present' realloc failed,
the 'blk' which is supposed to assign to 'rbnode->block' will be freed,
so 'rbnode->block' points a freed memory, in the error handling path of
regcache_rbtree_init(), 'rbnode->block' will be freed again in
regcache_rbtree_exit(), KASAN will report double-free as follows:

BUG: KASAN: double-free or invalid-free in kfree+0xce/0x390
Call Trace:
 slab_free_freelist_hook+0x10d/0x240
 kfree+0xce/0x390
 regcache_rbtree_exit+0x15d/0x1a0
 regcache_rbtree_init+0x224/0x2c0
 regcache_init+0x88d/0x1310
 __regmap_init+0x3151/0x4a80
 __devm_regmap_init+0x7d/0x100
 madera_spi_probe+0x10f/0x333 [madera_spi]
 spi_probe+0x183/0x210
 really_probe+0x285/0xc30

To fix this, moving up the assignment of rbnode->block to immediately after
the reallocation has succeeded so that the data structure stays valid even
if the second reallocation fails.

Reported-by: Hulk Robot <hulkci@huawei.com>
Fixes: 3f4ff561bc88b ("regmap: rbtree: Make cache_present bitmap per node")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Link: https://lore.kernel.org/r/20211012023735.1632786-1-yangyingliang@huawei.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/base/regmap/regcache-rbtree.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/drivers/base/regmap/regcache-rbtree.c
+++ b/drivers/base/regmap/regcache-rbtree.c
@@ -281,14 +281,14 @@ static int regcache_rbtree_insert_to_blo
 	if (!blk)
 		return -ENOMEM;
 
+	rbnode->block = blk;
+
 	if (BITS_TO_LONGS(blklen) > BITS_TO_LONGS(rbnode->blklen)) {
 		present = krealloc(rbnode->cache_present,
 				   BITS_TO_LONGS(blklen) * sizeof(*present),
 				   GFP_KERNEL);
-		if (!present) {
-			kfree(blk);
+		if (!present)
 			return -ENOMEM;
-		}
 
 		memset(present + BITS_TO_LONGS(rbnode->blklen), 0,
 		       (BITS_TO_LONGS(blklen) - BITS_TO_LONGS(rbnode->blklen))
@@ -305,7 +305,6 @@ static int regcache_rbtree_insert_to_blo
 	}
 
 	/* update the rbnode block, its size and the base register */
-	rbnode->block = blk;
 	rbnode->blklen = blklen;
 	rbnode->base_reg = base_reg;
 	rbnode->cache_present = present;


