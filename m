Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 922DB6EC89E
	for <lists+stable@lfdr.de>; Mon, 24 Apr 2023 11:19:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230311AbjDXJTt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Apr 2023 05:19:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230525AbjDXJTr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Apr 2023 05:19:47 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4A3EE55
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 02:19:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1682327986; x=1713863986;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=PDB/D/Uus3TWuaDx7RnY/WE+jcpUCX8ikaGorGvngwo=;
  b=RUsW7tIkkdzjQmwyuH8j2GL2th+FMEPdCLP+rfWdg9B73EY58caHcag2
   asmVMAI93RTRgHHxQY5YSpAJAMbzpib4Q81ik5pn6G34cyww52I7ila8/
   ab1btT3t35V3BfnGXzLQZg+Kw3AE81Tl/rqxnHszJLGJELLvUs3taWhO/
   axkxDewnhfFPT4Mpnv65Z73u75sfLfWLmNtEb3vf75NVoemRzFtd3w1gH
   ql9TS+wsGgsFT459etVfS4n47h56jBpHcO3fnqAala+53RB1jzgoja5Eq
   Ra17z0YxJnI3qKteJ2fBLEbK4lMiFCGhP68at6yUY0hGqAuV1NXjb2NeR
   Q==;
X-IronPort-AV: E=Sophos;i="5.99,222,1677567600"; 
   d="scan'208";a="148580184"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 24 Apr 2023 02:19:45 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 24 Apr 2023 02:19:45 -0700
Received: from wendy.microchip.com (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.2507.21 via Frontend
 Transport; Mon, 24 Apr 2023 02:19:44 -0700
From:   Conor Dooley <conor.dooley@microchip.com>
To:     <stable@vger.kernel.org>
CC:     <conor@kernel.org>, <conor.dooley@microchip.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Greentime Hu <greentime.hu@sifive.com>,
        Zong Li <zong.li@sifive.com>,
        Palmer Dabbelt <palmer@rivosinc.com>,
        Sasha Levin <sashal@kernel.org>,
        Yang Yingliang <yangyingliang@huawei.com>
Subject: [PATCH 5.15 v2 2/3] soc: sifive: l2_cache: fix missing free_irq() in error path in sifive_l2_init()
Date:   Mon, 24 Apr 2023 10:19:03 +0100
Message-ID: <20230424-citizen-emphasis-df520424513a@wendy>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230424-slingshot-knelt-7a2f81b422a3@wendy>
References: <20230424-slingshot-knelt-7a2f81b422a3@wendy>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1284; i=conor.dooley@microchip.com; h=from:subject:message-id; bh=26e9aVpOtGFQve8A9adhJ/1c7VLROfen5yZTHuKkeWc=; b=owGbwMvMwCFWscWwfUFT0iXG02pJDClunu3vlnIfFE2WubL0gukNtXd+q9PUfr5mW7HQ9sXlJTy9 kplPOkpZGMQ4GGTFFFkSb/e1SK3/47LDuectzBxWJpAhDFycAjCRWHeG/779e/wlZx+b9ZBp47JqfT H11QsubQwyiz7oxChp+G3+npWMDPc9Pq1hzDOx2B/x6MydgOlvDsgy7AlLS3n/kO1TtItZNAMA
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

commit 756344e7cb1afbb87da8705c20384dddd0dea233 upstream.

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

