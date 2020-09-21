Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5BC6272F1A
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 18:55:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728915AbgIUQxu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 12:53:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:53360 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729750AbgIUQqw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 12:46:52 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ED3A52223E;
        Mon, 21 Sep 2020 16:46:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600706811;
        bh=bsM2ZZAYSVxxRVUa1+U+KJ9VruWG1WgnYmFSrTI7X/c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qr+GxdM44Xf+H5HIS1gRH5OveVNhlleGNisPzA7BJiwW+oq1w70w4CEmebEDF6+BY
         VpuObnjPLHGH/qqD3nQhIQU4MtVlC/HZWeUn9d9dXBczSFakiFnA/bBLvVgZKSglG4
         A8emaEo9NJnI9yLD+76zs0zI7ZFYcRYmxHZOlz+k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Muchun Song <songmuchun@bytedance.com>,
        Chengming Zhou <zhouchengming@bytedance.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        "Naveen N . Rao" <naveen.n.rao@linux.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Song Liu <songliubraving@fb.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.8 104/118] kprobes: fix kill kprobe which has been marked as gone
Date:   Mon, 21 Sep 2020 18:28:36 +0200
Message-Id: <20200921162041.210437979@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200921162036.324813383@linuxfoundation.org>
References: <20200921162036.324813383@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Muchun Song <songmuchun@bytedance.com>

commit b0399092ccebd9feef68d4ceb8d6219a8c0caa05 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/kprobes.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -2108,6 +2108,9 @@ static void kill_kprobe(struct kprobe *p
 
 	lockdep_assert_held(&kprobe_mutex);
 
+	if (WARN_ON_ONCE(kprobe_gone(p)))
+		return;
+
 	p->flags |= KPROBE_FLAG_GONE;
 	if (kprobe_aggrprobe(p)) {
 		/*
@@ -2365,7 +2368,10 @@ static int kprobes_module_callback(struc
 	mutex_lock(&kprobe_mutex);
 	for (i = 0; i < KPROBE_TABLE_SIZE; i++) {
 		head = &kprobe_table[i];
-		hlist_for_each_entry(p, head, hlist)
+		hlist_for_each_entry(p, head, hlist) {
+			if (kprobe_gone(p))
+				continue;
+
 			if (within_module_init((unsigned long)p->addr, mod) ||
 			    (checkcore &&
 			     within_module_core((unsigned long)p->addr, mod))) {
@@ -2382,6 +2388,7 @@ static int kprobes_module_callback(struc
 				 */
 				kill_kprobe(p);
 			}
+		}
 	}
 	if (val == MODULE_STATE_GOING)
 		remove_module_kprobe_blacklist(mod);


