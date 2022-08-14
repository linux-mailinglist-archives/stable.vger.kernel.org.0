Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85A31592283
	for <lists+stable@lfdr.de>; Sun, 14 Aug 2022 17:47:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241608AbiHNPrs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Aug 2022 11:47:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241964AbiHNPqw (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 14 Aug 2022 11:46:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F269BBF6;
        Sun, 14 Aug 2022 08:35:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3866260DB7;
        Sun, 14 Aug 2022 15:35:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7424C433C1;
        Sun, 14 Aug 2022 15:35:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660491312;
        bh=/MXTzw3n6Y/+W//xvT4vPP3C/U0lrPd6wykSKx+nx6M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JjJLROSmaCdjGn9gm8ubh9szI9sHXjWgJcRtQbRiOD14/wFrs3du9d8zWot8Q2fax
         UAOd4t/nmA22VbEB8lRN3C7is1ifHE8aEoOxSAL0WhP08hMgvgwzMtD+0NUc3QqPsO
         s6NkyZXvtpOVU8DXxAYg1Mbn85duQck35lDZmwmZHz/3DSa+2McCtho3kPreiI/2XC
         uQFIdoskDWWOXz+SMTiXQ2UdxZYMz0EM6g9VvRNRHTlqCrUnXD0I2dFvVTV+1TPsE0
         qbAz+gL+6HV1L5FPKpwdwGFEZbDmMcQBa0jNAOw+EfvhQrQZrhY7tN+SpFSNsjpZqg
         JjV5LRrwyd93g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Richard Weinberger <richard@nod.at>,
        Sasha Levin <sashal@kernel.org>,
        anton.ivanov@cambridgegreys.com, johannes@sipsolutions.net,
        linux@roeck-us.net, linux-um@lists.infradead.org
Subject: [PATCH AUTOSEL 5.10 21/31] um: add "noreboot" command line option for PANIC_TIMEOUT=-1 setups
Date:   Sun, 14 Aug 2022 11:34:21 -0400
Message-Id: <20220814153431.2379231-21-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220814153431.2379231-1-sashal@kernel.org>
References: <20220814153431.2379231-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Jason A. Donenfeld" <Jason@zx2c4.com>

[ Upstream commit dda520d07b95072a0b63f6c52a8eb566d08ea897 ]

QEMU has a -no-reboot option, which halts instead of reboots when the
guest asks to reboot. This is invaluable when used with
CONFIG_PANIC_TIMEOUT=-1 (and panic_on_warn), because it allows panics
and warnings to be caught immediately in CI. Implement this in UML too,
by way of a basic setup param.

Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/um/os-Linux/skas/process.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/arch/um/os-Linux/skas/process.c b/arch/um/os-Linux/skas/process.c
index 94a7c4125ebc..eecde73b2e78 100644
--- a/arch/um/os-Linux/skas/process.c
+++ b/arch/um/os-Linux/skas/process.c
@@ -5,6 +5,7 @@
  */
 
 #include <stdlib.h>
+#include <stdbool.h>
 #include <unistd.h>
 #include <sched.h>
 #include <errno.h>
@@ -644,10 +645,24 @@ void halt_skas(void)
 	UML_LONGJMP(&initial_jmpbuf, INIT_JMP_HALT);
 }
 
+static bool noreboot;
+
+static int __init noreboot_cmd_param(char *str, int *add)
+{
+	noreboot = true;
+	return 0;
+}
+
+__uml_setup("noreboot", noreboot_cmd_param,
+"noreboot\n"
+"    Rather than rebooting, exit always, akin to QEMU's -no-reboot option.\n"
+"    This is useful if you're using CONFIG_PANIC_TIMEOUT in order to catch\n"
+"    crashes in CI\n");
+
 void reboot_skas(void)
 {
 	block_signals_trace();
-	UML_LONGJMP(&initial_jmpbuf, INIT_JMP_REBOOT);
+	UML_LONGJMP(&initial_jmpbuf, noreboot ? INIT_JMP_HALT : INIT_JMP_REBOOT);
 }
 
 void __switch_mm(struct mm_id *mm_idp)
-- 
2.35.1

