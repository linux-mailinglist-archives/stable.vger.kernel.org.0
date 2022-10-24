Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA77B60AA90
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 15:36:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232220AbiJXNfj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 09:35:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236027AbiJXNeR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 09:34:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8391240031;
        Mon, 24 Oct 2022 05:35:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 427D8612F4;
        Mon, 24 Oct 2022 12:34:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51B7AC433D6;
        Mon, 24 Oct 2022 12:34:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666614893;
        bh=QP6jpKbzjIw/sS90nlAhLMRpCZpRodo2sINVhMurHAU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Se/A7uG5u+ZqmbV0V7HmNy5o6t0KlKrjW5/2T/KKIG4z2V22ADJj17MbRwP01iYQl
         GvgcyNGHZkU5FRvjdzTy+ZEivJm7p6iAQsTZHHW9Q5zs24xw4jX75kVjA8i41vA24R
         yuFF6VJah0uftkpXsMvSvwOBhBjawsNzJ9vVlu8o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wenting Zhang <zephray@outlook.com>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
        Conor Dooley <conor.dooley@microchip.com>,
        Palmer Dabbelt <palmer@rivosinc.com>
Subject: [PATCH 5.15 044/530] riscv: always honor the CONFIG_CMDLINE_FORCE when parsing dtb
Date:   Mon, 24 Oct 2022 13:26:28 +0200
Message-Id: <20221024113047.011089891@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113044.976326639@linuxfoundation.org>
References: <20221024113044.976326639@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wenting Zhang <zephray@outlook.com>

commit 10f6913c548b32ecb73801a16b120e761c6957ea upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/kernel/setup.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/riscv/kernel/setup.c
+++ b/arch/riscv/kernel/setup.c
@@ -260,10 +260,10 @@ static void __init parse_dtb(void)
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


