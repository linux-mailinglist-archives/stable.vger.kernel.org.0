Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B64D61EFB1B
	for <lists+stable@lfdr.de>; Fri,  5 Jun 2020 16:24:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727925AbgFEOXW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Jun 2020 10:23:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:48740 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728639AbgFEOSR (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Jun 2020 10:18:17 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0BE9C20B80;
        Fri,  5 Jun 2020 14:18:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591366696;
        bh=bzdURzsQT6ilulB11ifWFwLDB9/zOSNFrKnb+ypWqfI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TGDUdn/Ipr6MYL2V+X+/fSgPqClYqmPW2ZlwrtSeVWpFNYYCLakJyJn6KwRtAQ/lL
         Lh2Ms+Cqhaem+rK4UQw90LBTJjvxOpewulv1Lgg5JNdN5AkWJZjLy31UN1uvpkzhfN
         /WFjAVs7iQ/D1beIc6PVWpSrkxPI6ecv3Pwtablk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Anju T Sudhakar <anju@linux.vnet.ibm.com>,
        Nageswara R Sastry <nasastry@in.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 17/38] powerpc/powernv: Avoid re-registration of imc debugfs directory
Date:   Fri,  5 Jun 2020 16:15:00 +0200
Message-Id: <20200605140253.599469499@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200605140252.542768750@linuxfoundation.org>
References: <20200605140252.542768750@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anju T Sudhakar <anju@linux.vnet.ibm.com>

[ Upstream commit 48e626ac85b43cc589dd1b3b8004f7f85f03544d ]

export_imc_mode_and_cmd() function which creates the debugfs interface
for imc-mode and imc-command, is invoked when each nest pmu units is
registered.

When the first nest pmu unit is registered, export_imc_mode_and_cmd()
creates 'imc' directory under `/debug/powerpc/`. In the subsequent
invocations debugfs_create_dir() function returns, since the directory
already exists.

The recent commit <c33d442328f55> (debugfs: make error message a bit
more verbose), throws a warning if we try to invoke
`debugfs_create_dir()` with an already existing directory name.

Address this warning by making the debugfs directory registration in
the opal_imc_counters_probe() function, i.e invoke
export_imc_mode_and_cmd() function from the probe function.

Signed-off-by: Anju T Sudhakar <anju@linux.vnet.ibm.com>
Tested-by: Nageswara R Sastry <nasastry@in.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20191127072035.4283-1-anju@linux.vnet.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/platforms/powernv/opal-imc.c | 39 ++++++++++-------------
 1 file changed, 16 insertions(+), 23 deletions(-)

diff --git a/arch/powerpc/platforms/powernv/opal-imc.c b/arch/powerpc/platforms/powernv/opal-imc.c
index 7ccc5c85c74e..000b350d4060 100644
--- a/arch/powerpc/platforms/powernv/opal-imc.c
+++ b/arch/powerpc/platforms/powernv/opal-imc.c
@@ -59,10 +59,6 @@ static void export_imc_mode_and_cmd(struct device_node *node,
 
 	imc_debugfs_parent = debugfs_create_dir("imc", powerpc_debugfs_root);
 
-	/*
-	 * Return here, either because 'imc' directory already exists,
-	 * Or failed to create a new one.
-	 */
 	if (!imc_debugfs_parent)
 		return;
 
@@ -135,7 +131,6 @@ static int imc_get_mem_addr_nest(struct device_node *node,
 	}
 
 	pmu_ptr->imc_counter_mmaped = true;
-	export_imc_mode_and_cmd(node, pmu_ptr);
 	kfree(base_addr_arr);
 	kfree(chipid_arr);
 	return 0;
@@ -151,7 +146,7 @@ static int imc_get_mem_addr_nest(struct device_node *node,
  *		    and domain as the inputs.
  * Allocates memory for the struct imc_pmu, sets up its domain, size and offsets
  */
-static int imc_pmu_create(struct device_node *parent, int pmu_index, int domain)
+static struct imc_pmu *imc_pmu_create(struct device_node *parent, int pmu_index, int domain)
 {
 	int ret = 0;
 	struct imc_pmu *pmu_ptr;
@@ -159,27 +154,23 @@ static int imc_pmu_create(struct device_node *parent, int pmu_index, int domain)
 
 	/* Return for unknown domain */
 	if (domain < 0)
-		return -EINVAL;
+		return NULL;
 
 	/* memory for pmu */
 	pmu_ptr = kzalloc(sizeof(*pmu_ptr), GFP_KERNEL);
 	if (!pmu_ptr)
-		return -ENOMEM;
+		return NULL;
 
 	/* Set the domain */
 	pmu_ptr->domain = domain;
 
 	ret = of_property_read_u32(parent, "size", &pmu_ptr->counter_mem_size);
-	if (ret) {
-		ret = -EINVAL;
+	if (ret)
 		goto free_pmu;
-	}
 
 	if (!of_property_read_u32(parent, "offset", &offset)) {
-		if (imc_get_mem_addr_nest(parent, pmu_ptr, offset)) {
-			ret = -EINVAL;
+		if (imc_get_mem_addr_nest(parent, pmu_ptr, offset))
 			goto free_pmu;
-		}
 	}
 
 	/* Function to register IMC pmu */
@@ -190,14 +181,14 @@ static int imc_pmu_create(struct device_node *parent, int pmu_index, int domain)
 		if (pmu_ptr->domain == IMC_DOMAIN_NEST)
 			kfree(pmu_ptr->mem_info);
 		kfree(pmu_ptr);
-		return ret;
+		return NULL;
 	}
 
-	return 0;
+	return pmu_ptr;
 
 free_pmu:
 	kfree(pmu_ptr);
-	return ret;
+	return NULL;
 }
 
 static void disable_nest_pmu_counters(void)
@@ -254,6 +245,7 @@ int get_max_nest_dev(void)
 static int opal_imc_counters_probe(struct platform_device *pdev)
 {
 	struct device_node *imc_dev = pdev->dev.of_node;
+	struct imc_pmu *pmu;
 	int pmu_count = 0, domain;
 	bool core_imc_reg = false, thread_imc_reg = false;
 	u32 type;
@@ -269,6 +261,7 @@ static int opal_imc_counters_probe(struct platform_device *pdev)
 	}
 
 	for_each_compatible_node(imc_dev, NULL, IMC_DTB_UNIT_COMPAT) {
+		pmu = NULL;
 		if (of_property_read_u32(imc_dev, "type", &type)) {
 			pr_warn("IMC Device without type property\n");
 			continue;
@@ -300,9 +293,13 @@ static int opal_imc_counters_probe(struct platform_device *pdev)
 			break;
 		}
 
-		if (!imc_pmu_create(imc_dev, pmu_count, domain)) {
-			if (domain == IMC_DOMAIN_NEST)
+		pmu = imc_pmu_create(imc_dev, pmu_count, domain);
+		if (pmu != NULL) {
+			if (domain == IMC_DOMAIN_NEST) {
+				if (!imc_debugfs_parent)
+					export_imc_mode_and_cmd(imc_dev, pmu);
 				pmu_count++;
+			}
 			if (domain == IMC_DOMAIN_CORE)
 				core_imc_reg = true;
 			if (domain == IMC_DOMAIN_THREAD)
@@ -310,10 +307,6 @@ static int opal_imc_counters_probe(struct platform_device *pdev)
 		}
 	}
 
-	/* If none of the nest units are registered, remove debugfs interface */
-	if (pmu_count == 0)
-		debugfs_remove_recursive(imc_debugfs_parent);
-
 	/* If core imc is not registered, unregister thread-imc */
 	if (!core_imc_reg && thread_imc_reg)
 		unregister_thread_imc();
-- 
2.25.1



