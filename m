Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D2E06EC89D
	for <lists+stable@lfdr.de>; Mon, 24 Apr 2023 11:19:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231438AbjDXJTs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Apr 2023 05:19:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231580AbjDXJTq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Apr 2023 05:19:46 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 682B2E55
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 02:19:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1682327985; x=1713863985;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=EzrK715aXbfeznXfKaDdlghScr9HpFRRrq58fDEKwhI=;
  b=oVWpL0uqLinIGQJC02RYkpJOP0wLfuxlvrr+nB8fU0u6ZY9S0cIqbFJQ
   50i3jaw8VAZroMhR6+2hTJK4XKCKI2CcdabMpTaulutpC4+9K0AtgCHVk
   eqvppHkyets7+oNjbfqKgxIkAu5VNUVC+G9Fl5eK/OqjE2Mbw1QNgG9hK
   KSWP669gdfcvLulTczpIXQheGi/HEDxSmP29xs7xduF2EtAjpV71tCIEJ
   uJYk+CbN5cnTD4Di2w0b4Khtu2KhDfSmygNtIVHxEyXJ+9bVxHJGYMIiJ
   a/J5abGPD69D+X0dPT+JbTRn2m/ck3LDHAJdgioQWF0jzPUEbtjaDxF1R
   g==;
X-IronPort-AV: E=Sophos;i="5.99,222,1677567600"; 
   d="scan'208";a="211939783"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 24 Apr 2023 02:19:44 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 24 Apr 2023 02:19:43 -0700
Received: from wendy.microchip.com (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.2507.21 via Frontend
 Transport; Mon, 24 Apr 2023 02:19:42 -0700
From:   Conor Dooley <conor.dooley@microchip.com>
To:     <stable@vger.kernel.org>
CC:     <conor@kernel.org>, <conor.dooley@microchip.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Greentime Hu <greentime.hu@sifive.com>,
        Zong Li <zong.li@sifive.com>,
        Palmer Dabbelt <palmer@rivosinc.com>,
        Sasha Levin <sashal@kernel.org>,
        Yang Yingliang <yangyingliang@huawei.com>
Subject: [PATCH 5.15 v2 1/3] soc: sifive: l2_cache: fix missing iounmap() in error path in sifive_l2_init()
Date:   Mon, 24 Apr 2023 10:19:02 +0100
Message-ID: <20230424-antonym-petroleum-d9930af1e6c6@wendy>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230424-slingshot-knelt-7a2f81b422a3@wendy>
References: <20230424-slingshot-knelt-7a2f81b422a3@wendy>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1570; i=conor.dooley@microchip.com; h=from:subject:message-id; bh=cPNEP+92asCUtjXQgJiWcc0zhhQFsdVd8N+KtH4B1HI=; b=owGbwMvMwCFWscWwfUFT0iXG02pJDClunm2vn/wue2vjIraJ84jFUg+h16vPTP5gPe2AUZbDdW0B sebmjlIWBjEOBlkxRZbE230tUuv/uOxw7nkLM4eVCWQIAxenAEyk5Rcjw2M1Je6ZJxnqPs2tyPcyLs v5ttl21TrzUlUV3bcchSmXZBkZLqx+JZTRUD/v5BzWBK53O+MXH71Sk2U8R9BqL8vMyOZCfgA=
X-Developer-Key: i=conor.dooley@microchip.com; a=openpgp; fpr=F9ECA03CF54F12CD01F1655722E2C55B37CF380C
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Yingliang <yangyingliang@huawei.com>

commit 73e770f085023da327dc9ffeb6cd96b0bb22d97e upstream.

Add missing iounmap() before return error from sifive_l2_init().

Fixes: a967a289f169 ("RISC-V: sifive_l2_cache: Add L2 cache controller driver for SiFive SoCs")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
Signed-off-by: Conor Dooley <conor.dooley@microchip.com>
[conor: ccache -> l2_cache]
Signed-off-by: Conor Dooley <conor.dooley@microchip.com>
---
 drivers/soc/sifive/sifive_l2_cache.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/soc/sifive/sifive_l2_cache.c b/drivers/soc/sifive/sifive_l2_cache.c
index 59640a1d0b28..483aeaf0d405 100644
--- a/drivers/soc/sifive/sifive_l2_cache.c
+++ b/drivers/soc/sifive/sifive_l2_cache.c
@@ -212,7 +212,8 @@ static int __init sifive_l2_init(void)
 	intr_num = of_property_count_u32_elems(np, "interrupts");
 	if (!intr_num) {
 		pr_err("L2CACHE: no interrupts property\n");
-		return -ENODEV;
+		rc = -ENODEV;
+		goto err_unmap;
 	}
 
 	for (i = 0; i < intr_num; i++) {
@@ -220,7 +221,7 @@ static int __init sifive_l2_init(void)
 		rc = request_irq(g_irq[i], l2_int_handler, 0, "l2_ecc", NULL);
 		if (rc) {
 			pr_err("L2CACHE: Could not request IRQ %d\n", g_irq[i]);
-			return rc;
+			goto err_unmap;
 		}
 	}
 
@@ -233,5 +234,9 @@ static int __init sifive_l2_init(void)
 	setup_sifive_debug();
 #endif
 	return 0;
+
+err_unmap:
+	iounmap(l2_base);
+	return rc;
 }
 device_initcall(sifive_l2_init);
-- 
2.39.2

