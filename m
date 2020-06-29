Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 682F720E6C2
	for <lists+stable@lfdr.de>; Tue, 30 Jun 2020 00:09:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727770AbgF2VuW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 17:50:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:56790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726684AbgF2Sfl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 14:35:41 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 82C50246A8;
        Mon, 29 Jun 2020 15:20:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593444001;
        bh=PubSyzXcRX96TmBkcmiWN+8QzQTbnj2lvtz2yyYNxAk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CQU5Uxf0zkXsujOx1L5sbgpWqydSnHwaJEqPeL8K5L8xJkKh0stUuiyHdMwwKea81
         XGGz1uEpzduT4iwWFu10J7U1ShfNBwRyhBbR+UevrXiyxvDdC5AfQLMPklE+MC0ruT
         rjFDwXkbGQLNRSDQz3RDagHrJOGLy/OvyAX1/gW8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Reinette Chatre <reinette.chatre@intel.com>,
        Borislav Petkov <bp@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 106/265] x86/resctrl: Support CPUID enumeration of MBM counter width
Date:   Mon, 29 Jun 2020 11:15:39 -0400
Message-Id: <20200629151818.2493727-107-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629151818.2493727-1-sashal@kernel.org>
References: <20200629151818.2493727-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.7.7-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.7.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.7.7-rc1
X-KernelTest-Deadline: 2020-07-01T15:14+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Reinette Chatre <reinette.chatre@intel.com>

[ Upstream commit f3d44f18b0662327c42128b9d3604489bdb6e36f ]

The original Memory Bandwidth Monitoring (MBM) architectural
definition defines counters of up to 62 bits in the
IA32_QM_CTR MSR while the first-generation MBM implementation
uses statically defined 24 bit counters.

Expand the MBM CPUID enumeration properties to include the MBM
counter width. The previously undefined EAX output register contains,
in bits [7:0], the MBM counter width encoded as an offset from
24 bits. Enumerating this property is only specified for Intel
CPUs.

Suggested-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Link: https://lkml.kernel.org/r/afa3af2f753f6bc301fb743bc8944e749cb24afa.1588715690.git.reinette.chatre@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/include/asm/processor.h   | 3 ++-
 arch/x86/kernel/cpu/resctrl/core.c | 5 +++++
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index 3bcf27caf6c9f..c4e8fd709cf67 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -113,9 +113,10 @@ struct cpuinfo_x86 {
 	/* in KB - valid for CPUS which support this call: */
 	unsigned int		x86_cache_size;
 	int			x86_cache_alignment;	/* In bytes */
-	/* Cache QoS architectural values: */
+	/* Cache QoS architectural values, valid only on the BSP: */
 	int			x86_cache_max_rmid;	/* max index */
 	int			x86_cache_occ_scale;	/* scale to bytes */
+	int			x86_cache_mbm_width_offset;
 	int			x86_power;
 	unsigned long		loops_per_jiffy;
 	/* cpuid returned max cores value: */
diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index 49599733fa94d..d242e864726c0 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -963,6 +963,7 @@ void resctrl_cpu_detect(struct cpuinfo_x86 *c)
 	if (!cpu_has(c, X86_FEATURE_CQM_LLC)) {
 		c->x86_cache_max_rmid  = -1;
 		c->x86_cache_occ_scale = -1;
+		c->x86_cache_mbm_width_offset = -1;
 		return;
 	}
 
@@ -979,6 +980,10 @@ void resctrl_cpu_detect(struct cpuinfo_x86 *c)
 
 		c->x86_cache_max_rmid  = ecx;
 		c->x86_cache_occ_scale = ebx;
+		if (c->x86_vendor == X86_VENDOR_INTEL)
+			c->x86_cache_mbm_width_offset = eax & 0xff;
+		else
+			c->x86_cache_mbm_width_offset = -1;
 	}
 }
 
-- 
2.25.1

