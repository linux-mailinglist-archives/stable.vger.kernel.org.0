Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B5EF2065D5
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 23:51:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389164AbgFWVeA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 17:34:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:52526 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387959AbgFWULO (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:11:14 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 67522206C3;
        Tue, 23 Jun 2020 20:11:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592943074;
        bh=6fgwNHIPBD3Hm7mVgFrD5Kbkh58GId9eslARor0a9SY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XTAnwwSHNPSVT2u3EiKoOweKbM5uo9ciGKpagF5bJzD/YV539lD6PwBbJ3+NWuUdq
         BiuFJSGGquIGj+J4MYUVkwazLHNv4Xw7orDIx626M4sedHmokWkOTHXtRApGXmCLaG
         ioxkGZvPsmEwbWAyHenNnygARqv8TNxmSzp85Htk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Juergen Gross <jgross@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 250/477] xen/cpuhotplug: Fix initial CPU offlining for PV(H) guests
Date:   Tue, 23 Jun 2020 21:54:07 +0200
Message-Id: <20200623195419.386921653@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195407.572062007@linuxfoundation.org>
References: <20200623195407.572062007@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index ec975decb5def..b96b11e2b571d 100644
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



