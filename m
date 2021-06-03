Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98F2439A83E
	for <lists+stable@lfdr.de>; Thu,  3 Jun 2021 19:22:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232783AbhFCROZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Jun 2021 13:14:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:42778 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232789AbhFCRNG (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Jun 2021 13:13:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7E9B7613F1;
        Thu,  3 Jun 2021 17:10:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622740240;
        bh=Qr9pE1eXosZU4d7fe/+B6rCTVSYSYg7RlK/F8Cv6GlU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WLWC7tG0tq4IdvfuKoXyY2QiiFuHMiTSXHXS+oOTeI4ToBFALB1ePxuWL0G13kYcm
         7PYxKGDyqeKjPgvEJQZ+22923QDBl2FVa8E0mseRRBUeFdKAJKoWLRgKh4mnh6Fmxh
         C1KamRcZqISa8IljdL5af9TeVgQPPyN7rexjKgaj0OxFy7EbPM9sJ7x5r5GIeFjBu8
         lCv8XI2QsEgR449U+2WPpVxK28jdoZ3mUCa1EHJ9OC+C2IFho52kZKEulYJ8RYz/fN
         eI0JFPdHWERuhpi5xEoKoTtMv2VOuRedgAMEDJsWJjAUcb5sYAnS+0Hcz67NA3BYEv
         lCx7YgPrQPfaA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Shakeel Butt <shakeelb@google.com>,
        NOMURA JUNICHI <junichi.nomura@nec.com>,
        Tejun Heo <tj@kernel.org>, Sasha Levin <sashal@kernel.org>,
        cgroups@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 08/18] cgroup: disable controllers at parse time
Date:   Thu,  3 Jun 2021 13:10:19 -0400
Message-Id: <20210603171029.3169669-8-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210603171029.3169669-1-sashal@kernel.org>
References: <20210603171029.3169669-1-sashal@kernel.org>
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
index ada060e628ce..99783685f3d9 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -5219,8 +5219,6 @@ int __init cgroup_init_early(void)
 	return 0;
 }
 
-static u16 cgroup_disable_mask __initdata;
-
 /**
  * cgroup_init - cgroup initialization
  *
@@ -5278,12 +5276,8 @@ int __init cgroup_init(void)
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
@@ -5642,7 +5636,10 @@ static int __init cgroup_disable(char *str)
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

