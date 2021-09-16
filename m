Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB47340E5F8
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:28:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350998AbhIPRQy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 13:16:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:40896 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1351205AbhIPRPQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 13:15:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D06B461B63;
        Thu, 16 Sep 2021 16:39:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631810371;
        bh=4zGDp9DQBCT6MhNwNV6mwLkG2nvXf/iNZYIZcDbNJxU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ksQ7TCdnmE6gvAVmSm0KCIkUona1fiu5CtqZSyI2YfsDmLPbaMJHaLL21CPF66Nv1
         kxudDb530WqCPHhivFCe0H8WE+X27T8zttuv5vBYnwLNhK9ERhYSy2nt3RuhKP6hGj
         wDyfmvKV8c5T0DWYQc6woUy/KAVE6ZKdV28E9TaM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 116/432] platform/x86: ISST: Fix optimization with use of numa
Date:   Thu, 16 Sep 2021 17:57:45 +0200
Message-Id: <20210916155814.698293182@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155810.813340753@linuxfoundation.org>
References: <20210916155810.813340753@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>

[ Upstream commit d36d4a1d75d2a8bd14ec00d5cb0ce166f6886146 ]

When numa is used to map CPU to PCI device, the optimized path to read
from cached data is not working and still calls _isst_if_get_pci_dev().

The reason is that when caching the mapping, numa information is not
available as it is read later. So move the assignment of
isst_cpu_info[cpu].numa_node before calling _isst_if_get_pci_dev().

Fixes: aa2ddd242572 ("platform/x86: ISST: Use numa node id for cpu pci dev mapping")
Signed-off-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Link: https://lore.kernel.org/r/20210727165052.427238-1-srinivas.pandruvada@linux.intel.com
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/intel_speed_select_if/isst_if_common.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/platform/x86/intel_speed_select_if/isst_if_common.c b/drivers/platform/x86/intel_speed_select_if/isst_if_common.c
index 6f0cc679c8e5..8a4d52a9028d 100644
--- a/drivers/platform/x86/intel_speed_select_if/isst_if_common.c
+++ b/drivers/platform/x86/intel_speed_select_if/isst_if_common.c
@@ -379,6 +379,8 @@ static int isst_if_cpu_online(unsigned int cpu)
 	u64 data;
 	int ret;
 
+	isst_cpu_info[cpu].numa_node = cpu_to_node(cpu);
+
 	ret = rdmsrl_safe(MSR_CPU_BUS_NUMBER, &data);
 	if (ret) {
 		/* This is not a fatal error on MSR mailbox only I/F */
@@ -397,7 +399,6 @@ static int isst_if_cpu_online(unsigned int cpu)
 		return ret;
 	}
 	isst_cpu_info[cpu].punit_cpu_id = data;
-	isst_cpu_info[cpu].numa_node = cpu_to_node(cpu);
 
 	isst_restore_msr_local(cpu);
 
-- 
2.30.2



