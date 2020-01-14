Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8655A13A631
	for <lists+stable@lfdr.de>; Tue, 14 Jan 2020 11:24:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729497AbgANKKE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jan 2020 05:10:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:43484 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729963AbgANKKC (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Jan 2020 05:10:02 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E275F24676;
        Tue, 14 Jan 2020 10:10:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578996602;
        bh=kzrT3qT3qSemd6xAxlmFMym2JQwhldvlctsOG+uH+kQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ERdXhwawLd1qLG4yd5vRyvRrEqwV87/53GherzdWVNZzVxJrLYbb+yOSiYWicWJlz
         6j+7p1B9lp2beH44xZ/JZtb/+ijXAqx+LAS5zBzDhDYEbiTCBJ4lfLK9qCMBCtnXD1
         gj1hpju8LAGKwLzZhyf/bLz0etc96yVsPVJGdZy8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kbuild test robot <lkp@intel.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 4.14 07/39] tracing: Have stack tracer compile when MCOUNT_INSN_SIZE is not defined
Date:   Tue, 14 Jan 2020 11:01:41 +0100
Message-Id: <20200114094340.869652496@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200114094336.210038037@linuxfoundation.org>
References: <20200114094336.210038037@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steven Rostedt (VMware) <rostedt@goodmis.org>

commit b8299d362d0837ae39e87e9019ebe6b736e0f035 upstream.

On some archs with some configurations, MCOUNT_INSN_SIZE is not defined, and
this makes the stack tracer fail to compile. Just define it to zero in this
case.

Link: https://lore.kernel.org/r/202001020219.zvE3vsty%lkp@intel.com

Cc: stable@vger.kernel.org
Fixes: 4df297129f622 ("tracing: Remove most or all of stack tracer stack size from stack_max_size")
Reported-by: kbuild test robot <lkp@intel.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/trace/trace_stack.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/kernel/trace/trace_stack.c
+++ b/kernel/trace/trace_stack.c
@@ -196,6 +196,11 @@ check_stack(unsigned long ip, unsigned l
 	local_irq_restore(flags);
 }
 
+/* Some archs may not define MCOUNT_INSN_SIZE */
+#ifndef MCOUNT_INSN_SIZE
+# define MCOUNT_INSN_SIZE 0
+#endif
+
 static void
 stack_trace_call(unsigned long ip, unsigned long parent_ip,
 		 struct ftrace_ops *op, struct pt_regs *pt_regs)


