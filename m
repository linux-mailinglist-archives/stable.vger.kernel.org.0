Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A4334DB567
	for <lists+stable@lfdr.de>; Wed, 16 Mar 2022 16:55:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357360AbiCPP40 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Mar 2022 11:56:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346085AbiCPP4Z (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Mar 2022 11:56:25 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E92B5F4F0
        for <stable@vger.kernel.org>; Wed, 16 Mar 2022 08:55:11 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id 15-20020a17090a098f00b001bef0376d5cso2780554pjo.5
        for <stable@vger.kernel.org>; Wed, 16 Mar 2022 08:55:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=KD5Vik00eM9ZbihLcHenZZWI4BOquYXJRbBsUzTo9js=;
        b=nOLC969K9agbENEcz5XtoQ6AYS58HoDltAylg+Y1q4QiGM23x7utwhvpShM/kRCk6E
         iGUfMblkurjKlntkr2pf4vdr69JxUKvSbBb8FOYLslldrZ1moEU/kkl38bFC6UO67fL0
         zXpETZqk0HKglOvIpHpsazU9pl0otXfAw2C7XqCUMjsgeLWJ3XgK3UnODGUw1pJ3F8Zx
         DxcZmuLCCdD5RfigsYQ+q54J/ufOo8bDhnjXXY70sJXznROenRYxJGhh5IckF1e+6XWa
         sJl9TOcWUwIlhWKRoY+RUPCIogxSVCjhsghEPFKKzKvZ6toJvB+iwl2BV9QwgxYh7vTq
         NcuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KD5Vik00eM9ZbihLcHenZZWI4BOquYXJRbBsUzTo9js=;
        b=T4qxMY9WS/ln/1+Bzj4LFvNdybIf2i7ytmIDg3VJoQe4+5RZGj8N6JY0o7/rpCnN3G
         Bcmt2GzR5KtXmUZLy3+d7IYgW5UHx1+K/8Al+VHYQr0T7CZdPttI6FgLfBZjTNYrtfcs
         4idQpkOPbZNxyHha3muRSvQGvHOR551wnxPjlRNdxyf62vfM/3AcG8gnxAQyE9srce13
         j3qkNzkp5pzjqP/8gSr4xwPTNaIKg0vRcIrEFQUNkOvJ5NdEIMJpZvLZ0Pz9jKPNjkxQ
         4KoMqrUXJSsC6kyjHvQenzK6X2NMbA2hJhm0cl+DPkd0F7VU5/uT/WEzBy2H6hv2lP1J
         7Q9Q==
X-Gm-Message-State: AOAM533VMkhTG2nf0YEwMiAB9cRA1NQnPdAGQucWXt/HAU6Mb7+eZXUb
        +QhlOFxU2jZBwb1LpvRcqlM=
X-Google-Smtp-Source: ABdhPJxVLKMm1Ja08E3Qvvn0H8/k8tf/6608qvzu8MlFBHsscsInWpsnw/NGSrF9gJ1+DGV1GMPnOw==
X-Received: by 2002:a17:90b:4f8f:b0:1bf:84ad:1fe6 with SMTP id qe15-20020a17090b4f8f00b001bf84ad1fe6mr346352pjb.189.1647446110661;
        Wed, 16 Mar 2022 08:55:10 -0700 (PDT)
Received: from tokunori-desktop.flets-east.jp ([240b:10:2720:5500:9500:ad27:b03f:5499])
        by smtp.gmail.com with ESMTPSA id x29-20020aa79a5d000000b004f0ef1822d3sm3427852pfj.128.2022.03.16.08.55.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Mar 2022 08:55:10 -0700 (PDT)
From:   Tokunori Ikegami <ikegami.t@gmail.com>
To:     miquel.raynal@bootlin.com
Cc:     linux-mtd@lists.infradead.org,
        Tokunori Ikegami <ikegami.t@gmail.com>, stable@vger.kernel.org
Subject: [PATCH v4 1/3] mtd: cfi_cmdset_0002: Move and rename chip_check/chip_ready/chip_good_for_write
Date:   Thu, 17 Mar 2022 00:54:53 +0900
Message-Id: <20220316155455.162362-2-ikegami.t@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220316155455.162362-1-ikegami.t@gmail.com>
References: <20220316155455.162362-1-ikegami.t@gmail.com>
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

This is a preparation patch for the functional change in preparation to a change
expected to fix the buffered writes on S29GL064N.

Fixes: dfeae1073583("mtd: cfi_cmdset_0002: Change write buffer to check correct value")
Signed-off-by: Tokunori Ikegami <ikegami.t@gmail.com>
Cc: stable@vger.kernel.org
---
 drivers/mtd/chips/cfi_cmdset_0002.c | 77 ++++++++++++-----------------
 1 file changed, 32 insertions(+), 45 deletions(-)

diff --git a/drivers/mtd/chips/cfi_cmdset_0002.c b/drivers/mtd/chips/cfi_cmdset_0002.c
index a761134fd3be..e68ddf0f7fc0 100644
--- a/drivers/mtd/chips/cfi_cmdset_0002.c
+++ b/drivers/mtd/chips/cfi_cmdset_0002.c
@@ -801,22 +801,12 @@ static struct mtd_info *cfi_amdstd_setup(struct mtd_info *mtd)
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
@@ -826,17 +816,35 @@ static int __xipram chip_ready(struct map_info *map, struct flchip *chip,
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
@@ -852,32 +860,11 @@ static int __xipram chip_ready(struct map_info *map, struct flchip *chip,
  * as each chip must be checked independently of the others).
  *
  */
-static int __xipram chip_good(struct map_info *map, struct flchip *chip,
-			      unsigned long addr, map_word expected)
-{
-	struct cfi_private *cfi = map->fldrv_priv;
-	map_word oldd, curd;
-
-	if (cfi_use_status_reg(cfi)) {
-		map_word ready = CMD(CFI_SR_DRB);
-
-		/*
-		 * For chips that support status register, check device
-		 * ready bit
-		 */
-		cfi_send_gen_cmd(0x70, cfi->addr_unlock1, chip->start, map, cfi,
-				 cfi->device_type, NULL);
-		curd = map_read(map, addr);
-
-		return map_word_andequal(map, curd, ready, ready);
-	}
-
-	oldd = map_read(map, addr);
-	curd = map_read(map, addr);
-
-	return	map_word_equal(map, oldd, curd) &&
-		map_word_equal(map, curd, expected);
-}
+#define chip_good(map, chip, addr, expected) \
+	({ \
+		map_word datum = expected; \
+		chip_check(map, chip, addr, &datum); \
+	})
 
 static int get_chip(struct map_info *map, struct flchip *chip, unsigned long adr, int mode)
 {
-- 
2.32.0

