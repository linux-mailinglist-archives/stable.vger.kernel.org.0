Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E044D39A74B
	for <lists+stable@lfdr.de>; Thu,  3 Jun 2021 19:10:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232047AbhFCRKz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Jun 2021 13:10:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:42392 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232078AbhFCRKl (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Jun 2021 13:10:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D8DCE613F8;
        Thu,  3 Jun 2021 17:08:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622740134;
        bh=oP5uqppbhMT+aMCdFfU/PluXUbOZINnOeEafkkCOHEQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lCpkdBJR17ILU0CbaOoVaxKuSfAQ5luBGxwVihg3FK9HLJiAXDUBzZ0ixuuQOLDIk
         uCzQuT1RvGJloaIS2kAbV4stAU9/bI2HvGDEQg6+XMV5cfOjSnZzMuDr3UuD0yAJOO
         ngpdWkzGD+BrYH4TDPV/3U3bUt3nIYaBCxXSNZpSzQEdbHaykp5bkaa8cXKo9dVElq
         ltJyay8UvIrs5uyO/wZCh9A9wBNejn/YVLq4Dm/Igt7o/Eq2iMmWt8C6rMZYvGNjPB
         lBRhjp7eIcb94Jsh97ABcOMSnwkm7RkBRMbrgP7uzA4yjNnU/YD2lThsUpIhjyxHNv
         dfleeGnmUIzGA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Shakeel Butt <shakeelb@google.com>,
        NOMURA JUNICHI <junichi.nomura@nec.com>,
        Tejun Heo <tj@kernel.org>, Sasha Levin <sashal@kernel.org>,
        cgroups@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 20/39] cgroup: disable controllers at parse time
Date:   Thu,  3 Jun 2021 13:08:10 -0400
Message-Id: <20210603170829.3168708-20-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210603170829.3168708-1-sashal@kernel.org>
References: <20210603170829.3168708-1-sashal@kernel.org>
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
 kernel/cgroup/cgroup.c | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 5d1fdf7c3ec6..c8b811e039cc 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -5665,8 +5665,6 @@ int __init cgroup_init_early(void)
 	return 0;
 }
 
-static u16 cgroup_disable_mask __initdata;
-
 /**
  * cgroup_init - cgroup initialization
  *
@@ -5725,12 +5723,8 @@ int __init cgroup_init(void)
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
 
 		if (cgroup1_ssid_disabled(ssid))
 			printk(KERN_INFO "Disabling %s control group subsystem in v1 mounts\n",
@@ -6245,7 +6239,10 @@ static int __init cgroup_disable(char *str)
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

