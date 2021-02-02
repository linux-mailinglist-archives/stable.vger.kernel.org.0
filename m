Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90FF930CE5E
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 23:04:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234181AbhBBWCx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 17:02:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:58644 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234291AbhBBWCD (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Feb 2021 17:02:03 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 60AEF64F90;
        Tue,  2 Feb 2021 22:01:22 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94)
        (envelope-from <rostedt@goodmis.org>)
        id 1l73jd-0096zq-DL; Tue, 02 Feb 2021 17:01:21 -0500
Message-ID: <20210202220121.298286520@goodmis.org>
User-Agent: quilt/0.66
Date:   Tue, 02 Feb 2021 16:59:53 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-kernel@vger.kernel.org
Cc:     Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable@vger.kernel.org,
        "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        Ananth N Mavinakayanahalli <ananth@linux.ibm.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Wang ShaoBo <bobo.shaobowang@huawei.com>,
        Cheng Jian <cj.chengjian@huawei.com>
Subject: [for-linus][PATCH 4/5] kretprobe: Avoid re-registration of the same kretprobe earlier
References: <20210202215949.848582355@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wang ShaoBo <bobo.shaobowang@huawei.com>

Our system encountered a re-init error when re-registering same kretprobe,
where the kretprobe_instance in rp->free_instances is illegally accessed
after re-init.

Implementation to avoid re-registration has been introduced for kprobe
before, but lags for register_kretprobe(). We must check if kprobe has
been re-registered before re-initializing kretprobe, otherwise it will
destroy the data struct of kretprobe registered, which can lead to memory
leak, system crash, also some unexpected behaviors.

We use check_kprobe_rereg() to check if kprobe has been re-registered
before running register_kretprobe()'s body, for giving a warning message
and terminate registration process.

Link: https://lkml.kernel.org/r/20210128124427.2031088-1-bobo.shaobowang@huawei.com

Cc: stable@vger.kernel.org
Fixes: 1f0ab40976460 ("kprobes: Prevent re-registration of the same kprobe")
[ The above commit should have been done for kretprobes too ]
Acked-by: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
Acked-by: Ananth N Mavinakayanahalli <ananth@linux.ibm.com>
Acked-by: Masami Hiramatsu <mhiramat@kernel.org>
Signed-off-by: Wang ShaoBo <bobo.shaobowang@huawei.com>
Signed-off-by: Cheng Jian <cj.chengjian@huawei.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 kernel/kprobes.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index 1a5bc321e0a5..d5a3eb74a657 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -1994,6 +1994,10 @@ int register_kretprobe(struct kretprobe *rp)
 	if (ret)
 		return ret;
 
+	/* If only rp->kp.addr is specified, check reregistering kprobes */
+	if (rp->kp.addr && check_kprobe_rereg(&rp->kp))
+		return -EINVAL;
+
 	if (kretprobe_blacklist_size) {
 		addr = kprobe_addr(&rp->kp);
 		if (IS_ERR(addr))
-- 
2.29.2


