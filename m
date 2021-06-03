Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4D1239A895
	for <lists+stable@lfdr.de>; Thu,  3 Jun 2021 19:22:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233302AbhFCRQZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Jun 2021 13:16:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:43672 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232238AbhFCROS (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Jun 2021 13:14:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7B48C6140B;
        Thu,  3 Jun 2021 17:11:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622740262;
        bh=QoxxFQ0dAv0B4Il9IHIAqp5Qvs1fImb2V7//DS7Y33k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q7NCV4qI2vG+3GQ2pZY9Lex1ZHRJPF72G7Uh1gxESsLMvMlSRoxIWxcOz6PANQKAh
         2yB/RzI0gRgekFYI6Zxj8G2rq6lNKWzcWCPFpQH8lZPBja+mmAjHJDWPG0Dr8HxMTc
         gga08wvWbLzSqqVsNKnsX+TU+fiiBXmxyHWQ/Sixf+TSSpE+ONTpp4uUaK61ydd8uT
         I9UY7jsUnhWCdYINc6bnNwhByCrjuBJkFsJH96uQuk3nzwT0H2zl4gw94yoo6tHTLq
         rtXLPNPQvcvusbQdI5cYhZT6t4Dju4kdpcNAcK6fmUMCbFNwp89qF85mqQ2Cb7S4ND
         U/AKStlRUZM+g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Shakeel Butt <shakeelb@google.com>,
        NOMURA JUNICHI <junichi.nomura@nec.com>,
        Tejun Heo <tj@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.9 07/17] cgroup: disable controllers at parse time
Date:   Thu,  3 Jun 2021 13:10:42 -0400
Message-Id: <20210603171052.3169893-7-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210603171052.3169893-1-sashal@kernel.org>
References: <20210603171052.3169893-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shakeel Butt <shakeelb@google.com>

[ Upstream commit 45e1ba40837ac2f6f4d4716bddb8d44bd7e4a251 ]

This patch effectively reverts the commit a3e72739b7a7 ("cgroup: fix
too early usage of static_branch_disable()"). The commit 6041186a3258
("init: initialize jump labels before command line option parsing") has
moved the jump_label_init() before parse_args() which has made the
commit a3e72739b7a7 unnecessary. On the other hand there are
consequences of disabling the controllers later as there are subsystems
doing the controller checks for different decisions. One such incident
is reported [1] regarding the memory controller and its impact on memory
reclaim code.

[1] https://lore.kernel.org/linux-mm/921e53f3-4b13-aab8-4a9e-e83ff15371e4@nec.com

Signed-off-by: Shakeel Butt <shakeelb@google.com>
Reported-by: NOMURA JUNICHI(野村　淳一) <junichi.nomura@nec.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Tested-by: Jun'ichi Nomura <junichi.nomura@nec.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/cgroup.c | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 684d02f343b4..3e0fca894a8b 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -5636,8 +5636,6 @@ int __init cgroup_init_early(void)
 	return 0;
 }
 
-static u16 cgroup_disable_mask __initdata;
-
 /**
  * cgroup_init - cgroup initialization
  *
@@ -5695,12 +5693,8 @@ int __init cgroup_init(void)
 		 * disabled flag and cftype registration needs kmalloc,
 		 * both of which aren't available during early_init.
 		 */
-		if (cgroup_disable_mask & (1 << ssid)) {
-			static_branch_disable(cgroup_subsys_enabled_key[ssid]);
-			printk(KERN_INFO "Disabling %s control group subsystem\n",
-			       ss->name);
+		if (!cgroup_ssid_enabled(ssid))
 			continue;
-		}
 
 		if (cgroup_ssid_no_v1(ssid))
 			printk(KERN_INFO "Disabling %s control group subsystem in v1 mounts\n",
@@ -6143,7 +6137,10 @@ static int __init cgroup_disable(char *str)
 			if (strcmp(token, ss->name) &&
 			    strcmp(token, ss->legacy_name))
 				continue;
-			cgroup_disable_mask |= 1 << i;
+
+			static_branch_disable(cgroup_subsys_enabled_key[i]);
+			pr_info("Disabling %s control group subsystem\n",
+				ss->name);
 		}
 	}
 	return 1;
-- 
2.30.2

