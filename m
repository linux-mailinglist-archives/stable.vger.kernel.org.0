Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8822F6C52A
	for <lists+stable@lfdr.de>; Thu, 18 Jul 2019 05:07:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389299AbfGRDDZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jul 2019 23:03:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:34050 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389252AbfGRDDY (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jul 2019 23:03:24 -0400
Received: from localhost (115.42.148.210.bf.2iij.net [210.148.42.115])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5BF692173B;
        Thu, 18 Jul 2019 03:03:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563419004;
        bh=PG3T8mXmGSKOIY8ZLT45pOA+wxybHzy/qkPK3tpEaWE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aZx7/l7cmmOOivGKNWf6vMzb+kMnPU5DpRGjL/XOIjKbt/2txuHlwfimCxuqRObyI
         aKoIqZusVSpuu1TvChQgLSBZDEyYAIPHlaDG5bdPAJfrusfHdPVrP2k5tuulcQhQLI
         JF/MU3+hNY28eUX4R/iagsurUFzmmffQgSIQ2PJA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Fenghua Yu <fenghua.yu@intel.com>,
        Reinette Chatre <reinette.chatre@intel.com>,
        James Morse <james.morse@arm.com>
Subject: [PATCH 5.2 05/21] drivers: base: cacheinfo: Ensure cpu hotplug work is done before Intel RDT
Date:   Thu, 18 Jul 2019 12:01:23 +0900
Message-Id: <20190718030031.591880791@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190718030030.456918453@linuxfoundation.org>
References: <20190718030030.456918453@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Morse <james.morse@arm.com>

commit 83b44fe343b5abfcb1b2261289bd0cfcfcfd60a8 upstream.

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
 drivers/base/cacheinfo.c   |    3 ++-
 include/linux/cpuhotplug.h |    1 +
 2 files changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/base/cacheinfo.c
+++ b/drivers/base/cacheinfo.c
@@ -655,7 +655,8 @@ static int cacheinfo_cpu_pre_down(unsign
 
 static int __init cacheinfo_sysfs_init(void)
 {
-	return cpuhp_setup_state(CPUHP_AP_ONLINE_DYN, "base/cacheinfo:online",
+	return cpuhp_setup_state(CPUHP_AP_BASE_CACHEINFO_ONLINE,
+				 "base/cacheinfo:online",
 				 cacheinfo_cpu_online, cacheinfo_cpu_pre_down);
 }
 device_initcall(cacheinfo_sysfs_init);
--- a/include/linux/cpuhotplug.h
+++ b/include/linux/cpuhotplug.h
@@ -176,6 +176,7 @@ enum cpuhp_state {
 	CPUHP_AP_WATCHDOG_ONLINE,
 	CPUHP_AP_WORKQUEUE_ONLINE,
 	CPUHP_AP_RCUTREE_ONLINE,
+	CPUHP_AP_BASE_CACHEINFO_ONLINE,
 	CPUHP_AP_ONLINE_DYN,
 	CPUHP_AP_ONLINE_DYN_END		= CPUHP_AP_ONLINE_DYN + 30,
 	CPUHP_AP_X86_HPET_ONLINE,


