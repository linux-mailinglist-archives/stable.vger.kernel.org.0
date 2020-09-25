Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC451277D5C
	for <lists+stable@lfdr.de>; Fri, 25 Sep 2020 03:05:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726829AbgIYBFG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Sep 2020 21:05:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:54456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726703AbgIYBFG (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 24 Sep 2020 21:05:06 -0400
Received: from devnote2 (NE2965lan1.rev.em-net.ne.jp [210.141.244.193])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 771902076B;
        Fri, 25 Sep 2020 01:05:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600995906;
        bh=zTuPaL8d7GGgM01JeuXivhDADH2uzFL/NRnv/oOtjVI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=YCw7ZALpc4tMF6gWLENEKiQnsQoNkgubv8WE6YjxNn+lS6eZotgSGGmdhbYZfWnI4
         GA4oCXHXNJC5pCog+x7BgL3JOaWfwrdJus9K8EekHHQGelcYd23Iyhq+pNvYnXK4jt
         XT81OXH4MF8m7y7k4PE0HjWZoL3Q4IA8eVRb03ow=
Date:   Fri, 25 Sep 2020 10:05:00 +0900
From:   Masami Hiramatsu <mhiramat@kernel.org>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     <gregkh@linuxfoundation.org>, mhiramat@kernel.org,
        songmuchun@bytedance.com, akpm@linux-foundation.org,
        anil.s.keshavamurthy@intel.com, davem@davemloft.net,
        naveen.n.rao@linux.ibm.com, songliubraving@fb.com,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        zhouchengming@bytedance.com
Subject: Re: FAILED: patch
 "[PATCH] kprobes: fix kill kprobe which has been marked as gone" failed to
 apply to 5.4-stable tree
Message-Id: <20200925100500.bfb38fe1227c187861a3e7db@kernel.org>
In-Reply-To: <20200924180606.42c852b6@oasis.local.home>
References: <1600691119190189@kroah.com>
        <20200924180606.42c852b6@oasis.local.home>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 24 Sep 2020 18:06:06 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> On Mon, 21 Sep 2020 14:25:19 +0200
> <gregkh@linuxfoundation.org> wrote:
> 
> > The patch below does not apply to the 5.4-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> > 
> > thanks,
> > 
> > greg k-h
> > 
> 
> 
> The below should apply and work for 5.4 - 4.4.
> 
> Masami, can you verify that I did this correctly. It appears to pass
> all the ftrace tests, at least all the ones that pass without the patch ;-)

Thanks Steve! I think we should keep using hlist_for_each_entry_rcu() unless
backporting commit 7e6a71d8e601 ("kprobes: Use non RCU traversal APIs on
 kprobe_tables if possible") (and this commit involves another improvement.)


From b2dafed7da5e4ee5e82fdfe309d69ca6e189ef0d Mon Sep 17 00:00:00 2001
From: Muchun Song <songmuchun@bytedance.com>
Date: Fri, 18 Sep 2020 21:20:21 -0700
Subject: [PATCH] kprobes: fix kill kprobe which has been marked as gone

If a kprobe is marked as gone, we should not kill it again.  Otherwise, we
can disarm the kprobe more than once.  In that case, the statistics of
kprobe_ftrace_enabled can unbalance which can lead to that kprobe do not
work.

Fixes: e8386a0cb22f ("kprobes: support probing module __exit function")
Co-developed-by: Chengming Zhou <zhouchengming@bytedance.com>
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Chengming Zhou <zhouchengming@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Masami Hiramatsu <mhiramat@kernel.org>
Cc: "Naveen N . Rao" <naveen.n.rao@linux.ibm.com>
Cc: Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Song Liu <songliubraving@fb.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: <stable@vger.kernel.org>
Link: https://lkml.kernel.org/r/20200822030055.32383-1-songmuchun@bytedance.com
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
---
 kernel/kprobes.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index bbff4bccb885..5646f291eb70 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -2088,6 +2088,9 @@ static void kill_kprobe(struct kprobe *p)
 {
 	struct kprobe *kp;
 
+	if (WARN_ON_ONCE(kprobe_gone(p)))
+		return;
+
 	p->flags |= KPROBE_FLAG_GONE;
 	if (kprobe_aggrprobe(p)) {
 		/*
@@ -2270,7 +2273,10 @@ static int kprobes_module_callback(struct notifier_block *nb,
 	mutex_lock(&kprobe_mutex);
 	for (i = 0; i < KPROBE_TABLE_SIZE; i++) {
 		head = &kprobe_table[i];
-		hlist_for_each_entry_rcu(p, head, hlist)
+		hlist_for_each_entry_rcu(p, head, hlist) {
+			if (kprobe_gone(p))
+				continue;
+
 			if (within_module_init((unsigned long)p->addr, mod) ||
 			    (checkcore &&
 			     within_module_core((unsigned long)p->addr, mod))) {
@@ -2287,6 +2293,7 @@ static int kprobes_module_callback(struct notifier_block *nb,
 				 */
 				kill_kprobe(p);
 			}
+		}
 	}
 	mutex_unlock(&kprobe_mutex);
 	return NOTIFY_DONE;
-- 
2.25.1
-- 
Masami Hiramatsu <mhiramat@kernel.org>
