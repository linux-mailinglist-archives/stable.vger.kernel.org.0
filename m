Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7789B540875
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 19:59:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349170AbiFGR6s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 13:58:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349046AbiFGR5t (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 13:57:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D7F74A911;
        Tue,  7 Jun 2022 10:40:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 262036165B;
        Tue,  7 Jun 2022 17:40:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33151C385A5;
        Tue,  7 Jun 2022 17:40:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654623651;
        bh=/LhHZS7KZOsRLjw20/Yc+E1iY9xUP5yA1eGvoz1lRmU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=va+pQ+JCFJmksengzKwJhm95Sc7YR7x2jvmd1AICbCuSWAkoYaY5Jz2lx+p4Ds6Rd
         miey4VGDgLQU9BRWjzUoe2KT4W1CIm4a8Jb9JsqjK+8WHI2SBaJb1Fw/+J+FyUHdDk
         k1rW2uJ5XvSBMbJ79phPgiUYzGVDO+I/7ltZ2f4M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Huaming Jiang <jianghuaming.jhm@alibaba-inc.com>,
        Guo Ren <guoren@kernel.org>, Heiko Stuebner <heiko@sntech.de>,
        Xianting Tian <xianting.tian@linux.alibaba.com>,
        Palmer Dabbelt <palmer@rivosinc.com>,
        Nick Kossifidis <mick@ics.forth.gr>
Subject: [PATCH 5.15 005/667] RISC-V: Mark IORESOURCE_EXCLUSIVE for reserved mem instead of IORESOURCE_BUSY
Date:   Tue,  7 Jun 2022 18:54:30 +0200
Message-Id: <20220607164934.940034192@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164934.766888869@linuxfoundation.org>
References: <20220607164934.766888869@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xianting Tian <xianting.tian@linux.alibaba.com>

commit e61bf5c071148c80d091f8e7220b3b9130780ae3 upstream.

Commit 00ab027a3b82 ("RISC-V: Add kernel image sections to the resource tree")
marked IORESOURCE_BUSY for reserved memory, which caused resource map
failed in subsequent operations of related driver, so remove the
IORESOURCE_BUSY flag. In order to prohibit userland mapping reserved
memory, mark IORESOURCE_EXCLUSIVE for it.

The code to reproduce the issue,
dts:
        mem0: memory@a0000000 {
                reg = <0x0 0xa0000000 0 0x1000000>;
                no-map;
        };

        &test {
                status = "okay";
                memory-region = <&mem0>;
        };

code:
        np = of_parse_phandle(pdev->dev.of_node, "memory-region", 0);
        ret = of_address_to_resource(np, 0, &r);
        base = devm_ioremap_resource(&pdev->dev, &r);
        // base = -EBUSY

Fixes: 00ab027a3b82 ("RISC-V: Add kernel image sections to the resource tree")
Reported-by: Huaming Jiang <jianghuaming.jhm@alibaba-inc.com>
Reviewed-by: Guo Ren <guoren@kernel.org>
Reviewed-by: Heiko Stuebner <heiko@sntech.de>
Tested-by: Heiko Stuebner <heiko@sntech.de>
Co-developed-by: Nick Kossifidis <mick@ics.forth.gr>
Signed-off-by: Xianting Tian <xianting.tian@linux.alibaba.com>
Link: https://lore.kernel.org/r/20220518013428.1338983-1-xianting.tian@linux.alibaba.com
Cc: stable@vger.kernel.org
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/kernel/setup.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/riscv/kernel/setup.c
+++ b/arch/riscv/kernel/setup.c
@@ -199,7 +199,7 @@ static void __init init_resources(void)
 		res = &mem_res[res_idx--];
 
 		res->name = "Reserved";
-		res->flags = IORESOURCE_MEM | IORESOURCE_BUSY;
+		res->flags = IORESOURCE_MEM | IORESOURCE_EXCLUSIVE;
 		res->start = __pfn_to_phys(memblock_region_reserved_base_pfn(region));
 		res->end = __pfn_to_phys(memblock_region_reserved_end_pfn(region)) - 1;
 
@@ -224,7 +224,7 @@ static void __init init_resources(void)
 
 		if (unlikely(memblock_is_nomap(region))) {
 			res->name = "Reserved";
-			res->flags = IORESOURCE_MEM | IORESOURCE_BUSY;
+			res->flags = IORESOURCE_MEM | IORESOURCE_EXCLUSIVE;
 		} else {
 			res->name = "System RAM";
 			res->flags = IORESOURCE_SYSTEM_RAM | IORESOURCE_BUSY;


