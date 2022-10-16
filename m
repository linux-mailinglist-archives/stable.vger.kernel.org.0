Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 706A25FFE72
	for <lists+stable@lfdr.de>; Sun, 16 Oct 2022 11:30:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229671AbiJPJap (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 Oct 2022 05:30:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229681AbiJPJan (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 16 Oct 2022 05:30:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA79E33A17
        for <stable@vger.kernel.org>; Sun, 16 Oct 2022 02:30:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6728A60023
        for <stable@vger.kernel.org>; Sun, 16 Oct 2022 09:30:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 752DCC433D6;
        Sun, 16 Oct 2022 09:30:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665912641;
        bh=8QkOjjOsLgHsBYTjy1IegUu8Dw7CBEy2ArqIFM2/ECw=;
        h=Subject:To:Cc:From:Date:From;
        b=xOR4lcUzmU6SAOP2048ZljNmuIxsWBVShxCX+yfXneZ/rG8qSQA3E0pgYInwq1DEY
         ETUg2NNkwcV/JLFgKOYQJQhbsn3AlLzzA3+IM1HXb6UdCC0kGQoEScQtfxnvSvHJx7
         RYI1pRuI3Bx6E+8WS7WlrY2yzyLzQoZrafhKF3nc=
Subject: FAILED: patch "[PATCH] riscv: always honor the CONFIG_CMDLINE_FORCE when parsing dtb" failed to apply to 5.4-stable tree
To:     zephray@outlook.com, bjorn@kernel.org, conor.dooley@microchip.com,
        palmer@rivosinc.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 16 Oct 2022 11:31:19 +0200
Message-ID: <16659126794522@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

10f6913c548b ("riscv: always honor the CONFIG_CMDLINE_FORCE when parsing dtb")
46ad48e8a28d ("riscv: Add machine name to kernel boot log and stack dump output")
8f3a2b4a96dc ("RISC-V: Move DT mapping outof fixmap")
2d2682512f0f ("riscv: Allow device trees to be built into the kernel")
335b139057ef ("riscv: Add SOC early init support")
20d2292754e7 ("riscv: make sure the cores stay looping in .Lsecondary_park")
6bd33e1ece52 ("riscv: add nommu support")
9e80635619b5 ("riscv: clear the instruction cache and all registers when booting")
accb9dbc4aff ("riscv: read the hart ID from mhartid on boot")
fcdc65375186 ("riscv: provide native clint access for M-mode")
4f9bbcefa142 ("riscv: add support for MMIO access to the timer registers")
8bf90f320d9a ("riscv: implement remote sfence.i using IPIs")
3b03ac6bbd6e ("riscv: poison SBI calls for M-mode")
a4c3733d32a7 ("riscv: abstract out CSR names for supervisor vs machine mode")
0c3ac28931d5 ("riscv: separate MMIO functions into their own header file")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 10f6913c548b32ecb73801a16b120e761c6957ea Mon Sep 17 00:00:00 2001
From: Wenting Zhang <zephray@outlook.com>
Date: Fri, 8 Jul 2022 16:38:22 -0400
Subject: [PATCH] riscv: always honor the CONFIG_CMDLINE_FORCE when parsing dtb
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

When CONFIG_CMDLINE_FORCE is enabled, cmdline provided by
CONFIG_CMDLINE are always used. This allows CONFIG_CMDLINE to be
used regardless of the result of device tree scanning.

This especially fixes the case where a device tree without the
chosen node is supplied to the kernel. In such cases,
early_init_dt_scan would return true. But inside
early_init_dt_scan_chosen, the cmdline won't be updated as there
is no chosen node in the device tree. As a result, CONFIG_CMDLINE
is not copied into boot_command_line even if CONFIG_CMDLINE_FORCE
is enabled. This commit allows properly update boot_command_line
in this situation.

Fixes: 8fd6e05c7463 ("arch: riscv: support kernel command line forcing when no DTB passed")
Signed-off-by: Wenting Zhang <zephray@outlook.com>
Reviewed-by: Björn Töpel <bjorn@kernel.org>
Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
Link: https://lore.kernel.org/r/PSBPR04MB399135DFC54928AB958D0638B1829@PSBPR04MB3991.apcprd04.prod.outlook.com
Cc: stable@vger.kernel.org
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>

diff --git a/arch/riscv/kernel/setup.c b/arch/riscv/kernel/setup.c
index 2dfc463b86bb..ad76bb59b059 100644
--- a/arch/riscv/kernel/setup.c
+++ b/arch/riscv/kernel/setup.c
@@ -252,10 +252,10 @@ static void __init parse_dtb(void)
 			pr_info("Machine model: %s\n", name);
 			dump_stack_set_arch_desc("%s (DT)", name);
 		}
-		return;
+	} else {
+		pr_err("No DTB passed to the kernel\n");
 	}
 
-	pr_err("No DTB passed to the kernel\n");
 #ifdef CONFIG_CMDLINE_FORCE
 	strscpy(boot_command_line, CONFIG_CMDLINE, COMMAND_LINE_SIZE);
 	pr_info("Forcing kernel command line to: %s\n", boot_command_line);

