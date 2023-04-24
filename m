Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26C4C6EC89F
	for <lists+stable@lfdr.de>; Mon, 24 Apr 2023 11:19:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230525AbjDXJTu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Apr 2023 05:19:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231571AbjDXJTt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Apr 2023 05:19:49 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB272E55
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 02:19:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1682327988; x=1713863988;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=iwPdPGtyXi+Lmp8PNlswmnwvTreB81pD477kVU0ht4Q=;
  b=SAY0933Frh11DFnZn0hr4SF0wftf3pCcmRdwaMntM/iahEWCupBVfr4O
   fiwsHph4b2h5K0hbxyn/oFs4qdAX6izL0LcvAjlj5FfC/nVZtEvaN1i/8
   8IUIKll2AJwpRruserdCIrlXH0r6KPMsTVUUrnDRXpAqXm2p5CdRBnZcz
   DeXZbqE07gyAHp7W0WCVyeM54Qj0YXxBaQJ7VtfFC1qcjcx1Ix3p5SiYe
   RY82153/dNijGUxiuyE2zqgVcWgUdG1LGY0QhejgmcsTdw5oOP0rs8FBl
   71W9eudcVPRbk3Qd+lGeGktmkEHfAI1EfU6RYPoIEhwQH4L7sAIjjam7l
   w==;
X-IronPort-AV: E=Sophos;i="5.99,222,1677567600"; 
   d="scan'208";a="222256065"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 24 Apr 2023 02:19:48 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 24 Apr 2023 02:19:47 -0700
Received: from wendy.microchip.com (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.2507.21 via Frontend
 Transport; Mon, 24 Apr 2023 02:19:46 -0700
From:   Conor Dooley <conor.dooley@microchip.com>
To:     <stable@vger.kernel.org>
CC:     <conor@kernel.org>, <conor.dooley@microchip.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Greentime Hu <greentime.hu@sifive.com>,
        Zong Li <zong.li@sifive.com>,
        Palmer Dabbelt <palmer@rivosinc.com>,
        Sasha Levin <sashal@kernel.org>,
        Yang Yingliang <yangyingliang@huawei.com>
Subject: [PATCH 5.15 v2 3/3] soc: sifive: l2_cache: fix missing of_node_put() in sifive_l2_init()
Date:   Mon, 24 Apr 2023 10:19:04 +0100
Message-ID: <20230424-shading-breeze-0d4b62b0dc55@wendy>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230424-slingshot-knelt-7a2f81b422a3@wendy>
References: <20230424-slingshot-knelt-7a2f81b422a3@wendy>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1763; i=conor.dooley@microchip.com; h=from:subject:message-id; bh=cEpCplfBV8wFwxhrzywZfL+cTKvEcv4IgTDKx7wcl04=; b=owGbwMvMwCFWscWwfUFT0iXG02pJDClunu2Lcx+wXr3Xe3JSxfSvW41TAqvXmz/omj8vJ6Pmh7Hk rjOxHaUsDGIcDLJiiiyJt/tapNb/cdnh3PMWZg4rE8gQBi5OAZjITR1GhoV5wvPmXrRPnRuUvqx7Wc GRl7Pmrct0P7S9K2idgdz1sBpGhh11vra7vsfceHBt+ozOa6mCR7f6TiyYdFglruVr+s2wrdwA
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

commit 8fbf94fea0b4e187ca9100936c5429f96b8a4e44 upstream.

The device_node pointer returned by of_find_matching_node() with
refcount incremented, when finish using it, the refcount need be
decreased.

Fixes: a967a289f169 ("RISC-V: sifive_l2_cache: Add L2 cache controller driver for SiFive SoCs")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
Signed-off-by: Conor Dooley <conor.dooley@microchip.com>
[conor: cache -> l2_cache]
Signed-off-by: Conor Dooley <conor.dooley@microchip.com>
---
 drivers/soc/sifive/sifive_l2_cache.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/soc/sifive/sifive_l2_cache.c b/drivers/soc/sifive/sifive_l2_cache.c
index 1248127009f6..783158070490 100644
--- a/drivers/soc/sifive/sifive_l2_cache.c
+++ b/drivers/soc/sifive/sifive_l2_cache.c
@@ -202,12 +202,16 @@ static int __init sifive_l2_init(void)
 	if (!np)
 		return -ENODEV;
 
-	if (of_address_to_resource(np, 0, &res))
-		return -ENODEV;
+	if (of_address_to_resource(np, 0, &res)) {
+		rc = -ENODEV;
+		goto err_node_put;
+	}
 
 	l2_base = ioremap(res.start, resource_size(&res));
-	if (!l2_base)
-		return -ENOMEM;
+	if (!l2_base) {
+		rc = -ENOMEM;
+		goto err_node_put;
+	}
 
 	intr_num = of_property_count_u32_elems(np, "interrupts");
 	if (!intr_num) {
@@ -224,6 +228,7 @@ static int __init sifive_l2_init(void)
 			goto err_free_irq;
 		}
 	}
+	of_node_put(np);
 
 	l2_config_read();
 
@@ -240,6 +245,8 @@ static int __init sifive_l2_init(void)
 		free_irq(g_irq[i], NULL);
 err_unmap:
 	iounmap(l2_base);
+err_node_put:
+	of_node_put(np);
 	return rc;
 }
 device_initcall(sifive_l2_init);
-- 
2.39.2

