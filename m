Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DBD9C12C521
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 18:41:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729108AbfL2ReE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:34:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:36640 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729341AbfL2ReD (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:34:03 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EB03620722;
        Sun, 29 Dec 2019 17:34:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577640842;
        bh=rUUCdtKigrJ3fjJAqcT3oCeJoZaLGwC5NsEBQHBw/ZA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KfRVsE6b1Fy/S248zXskkkXSiddBGSCr3LNqdPzzpqppnNxaIbR8fczJik9J8ThUZ
         SPIzk1Wg2Py+1vamsSUzdzZ3sBknPgLuuVu2R6h3pGIzO8UW3KpwPqUWhBfsTFqsjW
         cmF6f7zwbzAWrliEiU1pgouAA0snEc+/Zr98GuCQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yuming Han <yuming.han@unisoc.com>,
        Chunyan Zhang <chunyan.zhang@unisoc.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 160/219] tracing: use kvcalloc for tgid_map array allocation
Date:   Sun, 29 Dec 2019 18:19:22 +0100
Message-Id: <20191229162532.825769004@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229162508.458551679@linuxfoundation.org>
References: <20191229162508.458551679@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index bdd7f3d78724..b6ff2f84df17 100644
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



