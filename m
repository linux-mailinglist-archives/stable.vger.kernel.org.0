Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 489C16EAC25
	for <lists+stable@lfdr.de>; Fri, 21 Apr 2023 15:59:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230248AbjDUN7H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Apr 2023 09:59:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232596AbjDUN7A (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 Apr 2023 09:59:00 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EBCF1BF5
        for <stable@vger.kernel.org>; Fri, 21 Apr 2023 06:58:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1682085539; x=1713621539;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=IeRP5brmXrJ/qHqGp5c6mSGYHDExvn7ZiCuTJTLaXk0=;
  b=pbsFnVwLe/ZdimBR2ajRmDwixNQkRI//mp0ht4JqtQVjXs7r9kBk3sxI
   n8kc1ZDq6o6cawlxdn2Ri8MFRHVj67KdgYoq4qEJiIDrhsRAMGAXF1KCI
   +xGxf9E6yYxh4MtFjyQC3rx0Xyi6NrnTG8CFw6pF38bBFOEbtzK4drVpN
   Mkqf/Ez1xglK5EVKjAaP/xGUsECiAvlfT9BqaWXskA9d/CGerNDNYoNIe
   mej1+xCmNKtj4C8RMPjdP0d2LrNJxrUkaGyxOUHFtKWlQYW/5xmdMO3W8
   Q0JklTZXLbBV4gNVzR2O7dLJUFGXqjo0BkvhIjky/8oXv1UuCUOxQEkko
   g==;
X-IronPort-AV: E=Sophos;i="5.99,214,1677567600"; 
   d="scan'208";a="210133220"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 21 Apr 2023 06:58:58 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Fri, 21 Apr 2023 06:58:57 -0700
Received: from wendy.microchip.com (10.10.115.15) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server id 15.1.2507.21 via Frontend
 Transport; Fri, 21 Apr 2023 06:58:55 -0700
From:   Conor Dooley <conor.dooley@microchip.com>
To:     <stable@vger.kernel.org>
CC:     <conor@kernel.org>, <conor.dooley@microchip.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Greentime Hu <greentime.hu@sifive.com>,
        Zong Li <zong.li@sifive.com>,
        Palmer Dabbelt <palmer@rivosinc.com>,
        Sasha Levin <sashal@kernel.org>,
        Yang Yingliang <yangyingliang@huawei.com>
Subject: [PATCH 5.15 2/3] soc: sifive: l2_cache: fix missing free_irq() in error path in sifive_l2_init()
Date:   Fri, 21 Apr 2023 14:58:17 +0100
Message-ID: <20230421-dole-ignition-10fe81114811@wendy>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230421-scam-karma-3de5bf7904b3@wendy>
References: <20230421-scam-karma-3de5bf7904b3@wendy>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1284; i=conor.dooley@microchip.com; h=from:subject:message-id; bh=bSxywki0QH7dxAMrS4xJZCvvsAqjCjHPd3qWoQ4+Vm4=; b=owGbwMvMwCFWscWwfUFT0iXG02pJDClO0yqcp079/P5W48u86Xp3Q9liD0/h/f3BLKCF88+XpAc8 xjNNO0pZGMQ4GGTFFFkSb/e1SK3/47LDuectzBxWJpAhDFycAjCRlqMMfyX39KkpPuXV28v3xy/cM/ 6g0w9pi032Ex2OH7HPm+f5cArDH26m07vsNI1uzfq8UzlmktICFiF10f8R9c0uisv2Mk24xAMA
X-Developer-Key: i=conor.dooley@microchip.com; a=openpgp; fpr=F9ECA03CF54F12CD01F1655722E2C55B37CF380C
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Yingliang <yangyingliang@huawei.com>

commit 73e770f085023da327dc9ffeb6cd96b0bb22d97e upstream.

Add missing free_irq() before return error from sifive_l2_init().

Fixes: a967a289f169 ("RISC-V: sifive_l2_cache: Add L2 cache controller driver for SiFive SoCs")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
Signed-off-by: Conor Dooley <conor.dooley@microchip.com>
[conor: ccache -> l2_cache]
Signed-off-by: Conor Dooley <conor.dooley@microchip.com>
---
 drivers/soc/sifive/sifive_l2_cache.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/soc/sifive/sifive_l2_cache.c b/drivers/soc/sifive/sifive_l2_cache.c
index 483aeaf0d405..1248127009f6 100644
--- a/drivers/soc/sifive/sifive_l2_cache.c
+++ b/drivers/soc/sifive/sifive_l2_cache.c
@@ -221,7 +221,7 @@ static int __init sifive_l2_init(void)
 		rc = request_irq(g_irq[i], l2_int_handler, 0, "l2_ecc", NULL);
 		if (rc) {
 			pr_err("L2CACHE: Could not request IRQ %d\n", g_irq[i]);
-			goto err_unmap;
+			goto err_free_irq;
 		}
 	}
 
@@ -235,6 +235,9 @@ static int __init sifive_l2_init(void)
 #endif
 	return 0;
 
+err_free_irq:
+	while (--i >= 0)
+		free_irq(g_irq[i], NULL);
 err_unmap:
 	iounmap(l2_base);
 	return rc;
-- 
2.39.2

