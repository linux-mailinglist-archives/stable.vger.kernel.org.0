Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 380136CC33B
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 16:52:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233469AbjC1OwZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 10:52:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233478AbjC1OwH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 10:52:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F86EE05D
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 07:51:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 82E94B81D68
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 14:51:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4A5CC433D2;
        Tue, 28 Mar 2023 14:51:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680015113;
        bh=F0ukMBHO/kPpbe6k3DjTflDUCcbuGBOy15vOvYd6NWE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VyOfjE8L0cz32XsnbUi4F+ehLJxv/OlDQ88bSAnEkL3bPBvM40eFGHnNKXtTc5QL9
         LaVKPCZAKvZmBPCBTR4pYQOdWaiy34O0fT5vB4SytzdIiKobeB/vUidG3IhTByv/Rs
         5rD/PZzPHaHwdmPTkrP515W89ImqwxoK36FZoFDo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Eero Tamminen <oak@helsinkinet.fi>,
        Michael Schmitz <schmitzmic@gmail.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 139/240] m68k: Only force 030 bus error if PC not in exception table
Date:   Tue, 28 Mar 2023 16:41:42 +0200
Message-Id: <20230328142625.541034353@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142619.643313678@linuxfoundation.org>
References: <20230328142619.643313678@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
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
index 5c8cba0efc63e..a700807c9b6d9 100644
--- a/arch/m68k/kernel/traps.c
+++ b/arch/m68k/kernel/traps.c
@@ -30,6 +30,7 @@
 #include <linux/init.h>
 #include <linux/ptrace.h>
 #include <linux/kallsyms.h>
+#include <linux/extable.h>
 
 #include <asm/setup.h>
 #include <asm/fpu.h>
@@ -545,7 +546,8 @@ static inline void bus_error030 (struct frame *fp)
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



