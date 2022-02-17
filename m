Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BD734BA380
	for <lists+stable@lfdr.de>; Thu, 17 Feb 2022 15:50:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242137AbiBQOtm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Feb 2022 09:49:42 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:38936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242122AbiBQOtj (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Feb 2022 09:49:39 -0500
Received: from mx07-00178001.pphosted.com (mx07-00178001.pphosted.com [185.132.182.106])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0145721FC69;
        Thu, 17 Feb 2022 06:49:24 -0800 (PST)
Received: from pps.filterd (m0288072.ppops.net [127.0.0.1])
        by mx07-00178001.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 21HBatfR010860;
        Thu, 17 Feb 2022 15:49:03 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foss.st.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=selector1;
 bh=uDBTaIhKiAzA8mTM+6OWIIjO0uszxvkCNaIBSKJuIPE=;
 b=cepx7Q01ybZURJgeAHcz2UECpj/Q9EsgWS4PVaF5dwaGrgoTsMzL7htjFyB8m5ejX1p8
 WYvFMuaT/HJ4DGehMlTtL2aL7b9uLABGuhnaOQKtTOFaEgfK3wCgcrmRv63SmM8M8X2+
 UBFI8SXObppvaFqdXNYtJFiUj0sxBOiaZTIcaiY/WuaszmB/Nz+ug0JikV48mz6xPDjX
 9aVWlxV/5GxkL/GK41YpNhQVK9Fpwkjn2+rx8cyyaOwUvuyjwOt5lqc8Tkzwez3SgJJn
 T0pywHZdKhQeZZXieE7c5ZTGQWGFwLnW0pQLRJotZ/CnJ0LosPOU439bOoa3YfsGULWZ +Q== 
Received: from beta.dmz-eu.st.com (beta.dmz-eu.st.com [164.129.1.35])
        by mx07-00178001.pphosted.com (PPS) with ESMTPS id 3e9hvgjmpp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Feb 2022 15:49:03 +0100
Received: from euls16034.sgp.st.com (euls16034.sgp.st.com [10.75.44.20])
        by beta.dmz-eu.st.com (STMicroelectronics) with ESMTP id 509B710002A;
        Thu, 17 Feb 2022 15:49:03 +0100 (CET)
Received: from Webmail-eu.st.com (sfhdag2node2.st.com [10.75.127.5])
        by euls16034.sgp.st.com (STMicroelectronics) with ESMTP id 4722E2278A1;
        Thu, 17 Feb 2022 15:49:03 +0100 (CET)
Received: from localhost (10.75.127.50) by SFHDAG2NODE2.st.com (10.75.127.5)
 with Microsoft SMTP Server (TLS) id 15.0.1497.26; Thu, 17 Feb 2022 15:49:02
 +0100
From:   Christophe Kerello <christophe.kerello@foss.st.com>
To:     <miquel.raynal@bootlin.com>, <richard@nod.at>, <vigneshr@ti.com>,
        <robh+dt@kernel.org>, <srinivas.kandagatla@linaro.org>,
        <p.yadav@ti.com>
CC:     <linux-mtd@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <devicetree@vger.kernel.org>, <chenshumin86@sina.com>,
        Christophe Kerello <christophe.kerello@foss.st.com>,
        <stable@vger.kernel.org>
Subject: [PATCH v3 4/4] mtd: core: Fix a conflict between MTD and NVMEM on wp-gpios property
Date:   Thu, 17 Feb 2022 15:47:55 +0100
Message-ID: <20220217144755.270679-5-christophe.kerello@foss.st.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220217144755.270679-1-christophe.kerello@foss.st.com>
References: <20220217144755.270679-1-christophe.kerello@foss.st.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.75.127.50]
X-ClientProxiedBy: SFHDAG2NODE1.st.com (10.75.127.4) To SFHDAG2NODE2.st.com
 (10.75.127.5)
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-17_05,2022-02-17_01,2021-12-02_01
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Wp-gpios property can be used on NVMEM nodes and the same property can
be also used on MTD NAND nodes. In case of the wp-gpios property is
defined at NAND level node, the GPIO management is done at NAND driver
level. Write protect is disabled when the driver is probed or resumed
and is enabled when the driver is released or suspended.

When no partitions are defined in the NAND DT node, then the NAND DT node
will be passed to NVMEM framework. If wp-gpios property is defined in
this node, the GPIO resource is taken twice and the NAND controller
driver fails to probe.

A new Boolean flag named ignore_wp has been added in nvmem_config.
In case ignore_wp is set, it means that the GPIO is handled by the
provider. Lets set this flag in MTD layer to avoid the conflict on
wp_gpios property.

Fixes: 2a127da461a9 ("nvmem: add support for the write-protect pin")
Signed-off-by: Christophe Kerello <christophe.kerello@foss.st.com>
Cc: stable@vger.kernel.org
---
Changes in v3:
 - add a fixes tag
 - rename skip_wp_gpio by ignore_wp in nvmen_config.

 drivers/mtd/mtdcore.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/mtd/mtdcore.c b/drivers/mtd/mtdcore.c
index 70f492dce158..eef87b28d6c8 100644
--- a/drivers/mtd/mtdcore.c
+++ b/drivers/mtd/mtdcore.c
@@ -546,6 +546,7 @@ static int mtd_nvmem_add(struct mtd_info *mtd)
 	config.stride = 1;
 	config.read_only = true;
 	config.root_only = true;
+	config.ignore_wp = true;
 	config.no_of_node = !of_device_is_compatible(node, "nvmem-cells");
 	config.priv = mtd;
 
@@ -833,6 +834,7 @@ static struct nvmem_device *mtd_otp_nvmem_register(struct mtd_info *mtd,
 	config.owner = THIS_MODULE;
 	config.type = NVMEM_TYPE_OTP;
 	config.root_only = true;
+	config.ignore_wp = true;
 	config.reg_read = reg_read;
 	config.size = size;
 	config.of_node = np;
-- 
2.25.1

