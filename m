Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C765F119841
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 22:39:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728470AbfLJViL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 16:38:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:41074 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730236AbfLJVfW (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Dec 2019 16:35:22 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A22FB207FF;
        Tue, 10 Dec 2019 21:35:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576013721;
        bh=ulJhlXXHYMcoZMdsOfGi4cFLx7QCJqnj2AGhY8vpYdI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U9vYdmR2bKaK5DHAuCKhadMDxn0U4bdA4iljr/4k9WaOWu3QD8g+HiLc2NLbKVrNN
         kZuEpyvir38nDdQKZAmdQxAEIl6bRGeSu1+Dqci3eiF9If1CefxHgk/oznh14tnznW
         NKz8uivkNpF559DUj+a7DlEvXfPdNTbLXhSAbOiI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yuming Han <yuming.han@unisoc.com>,
        Chunyan Zhang <chunyan.zhang@unisoc.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 147/177] tracing: use kvcalloc for tgid_map array allocation
Date:   Tue, 10 Dec 2019 16:31:51 -0500
Message-Id: <20191210213221.11921-147-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210213221.11921-1-sashal@kernel.org>
References: <20191210213221.11921-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yuming Han <yuming.han@unisoc.com>

[ Upstream commit 6ee40511cb838f9ced002dff7131bca87e3ccbdd ]

Fail to allocate memory for tgid_map, because it requires order-6 page.
detail as:

c3 sh: page allocation failure: order:6,
   mode:0x140c0c0(GFP_KERNEL), nodemask=(null)
c3 sh cpuset=/ mems_allowed=0
c3 CPU: 3 PID: 5632 Comm: sh Tainted: G        W  O    4.14.133+ #10
c3 Hardware name: Generic DT based system
c3 Backtrace:
c3 [<c010bdbc>] (dump_backtrace) from [<c010c08c>](show_stack+0x18/0x1c)
c3 [<c010c074>] (show_stack) from [<c0993c54>](dump_stack+0x84/0xa4)
c3 [<c0993bd0>] (dump_stack) from [<c0229858>](warn_alloc+0xc4/0x19c)
c3 [<c0229798>] (warn_alloc) from [<c022a6e4>](__alloc_pages_nodemask+0xd18/0xf28)
c3 [<c02299cc>] (__alloc_pages_nodemask) from [<c0248344>](kmalloc_order+0x20/0x38)
c3 [<c0248324>] (kmalloc_order) from [<c0248380>](kmalloc_order_trace+0x24/0x108)
c3 [<c024835c>] (kmalloc_order_trace) from [<c01e6078>](set_tracer_flag+0xb0/0x158)
c3 [<c01e5fc8>] (set_tracer_flag) from [<c01e6404>](trace_options_core_write+0x7c/0xcc)
c3 [<c01e6388>] (trace_options_core_write) from [<c0278b1c>](__vfs_write+0x40/0x14c)
c3 [<c0278adc>] (__vfs_write) from [<c0278e10>](vfs_write+0xc4/0x198)
c3 [<c0278d4c>] (vfs_write) from [<c027906c>](SyS_write+0x6c/0xd0)
c3 [<c0279000>] (SyS_write) from [<c01079a0>](ret_fast_syscall+0x0/0x54)

Switch to use kvcalloc to avoid unexpected allocation failures.

Link: http://lkml.kernel.org/r/1571888070-24425-1-git-send-email-chunyan.zhang@unisoc.com

Signed-off-by: Yuming Han <yuming.han@unisoc.com>
Signed-off-by: Chunyan Zhang <chunyan.zhang@unisoc.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index bdd7f3d78724e..b6ff2f84df174 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -4389,7 +4389,7 @@ int set_tracer_flag(struct trace_array *tr, unsigned int mask, int enabled)
 
 	if (mask == TRACE_ITER_RECORD_TGID) {
 		if (!tgid_map)
-			tgid_map = kcalloc(PID_MAX_DEFAULT + 1,
+			tgid_map = kvcalloc(PID_MAX_DEFAULT + 1,
 					   sizeof(*tgid_map),
 					   GFP_KERNEL);
 		if (!tgid_map) {
-- 
2.20.1

