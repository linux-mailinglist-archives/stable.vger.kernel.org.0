Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25EF34875F4
	for <lists+stable@lfdr.de>; Fri,  7 Jan 2022 11:56:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237912AbiAGK4e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Jan 2022 05:56:34 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:47196 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237991AbiAGK4d (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 7 Jan 2022 05:56:33 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 94A1160AC9
        for <stable@vger.kernel.org>; Fri,  7 Jan 2022 10:56:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73D98C36AE9;
        Fri,  7 Jan 2022 10:56:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641552993;
        bh=unsz6Fgp+2ILc2NKoJCJ+aVuRYvZnWLFkt1l1NXkeAU=;
        h=Subject:To:Cc:From:Date:From;
        b=p3WtnWDPK0G5F1FGhIjoPEk/rc7rtxCagEb2RG0UMNO4nhIE4NF67yVlrRNc6C7PQ
         Ga/tfrMO5PbEXfudaLi5A+K3z4ascXg1wqeewOoCgm0sgG+md0XEeR0DpN1QPCUy7m
         YZEBOLC7OPLKF7DQ9MoWEVlBporNt1OmKwCCjD8s=
Subject: FAILED: patch "[PATCH] tracing: Tag trace_percpu_buffer as a percpu pointer" failed to apply to 4.4-stable tree
To:     naveen.n.rao@linux.vnet.ibm.com, lkp@intel.com, rostedt@goodmis.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 07 Jan 2022 11:56:30 +0100
Message-ID: <16415529901298@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From f28439db470cca8b6b082239314e9fd10bd39034 Mon Sep 17 00:00:00 2001
From: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
Date: Thu, 23 Dec 2021 16:04:39 +0530
Subject: [PATCH] tracing: Tag trace_percpu_buffer as a percpu pointer

Tag trace_percpu_buffer as a percpu pointer to resolve warnings
reported by sparse:
  /linux/kernel/trace/trace.c:3218:46: warning: incorrect type in initializer (different address spaces)
  /linux/kernel/trace/trace.c:3218:46:    expected void const [noderef] __percpu *__vpp_verify
  /linux/kernel/trace/trace.c:3218:46:    got struct trace_buffer_struct *
  /linux/kernel/trace/trace.c:3234:9: warning: incorrect type in initializer (different address spaces)
  /linux/kernel/trace/trace.c:3234:9:    expected void const [noderef] __percpu *__vpp_verify
  /linux/kernel/trace/trace.c:3234:9:    got int *

Link: https://lkml.kernel.org/r/ebabd3f23101d89cb75671b68b6f819f5edc830b.1640255304.git.naveen.n.rao@linux.vnet.ibm.com

Cc: stable@vger.kernel.org
Reported-by: kernel test robot <lkp@intel.com>
Fixes: 07d777fe8c398 ("tracing: Add percpu buffers for trace_printk()")
Signed-off-by: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index e1f55851e53f..78ea542ce3bc 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -3207,7 +3207,7 @@ struct trace_buffer_struct {
 	char buffer[4][TRACE_BUF_SIZE];
 };
 
-static struct trace_buffer_struct *trace_percpu_buffer;
+static struct trace_buffer_struct __percpu *trace_percpu_buffer;
 
 /*
  * This allows for lockless recording.  If we're nested too deeply, then
@@ -3236,7 +3236,7 @@ static void put_trace_buf(void)
 
 static int alloc_percpu_trace_buffer(void)
 {
-	struct trace_buffer_struct *buffers;
+	struct trace_buffer_struct __percpu *buffers;
 
 	if (trace_percpu_buffer)
 		return 0;

