Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35C5A5410B9
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 21:29:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355047AbiFGT3H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 15:29:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356881AbiFGT2S (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 15:28:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D74351A197B;
        Tue,  7 Jun 2022 11:11:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6C04561903;
        Tue,  7 Jun 2022 18:11:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B9DDC385A2;
        Tue,  7 Jun 2022 18:11:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654625482;
        bh=xkQiGxoMysz9EE4tGtqoiVDGv52Ju5dOkOMx/O/9Vvk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Qrbdldv25eAM6opPKOpYjwdiJRfc7kgb/rxRm488AmQUkDs8JYEueJ7u4oH0j7Z6p
         TOIUAmU/Sk/tYK/S5olQhYdzgy5qqWXX2ebIBWWRuQhhUQ3MwKLQ4+Y7HG1qfwP0ay
         Kwr2XpGSrL7QKe6GO85Ld/Wm0MPnxsXjNUAv2CSE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Huaming Jiang <jianghuaming.jhm@alibaba-inc.com>,
        Guo Ren <guoren@kernel.org>, Heiko Stuebner <heiko@sntech.de>,
        Xianting Tian <xianting.tian@linux.alibaba.com>,
        Palmer Dabbelt <palmer@rivosinc.com>,
        Nick Kossifidis <mick@ics.forth.gr>
Subject: [PATCH 5.17 005/772] RISC-V: Mark IORESOURCE_EXCLUSIVE for reserved mem instead of IORESOURCE_BUSY
Date:   Tue,  7 Jun 2022 18:53:17 +0200
Message-Id: <20220607164949.154512365@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164948.980838585@linuxfoundation.org>
References: <20220607164948.980838585@linuxfoundation.org>
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
@@ -189,7 +189,7 @@ static void __init init_resources(void)
 		res = &mem_res[res_idx--];
 
 		res->name = "Reserved";
-		res->flags = IORESOURCE_MEM | IORESOURCE_BUSY;
+		res->flags = IORESOURCE_MEM | IORESOURCE_EXCLUSIVE;
 		res->start = __pfn_to_phys(memblock_region_reserved_base_pfn(region));
 		res->end = __pfn_to_phys(memblock_region_reserved_end_pfn(region)) - 1;
 
@@ -214,7 +214,7 @@ static void __init init_resources(void)
 
 		if (unlikely(memblock_is_nomap(region))) {
 			res->name = "Reserved";
-			res->flags = IORESOURCE_MEM | IORESOURCE_BUSY;
+			res->flags = IORESOURCE_MEM | IORESOURCE_EXCLUSIVE;
 		} else {
 			res->name = "System RAM";
 			res->flags = IORESOURCE_SYSTEM_RAM | IORESOURCE_BUSY;


