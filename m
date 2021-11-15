Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E224452448
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 02:34:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356590AbhKPBhF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 20:37:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:50438 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242848AbhKOSq4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:46:56 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 478E36338D;
        Mon, 15 Nov 2021 18:07:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636999642;
        bh=bQfI4NAOYnv+pU89wDqeueLaq2x4Dh4kOz3V+7GHgIQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wUEL7OhnAWEDvquJddts7pF1UOwUkM67P0VU6AM+L9EDqkJrYA6Ms0iS9CanCBA4a
         5Naws7SzctmcCvFfPCdSQOWcBSaXm07mNCP6Z4szn1ubmfeijqOAjN2RelUP/41evE
         QlCgldMP0UyPZsAl0O9Q68YrMaLL/cbY13DwqEoo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Waiman Long <longman@redhat.com>,
        Tejun Heo <tj@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 354/849] cgroup: Make rebind_subsystems() disable v2 controllers all at once
Date:   Mon, 15 Nov 2021 17:57:17 +0100
Message-Id: <20211115165432.208947585@linuxfoundation.org>
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

From: Waiman Long <longman@redhat.com>

[ Upstream commit 7ee285395b211cad474b2b989db52666e0430daf ]

It was found that the following warning was displayed when remounting
controllers from cgroup v2 to v1:

[ 8042.997778] WARNING: CPU: 88 PID: 80682 at kernel/cgroup/cgroup.c:3130 cgroup_apply_control_disable+0x158/0x190
   :
[ 8043.091109] RIP: 0010:cgroup_apply_control_disable+0x158/0x190
[ 8043.096946] Code: ff f6 45 54 01 74 39 48 8d 7d 10 48 c7 c6 e0 46 5a a4 e8 7b 67 33 00 e9 41 ff ff ff 49 8b 84 24 e8 01 00 00 0f b7 40 08 eb 95 <0f> 0b e9 5f ff ff ff 48 83 c4 08 5b 5d 41 5c 41 5d 41 5e 41 5f c3
[ 8043.115692] RSP: 0018:ffffba8a47c23d28 EFLAGS: 00010202
[ 8043.120916] RAX: 0000000000000036 RBX: ffffffffa624ce40 RCX: 000000000000181a
[ 8043.128047] RDX: ffffffffa63c43e0 RSI: ffffffffa63c43e0 RDI: ffff9d7284ee1000
[ 8043.135180] RBP: ffff9d72874c5800 R08: ffffffffa624b090 R09: 0000000000000004
[ 8043.142314] R10: ffffffffa624b080 R11: 0000000000002000 R12: ffff9d7284ee1000
[ 8043.149447] R13: ffff9d7284ee1000 R14: ffffffffa624ce70 R15: ffffffffa6269e20
[ 8043.156576] FS:  00007f7747cff740(0000) GS:ffff9d7a5fc00000(0000) knlGS:0000000000000000
[ 8043.164663] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 8043.170409] CR2: 00007f7747e96680 CR3: 0000000887d60001 CR4: 00000000007706e0
[ 8043.177539] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 8043.184673] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[ 8043.191804] PKRU: 55555554
[ 8043.194517] Call Trace:
[ 8043.196970]  rebind_subsystems+0x18c/0x470
[ 8043.201070]  cgroup_setup_root+0x16c/0x2f0
[ 8043.205177]  cgroup1_root_to_use+0x204/0x2a0
[ 8043.209456]  cgroup1_get_tree+0x3e/0x120
[ 8043.213384]  vfs_get_tree+0x22/0xb0
[ 8043.216883]  do_new_mount+0x176/0x2d0
[ 8043.220550]  __x64_sys_mount+0x103/0x140
[ 8043.224474]  do_syscall_64+0x38/0x90
[ 8043.228063]  entry_SYSCALL_64_after_hwframe+0x44/0xae

It was caused by the fact that rebind_subsystem() disables
controllers to be rebound one by one. If more than one disabled
controllers are originally from the default hierarchy, it means that
cgroup_apply_control_disable() will be called multiple times for the
same default hierarchy. A controller may be killed by css_kill() in
the first round. In the second round, the killed controller may not be
completely dead yet leading to the warning.

To avoid this problem, we collect all the ssid's of controllers that
needed to be disabled from the default hierarchy and then disable them
in one go instead of one by one.

Fixes: 334c3679ec4b ("cgroup: reimplement rebind_subsystems() using cgroup_apply_control() and friends")
Signed-off-by: Waiman Long <longman@redhat.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/cgroup/cgroup.c | 31 +++++++++++++++++++++++++++----
 1 file changed, 27 insertions(+), 4 deletions(-)

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 38750c385dd2c..552d86b6d6c90 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -1726,6 +1726,7 @@ int rebind_subsystems(struct cgroup_root *dst_root, u16 ss_mask)
 	struct cgroup *dcgrp = &dst_root->cgrp;
 	struct cgroup_subsys *ss;
 	int ssid, i, ret;
+	u16 dfl_disable_ss_mask = 0;
 
 	lockdep_assert_held(&cgroup_mutex);
 
@@ -1742,8 +1743,28 @@ int rebind_subsystems(struct cgroup_root *dst_root, u16 ss_mask)
 		/* can't move between two non-dummy roots either */
 		if (ss->root != &cgrp_dfl_root && dst_root != &cgrp_dfl_root)
 			return -EBUSY;
+
+		/*
+		 * Collect ssid's that need to be disabled from default
+		 * hierarchy.
+		 */
+		if (ss->root == &cgrp_dfl_root)
+			dfl_disable_ss_mask |= 1 << ssid;
+
 	} while_each_subsys_mask();
 
+	if (dfl_disable_ss_mask) {
+		struct cgroup *scgrp = &cgrp_dfl_root.cgrp;
+
+		/*
+		 * Controllers from default hierarchy that need to be rebound
+		 * are all disabled together in one go.
+		 */
+		cgrp_dfl_root.subsys_mask &= ~dfl_disable_ss_mask;
+		WARN_ON(cgroup_apply_control(scgrp));
+		cgroup_finalize_control(scgrp, 0);
+	}
+
 	do_each_subsys_mask(ss, ssid, ss_mask) {
 		struct cgroup_root *src_root = ss->root;
 		struct cgroup *scgrp = &src_root->cgrp;
@@ -1752,10 +1773,12 @@ int rebind_subsystems(struct cgroup_root *dst_root, u16 ss_mask)
 
 		WARN_ON(!css || cgroup_css(dcgrp, ss));
 
-		/* disable from the source */
-		src_root->subsys_mask &= ~(1 << ssid);
-		WARN_ON(cgroup_apply_control(scgrp));
-		cgroup_finalize_control(scgrp, 0);
+		if (src_root != &cgrp_dfl_root) {
+			/* disable from the source */
+			src_root->subsys_mask &= ~(1 << ssid);
+			WARN_ON(cgroup_apply_control(scgrp));
+			cgroup_finalize_control(scgrp, 0);
+		}
 
 		/* rebind */
 		RCU_INIT_POINTER(scgrp->subsys[ssid], NULL);
-- 
2.33.0



