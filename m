Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8687A143007
	for <lists+stable@lfdr.de>; Mon, 20 Jan 2020 17:36:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729080AbgATQgm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jan 2020 11:36:42 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:32885 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726876AbgATQgm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jan 2020 11:36:42 -0500
Received: by mail-wr1-f65.google.com with SMTP id b6so160689wrq.0
        for <stable@vger.kernel.org>; Mon, 20 Jan 2020 08:36:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dOkzNM5nxgSk+tKouD8MJc8DJm3w+fMwD4IBQWVE0HI=;
        b=geQD4FlMh5hwtlNh0qJG1Z0u/1zrKbISlLoH/qPVQdR6vrzxfb9djsCDjKdwRh72nX
         vhv8xFRQJAlmI0Dux9MXuC0bmOlbZIlXVGpxCRvjJ0G4qTHTW+/0xsf7h8/5vd0yOH5n
         uixPonZqSLCkAIEcyRuLyvtE93ev0qxhVc4om0ivYaHDtX1MZDw9XdRhj5HFZDRTHIh6
         Rd2QwB6nQuebLjF4HQoXmidPX4c6yPnpfV/h24WHWO7N3/hNXn6eYRG98hdA/3a3UbpU
         go4yQY2g9t5rKp78aS8mfaMQquxXvQGsXWMsPvVS1t7yot5c3TxtinbmLNH2dgWfpGGC
         iKGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dOkzNM5nxgSk+tKouD8MJc8DJm3w+fMwD4IBQWVE0HI=;
        b=fClAEiWf1GTTZm1bC1HN56rQDT1uxotUUNLJpz/jYoyCSuwAqGXHyNFjFB8iXB/7TJ
         LeehU30S1BDYEvU5aPbg0NdsJGJfFb15sFOa047HkcsT3Be3m+XHHnvaAgPMch+jsNkv
         R0rLHCt0yV9o+hDQCHNp3+Z1VbEYH85/O/y/h0OMtR3DhVuvqgQ/gRDr9Cl9JkqS1xQC
         Z2fV/kgCMLP9y38CYGk+uNq2miHugL8yiOQv20OxgTblACyptnAErpuloJVZBva8Bxgd
         2Yr8rDJ+6uB9gktQ7lSxKP/EIqDzj2ey5j+Lnq/YFEM7zijo/9+xMJguSd5bp5e/UduI
         FBXQ==
X-Gm-Message-State: APjAAAUj9i1j5PG4mB8bwwBUZkcwYBizPhEWuKvWsm6cYUkz0C4sJlwl
        uyLUSUPKQJsvJz+Qkx+3+A==
X-Google-Smtp-Source: APXvYqx0pqHT8yYXF47WqCM4x68hp9kZOTqQz/5Vn1VNqAa7k02ydijeniZFEFTwB39UTYAc5JhEDg==
X-Received: by 2002:a5d:6a52:: with SMTP id t18mr312250wrw.391.1579538199728;
        Mon, 20 Jan 2020 08:36:39 -0800 (PST)
Received: from ninjahub.org ([91.235.65.22])
        by smtp.googlemail.com with ESMTPSA id x7sm47089018wrq.41.2020.01.20.08.36.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jan 2020 08:36:39 -0800 (PST)
From:   Jules Irenge <jbi.octave@gmail.com>
To:     jbi.octave@gmail.com
Cc:     "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        stable@vger.kernel.org, kbuild test robot <lkp@intel.com>
Subject: [PATCH 3/7] tracing: Have stack tracer compile when MCOUNT_INSN_SIZE is not defined
Date:   Mon, 20 Jan 2020 16:36:18 +0000
Message-Id: <20200120163622.8603-3-jbi.octave@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200120163622.8603-1-jbi.octave@gmail.com>
References: <20200120163622.8603-1-jbi.octave@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

On some archs with some configurations, MCOUNT_INSN_SIZE is not defined, and
this makes the stack tracer fail to compile. Just define it to zero in this
case.

Link: https://lore.kernel.org/r/202001020219.zvE3vsty%lkp@intel.com

Cc: stable@vger.kernel.org
Fixes: 4df297129f622 ("tracing: Remove most or all of stack tracer stack size from stack_max_size")
Reported-by: kbuild test robot <lkp@intel.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 kernel/trace/trace_stack.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/kernel/trace/trace_stack.c b/kernel/trace/trace_stack.c
index 4df9a209f7ca..c557f42a9397 100644
--- a/kernel/trace/trace_stack.c
+++ b/kernel/trace/trace_stack.c
@@ -283,6 +283,11 @@ static void check_stack(unsigned long ip, unsigned long *stack)
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
-- 
2.24.1

