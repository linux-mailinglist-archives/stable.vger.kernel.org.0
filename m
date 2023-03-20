Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36B586C0815
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 02:06:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231211AbjCTBGB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 19 Mar 2023 21:06:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231350AbjCTBD1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 19 Mar 2023 21:03:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6C0623A61;
        Sun, 19 Mar 2023 17:57:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4DD10B80D48;
        Mon, 20 Mar 2023 00:56:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A8F9C433D2;
        Mon, 20 Mar 2023 00:56:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679273806;
        bh=HFFX2fAl8OfFHPhOUngXFoLexJdmRG+1d1kDH9UkmiM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DwQazwDvfDO6Fgi9gq88vkxtvfX9VeyrAKDEYxvnkZkdAbmxsvhuhwPit0SEfjiMZ
         LlgzwnI19PISrzMyYwjvrh8MpYn8vGscma7I15ycRa4fwbyKIAQICt4etd63SyX5On
         JKUyjTEQlAByOnI5QOnLyAS9h1deTd2yWsVOiaJDw8+j3J6WVcb3TV3VZ8yvxvjHE6
         nZJGkhdEoI9s+oovzxyf/RKnETmQfWscXYc6zf1ZeRjGn95UKz/e5dxtq7IlPA0c28
         bsz7wlkBdAtPYL1J2zFjGxEd7Vf5BL2RkJ5gFuqGQwxgzpsGDJ8XzmEvrX1a4IOoLI
         nRnfwiBJmY79g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Michael Schmitz <schmitzmic@gmail.com>,
        Eero Tamminen <oak@helsinkinet.fi>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Sasha Levin <sashal@kernel.org>, laurent@vivier.eu,
        linux-m68k@lists.linux-m68k.org
Subject: [PATCH AUTOSEL 5.4 04/12] m68k: Only force 030 bus error if PC not in exception table
Date:   Sun, 19 Mar 2023 20:56:27 -0400
Message-Id: <20230320005636.1429242-4-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230320005636.1429242-1-sashal@kernel.org>
References: <20230320005636.1429242-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Schmitz <schmitzmic@gmail.com>

[ Upstream commit e36a82bebbf7da814530d5a179bef9df5934b717 ]

__get_kernel_nofault() does copy data in supervisor mode when
forcing a task backtrace log through /proc/sysrq_trigger.
This is expected cause a bus error exception on e.g. NULL
pointer dereferencing when logging a kernel task has no
workqueue associated. This bus error ought to be ignored.

Our 030 bus error handler is ill equipped to deal with this:

Whenever ssw indicates a kernel mode access on a data fault,
we don't even attempt to handle the fault and instead always
send a SEGV signal (or panic). As a result, the check
for exception handling at the fault PC (buried in
send_sig_fault() which gets called from do_page_fault()
eventually) is never used.

In contrast, both 040 and 060 access error handlers do not
care whether a fault happened on supervisor mode access,
and will call do_page_fault() on those, ultimately honoring
the exception table.

Add a check in bus_error030 to call do_page_fault() in case
we do have an entry for the fault PC in our exception table.

I had attempted a fix for this earlier in 2019 that did rely
on testing pagefault_disabled() (see link below) to achieve
the same thing, but this patch should be more generic.

Tested on 030 Atari Falcon.

Reported-by: Eero Tamminen <oak@helsinkinet.fi>
Link: https://lore.kernel.org/r/alpine.LNX.2.21.1904091023540.25@nippy.intranet
Link: https://lore.kernel.org/r/63130691-1984-c423-c1f2-73bfd8d3dcd3@gmail.com
Signed-off-by: Michael Schmitz <schmitzmic@gmail.com>
Reviewed-by: Geert Uytterhoeven <geert@linux-m68k.org>
Link: https://lore.kernel.org/r/20230301021107.26307-1-schmitzmic@gmail.com
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/m68k/kernel/traps.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/m68k/kernel/traps.c b/arch/m68k/kernel/traps.c
index a245c1933d418..5bf314871e9f6 100644
--- a/arch/m68k/kernel/traps.c
+++ b/arch/m68k/kernel/traps.c
@@ -30,6 +30,7 @@
 #include <linux/init.h>
 #include <linux/ptrace.h>
 #include <linux/kallsyms.h>
+#include <linux/extable.h>
 
 #include <asm/setup.h>
 #include <asm/fpu.h>
@@ -550,7 +551,8 @@ static inline void bus_error030 (struct frame *fp)
 			errorcode |= 2;
 
 		if (mmusr & (MMU_I | MMU_WP)) {
-			if (ssw & 4) {
+			/* We might have an exception table for this PC */
+			if (ssw & 4 && !search_exception_tables(fp->ptregs.pc)) {
 				pr_err("Data %s fault at %#010lx in %s (pc=%#lx)\n",
 				       ssw & RW ? "read" : "write",
 				       fp->un.fmtb.daddr,
-- 
2.39.2

