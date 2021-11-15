Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B7764512C5
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 20:41:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347374AbhKOTjs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 14:39:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:44642 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245012AbhKOTSW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:18:22 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B4CF063433;
        Mon, 15 Nov 2021 18:27:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637000823;
        bh=sg1bUQBCpesztslWeZj8wedOnSZRGxGuQVRXlQ2WuSQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=toGKckv5u4zFGEP0CPgYJpz5/6Auj+XOA0jWA6YJfUKDMi2lBYmz57GzrxHf4b0sG
         cvY56FZWtvvoPgWQi/slGLBCKqp+Vc/XZVB8N2M1REWvwR7m+42GM2Ro4w7wX64Zfd
         PbVAoN3GiaA1/5EdIc3JukWF5w+6Vko+cib2gAZ4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+df709157a4ecaf192b03@syzkaller.appspotmail.com,
        syzbot+533f389d4026d86a2a95@syzkaller.appspotmail.com,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>, Tejun Heo <tj@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 805/849] bpf, cgroup: Assign cgroup in cgroup_sk_alloc when called from interrupt
Date:   Mon, 15 Nov 2021 18:04:48 +0100
Message-Id: <20211115165447.467862917@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Borkmann <daniel@iogearbox.net>

[ Upstream commit 78cc316e9583067884eb8bd154301dc1e9ee945c ]

If cgroup_sk_alloc() is called from interrupt context, then just assign the
root cgroup to skcd->cgroup. Prior to commit 8520e224f547 ("bpf, cgroups:
Fix cgroup v2 fallback on v1/v2 mixed mode") we would just return, and later
on in sock_cgroup_ptr(), we were NULL-testing the cgroup in fast-path, and
iff indeed NULL returning the root cgroup (v ?: &cgrp_dfl_root.cgrp). Rather
than re-adding the NULL-test to the fast-path we can just assign it once from
cgroup_sk_alloc() given v1/v2 handling has been simplified. The migration from
NULL test with returning &cgrp_dfl_root.cgrp to assigning &cgrp_dfl_root.cgrp
directly does /not/ change behavior for callers of sock_cgroup_ptr().

syzkaller was able to trigger a splat in the legacy netrom code base, where
the RX handler in nr_rx_frame() calls nr_make_new() which calls sk_alloc()
and therefore cgroup_sk_alloc() with in_interrupt() condition. Thus the NULL
skcd->cgroup, where it trips over on cgroup_sk_free() side given it expects
a non-NULL object. There are a few other candidates aside from netrom which
have similar pattern where in their accept-like implementation, they just call
to sk_alloc() and thus cgroup_sk_alloc() instead of sk_clone_lock() with the
corresponding cgroup_sk_clone() which then inherits the cgroup from the parent
socket. None of them are related to core protocols where BPF cgroup programs
are running from. However, in future, they should follow to implement a similar
inheritance mechanism.

Additionally, with a !CONFIG_CGROUP_NET_PRIO and !CONFIG_CGROUP_NET_CLASSID
configuration, the same issue was exposed also prior to 8520e224f547 due to
commit e876ecc67db8 ("cgroup: memcg: net: do not associate sock with unrelated
cgroup") which added the early in_interrupt() return back then.

Fixes: 8520e224f547 ("bpf, cgroups: Fix cgroup v2 fallback on v1/v2 mixed mode")
Fixes: e876ecc67db8 ("cgroup: memcg: net: do not associate sock with unrelated cgroup")
Reported-by: syzbot+df709157a4ecaf192b03@syzkaller.appspotmail.com
Reported-by: syzbot+533f389d4026d86a2a95@syzkaller.appspotmail.com
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Tested-by: syzbot+df709157a4ecaf192b03@syzkaller.appspotmail.com
Tested-by: syzbot+533f389d4026d86a2a95@syzkaller.appspotmail.com
Acked-by: Tejun Heo <tj@kernel.org>
Link: https://lore.kernel.org/bpf/20210927123921.21535-1-daniel@iogearbox.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/cgroup/cgroup.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 869a16f7684f1..bfbed4c99f166 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -6586,22 +6586,29 @@ int cgroup_parse_float(const char *input, unsigned dec_shift, s64 *v)
 
 void cgroup_sk_alloc(struct sock_cgroup_data *skcd)
 {
-	/* Don't associate the sock with unrelated interrupted task's cgroup. */
-	if (in_interrupt())
-		return;
+	struct cgroup *cgroup;
 
 	rcu_read_lock();
+	/* Don't associate the sock with unrelated interrupted task's cgroup. */
+	if (in_interrupt()) {
+		cgroup = &cgrp_dfl_root.cgrp;
+		cgroup_get(cgroup);
+		goto out;
+	}
+
 	while (true) {
 		struct css_set *cset;
 
 		cset = task_css_set(current);
 		if (likely(cgroup_tryget(cset->dfl_cgrp))) {
-			skcd->cgroup = cset->dfl_cgrp;
-			cgroup_bpf_get(cset->dfl_cgrp);
+			cgroup = cset->dfl_cgrp;
 			break;
 		}
 		cpu_relax();
 	}
+out:
+	skcd->cgroup = cgroup;
+	cgroup_bpf_get(cgroup);
 	rcu_read_unlock();
 }
 
-- 
2.33.0



