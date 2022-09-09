Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 866D25B3ED4
	for <lists+stable@lfdr.de>; Fri,  9 Sep 2022 20:31:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229478AbiIISbb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Sep 2022 14:31:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbiIISba (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 9 Sep 2022 14:31:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 303B4AE9E5
        for <stable@vger.kernel.org>; Fri,  9 Sep 2022 11:31:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D62E9B8261B
        for <stable@vger.kernel.org>; Fri,  9 Sep 2022 18:31:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FF05C433C1;
        Fri,  9 Sep 2022 18:31:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662748286;
        bh=rJPo2ViO2XPv7760vNmx0x734OLpSCs8MycDR4jDb2o=;
        h=Subject:To:Cc:From:Date:From;
        b=kD8m/1HSjjuCy8LQ4TkexrSGhJgm3ZH+EHiacHFpPewFZU0sB0+civzUuZHNvMIjn
         H45IbW9qZON2gWPpG/w7z3Im6BtGPvfQDcK36wZHNoqr4PZ+/5POlG1s8Rj576GIV2
         +qhB6f55ZUNjjDkutGWM6F5L6KmXcnEop9b2d+gs=
Subject: FAILED: patch "[PATCH] tracing: hold caller_addr to hardirq_{enable,disable}_ip" failed to apply to 5.15-stable tree
To:     zouyipeng@huawei.com, rostedt@goodmis.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 09 Sep 2022 20:31:23 +0200
Message-ID: <1662748283119130@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

54c3931957f6 ("tracing: hold caller_addr to hardirq_{enable,disable}_ip")
8b023accc8df ("lockdep: Fix -Wunused-parameter for _THIS_IP_")
ef9989afda73 ("kvm: add guest_state_{enter,exit}_irqoff()")
ed922739c919 ("KVM: Use interval tree to do fast hva lookup in memslots")
26b8345abc75 ("KVM: Resolve memslot ID via a hash table instead of via a static array")
1e8617d37fc3 ("KVM: Move WARN on invalid memslot index to update_memslots()")
4e4d30cb9b87 ("KVM: Resync only arch fields when slots_arch_lock gets reacquired")
c5b077549136 ("KVM: Convert the kvm->vcpus array to a xarray")
27592ae8dbe4 ("KVM: Move wiping of the kvm->vcpus array to common code")
bda44d844758 ("KVM: Ensure local memslot copies operate on up-to-date arch-specific data")
99cdc6c18c2d ("RISC-V: Add initial skeletal KVM support")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 54c3931957f6a6194d5972eccc36d052964b2abe Mon Sep 17 00:00:00 2001
From: Yipeng Zou <zouyipeng@huawei.com>
Date: Thu, 1 Sep 2022 18:45:14 +0800
Subject: [PATCH] tracing: hold caller_addr to hardirq_{enable,disable}_ip

Currently, The arguments passing to lockdep_hardirqs_{on,off} was fixed
in CALLER_ADDR0.
The function trace_hardirqs_on_caller should have been intended to use
caller_addr to represent the address that caller wants to be traced.

For example, lockdep log in riscv showing the last {enabled,disabled} at
__trace_hardirqs_{on,off} all the time(if called by):
[   57.853175] hardirqs last  enabled at (2519): __trace_hardirqs_on+0xc/0x14
[   57.853848] hardirqs last disabled at (2520): __trace_hardirqs_off+0xc/0x14

After use trace_hardirqs_xx_caller, we can get more effective information:
[   53.781428] hardirqs last  enabled at (2595): restore_all+0xe/0x66
[   53.782185] hardirqs last disabled at (2596): ret_from_exception+0xa/0x10

Link: https://lkml.kernel.org/r/20220901104515.135162-2-zouyipeng@huawei.com

Cc: stable@vger.kernel.org
Fixes: c3bc8fd637a96 ("tracing: Centralize preemptirq tracepoints and unify their usage")
Signed-off-by: Yipeng Zou <zouyipeng@huawei.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>

diff --git a/kernel/trace/trace_preemptirq.c b/kernel/trace/trace_preemptirq.c
index 95b58bd757ce..1e130da1b742 100644
--- a/kernel/trace/trace_preemptirq.c
+++ b/kernel/trace/trace_preemptirq.c
@@ -95,14 +95,14 @@ __visible void trace_hardirqs_on_caller(unsigned long caller_addr)
 	}
 
 	lockdep_hardirqs_on_prepare();
-	lockdep_hardirqs_on(CALLER_ADDR0);
+	lockdep_hardirqs_on(caller_addr);
 }
 EXPORT_SYMBOL(trace_hardirqs_on_caller);
 NOKPROBE_SYMBOL(trace_hardirqs_on_caller);
 
 __visible void trace_hardirqs_off_caller(unsigned long caller_addr)
 {
-	lockdep_hardirqs_off(CALLER_ADDR0);
+	lockdep_hardirqs_off(caller_addr);
 
 	if (!this_cpu_read(tracing_irq_cpu)) {
 		this_cpu_write(tracing_irq_cpu, 1);

