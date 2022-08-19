Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F34659A056
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 18:33:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350145AbiHSPvO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 11:51:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350427AbiHSPuc (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 11:50:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 921332CE26;
        Fri, 19 Aug 2022 08:48:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0F34C615D5;
        Fri, 19 Aug 2022 15:48:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B969C433C1;
        Fri, 19 Aug 2022 15:48:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660924091;
        bh=Yr7okvVqXnDFjMSzgjiWDpsS49DA0YngByrlZroVnJU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ijMILB8B8skguetVNVT2xFPMt0Al9sFNznmFgBOFl325ZSCwA3/PG5LPrlFs9crqu
         oiVQkqUccyJu+DpHkyWR+9urVqzG16i/zzkkz1TW2kPx9Xdl9VWrKmAWbPEAY6TiFQ
         CxT+a7uQAHuNv9oNh2XFtkH3G5a9YVy4PHZjk2lY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dimitri John Ledkov <dimitri.ledkov@canonical.com>,
        Anup Patel <anup@brainfault.org>,
        Ron Economos <w6rz@comcast.net>,
        Palmer Dabbelt <palmerdabbelt@google.com>,
        Nathan Chancellor <nathan@kernel.org>
Subject: [PATCH 5.10 022/545] riscv: set default pm_power_off to NULL
Date:   Fri, 19 Aug 2022 17:36:32 +0200
Message-Id: <20220819153830.184035307@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220819153829.135562864@linuxfoundation.org>
References: <20220819153829.135562864@linuxfoundation.org>
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

From: Dimitri John Ledkov <dimitri.ledkov@canonical.com>

commit f2928e224d85e7cc139009ab17cefdfec2df5d11 upstream.

Set pm_power_off to NULL like on all other architectures, check if it
is set in machine_halt() and machine_power_off() and fallback to
default_power_off if no other power driver got registered.

This brings riscv architecture inline with all other architectures,
and allows to reuse exiting power drivers unmodified.

Kernels without legacy SBI v0.1 extensions (CONFIG_RISCV_SBI_V01 is
not set), do not set pm_power_off to sbi_shutdown(). There is no
support for SBI v0.3 system reset extension either. This prevents
using gpio_poweroff on SiFive HiFive Unmatched.

Tested on SiFive HiFive unmatched, with a dtb specifying gpio-poweroff
node and kernel complied without CONFIG_RISCV_SBI_V01.

BugLink: https://bugs.launchpad.net/bugs/1942806
Signed-off-by: Dimitri John Ledkov <dimitri.ledkov@canonical.com>
Reviewed-by: Anup Patel <anup@brainfault.org>
Tested-by: Ron Economos <w6rz@comcast.net>
Signed-off-by: Palmer Dabbelt <palmerdabbelt@google.com>
Cc: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/kernel/reset.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

--- a/arch/riscv/kernel/reset.c
+++ b/arch/riscv/kernel/reset.c
@@ -12,7 +12,7 @@ static void default_power_off(void)
 		wait_for_interrupt();
 }
 
-void (*pm_power_off)(void) = default_power_off;
+void (*pm_power_off)(void) = NULL;
 EXPORT_SYMBOL(pm_power_off);
 
 void machine_restart(char *cmd)
@@ -23,10 +23,16 @@ void machine_restart(char *cmd)
 
 void machine_halt(void)
 {
-	pm_power_off();
+	if (pm_power_off != NULL)
+		pm_power_off();
+	else
+		default_power_off();
 }
 
 void machine_power_off(void)
 {
-	pm_power_off();
+	if (pm_power_off != NULL)
+		pm_power_off();
+	else
+		default_power_off();
 }


