Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC03F6AF0DA
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:37:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231401AbjCGSgs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:36:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233062AbjCGSfF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:35:05 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1481B8629;
        Tue,  7 Mar 2023 10:27:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5D7CA6154C;
        Tue,  7 Mar 2023 18:26:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FD54C433EF;
        Tue,  7 Mar 2023 18:26:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678213614;
        bh=9Rd0waOKcoTHm8nXq0CQ+JjvJSAFcyFasPghAfRA24Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PWoErDlS171rDZXBk8GIXjkcm8vU1120CCDp7w4cMTwr8Wo/lk0sdT/oL0/wuZfnM
         NQD9sBWE7quFexzQEO43LK6axMVy3DXnTK1rPP+4K7s/PNuzx6kFgEyAvA2p0JryuE
         HlrXsNe+D/pQrxpqcRxM1c7VeJEmp2UutL+PcNGY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Mark Rutland <mark.rutland@arm.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Florent Revest <revest@chromium.org>,
        Len Brown <lenb@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Robert Moore <robert.moore@intel.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Will Deacon <will@kernel.org>, linux-acpi@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 563/885] ACPI: Dont build ACPICA with -Os
Date:   Tue,  7 Mar 2023 17:58:17 +0100
Message-Id: <20230307170026.914609218@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mark Rutland <mark.rutland@arm.com>

[ Upstream commit 8f9e0a52810dd83406c768972d022c37e7a18f1f ]

The ACPICA code has been built with '-Os' since the beginning of git
history, though there's no explanatory comment as to why.

This is unfortunate as GCC drops the alignment specificed by
'-falign-functions=N' when '-Os' is used, as reported in GCC bug 88345:

  https://gcc.gnu.org/bugzilla/show_bug.cgi?id=88345

This prevents CONFIG_FUNCTION_ALIGNMENT and
CONFIG_DEBUG_FORCE_FUNCTION_ALIGN_64B from having their expected effect
on the ACPICA code. This is doubly unfortunate as in subsequent patches
arm64 will depend upon CONFIG_FUNCTION_ALIGNMENT for its ftrace
implementation.

Drop the '-Os' flag when building the ACPICA code. With this removed,
the code builds cleanly and works correctly in testing so far.

I've tested this by selecting CONFIG_DEBUG_FORCE_FUNCTION_ALIGN_64B=y,
building and booting a kernel using ACPI, and looking for misaligned
text symbols:

* arm64:

  Before, v6.2-rc3:
    # uname -rm
    6.2.0-rc3 aarch64
    # grep ' [Tt] ' /proc/kallsyms | grep -iv '[048c]0 [Tt] ' | wc -l
    5009

  Before, v6.2-rc3 + fixed __cold:
    # uname -rm
    6.2.0-rc3-00001-g2a2bedf8bfa9 aarch64
    # grep ' [Tt] ' /proc/kallsyms | grep -iv '[048c]0 [Tt] ' | wc -l
    919

  After:
    # uname -rm
    6.2.0-rc3-00002-g267bddc38572 aarch64
    # grep ' [Tt] ' /proc/kallsyms | grep -iv '[048c]0 [Tt] ' | wc -l
    323
    # grep ' [Tt] ' /proc/kallsyms | grep -iv '[048c]0 [Tt] ' | grep acpi | wc -l
    0

* x86_64:

  Before, v6.2-rc3:
    # uname -rm
    6.2.0-rc3 x86_64
    # grep ' [Tt] ' /proc/kallsyms | grep -iv '[048c]0 [Tt] ' | wc -l
    11537

  Before, v6.2-rc3 + fixed __cold:
    # uname -rm
    6.2.0-rc3-00001-g2a2bedf8bfa9 x86_64
    # grep ' [Tt] ' /proc/kallsyms | grep -iv '[048c]0 [Tt] ' | wc -l
    2805

  After:
    # uname -rm
    6.2.0-rc3-00002-g267bddc38572 x86_64
    # grep ' [Tt] ' /proc/kallsyms | grep -iv '[048c]0 [Tt] ' | wc -l
    1357
    # grep ' [Tt] ' /proc/kallsyms | grep -iv '[048c]0 [Tt] ' | grep acpi | wc -l
    0

With the patch applied, the remaining unaligned text labels are a
combination of static call trampolines and labels in assembly, which can
be dealt with in subsequent patches.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Cc: Florent Revest <revest@chromium.org>
Cc: Len Brown <lenb@kernel.org>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Robert Moore <robert.moore@intel.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Will Deacon <will@kernel.org>
Cc: linux-acpi@vger.kernel.org
Link: https://lore.kernel.org/r/20230123134603.1064407-4-mark.rutland@arm.com
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/acpica/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/acpi/acpica/Makefile b/drivers/acpi/acpica/Makefile
index 59700433a96e5..f919811156b1f 100644
--- a/drivers/acpi/acpica/Makefile
+++ b/drivers/acpi/acpica/Makefile
@@ -3,7 +3,7 @@
 # Makefile for ACPICA Core interpreter
 #
 
-ccflags-y			:= -Os -D_LINUX -DBUILDING_ACPICA
+ccflags-y			:= -D_LINUX -DBUILDING_ACPICA
 ccflags-$(CONFIG_ACPI_DEBUG)	+= -DACPI_DEBUG_OUTPUT
 
 # use acpi.o to put all files here into acpi.o modparam namespace
-- 
2.39.2



