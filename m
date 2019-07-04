Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD13F5F265
	for <lists+stable@lfdr.de>; Thu,  4 Jul 2019 07:51:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725895AbfGDFvz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Jul 2019 01:51:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:53748 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725861AbfGDFvz (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 4 Jul 2019 01:51:55 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DAA12218A6;
        Thu,  4 Jul 2019 05:51:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562219514;
        bh=xeHWgebD2+9bnc78R9auAHmSfRFA4QnpxPuWd75vVa4=;
        h=Subject:To:From:Date:From;
        b=BexXYccVBxDsUwk2G7KYHHTogt8bnihygYcdzUBFC3poW+k26GY1lbyn30PQh6RBu
         M8WzBOQCOY5jkLLwmf30sYBU5gb+ouEAWuQ1TTzF73nH4BgnsOz+/jEygkRBtM5QGx
         9mKs+2D3rdxy+ZmqqedppCsU8pWeOgXDYGVIKTmI=
Subject: patch "drivers: base: cacheinfo: Ensure cpu hotplug work is done before" added to driver-core-next
To:     james.morse@arm.com, fenghua.yu@intel.com,
        gregkh@linuxfoundation.org, reinette.chatre@intel.com,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 04 Jul 2019 07:51:25 +0200
Message-ID: <1562219485222250@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    drivers: base: cacheinfo: Ensure cpu hotplug work is done before

to my driver-core git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/driver-core.git
in the driver-core-next branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will also be merged in the next major kernel release
during the merge window.

If you have any questions about this process, please let me know.


From 83b44fe343b5abfcb1b2261289bd0cfcfcfd60a8 Mon Sep 17 00:00:00 2001
From: James Morse <james.morse@arm.com>
Date: Mon, 24 Jun 2019 18:36:56 +0100
Subject: drivers: base: cacheinfo: Ensure cpu hotplug work is done before
 Intel RDT

The cacheinfo structures are alloced/freed by cpu online/offline
callbacks. Originally these were only used by sysfs to expose the
cache topology to user space. Without any in-kernel dependencies
CPUHP_AP_ONLINE_DYN was an appropriate choice.

resctrl has started using these structures to identify CPUs that
share a cache. It updates its 'domain' structures from cpu
online/offline callbacks. These depend on the cacheinfo structures
(resctrl_online_cpu()->domain_add_cpu()->get_cache_id()->
 get_cpu_cacheinfo()).
These also run as CPUHP_AP_ONLINE_DYN.

Now that there is an in-kernel dependency, move the cacheinfo
work earlier so we know its done before resctrl's CPUHP_AP_ONLINE_DYN
work runs.

Fixes: 2264d9c74dda1 ("x86/intel_rdt: Build structures for each resource based on cache topology")
Cc: <stable@vger.kernel.org>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: Reinette Chatre <reinette.chatre@intel.com>
Signed-off-by: James Morse <james.morse@arm.com>
Link: https://lore.kernel.org/r/20190624173656.202407-1-james.morse@arm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/base/cacheinfo.c   | 3 ++-
 include/linux/cpuhotplug.h | 1 +
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/base/cacheinfo.c b/drivers/base/cacheinfo.c
index a7359535caf5..b444f89a2041 100644
--- a/drivers/base/cacheinfo.c
+++ b/drivers/base/cacheinfo.c
@@ -655,7 +655,8 @@ static int cacheinfo_cpu_pre_down(unsigned int cpu)
 
 static int __init cacheinfo_sysfs_init(void)
 {
-	return cpuhp_setup_state(CPUHP_AP_ONLINE_DYN, "base/cacheinfo:online",
+	return cpuhp_setup_state(CPUHP_AP_BASE_CACHEINFO_ONLINE,
+				 "base/cacheinfo:online",
 				 cacheinfo_cpu_online, cacheinfo_cpu_pre_down);
 }
 device_initcall(cacheinfo_sysfs_init);
diff --git a/include/linux/cpuhotplug.h b/include/linux/cpuhotplug.h
index 6a381594608c..50c893f03c21 100644
--- a/include/linux/cpuhotplug.h
+++ b/include/linux/cpuhotplug.h
@@ -175,6 +175,7 @@ enum cpuhp_state {
 	CPUHP_AP_WATCHDOG_ONLINE,
 	CPUHP_AP_WORKQUEUE_ONLINE,
 	CPUHP_AP_RCUTREE_ONLINE,
+	CPUHP_AP_BASE_CACHEINFO_ONLINE,
 	CPUHP_AP_ONLINE_DYN,
 	CPUHP_AP_ONLINE_DYN_END		= CPUHP_AP_ONLINE_DYN + 30,
 	CPUHP_AP_X86_HPET_ONLINE,
-- 
2.22.0


