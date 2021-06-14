Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 538C03A635E
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 13:11:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234833AbhFNLMK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 07:12:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:42830 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235629AbhFNLLA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 07:11:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5BD7C61944;
        Mon, 14 Jun 2021 10:47:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623667656;
        bh=gK/PIRaPplH2AOarruFJFMSYjmI7TyAu/ZGffVNZ/Hg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RiMko76fTkLxADR73QGFuXsqVF7MKuR1TWyVmk/4JAy7HjK/3w0pyQ/mxr570l3xI
         TrcUS9TCLwmPUv5zmQoYHd4tQ8D6mrTgzXfwLXs7eZoMEOXhmj8RjeyC3+i8DNhcaB
         BLoXinWS0UjaqTRTk3G5wTRNluHb7DkCBpDdtpOs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shakeel Butt <shakeelb@google.com>,
        =?UTF-8?q?NOMURA=20JUNICHI ?= <junichi.nomura@nec.com>,
        Tejun Heo <tj@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 023/173] cgroup: disable controllers at parse time
Date:   Mon, 14 Jun 2021 12:25:55 +0200
Message-Id: <20210614102658.915601054@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210614102658.137943264@linuxfoundation.org>
References: <20210614102658.137943264@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 9153b20e5cc6..2529d1f88330 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -5626,8 +5626,6 @@ int __init cgroup_init_early(void)
 	return 0;
 }
 
-static u16 cgroup_disable_mask __initdata;
-
 /**
  * cgroup_init - cgroup initialization
  *
@@ -5686,12 +5684,8 @@ int __init cgroup_init(void)
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
@@ -6206,7 +6200,10 @@ static int __init cgroup_disable(char *str)
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



