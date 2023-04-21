Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F15396EAC24
	for <lists+stable@lfdr.de>; Fri, 21 Apr 2023 15:59:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229877AbjDUN7G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Apr 2023 09:59:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232586AbjDUN66 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 Apr 2023 09:58:58 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E063510DB
        for <stable@vger.kernel.org>; Fri, 21 Apr 2023 06:58:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1682085536; x=1713621536;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=EzrK715aXbfeznXfKaDdlghScr9HpFRRrq58fDEKwhI=;
  b=rsWtVP9C9W0CiiSt4ZtSCqLlfd2ufLtXFYzRuMzkPXNwjq9225lnixu8
   JcoyztIS6BRo8roBZD0Lo1kRiA8oAKOUc68elE8Syyih0ifbCi3DtypOg
   yFQ+YYVJvuGJutyIH9yTxTgRwEKGkgQf9ABXzWXGphQBLPpY4yBfrN1gW
   WzG3/xDiLkq8xG7jWf5G0cLLT3H0LtKipOZOKY/c1OfHKatr6PxJ3lWXk
   z5vimeeCqrfq+BkY1p5D+Jm54SEI+ix8misLxC6s1BMvjCC9aiLOK3NWU
   iTSxRh2kP1bVAO+/M3XhoeNFt837kpiDA7MOvnze8/RvEVK4/pk0Sfbsg
   g==;
X-IronPort-AV: E=Sophos;i="5.99,214,1677567600"; 
   d="scan'208";a="148304060"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 21 Apr 2023 06:58:55 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Fri, 21 Apr 2023 06:58:55 -0700
Received: from wendy.microchip.com (10.10.115.15) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server id 15.1.2507.21 via Frontend
 Transport; Fri, 21 Apr 2023 06:58:53 -0700
From:   Conor Dooley <conor.dooley@microchip.com>
To:     <stable@vger.kernel.org>
CC:     <conor@kernel.org>, <conor.dooley@microchip.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Greentime Hu <greentime.hu@sifive.com>,
        Zong Li <zong.li@sifive.com>,
        Palmer Dabbelt <palmer@rivosinc.com>,
        Sasha Levin <sashal@kernel.org>,
        Yang Yingliang <yangyingliang@huawei.com>
Subject: [PATCH 5.15 1/3] soc: sifive: l2_cache: fix missing iounmap() in error path in sifive_l2_init()
Date:   Fri, 21 Apr 2023 14:58:16 +0100
Message-ID: <20230421-brownnose-resend-337d31a61751@wendy>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230421-scam-karma-3de5bf7904b3@wendy>
References: <20230421-scam-karma-3de5bf7904b3@wendy>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1570; i=conor.dooley@microchip.com; h=from:subject:message-id; bh=cPNEP+92asCUtjXQgJiWcc0zhhQFsdVd8N+KtH4B1HI=; b=owGbwMvMwCFWscWwfUFT0iXG02pJDClO0yrkw4VFoh5VJby/X76gpzbNJWninJmCBwJfX7+q0ll8 5ENhRykLgxgHg6yYIkvi7b4WqfV/XHY497yFmcPKBDKEgYtTACbC4MTI8MY6zUVr56Kze2yftN44L/ Aj6Lv2juksszg47kd6PzTO0mf4Z6BrUsRl4/ciwKPIj79BxVBonuN9rwfcslOsW3t2NvLyAwA=
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

