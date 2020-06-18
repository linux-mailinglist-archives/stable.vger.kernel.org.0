Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A3471FE6F4
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 04:38:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726899AbgFRChs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 22:37:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:42904 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729158AbgFRBNh (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 21:13:37 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C07F3221EB;
        Thu, 18 Jun 2020 01:13:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592442816;
        bh=w8V3cTH4FJj2K9JiCLrtLjXXfg1XK0Rl1yo5hamlduY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uyMWBSbjABXyGlynbRDNDWGl5kfLLRgPTowTwBJVD98rnW6OyLH+lOSn2PIyd+J9H
         NigPk/ICcq6pqWp+RACr97Oa0zLZx0sp84jaPb+NFb2CexQ7vlQd/t950GXRZrdg6p
         aHuH8rl9eRHnX85PfXOdKuaQFyyUf9uOKxfm/IWg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Juergen Gross <jgross@suse.com>,
        Sasha Levin <sashal@kernel.org>, xen-devel@lists.xenproject.org
Subject: [PATCH AUTOSEL 5.7 254/388] xen/cpuhotplug: Fix initial CPU offlining for PV(H) guests
Date:   Wed, 17 Jun 2020 21:05:51 -0400
Message-Id: <20200618010805.600873-254-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618010805.600873-1-sashal@kernel.org>
References: <20200618010805.600873-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Boris Ostrovsky <boris.ostrovsky@oracle.com>

[ Upstream commit c54b071c192dfe8061336f650ceaf358e6386e0b ]

Commit a926f81d2f6c ("xen/cpuhotplug: Replace cpu_up/down() with
device_online/offline()") replaced cpu_down() with device_offline()
call which requires that the CPU has been registered before. This
registration, however, happens later from topology_init() which
is called as subsys_initcall(). setup_vcpu_hotplug_event(), on the
other hand, is invoked earlier, during arch_initcall().

As result, booting a PV(H) guest with vcpus < maxvcpus causes a crash.

Move setup_vcpu_hotplug_event() (and therefore setup_cpu_watcher()) to
late_initcall(). In addition, instead of performing all offlining steps
in setup_cpu_watcher() simply call disable_hotplug_cpu().

Fixes: a926f81d2f6c (xen/cpuhotplug: Replace cpu_up/down() with device_online/offline()"
Signed-off-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Link: https://lore.kernel.org/r/1588976923-3667-1-git-send-email-boris.ostrovsky@oracle.com
Reviewed-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/xen/cpu_hotplug.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/xen/cpu_hotplug.c b/drivers/xen/cpu_hotplug.c
index ec975decb5de..b96b11e2b571 100644
--- a/drivers/xen/cpu_hotplug.c
+++ b/drivers/xen/cpu_hotplug.c
@@ -93,10 +93,8 @@ static int setup_cpu_watcher(struct notifier_block *notifier,
 	(void)register_xenbus_watch(&cpu_watch);
 
 	for_each_possible_cpu(cpu) {
-		if (vcpu_online(cpu) == 0) {
-			device_offline(get_cpu_device(cpu));
-			set_cpu_present(cpu, false);
-		}
+		if (vcpu_online(cpu) == 0)
+			disable_hotplug_cpu(cpu);
 	}
 
 	return NOTIFY_DONE;
@@ -119,5 +117,5 @@ static int __init setup_vcpu_hotplug_event(void)
 	return 0;
 }
 
-arch_initcall(setup_vcpu_hotplug_event);
+late_initcall(setup_vcpu_hotplug_event);
 
-- 
2.25.1

