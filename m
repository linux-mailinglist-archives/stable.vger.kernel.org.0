Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4249C4CEC1A
	for <lists+stable@lfdr.de>; Sun,  6 Mar 2022 16:33:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231743AbiCFPe0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Mar 2022 10:34:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230420AbiCFPeZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 6 Mar 2022 10:34:25 -0500
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65A364B1DA
        for <stable@vger.kernel.org>; Sun,  6 Mar 2022 07:33:31 -0800 (PST)
Received: by mail-pg1-x52d.google.com with SMTP id o26so11565277pgb.8
        for <stable@vger.kernel.org>; Sun, 06 Mar 2022 07:33:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=gXYCAvH5QXBZfZLy8LZVI1ZLS4flN5UA88X9rSzFHso=;
        b=iMWe1XWd7bhFyUmsogsIR5EDIkOrbXj7gbAbymf8cCeOuK9CkMQISduNzp0LdQI75n
         aFrgnsQXXMMUaN4GC/jolb/tqXKWvGg0gdG3gatx+DvpPGCl94xsLBnxe8IdtIuYfjez
         LaocSlBRaTyWHtDker5XpCYxDS+YjKHmHOkE5BfjR6Dt0rvRaqe0dP2nbHCXtWUzJadO
         2akDM0NSCJvMOWYCQ0FC4cUDBc7omDEeu50++FtT62RDcFNjS7/zYLHKpMhcxe/TO5CP
         g9MwDAFUMbzooiQNwsLYF2bYWsgsViZkABI0pHVqRfthHNdRTG1aE5bxza5XHU9yBX/K
         NGBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=gXYCAvH5QXBZfZLy8LZVI1ZLS4flN5UA88X9rSzFHso=;
        b=PuNlFSs4Hs6X+ZIAdOtcT5kERlaHevqpk79X1oUUeIkmAF+GTEU/gnC0RaqWKjHYI/
         amPweLqrclV/MEwf3NQ3CR007EEMJtT+wx9cJMWB9vHgPzSqEJw0H4nzQTD/ko9kj+6l
         2xQ3cxhSXRYCDt6gy05EtaO9wL5gan4T3fvign2f38eYcgF98t/bZukpcELnTSxaxFT1
         LTrzzYc/3FauWdhOCCWzFP33ezZ2NDsiJeKnN+cGMypSo5mBLMs+uOOMrugyL4tFQ3nN
         6s5ov9IWzuIfRJ0v4i4hqGeMSH5SOPL3+S0XbxHhMePCETOpW6WhHD9wozmujdAx+Vnw
         DRYg==
X-Gm-Message-State: AOAM531CKEXQE1hiaO2edVmyishANEVK1V+9R+uNnvkmLqzAVlGAgdW0
        PVBynX7nQv4wl8TKLImZ99w=
X-Google-Smtp-Source: ABdhPJxI3NjDqplpVf/vzZ2RSBIXGfZ9M2R5ELkt8NUwLG1nzA1acU17sF9uo9KfRI6NIKY/nPKtoQ==
X-Received: by 2002:a05:6a00:1f9b:b0:4f4:1c0b:7102 with SMTP id bg27-20020a056a001f9b00b004f41c0b7102mr8603324pfb.62.1646580810504;
        Sun, 06 Mar 2022 07:33:30 -0800 (PST)
Received: from tokunori-desktop.flets-east.jp ([240b:10:2720:5500:7cd8:5236:546e:2b2c])
        by smtp.gmail.com with ESMTPSA id n22-20020a056a0007d600b004f11e614565sm12619338pfu.189.2022.03.06.07.33.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Mar 2022 07:33:30 -0800 (PST)
From:   Tokunori Ikegami <ikegami.t@gmail.com>
To:     vigneshr@ti.com
Cc:     linux-mtd@lists.infradead.org,
        Tokunori Ikegami <ikegami.t@gmail.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>, stable@vger.kernel.org
Subject: [PATCH v2] mtd: cfi_cmdset_0002: Use chip_ready() for write on S29GL064N
Date:   Mon,  7 Mar 2022 00:32:13 +0900
Message-Id: <20220306153213.411425-1-ikegami.t@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The regression issue has been caused on S29GL064N and reported it.
Also the change mentioned is to use chip_good() for buffered write.
So disable the change on S29GL064N and use chip_ready() as before.

Fixes: dfeae1073583("mtd: cfi_cmdset_0002: Change write buffer to check correct value")
Signed-off-by: Tokunori Ikegami <ikegami.t@gmail.com>
Cc: Miquel Raynal <miquel.raynal@bootlin.com>
Cc: Richard Weinberger <richard@nod.at>
Cc: Vignesh Raghavendra <vigneshr@ti.com>
Cc: linux-mtd@lists.infradead.org
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/b687c259-6413-26c9-d4c9-b3afa69ea124@pengutronix.de/
---
 drivers/mtd/chips/cfi_cmdset_0002.c | 89 +++++++++++++++--------------
 1 file changed, 47 insertions(+), 42 deletions(-)

diff --git a/drivers/mtd/chips/cfi_cmdset_0002.c b/drivers/mtd/chips/cfi_cmdset_0002.c
index a761134fd3be..5e14b60e8638 100644
--- a/drivers/mtd/chips/cfi_cmdset_0002.c
+++ b/drivers/mtd/chips/cfi_cmdset_0002.c
@@ -48,6 +48,7 @@
 #define SST49LF040B		0x0050
 #define SST49LF008A		0x005a
 #define AT49BV6416		0x00d6
+#define S29GL064N_MN12		0x0c01
 
 /*
  * Status Register bit description. Used by flash devices that don't
@@ -462,7 +463,7 @@ static struct cfi_fixup cfi_fixup_table[] = {
 	{ CFI_MFR_AMD, 0x0056, fixup_use_secsi },
 	{ CFI_MFR_AMD, 0x005C, fixup_use_secsi },
 	{ CFI_MFR_AMD, 0x005F, fixup_use_secsi },
-	{ CFI_MFR_AMD, 0x0c01, fixup_s29gl064n_sectors },
+	{ CFI_MFR_AMD, S29GL064N_MN12, fixup_s29gl064n_sectors },
 	{ CFI_MFR_AMD, 0x1301, fixup_s29gl064n_sectors },
 	{ CFI_MFR_AMD, 0x1a00, fixup_s29gl032n_sectors },
 	{ CFI_MFR_AMD, 0x1a01, fixup_s29gl032n_sectors },
@@ -801,22 +802,12 @@ static struct mtd_info *cfi_amdstd_setup(struct mtd_info *mtd)
 	return NULL;
 }
 
-/*
- * Return true if the chip is ready.
- *
- * Ready is one of: read mode, query mode, erase-suspend-read mode (in any
- * non-suspended sector) and is indicated by no toggle bits toggling.
- *
- * Note that anything more complicated than checking if no bits are toggling
- * (including checking DQ5 for an error status) is tricky to get working
- * correctly and is therefore not done	(particularly with interleaved chips
- * as each chip must be checked independently of the others).
- */
-static int __xipram chip_ready(struct map_info *map, struct flchip *chip,
-			       unsigned long addr)
+static int __xipram chip_check(struct map_info *map, struct flchip *chip,
+			       unsigned long addr, map_word *expected)
 {
 	struct cfi_private *cfi = map->fldrv_priv;
-	map_word d, t;
+	map_word oldd, curd;
+	int ret;
 
 	if (cfi_use_status_reg(cfi)) {
 		map_word ready = CMD(CFI_SR_DRB);
@@ -826,17 +817,35 @@ static int __xipram chip_ready(struct map_info *map, struct flchip *chip,
 		 */
 		cfi_send_gen_cmd(0x70, cfi->addr_unlock1, chip->start, map, cfi,
 				 cfi->device_type, NULL);
-		d = map_read(map, addr);
+		curd = map_read(map, addr);
 
-		return map_word_andequal(map, d, ready, ready);
+		return map_word_andequal(map, curd, ready, ready);
 	}
 
-	d = map_read(map, addr);
-	t = map_read(map, addr);
+	oldd = map_read(map, addr);
+	curd = map_read(map, addr);
+
+	ret = map_word_equal(map, oldd, curd);
 
-	return map_word_equal(map, d, t);
+	if (!ret || !expected)
+		return ret;
+
+	return map_word_equal(map, curd, *expected);
 }
 
+/*
+ * Return true if the chip is ready.
+ *
+ * Ready is one of: read mode, query mode, erase-suspend-read mode (in any
+ * non-suspended sector) and is indicated by no toggle bits toggling.
+ *
+ * Note that anything more complicated than checking if no bits are toggling
+ * (including checking DQ5 for an error status) is tricky to get working
+ * correctly and is therefore not done	(particularly with interleaved chips
+ * as each chip must be checked independently of the others).
+ */
+#define chip_ready(map, chip, addr) chip_check(map, chip, addr, NULL)
+
 /*
  * Return true if the chip is ready and has the correct value.
  *
@@ -855,28 +864,24 @@ static int __xipram chip_ready(struct map_info *map, struct flchip *chip,
 static int __xipram chip_good(struct map_info *map, struct flchip *chip,
 			      unsigned long addr, map_word expected)
 {
-	struct cfi_private *cfi = map->fldrv_priv;
-	map_word oldd, curd;
-
-	if (cfi_use_status_reg(cfi)) {
-		map_word ready = CMD(CFI_SR_DRB);
+	return chip_check(map, chip, addr, &expected);
+}
 
-		/*
-		 * For chips that support status register, check device
-		 * ready bit
-		 */
-		cfi_send_gen_cmd(0x70, cfi->addr_unlock1, chip->start, map, cfi,
-				 cfi->device_type, NULL);
-		curd = map_read(map, addr);
+static bool cfi_use_chip_ready_for_write(struct map_info *map)
+{
+	struct cfi_private *cfi = map->fldrv_priv;
 
-		return map_word_andequal(map, curd, ready, ready);
-	}
+	return cfi->mfr == CFI_MFR_AMD && cfi->id == S29GL064N_MN12;
+}
 
-	oldd = map_read(map, addr);
-	curd = map_read(map, addr);
+static int __xipram chip_good_for_write(struct map_info *map,
+					struct flchip *chip, unsigned long addr,
+					map_word expected)
+{
+	if (cfi_use_chip_ready_for_write(map))
+		return chip_ready(map, chip, addr);
 
-	return	map_word_equal(map, oldd, curd) &&
-		map_word_equal(map, curd, expected);
+	return chip_good(map, chip, addr, expected);
 }
 
 static int get_chip(struct map_info *map, struct flchip *chip, unsigned long adr, int mode)
@@ -1699,7 +1704,7 @@ static int __xipram do_write_oneword_once(struct map_info *map,
 		 * "chip_good" to avoid the failure due to scheduling.
 		 */
 		if (time_after(jiffies, timeo) &&
-		    !chip_good(map, chip, adr, datum)) {
+		    !chip_good_for_write(map, chip, adr, datum)) {
 			xip_enable(map, chip, adr);
 			printk(KERN_WARNING "MTD %s(): software timeout\n", __func__);
 			xip_disable(map, chip, adr);
@@ -1707,7 +1712,7 @@ static int __xipram do_write_oneword_once(struct map_info *map,
 			break;
 		}
 
-		if (chip_good(map, chip, adr, datum)) {
+		if (chip_good_for_write(map, chip, adr, datum)) {
 			if (cfi_check_err_status(map, chip, adr))
 				ret = -EIO;
 			break;
@@ -1979,14 +1984,14 @@ static int __xipram do_write_buffer_wait(struct map_info *map,
 		 * "chip_good" to avoid the failure due to scheduling.
 		 */
 		if (time_after(jiffies, timeo) &&
-		    !chip_good(map, chip, adr, datum)) {
+		    !chip_good_for_write(map, chip, adr, datum)) {
 			pr_err("MTD %s(): software timeout, address:0x%.8lx.\n",
 			       __func__, adr);
 			ret = -EIO;
 			break;
 		}
 
-		if (chip_good(map, chip, adr, datum)) {
+		if (chip_good_for_write(map, chip, adr, datum)) {
 			if (cfi_check_err_status(map, chip, adr))
 				ret = -EIO;
 			break;
-- 
2.32.0

