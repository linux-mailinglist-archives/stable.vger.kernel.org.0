Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB33F6CC751
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 18:00:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232530AbjC1QAw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 12:00:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233055AbjC1QAv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 12:00:51 -0400
Received: from mx07-00178001.pphosted.com (mx08-00178001.pphosted.com [91.207.212.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F038109;
        Tue, 28 Mar 2023 09:00:50 -0700 (PDT)
Received: from pps.filterd (m0046661.ppops.net [127.0.0.1])
        by mx07-00178001.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32SE44rd000485;
        Tue, 28 Mar 2023 18:00:42 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foss.st.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=selector1;
 bh=1KoJfQkxDvqB7Qmm6LrkF/J0EXp00kAedWPRi4RBeYs=;
 b=w/z7cIDSRra8hWLk6emdR9DxXpv4T8R19YPaDhQmzRV1Yaiu4m/qmvM1E+JeIK3zM0Iz
 3G0BaIBTfRthsN+cLqDDh1DQFBGSvEzj9ENLnEzdo59KuaTzGvP7fgZTiaOhMboTbKb7
 hyGIeCMmlybhas3vkRgF6K+AeasGeMBjfDUdYnaY3UWKO1m4Sbs6EulzhhPJhIULprMU
 MVM58nDF7sNgWj2VcMpO40O8WHidu1QZ0pkEiA3FYseGmr0Tk1yKMGn8EAIltuVeshU2
 fXmR/UmVtIWMGXFUJVxDuRD7VPt3rlVmANvl3tuqDv2cFNchXua3Pc3dtcdfu3gomxoL Bw== 
Received: from beta.dmz-eu.st.com (beta.dmz-eu.st.com [164.129.1.35])
        by mx07-00178001.pphosted.com (PPS) with ESMTPS id 3pkvs4u1xt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Mar 2023 18:00:42 +0200
Received: from euls16034.sgp.st.com (euls16034.sgp.st.com [10.75.44.20])
        by beta.dmz-eu.st.com (STMicroelectronics) with ESMTP id 6B25510002A;
        Tue, 28 Mar 2023 18:00:41 +0200 (CEST)
Received: from Webmail-eu.st.com (shfdag1node3.st.com [10.75.129.71])
        by euls16034.sgp.st.com (STMicroelectronics) with ESMTP id 6424221A210;
        Tue, 28 Mar 2023 18:00:41 +0200 (CEST)
Received: from localhost (10.48.0.175) by SHFDAG1NODE3.st.com (10.75.129.71)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.17; Tue, 28 Mar
 2023 18:00:41 +0200
From:   Christophe Kerello <christophe.kerello@foss.st.com>
To:     <miquel.raynal@bootlin.com>, <richard@nod.at>, <vigneshr@ti.com>
CC:     <linux-mtd@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        Christophe Kerello <christophe.kerello@foss.st.com>,
        <stable@vger.kernel.org>, Tudor Ambarus <tudor.ambarus@linaro.org>
Subject: [PATCH v3 2/2] mtd: rawnand: stm32_fmc2: use timings.mode instead of checking tRC_min
Date:   Tue, 28 Mar 2023 17:58:19 +0200
Message-ID: <20230328155819.225521-3-christophe.kerello@foss.st.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230328155819.225521-1-christophe.kerello@foss.st.com>
References: <20230328155819.225521-1-christophe.kerello@foss.st.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.48.0.175]
X-ClientProxiedBy: EQNCAS1NODE4.st.com (10.75.129.82) To SHFDAG1NODE3.st.com
 (10.75.129.71)
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-24_11,2023-03-28_02,2023-02-09_01
X-Spam-Status: No, score=-0.8 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Use timings.mode value instead of checking tRC_min timing
for EDO mode support.

Signed-off-by: Christophe Kerello <christophe.kerello@foss.st.com>
Fixes: 2cd457f328c1 ("mtd: rawnand: stm32_fmc2: add STM32 FMC2 NAND flash controller driver")
Cc: stable@vger.kernel.org #v5.10+
Reviewed-by: Tudor Ambarus <tudor.ambarus@linaro.org>
---
Changes in v3:
 - Fixes added
 - Cc to stable added
 - Tudor Reviewed-by added

 drivers/mtd/nand/raw/stm32_fmc2_nand.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mtd/nand/raw/stm32_fmc2_nand.c b/drivers/mtd/nand/raw/stm32_fmc2_nand.c
index 3abb63d00a0b..9e74bcd90aaa 100644
--- a/drivers/mtd/nand/raw/stm32_fmc2_nand.c
+++ b/drivers/mtd/nand/raw/stm32_fmc2_nand.c
@@ -1531,7 +1531,7 @@ static int stm32_fmc2_nfc_setup_interface(struct nand_chip *chip, int chipnr,
 	if (IS_ERR(sdrt))
 		return PTR_ERR(sdrt);
 
-	if (sdrt->tRC_min < 30000)
+	if (conf->timings.mode > 3)
 		return -EOPNOTSUPP;
 
 	if (chipnr == NAND_DATA_IFACE_CHECK_ONLY)
-- 
2.25.1

