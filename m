Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 23858C184C
	for <lists+stable@lfdr.de>; Sun, 29 Sep 2019 19:43:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729669AbfI2RcL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Sep 2019 13:32:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:42948 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729662AbfI2RcK (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Sep 2019 13:32:10 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7AF3921928;
        Sun, 29 Sep 2019 17:32:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569778330;
        bh=BEnfgb96q4UyJzbI8cOPcJZOQlozNTSU2+Qi33Sg6eg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GUWQdNzkezozomdseBJU/lyal1lO7XmQVIg9iyWxnB4JAcvJ9kwGuCdh2LZbJrRMO
         pnBEmU8P0WO5ndKPrE7AN6cxyOtquFAGPoIDMnUMsQHEj0SMKnKnUaGfaoiN3tPz0d
         ZoxOw4ziiFt9MC36aQoeUUYgdBeGa4q0to9av6GM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Youquan Song <youquan.song@intel.com>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>,
        platform-driver-x86@vger.kernel.org
Subject: [PATCH AUTOSEL 5.3 40/49] tools/power/x86/intel-speed-select: Fix high priority core mask over count
Date:   Sun, 29 Sep 2019 13:30:40 -0400
Message-Id: <20190929173053.8400-40-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190929173053.8400-1-sashal@kernel.org>
References: <20190929173053.8400-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Youquan Song <youquan.song@intel.com>

[ Upstream commit 44460efe44e05eae2f21e57d06d542bbbb792e65 ]

If the CPU package has the less logical CPU than topo_max_cpus, but un-present
CPU's punit_cpu_core will be initiated to 0 and they will be count to core 0

Like below, there are only 10 high priority cores (20 logical CPUs) in the CPU
package, but it count to 27 logic CPUs.

./intel-speed-select base-freq info -l 0 | grep mask
        high-priority-cpu-mask:7f000179,f000179f

With the fix patch:
./intel-speed-select base-freq info -l 0
        high-priority-cpu-mask:00000179,f000179f

Signed-off-by: Youquan Song <youquan.song@intel.com>
Signed-off-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/power/x86/intel-speed-select/isst-config.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/power/x86/intel-speed-select/isst-config.c b/tools/power/x86/intel-speed-select/isst-config.c
index 91c5ad1685a15..a6b1487b5f0f6 100644
--- a/tools/power/x86/intel-speed-select/isst-config.c
+++ b/tools/power/x86/intel-speed-select/isst-config.c
@@ -402,6 +402,9 @@ void set_cpu_mask_from_punit_coremask(int cpu, unsigned long long core_mask,
 			int j;
 
 			for (j = 0; j < topo_max_cpus; ++j) {
+				if (!CPU_ISSET_S(j, present_cpumask_size, present_cpumask))
+					continue;
+
 				if (cpu_map[j].pkg_id == pkg_id &&
 				    cpu_map[j].die_id == die_id &&
 				    cpu_map[j].punit_cpu_core == i) {
-- 
2.20.1

