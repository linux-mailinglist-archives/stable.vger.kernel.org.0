Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9550C2CA7B0
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 17:05:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391994AbgLAQBo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 11:01:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:42714 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391983AbgLAQB2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Dec 2020 11:01:28 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DC32622244;
        Tue,  1 Dec 2020 16:00:07 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94)
        (envelope-from <rostedt@goodmis.org>)
        id 1kk84U-002R9O-Pz; Tue, 01 Dec 2020 11:00:06 -0500
Message-ID: <20201201160006.643788057@goodmis.org>
User-Agent: quilt/0.66
Date:   Tue, 01 Dec 2020 10:58:46 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-kernel@vger.kernel.org
Cc:     Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable@vger.kernel.org,
        "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
Subject: [for-linus][PATCH 11/12] ftrace: Fix DYNAMIC_FTRACE_WITH_DIRECT_CALLS dependency
References: <20201201155835.647858317@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>

DYNAMIC_FTRACE_WITH_DIRECT_CALLS should depend on
DYNAMIC_FTRACE_WITH_REGS since we need ftrace_regs_caller().

Link: https://lkml.kernel.org/r/fc4b257ea8689a36f086d2389a9ed989496ca63a.1606412433.git.naveen.n.rao@linux.vnet.ibm.com

Cc: stable@vger.kernel.org
Fixes: 763e34e74bb7d5c ("ftrace: Add register_ftrace_direct()")
Signed-off-by: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 kernel/trace/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
index a4020c0b4508..e1bf5228fb69 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -202,7 +202,7 @@ config DYNAMIC_FTRACE_WITH_REGS
 
 config DYNAMIC_FTRACE_WITH_DIRECT_CALLS
 	def_bool y
-	depends on DYNAMIC_FTRACE
+	depends on DYNAMIC_FTRACE_WITH_REGS
 	depends on HAVE_DYNAMIC_FTRACE_WITH_DIRECT_CALLS
 
 config FUNCTION_PROFILER
-- 
2.28.0


