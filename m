Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1358D59355F
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 20:28:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240662AbiHOSXX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 14:23:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241164AbiHOSXC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 14:23:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 772112DABA;
        Mon, 15 Aug 2022 11:17:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4CB1C60685;
        Mon, 15 Aug 2022 18:17:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59AA3C4347C;
        Mon, 15 Aug 2022 18:17:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660587445;
        bh=AICtVT5BSqME0mJF4xJXxsjnLdJMwqvSiqa4MFAvTH8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0WKbnExdnuv9F3x6ANqrOAaLjTnr7NuS9ZMhcgTSLAbhqR2SdVZkD59EbcqxMF3kI
         QaSz//tJMb524uTNmiah4fGPWMkaDKxlBkgPTg2meWBwt+xlJjtoEzqIW5IiojQStm
         V22WxL+2P1bkughLySu11oKolAjR3T5eCKgmEjOg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guo Ren <guoren@kernel.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Xianting Tian <xianting.tian@linux.alibaba.com>,
        Palmer Dabbelt <palmer@rivosinc.com>
Subject: [PATCH 5.15 058/779] RISC-V: Add modules to virtual kernel memory layout dump
Date:   Mon, 15 Aug 2022 19:55:02 +0200
Message-Id: <20220815180339.741245916@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
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
@@ -100,6 +100,10 @@ static void __init print_vm_layout(void)
 		  (unsigned long)VMEMMAP_END);
 	print_mlm("vmalloc", (unsigned long)VMALLOC_START,
 		  (unsigned long)VMALLOC_END);
+#ifdef CONFIG_64BIT
+	print_mlm("modules", (unsigned long)MODULES_VADDR,
+		  (unsigned long)MODULES_END);
+#endif
 	print_mlm("lowmem", (unsigned long)PAGE_OFFSET,
 		  (unsigned long)high_memory);
 #ifdef CONFIG_64BIT


