Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F01E429BF4D
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 18:07:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1793614AbgJ0PH1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:07:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:37360 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1789820AbgJ0PDC (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:03:02 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2E9C720747;
        Tue, 27 Oct 2020 15:03:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603810981;
        bh=2pAFCnSnHthtt5kihnUSeHNxZ0KWtqapg7ske1jDZF4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uiUYGjL4ianaKtlGmDWZB4PRr4uSHpZUXro/Veh3pPxyXDTYERKpVrdQVrbnWwHp9
         mrog1tQDtx0RDHmyLqPXk9V2vkUT0FGNd0plKx19M531fZh0rRqTXUF6bWl2BP4dze
         L6ipxgeA5X6A2nIuB2ylZRdcqzHwcOJvv5YucSw8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 331/633] mtd: lpddr: fix excessive stack usage with clang
Date:   Tue, 27 Oct 2020 14:51:14 +0100
Message-Id: <20201027135538.209177607@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135522.655719020@linuxfoundation.org>
References: <20201027135522.655719020@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 3e1b6469f8324bee5927b063e2aca30d3e56b907 ]

Building lpddr2_nvm with clang can result in a giant stack usage
in one function:

drivers/mtd/lpddr/lpddr2_nvm.c:399:12: error: stack frame size of 1144 bytes in function 'lpddr2_nvm_probe' [-Werror,-Wframe-larger-than=]

The problem is that clang decides to build a copy of the mtd_info
structure on the stack and then do a memcpy() into the actual version. It
shouldn't really do it that way, but it's not strictly a bug either.

As a workaround, use a static const version of the structure to assign
most of the members upfront and then only set the few members that
require runtime knowledge at probe time.

Fixes: 96ba9dd65788 ("mtd: lpddr: add driver for LPDDR2-NVM PCM memories")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Nathan Chancellor <natechancellor@gmail.com>
Acked-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20200505140136.263461-1-arnd@arndb.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/lpddr/lpddr2_nvm.c | 35 ++++++++++++++++++----------------
 1 file changed, 19 insertions(+), 16 deletions(-)

diff --git a/drivers/mtd/lpddr/lpddr2_nvm.c b/drivers/mtd/lpddr/lpddr2_nvm.c
index 0f1547f09d08b..72f5c7b300790 100644
--- a/drivers/mtd/lpddr/lpddr2_nvm.c
+++ b/drivers/mtd/lpddr/lpddr2_nvm.c
@@ -393,6 +393,17 @@ static int lpddr2_nvm_lock(struct mtd_info *mtd, loff_t start_add,
 	return lpddr2_nvm_do_block_op(mtd, start_add, len, LPDDR2_NVM_LOCK);
 }
 
+static const struct mtd_info lpddr2_nvm_mtd_info = {
+	.type		= MTD_RAM,
+	.writesize	= 1,
+	.flags		= (MTD_CAP_NVRAM | MTD_POWERUP_LOCK),
+	._read		= lpddr2_nvm_read,
+	._write		= lpddr2_nvm_write,
+	._erase		= lpddr2_nvm_erase,
+	._unlock	= lpddr2_nvm_unlock,
+	._lock		= lpddr2_nvm_lock,
+};
+
 /*
  * lpddr2_nvm driver probe method
  */
@@ -433,6 +444,7 @@ static int lpddr2_nvm_probe(struct platform_device *pdev)
 		.pfow_base	= OW_BASE_ADDRESS,
 		.fldrv_priv	= pcm_data,
 	};
+
 	if (IS_ERR(map->virt))
 		return PTR_ERR(map->virt);
 
@@ -444,22 +456,13 @@ static int lpddr2_nvm_probe(struct platform_device *pdev)
 		return PTR_ERR(pcm_data->ctl_regs);
 
 	/* Populate mtd_info data structure */
-	*mtd = (struct mtd_info) {
-		.dev		= { .parent = &pdev->dev },
-		.name		= pdev->dev.init_name,
-		.type		= MTD_RAM,
-		.priv		= map,
-		.size		= resource_size(add_range),
-		.erasesize	= ERASE_BLOCKSIZE * pcm_data->bus_width,
-		.writesize	= 1,
-		.writebufsize	= WRITE_BUFFSIZE * pcm_data->bus_width,
-		.flags		= (MTD_CAP_NVRAM | MTD_POWERUP_LOCK),
-		._read		= lpddr2_nvm_read,
-		._write		= lpddr2_nvm_write,
-		._erase		= lpddr2_nvm_erase,
-		._unlock	= lpddr2_nvm_unlock,
-		._lock		= lpddr2_nvm_lock,
-	};
+	*mtd = lpddr2_nvm_mtd_info;
+	mtd->dev.parent		= &pdev->dev;
+	mtd->name		= pdev->dev.init_name;
+	mtd->priv		= map;
+	mtd->size		= resource_size(add_range);
+	mtd->erasesize		= ERASE_BLOCKSIZE * pcm_data->bus_width;
+	mtd->writebufsize	= WRITE_BUFFSIZE * pcm_data->bus_width;
 
 	/* Verify the presence of the device looking for PFOW string */
 	if (!lpddr2_nvm_pfow_present(map)) {
-- 
2.25.1



