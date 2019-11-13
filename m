Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5128BFA4F8
	for <lists+stable@lfdr.de>; Wed, 13 Nov 2019 03:20:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727934AbfKMByl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Nov 2019 20:54:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:45646 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728928AbfKMByj (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Nov 2019 20:54:39 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2C03B222D3;
        Wed, 13 Nov 2019 01:54:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573610078;
        bh=dK+rVcll+nkPzN51xRG+DpwYGJuH74V97/lT28cg95M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L2oU0TZKQFoy6un9BjiVtcSF3wpPmJXMA5kDOvqJd396htbovK0CblH2IG4mbxI3a
         GXb2rk5sGadjyubNYXlRkegkweXP6jGPSmdBHgEWoIWvZ/TmOfxJHq0PWy54O85Czk
         jGcqDsS2S/fP9WsJPuU1iPfFG20Nkpytk5M70wg4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Reinette Chatre <reinette.chatre@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jithu Joseph <jithu.joseph@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>, tony.luck@intel.com,
        gavin.hindman@intel.com, dave.hansen@intel.com, hpa@zytor.com,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 153/209] x86/intel_rdt: Introduce utility to obtain CDP peer
Date:   Tue, 12 Nov 2019 20:49:29 -0500
Message-Id: <20191113015025.9685-153-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191113015025.9685-1-sashal@kernel.org>
References: <20191113015025.9685-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Reinette Chatre <reinette.chatre@intel.com>

[ Upstream commit 521348b011d64cf3febb10b64ba5b472681bef94 ]

Introduce a utility that, when provided with a RDT resource and an
instance of this RDT resource (a RDT domain), would return pointers to
the RDT resource and RDT domain that share the same hardware. This is
specific to the CDP resources that share the same hardware.

For example, if a pointer to the RDT_RESOURCE_L2DATA resource (struct
rdt_resource) and a pointer to an instance of this resource (struct
rdt_domain) is provided, then it will return a pointer to the
RDT_RESOURCE_L2CODE resource as well as the specific instance that
shares the same hardware as the provided rdt_domain.

This utility is created in support of the "exclusive" resource group
mode where overlap of resource allocation between resource groups need
to be avoided. The overlap test need to consider not just the matching
resources, but also the resources that share the same hardware.

Temporarily mark it as unused in support of patch testing to avoid
compile warnings until it is used.

Fixes: 49f7b4efa110 ("x86/intel_rdt: Enable setting of exclusive mode")
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Jithu Joseph <jithu.joseph@intel.com>
Acked-by: Fenghua Yu <fenghua.yu@intel.com>
Cc: tony.luck@intel.com
Cc: gavin.hindman@intel.com
Cc: dave.hansen@intel.com
Cc: hpa@zytor.com
Link: https://lkml.kernel.org/r/9b4bc4d59ba2e903b6a3eb17e16ef41a8e7b7c3e.1538603665.git.reinette.chatre@intel.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/cpu/intel_rdt_rdtgroup.c | 72 ++++++++++++++++++++++++
 1 file changed, 72 insertions(+)

diff --git a/arch/x86/kernel/cpu/intel_rdt_rdtgroup.c b/arch/x86/kernel/cpu/intel_rdt_rdtgroup.c
index 2013699a5c54a..bf15ffc1248fd 100644
--- a/arch/x86/kernel/cpu/intel_rdt_rdtgroup.c
+++ b/arch/x86/kernel/cpu/intel_rdt_rdtgroup.c
@@ -964,6 +964,78 @@ static int rdtgroup_mode_show(struct kernfs_open_file *of,
 	return 0;
 }
 
+/**
+ * rdt_cdp_peer_get - Retrieve CDP peer if it exists
+ * @r: RDT resource to which RDT domain @d belongs
+ * @d: Cache instance for which a CDP peer is requested
+ * @r_cdp: RDT resource that shares hardware with @r (RDT resource peer)
+ *         Used to return the result.
+ * @d_cdp: RDT domain that shares hardware with @d (RDT domain peer)
+ *         Used to return the result.
+ *
+ * RDT resources are managed independently and by extension the RDT domains
+ * (RDT resource instances) are managed independently also. The Code and
+ * Data Prioritization (CDP) RDT resources, while managed independently,
+ * could refer to the same underlying hardware. For example,
+ * RDT_RESOURCE_L2CODE and RDT_RESOURCE_L2DATA both refer to the L2 cache.
+ *
+ * When provided with an RDT resource @r and an instance of that RDT
+ * resource @d rdt_cdp_peer_get() will return if there is a peer RDT
+ * resource and the exact instance that shares the same hardware.
+ *
+ * Return: 0 if a CDP peer was found, <0 on error or if no CDP peer exists.
+ *         If a CDP peer was found, @r_cdp will point to the peer RDT resource
+ *         and @d_cdp will point to the peer RDT domain.
+ */
+static int __attribute__((unused)) rdt_cdp_peer_get(struct rdt_resource *r,
+						    struct rdt_domain *d,
+						    struct rdt_resource **r_cdp,
+						    struct rdt_domain **d_cdp)
+{
+	struct rdt_resource *_r_cdp = NULL;
+	struct rdt_domain *_d_cdp = NULL;
+	int ret = 0;
+
+	switch (r->rid) {
+	case RDT_RESOURCE_L3DATA:
+		_r_cdp = &rdt_resources_all[RDT_RESOURCE_L3CODE];
+		break;
+	case RDT_RESOURCE_L3CODE:
+		_r_cdp =  &rdt_resources_all[RDT_RESOURCE_L3DATA];
+		break;
+	case RDT_RESOURCE_L2DATA:
+		_r_cdp =  &rdt_resources_all[RDT_RESOURCE_L2CODE];
+		break;
+	case RDT_RESOURCE_L2CODE:
+		_r_cdp =  &rdt_resources_all[RDT_RESOURCE_L2DATA];
+		break;
+	default:
+		ret = -ENOENT;
+		goto out;
+	}
+
+	/*
+	 * When a new CPU comes online and CDP is enabled then the new
+	 * RDT domains (if any) associated with both CDP RDT resources
+	 * are added in the same CPU online routine while the
+	 * rdtgroup_mutex is held. It should thus not happen for one
+	 * RDT domain to exist and be associated with its RDT CDP
+	 * resource but there is no RDT domain associated with the
+	 * peer RDT CDP resource. Hence the WARN.
+	 */
+	_d_cdp = rdt_find_domain(_r_cdp, d->id, NULL);
+	if (WARN_ON(!_d_cdp)) {
+		_r_cdp = NULL;
+		ret = -EINVAL;
+	}
+
+out:
+	*r_cdp = _r_cdp;
+	*d_cdp = _d_cdp;
+
+	return ret;
+}
+
 /**
  * rdtgroup_cbm_overlaps - Does CBM for intended closid overlap with other
  * @r: Resource to which domain instance @d belongs.
-- 
2.20.1

