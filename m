Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F5C8441653
	for <lists+stable@lfdr.de>; Mon,  1 Nov 2021 10:22:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232618AbhKAJYV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 05:24:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:58176 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232233AbhKAJXO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Nov 2021 05:23:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1122B610A2;
        Mon,  1 Nov 2021 09:20:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635758422;
        bh=fn9RVgz7n/ysygwQNjBLNXU8CmZZ8RIfTmVJcrElIEA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HXuCW0YKf6S0F3rTjBZjZdnIfqUp1qU37C3yG8hIjEvmocj/zwvBtJ8/CKvf+6CLd
         o5WNEKrR0/NerPWYdkwYZPEO39hqRLpD/DhiuBMCGMWUD+1ZETjBpZVVMqZCxtb77F
         C+XP48N958eV9Dk7zJ9VTfF8fzqu8Kk3H396+uL4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 4.14 17/25] regmap: Fix possible double-free in regcache_rbtree_exit()
Date:   Mon,  1 Nov 2021 10:17:29 +0100
Message-Id: <20211101082451.117867566@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211101082447.070493993@linuxfoundation.org>
References: <20211101082447.070493993@linuxfoundation.org>
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
@@ -295,14 +295,14 @@ static int regcache_rbtree_insert_to_blo
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
@@ -319,7 +319,6 @@ static int regcache_rbtree_insert_to_blo
 	}
 
 	/* update the rbnode block, its size and the base register */
-	rbnode->block = blk;
 	rbnode->blklen = blklen;
 	rbnode->base_reg = base_reg;
 	rbnode->cache_present = present;


