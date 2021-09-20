Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76B3E412481
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:34:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346807AbhITSfg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:35:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:52010 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1380086AbhITSc1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:32:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A23EF632F9;
        Mon, 20 Sep 2021 17:27:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632158865;
        bh=Gxqs7vcnkyg6slCKZ4aPq89mbLPunvfhing9PV39mbY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v90fYdzlVnY2gxDVbe3fX7nr7iApFjV+4Cgf/LDc4x3ixB63ulyaYWgw7F9thW+bI
         nNU+M8VKF+6rpqZsYpAajS/ztUtTF1gsbLLsOcfKztxYhgsoEm8Y3E382CIbmKaHyM
         Xv1WRytl13ew+VldSe6rh69rDH9JrCs7y+OjybMA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhihao Cheng <chengzhihao1@huawei.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 090/122] mtd: mtdconcat: Judge callback existence based on the master
Date:   Mon, 20 Sep 2021 18:44:22 +0200
Message-Id: <20210920163918.741114785@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163915.757887582@linuxfoundation.org>
References: <20210920163915.757887582@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhihao Cheng <chengzhihao1@huawei.com>

[ Upstream commit f9e109a209a8e01e16f37e1252304f1eb3908be4 ]

Since commit 46b5889cc2c5("mtd: implement proper partition handling")
applied, mtd partition device won't hold some callback functions, such
as _block_isbad, _block_markbad, etc. Besides, function mtd_block_isbad()
will get mtd device's master mtd device, then invokes master mtd device's
callback function. So, following process may result mtd_block_isbad()
always return 0, even though mtd device has bad blocks:

1. Split a mtd device into 3 partitions: PA, PB, PC
[ Each mtd partition device won't has callback function _block_isbad(). ]
2. Concatenate PA and PB as a new mtd device PN
[ mtd_concat_create() finds out each subdev has no callback function
_block_isbad(), so PN won't be assigned callback function
concat_block_isbad(). ]
Then, mtd_block_isbad() checks "!master->_block_isbad" is true, will
always return 0.

Reproducer:
// reproduce.c
static int __init init_diy_module(void)
{
	struct mtd_info *mtd[2];
	struct mtd_info *mtd_combine = NULL;

	mtd[0] = get_mtd_device_nm("NAND simulator partition 0");
	if (!mtd[0]) {
		pr_err("cannot find mtd1\n");
		return -EINVAL;
	}
	mtd[1] = get_mtd_device_nm("NAND simulator partition 1");
	if (!mtd[1]) {
		pr_err("cannot find mtd2\n");
		return -EINVAL;
	}

	put_mtd_device(mtd[0]);
	put_mtd_device(mtd[1]);

	mtd_combine = mtd_concat_create(mtd, 2, "Combine mtd");
	if (mtd_combine == NULL) {
		pr_err("combine failed\n");
		return -EINVAL;
	}

	mtd_device_register(mtd_combine, NULL, 0);
	pr_info("Combine success\n");

	return 0;
}

1. ID="0x20,0xac,0x00,0x15"
2. modprobe nandsim id_bytes=$ID parts=50,100 badblocks=100
3. insmod reproduce.ko
4. flash_erase /dev/mtd3 0 0
  libmtd: error!: MEMERASE64 ioctl failed for eraseblock 100 (mtd3)
  error 5 (Input/output error)
  // Should be "flash_erase: Skipping bad block at 00c80000"

Fixes: 46b5889cc2c54bac ("mtd: implement proper partition handling")
Signed-off-by: Zhihao Cheng <chengzhihao1@huawei.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20210817114857.2784825-2-chengzhihao1@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/mtdconcat.c | 27 +++++++++++++++++++--------
 1 file changed, 19 insertions(+), 8 deletions(-)

diff --git a/drivers/mtd/mtdconcat.c b/drivers/mtd/mtdconcat.c
index 6e4d0017c0bd..af51eee6b5e8 100644
--- a/drivers/mtd/mtdconcat.c
+++ b/drivers/mtd/mtdconcat.c
@@ -641,6 +641,7 @@ struct mtd_info *mtd_concat_create(struct mtd_info *subdev[],	/* subdevices to c
 	int i;
 	size_t size;
 	struct mtd_concat *concat;
+	struct mtd_info *subdev_master = NULL;
 	uint32_t max_erasesize, curr_erasesize;
 	int num_erase_region;
 	int max_writebufsize = 0;
@@ -679,17 +680,19 @@ struct mtd_info *mtd_concat_create(struct mtd_info *subdev[],	/* subdevices to c
 	concat->mtd.subpage_sft = subdev[0]->subpage_sft;
 	concat->mtd.oobsize = subdev[0]->oobsize;
 	concat->mtd.oobavail = subdev[0]->oobavail;
-	if (subdev[0]->_writev)
+
+	subdev_master = mtd_get_master(subdev[0]);
+	if (subdev_master->_writev)
 		concat->mtd._writev = concat_writev;
-	if (subdev[0]->_read_oob)
+	if (subdev_master->_read_oob)
 		concat->mtd._read_oob = concat_read_oob;
-	if (subdev[0]->_write_oob)
+	if (subdev_master->_write_oob)
 		concat->mtd._write_oob = concat_write_oob;
-	if (subdev[0]->_block_isbad)
+	if (subdev_master->_block_isbad)
 		concat->mtd._block_isbad = concat_block_isbad;
-	if (subdev[0]->_block_markbad)
+	if (subdev_master->_block_markbad)
 		concat->mtd._block_markbad = concat_block_markbad;
-	if (subdev[0]->_panic_write)
+	if (subdev_master->_panic_write)
 		concat->mtd._panic_write = concat_panic_write;
 
 	concat->mtd.ecc_stats.badblocks = subdev[0]->ecc_stats.badblocks;
@@ -721,14 +724,22 @@ struct mtd_info *mtd_concat_create(struct mtd_info *subdev[],	/* subdevices to c
 				    subdev[i]->flags & MTD_WRITEABLE;
 		}
 
+		subdev_master = mtd_get_master(subdev[i]);
 		concat->mtd.size += subdev[i]->size;
 		concat->mtd.ecc_stats.badblocks +=
 			subdev[i]->ecc_stats.badblocks;
 		if (concat->mtd.writesize   !=  subdev[i]->writesize ||
 		    concat->mtd.subpage_sft != subdev[i]->subpage_sft ||
 		    concat->mtd.oobsize    !=  subdev[i]->oobsize ||
-		    !concat->mtd._read_oob  != !subdev[i]->_read_oob ||
-		    !concat->mtd._write_oob != !subdev[i]->_write_oob) {
+		    !concat->mtd._read_oob  != !subdev_master->_read_oob ||
+		    !concat->mtd._write_oob != !subdev_master->_write_oob) {
+			/*
+			 * Check against subdev[i] for data members, because
+			 * subdev's attributes may be different from master
+			 * mtd device. Check against subdev's master mtd
+			 * device for callbacks, because the existence of
+			 * subdev's callbacks is decided by master mtd device.
+			 */
 			kfree(concat);
 			printk("Incompatible OOB or ECC data on \"%s\"\n",
 			       subdev[i]->name);
-- 
2.30.2



