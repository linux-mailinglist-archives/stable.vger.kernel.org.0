Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D510594619
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 01:02:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347667AbiHOWD7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 18:03:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350493AbiHOWCQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 18:02:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7EC03057E;
        Mon, 15 Aug 2022 12:36:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EF563610A5;
        Mon, 15 Aug 2022 19:36:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEE95C433D6;
        Mon, 15 Aug 2022 19:36:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660592218;
        bh=S03DrVIez8ZhURF5AK3S4u4nvNPVH0sG3GwEDu/RG8s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hU2Atgml2UGkoAsbDyn7ImVdn5Akhj1IpoT91dg6AOfwufUVxUp5GzUy5iPa/iMmF
         fp1b58NroqaRqh/ZXv6ObwRNfTI7RFBkhBPZRum/txug9abg50smPSbrO7a6VsLDv/
         pJEvbVSl+OpxwY6Uo7cBrqffgXRfYTseN8ucA5w4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guo Ren <guoren@kernel.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Xianting Tian <xianting.tian@linux.alibaba.com>,
        Palmer Dabbelt <palmer@rivosinc.com>
Subject: [PATCH 5.19 0076/1157] RISC-V: Add modules to virtual kernel memory layout dump
Date:   Mon, 15 Aug 2022 19:50:32 +0200
Message-Id: <20220815180442.559813771@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xianting Tian <xianting.tian@linux.alibaba.com>

commit f9293ad46d8ba9909187a37b7215324420ad4596 upstream.

Modules always live before the kernel, MODULES_END is fixed but
MODULES_VADDR isn't fixed, it depends on the kernel size.
Let's add it to virtual kernel memory layout dump.

As MODULES is only defined for CONFIG_64BIT, so we dump it when
CONFIG_64BIT=y.

eg,
MODULES_VADDR - MODULES_END
0xffffffff01133000 - 0xffffffff80000000

Reviewed-by: Guo Ren <guoren@kernel.org>
Reviewed-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Xianting Tian <xianting.tian@linux.alibaba.com>
Link: https://lore.kernel.org/r/20220811074150.3020189-5-xianting.tian@linux.alibaba.com
Cc: stable@vger.kernel.org
Fixes: 2bfc6cd81bd1 ("riscv: Move kernel mapping outside of linear mapping")
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/mm/init.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/arch/riscv/mm/init.c
+++ b/arch/riscv/mm/init.c
@@ -135,6 +135,10 @@ static void __init print_vm_layout(void)
 		(unsigned long)VMEMMAP_END);
 	print_ml("vmalloc", (unsigned long)VMALLOC_START,
 		(unsigned long)VMALLOC_END);
+#ifdef CONFIG_64BIT
+	print_ml("modules", (unsigned long)MODULES_VADDR,
+		(unsigned long)MODULES_END);
+#endif
 	print_ml("lowmem", (unsigned long)PAGE_OFFSET,
 		(unsigned long)high_memory);
 	if (IS_ENABLED(CONFIG_64BIT)) {


