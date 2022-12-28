Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0EC41657A9E
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:13:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233053AbiL1PNo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:13:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233095AbiL1PNU (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:13:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD79E13E3E
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:12:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 57281B8171C
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:12:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2138C433D2;
        Wed, 28 Dec 2022 15:12:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672240375;
        bh=UHBlDUhsez1dcACx8Ck0SuPtBxLNYo6KvdxCrrVZH9g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DSek/YUmSjXXF1+Ig5ILb3WF7pjqGTZo+4ah6kDPcB9x/7OOHuvYDN5JGdX3Bhduh
         tq6AIWag1mZ0gouQnUzxhm29RTaXzs4Iwi4vo345hg1nOb2uEbR0Ben0uklkeP8xsN
         KhL947DlG5pksos2wX4SqgOccEH3el8GPoHRVJ/s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        John Thomson <git@johnthomson.fastmail.com.au>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0153/1073] mips: ralink: mt7621: soc queries and tests as functions
Date:   Wed, 28 Dec 2022 15:29:01 +0100
Message-Id: <20221228144332.177500316@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: John Thomson <git@johnthomson.fastmail.com.au>

[ Upstream commit b4767d4c072583dec987225b6fe3f5524a735f42 ]

Move the SoC register value queries and tests to specific functions,
to remove repetition of logic
No functional changes intended

Signed-off-by: John Thomson <git@johnthomson.fastmail.com.au>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Stable-dep-of: 7c18b64bba3b ("mips: ralink: mt7621: do not use kzalloc too early")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/ralink/mt7621.c | 86 +++++++++++++++++++++++++++------------
 1 file changed, 61 insertions(+), 25 deletions(-)

diff --git a/arch/mips/ralink/mt7621.c b/arch/mips/ralink/mt7621.c
index 17dbf28897e0..6e126f570f0c 100644
--- a/arch/mips/ralink/mt7621.c
+++ b/arch/mips/ralink/mt7621.c
@@ -97,7 +97,57 @@ void __init ralink_of_remap(void)
 		panic("Failed to remap core resources");
 }
 
-static void soc_dev_init(struct ralink_soc_info *soc_info, u32 rev)
+static unsigned int __init mt7621_get_soc_name0(void)
+{
+	return __raw_readl(MT7621_SYSC_BASE + SYSC_REG_CHIP_NAME0);
+}
+
+static unsigned int __init mt7621_get_soc_name1(void)
+{
+	return __raw_readl(MT7621_SYSC_BASE + SYSC_REG_CHIP_NAME1);
+}
+
+static bool __init mt7621_soc_valid(void)
+{
+	if (mt7621_get_soc_name0() == MT7621_CHIP_NAME0 &&
+			mt7621_get_soc_name1() == MT7621_CHIP_NAME1)
+		return true;
+	else
+		return false;
+}
+
+static const char __init *mt7621_get_soc_id(void)
+{
+	if (mt7621_soc_valid())
+		return "MT7621";
+	else
+		return "invalid";
+}
+
+static unsigned int __init mt7621_get_soc_rev(void)
+{
+	return __raw_readl(MT7621_SYSC_BASE + SYSC_REG_CHIP_REV);
+}
+
+static unsigned int __init mt7621_get_soc_ver(void)
+{
+	return (mt7621_get_soc_rev() >> CHIP_REV_VER_SHIFT) & CHIP_REV_VER_MASK;
+}
+
+static unsigned int __init mt7621_get_soc_eco(void)
+{
+	return (mt7621_get_soc_rev() & CHIP_REV_ECO_MASK);
+}
+
+static const char __init *mt7621_get_soc_revision(void)
+{
+	if (mt7621_get_soc_rev() == 1 && mt7621_get_soc_eco() == 1)
+		return "E2";
+	else
+		return "E1";
+}
+
+static void soc_dev_init(struct ralink_soc_info *soc_info)
 {
 	struct soc_device *soc_dev;
 	struct soc_device_attribute *soc_dev_attr;
@@ -108,12 +158,7 @@ static void soc_dev_init(struct ralink_soc_info *soc_info, u32 rev)
 
 	soc_dev_attr->soc_id = "mt7621";
 	soc_dev_attr->family = "Ralink";
-
-	if (((rev >> CHIP_REV_VER_SHIFT) & CHIP_REV_VER_MASK) == 1 &&
-	    (rev & CHIP_REV_ECO_MASK) == 1)
-		soc_dev_attr->revision = "E2";
-	else
-		soc_dev_attr->revision = "E1";
+	soc_dev_attr->revision = mt7621_get_soc_revision();
 
 	soc_dev_attr->data = soc_info;
 
@@ -126,11 +171,6 @@ static void soc_dev_init(struct ralink_soc_info *soc_info, u32 rev)
 
 void __init prom_soc_init(struct ralink_soc_info *soc_info)
 {
-	unsigned char *name = NULL;
-	u32 n0;
-	u32 n1;
-	u32 rev;
-
 	/* Early detection of CMP support */
 	mips_cm_probe();
 	mips_cpc_probe();
@@ -153,27 +193,23 @@ void __init prom_soc_init(struct ralink_soc_info *soc_info)
 		__sync();
 	}
 
-	n0 = __raw_readl(MT7621_SYSC_BASE + SYSC_REG_CHIP_NAME0);
-	n1 = __raw_readl(MT7621_SYSC_BASE + SYSC_REG_CHIP_NAME1);
-
-	if (n0 == MT7621_CHIP_NAME0 && n1 == MT7621_CHIP_NAME1) {
-		name = "MT7621";
+	if (mt7621_soc_valid())
 		soc_info->compatible = "mediatek,mt7621-soc";
-	} else {
-		panic("mt7621: unknown SoC, n0:%08x n1:%08x\n", n0, n1);
-	}
+	else
+		panic("mt7621: unknown SoC, n0:%08x n1:%08x\n",
+				mt7621_get_soc_name0(),
+				mt7621_get_soc_name1());
 	ralink_soc = MT762X_SOC_MT7621AT;
-	rev = __raw_readl(MT7621_SYSC_BASE + SYSC_REG_CHIP_REV);
 
 	snprintf(soc_info->sys_type, RAMIPS_SYS_TYPE_LEN,
 		"MediaTek %s ver:%u eco:%u",
-		name,
-		(rev >> CHIP_REV_VER_SHIFT) & CHIP_REV_VER_MASK,
-		(rev & CHIP_REV_ECO_MASK));
+		mt7621_get_soc_id(),
+		mt7621_get_soc_ver(),
+		mt7621_get_soc_eco());
 
 	soc_info->mem_detect = mt7621_memory_detect;
 
-	soc_dev_init(soc_info, rev);
+	soc_dev_init(soc_info);
 
 	if (!register_cps_smp_ops())
 		return;
-- 
2.35.1



