Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5378F4BE013
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 18:51:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350118AbiBUJcZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 04:32:25 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:36802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350183AbiBUJbw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 04:31:52 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EDDD27CF1;
        Mon, 21 Feb 2022 01:13:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DE5D2608C1;
        Mon, 21 Feb 2022 09:13:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8CD7C340E9;
        Mon, 21 Feb 2022 09:13:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645434806;
        bh=kPsipjtm5BFbOtdKq1wVwjsC6HImBrZUVW4TMQmoygI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ztN97UbMiiNtu0HdB+SQNdd5PGE9DQQLZPYHio+J0dBAKTI0x9qpS0udHzxVT0rNR
         K2HkVfRl3jno/7b695XaN2ojzUG1JjdbawQAzpuKiiIVATtWBQBygEUijBfB2HHds1
         d2Tg+gFm8RPH0y9KTM+uHGMtXpaFqxTxwCgK02AQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ansuel Smith <ansuelsmth@gmail.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 5.15 137/196] mtd: parsers: qcom: Fix kernel panic on skipped partition
Date:   Mon, 21 Feb 2022 09:49:29 +0100
Message-Id: <20220221084935.502531213@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220221084930.872957717@linuxfoundation.org>
References: <20220221084930.872957717@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ansuel Smith <ansuelsmth@gmail.com>

commit 65d003cca335cabc0160d3cd7daa689eaa9dd3cd upstream.

In the event of a skipped partition (case when the entry name is empty)
the kernel panics in the cleanup function as the name entry is NULL.
Rework the parser logic by first checking the real partition number and
then allocate the space and set the data for the valid partitions.

The logic was also fundamentally wrong as with a skipped partition, the
parts number returned was incorrect by not decreasing it for the skipped
partitions.

Fixes: 803eb124e1a6 ("mtd: parsers: Add Qcom SMEM parser")
Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20220116032211.9728-1-ansuelsmth@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/parsers/qcomsmempart.c |   31 +++++++++++++++++++------------
 1 file changed, 19 insertions(+), 12 deletions(-)

--- a/drivers/mtd/parsers/qcomsmempart.c
+++ b/drivers/mtd/parsers/qcomsmempart.c
@@ -58,11 +58,11 @@ static int parse_qcomsmem_part(struct mt
 			       const struct mtd_partition **pparts,
 			       struct mtd_part_parser_data *data)
 {
+	size_t len = SMEM_FLASH_PTABLE_HDR_LEN;
+	int ret, i, j, tmpparts, numparts = 0;
 	struct smem_flash_pentry *pentry;
 	struct smem_flash_ptable *ptable;
-	size_t len = SMEM_FLASH_PTABLE_HDR_LEN;
 	struct mtd_partition *parts;
-	int ret, i, numparts;
 	char *name, *c;
 
 	if (IS_ENABLED(CONFIG_MTD_SPI_NOR_USE_4K_SECTORS)
@@ -87,8 +87,8 @@ static int parse_qcomsmem_part(struct mt
 	}
 
 	/* Ensure that # of partitions is less than the max we have allocated */
-	numparts = le32_to_cpu(ptable->numparts);
-	if (numparts > SMEM_FLASH_PTABLE_MAX_PARTS_V4) {
+	tmpparts = le32_to_cpu(ptable->numparts);
+	if (tmpparts > SMEM_FLASH_PTABLE_MAX_PARTS_V4) {
 		pr_err("Partition numbers exceed the max limit\n");
 		return -EINVAL;
 	}
@@ -116,11 +116,17 @@ static int parse_qcomsmem_part(struct mt
 		return PTR_ERR(ptable);
 	}
 
+	for (i = 0; i < tmpparts; i++) {
+		pentry = &ptable->pentry[i];
+		if (pentry->name[0] != '\0')
+			numparts++;
+	}
+
 	parts = kcalloc(numparts, sizeof(*parts), GFP_KERNEL);
 	if (!parts)
 		return -ENOMEM;
 
-	for (i = 0; i < numparts; i++) {
+	for (i = 0, j = 0; i < tmpparts; i++) {
 		pentry = &ptable->pentry[i];
 		if (pentry->name[0] == '\0')
 			continue;
@@ -135,24 +141,25 @@ static int parse_qcomsmem_part(struct mt
 		for (c = name; *c != '\0'; c++)
 			*c = tolower(*c);
 
-		parts[i].name = name;
-		parts[i].offset = le32_to_cpu(pentry->offset) * mtd->erasesize;
-		parts[i].mask_flags = pentry->attr;
-		parts[i].size = le32_to_cpu(pentry->length) * mtd->erasesize;
+		parts[j].name = name;
+		parts[j].offset = le32_to_cpu(pentry->offset) * mtd->erasesize;
+		parts[j].mask_flags = pentry->attr;
+		parts[j].size = le32_to_cpu(pentry->length) * mtd->erasesize;
 		pr_debug("%d: %s offs=0x%08x size=0x%08x attr:0x%08x\n",
 			 i, pentry->name, le32_to_cpu(pentry->offset),
 			 le32_to_cpu(pentry->length), pentry->attr);
+		j++;
 	}
 
 	pr_debug("SMEM partition table found: ver: %d len: %d\n",
-		 le32_to_cpu(ptable->version), numparts);
+		 le32_to_cpu(ptable->version), tmpparts);
 	*pparts = parts;
 
 	return numparts;
 
 out_free_parts:
-	while (--i >= 0)
-		kfree(parts[i].name);
+	while (--j >= 0)
+		kfree(parts[j].name);
 	kfree(parts);
 	*pparts = NULL;
 


