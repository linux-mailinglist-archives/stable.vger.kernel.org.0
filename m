Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B7C35FFE71
	for <lists+stable@lfdr.de>; Sun, 16 Oct 2022 11:30:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229562AbiJPJai (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 Oct 2022 05:30:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229662AbiJPJah (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 16 Oct 2022 05:30:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2588731FB0
        for <stable@vger.kernel.org>; Sun, 16 Oct 2022 02:30:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C446A60ADE
        for <stable@vger.kernel.org>; Sun, 16 Oct 2022 09:30:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0E2AC433C1;
        Sun, 16 Oct 2022 09:30:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665912634;
        bh=YcrXabzGIOP7C6SuFcvClIOSinFH1zx3zLxd1f9pFxw=;
        h=Subject:To:Cc:From:Date:From;
        b=EYmjvkECtmLxai2nSf67zntPBHg5b4+svXpj2CxuvKsdS2E73m2ib555jHxzrMxg7
         8EQeoMx9MaODHiniz5YS86TGn6KxReiEZHnO//zL8BT5K4c3MWof6td+65e8ssQ1ip
         OrV9UiJ18i7XEHBj6ozsd4qvMkjR1RWvVhC9DGFA=
Subject: FAILED: patch "[PATCH] riscv: always honor the CONFIG_CMDLINE_FORCE when parsing dtb" failed to apply to 5.10-stable tree
To:     zephray@outlook.com, bjorn@kernel.org, conor.dooley@microchip.com,
        palmer@rivosinc.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 16 Oct 2022 11:31:18 +0200
Message-ID: <166591267875217@kroah.com>
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


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

10f6913c548b ("riscv: always honor the CONFIG_CMDLINE_FORCE when parsing dtb")
46ad48e8a28d ("riscv: Add machine name to kernel boot log and stack dump output")

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

