Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C88C412631
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:54:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354796AbhITS4T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:56:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:33188 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1385437AbhITSu0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:50:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 842646337E;
        Mon, 20 Sep 2021 17:34:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632159281;
        bh=HzC4FEJyEmQTpbQRKNOD5mi7b2ZooCXj66Madr1v6Og=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iv6cjLnAzSml/bhAbTRnuYEb3pnbPvm1PG00MIy59Fo8XDVX7sOkklv8VPLR2W4ax
         w8pkuHFE2R/QY/xb3b7Rvdrv9w/2E3wRoguRE3JCwtyKyf9MLlqExvStp29u1HpPQP
         CoMvO6kFnpGYw1bTMKuAkBMZlhmoR5Xf+jj5xZYc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhihao Cheng <chengzhihao1@huawei.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 132/168] mtd: mtdconcat: Check _read, _write callbacks existence before assignment
Date:   Mon, 20 Sep 2021 18:44:30 +0200
Message-Id: <20210920163926.005202402@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163921.633181900@linuxfoundation.org>
References: <20210920163921.633181900@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhihao Cheng <chengzhihao1@huawei.com>

[ Upstream commit a89d69a44e282be95ae76125dddc79515541efeb ]

Since 2431c4f5b46c3 ("mtd: Implement mtd_{read,write}() as wrappers
around mtd_{read,write}_oob()") don't allow _write|_read and
_write_oob|_read_oob existing at the same time, we should check the
existence of callbacks "_read and _write" from subdev's master device
(We can trust master device since it has been registered) before
assigning, otherwise following warning occurs while making
concatenated device:

  WARNING: CPU: 2 PID: 6728 at drivers/mtd/mtdcore.c:595
  add_mtd_device+0x7f/0x7b0

Fixes: 2431c4f5b46c3 ("mtd: Implement mtd_{read,write}() around ...")
Signed-off-by: Zhihao Cheng <chengzhihao1@huawei.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20210817114857.2784825-3-chengzhihao1@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/mtdconcat.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/mtd/mtdconcat.c b/drivers/mtd/mtdconcat.c
index af51eee6b5e8..f685a581df48 100644
--- a/drivers/mtd/mtdconcat.c
+++ b/drivers/mtd/mtdconcat.c
@@ -694,6 +694,10 @@ struct mtd_info *mtd_concat_create(struct mtd_info *subdev[],	/* subdevices to c
 		concat->mtd._block_markbad = concat_block_markbad;
 	if (subdev_master->_panic_write)
 		concat->mtd._panic_write = concat_panic_write;
+	if (subdev_master->_read)
+		concat->mtd._read = concat_read;
+	if (subdev_master->_write)
+		concat->mtd._write = concat_write;
 
 	concat->mtd.ecc_stats.badblocks = subdev[0]->ecc_stats.badblocks;
 
@@ -755,8 +759,6 @@ struct mtd_info *mtd_concat_create(struct mtd_info *subdev[],	/* subdevices to c
 	concat->mtd.name = name;
 
 	concat->mtd._erase = concat_erase;
-	concat->mtd._read = concat_read;
-	concat->mtd._write = concat_write;
 	concat->mtd._sync = concat_sync;
 	concat->mtd._lock = concat_lock;
 	concat->mtd._unlock = concat_unlock;
-- 
2.30.2



