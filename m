Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11FDD29B3B4
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 15:56:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1752418AbgJ0Oyb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:54:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:50824 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1773149AbgJ0Ovb (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:51:31 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AD411206E5;
        Tue, 27 Oct 2020 14:51:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603810291;
        bh=jROyRl4IlFQlr/eDMRaZS7v3bR7TJkmvLMc6pNifok0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OoIQ3CbqybCBOoDP4xqckojBFh07wxy7ocKdAnvgL63d5NSL1oGKZIGpZ+3fXISHl
         tJDZp5HWLqcg5KHA7O9nKICC9Uhwb4G1XD/OIOZ32BCSlntDyKer0FpuKmajmqYpgX
         VHOnaaJhHJHQz7E6NmrTXeTavpjtML1BWUAznBhA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mark Salter <msalter@redhat.com>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 088/633] drivers/perf: xgene_pmu: Fix uninitialized resource struct
Date:   Tue, 27 Oct 2020 14:47:11 +0100
Message-Id: <20201027135526.822598645@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135522.655719020@linuxfoundation.org>
References: <20201027135522.655719020@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mark Salter <msalter@redhat.com>

[ Upstream commit a76b8236edcf5b785d044b930f9e14ad02b4a484 ]

This splat was reported on newer Fedora kernels booting on certain
X-gene based machines:

 xgene-pmu APMC0D83:00: X-Gene PMU version 3
 Unable to handle kernel read from unreadable memory at virtual \
 address 0000000000004006
 ...
 Call trace:
  string+0x50/0x100
  vsnprintf+0x160/0x750
  devm_kvasprintf+0x5c/0xb4
  devm_kasprintf+0x54/0x60
  __devm_ioremap_resource+0xdc/0x1a0
  devm_ioremap_resource+0x14/0x20
  acpi_get_pmu_hw_inf.isra.0+0x84/0x15c
  acpi_pmu_dev_add+0xbc/0x21c
  acpi_ns_walk_namespace+0x16c/0x1e4
  acpi_walk_namespace+0xb4/0xfc
  xgene_pmu_probe_pmu_dev+0x7c/0xe0
  xgene_pmu_probe.part.0+0x2c0/0x310
  xgene_pmu_probe+0x54/0x64
  platform_drv_probe+0x60/0xb4
  really_probe+0xe8/0x4a0
  driver_probe_device+0xe4/0x100
  device_driver_attach+0xcc/0xd4
  __driver_attach+0xb0/0x17c
  bus_for_each_dev+0x6c/0xb0
  driver_attach+0x30/0x40
  bus_add_driver+0x154/0x250
  driver_register+0x84/0x140
  __platform_driver_register+0x54/0x60
  xgene_pmu_driver_init+0x28/0x34
  do_one_initcall+0x40/0x204
  do_initcalls+0x104/0x144
  kernel_init_freeable+0x198/0x210
  kernel_init+0x20/0x12c
  ret_from_fork+0x10/0x18
 Code: 91000400 110004e1 eb08009f 540000c0 (38646846)
 ---[ end trace f08c10566496a703 ]---

This is due to use of an uninitialized local resource struct in the xgene
pmu driver. The thunderx2_pmu driver avoids this by using the resource list
constructed by acpi_dev_get_resources() rather than using a callback from
that function. The callback in the xgene driver didn't fully initialize
the resource. So get rid of the callback and search the resource list as
done by thunderx2.

Fixes: 832c927d119b ("perf: xgene: Add APM X-Gene SoC Performance Monitoring Unit driver")
Signed-off-by: Mark Salter <msalter@redhat.com>
Link: https://lore.kernel.org/r/20200915204110.326138-1-msalter@redhat.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/perf/xgene_pmu.c | 32 +++++++++++++++++---------------
 1 file changed, 17 insertions(+), 15 deletions(-)

diff --git a/drivers/perf/xgene_pmu.c b/drivers/perf/xgene_pmu.c
index edac28cd25ddc..633cf07ba6723 100644
--- a/drivers/perf/xgene_pmu.c
+++ b/drivers/perf/xgene_pmu.c
@@ -1453,17 +1453,6 @@ static char *xgene_pmu_dev_name(struct device *dev, u32 type, int id)
 }
 
 #if defined(CONFIG_ACPI)
-static int acpi_pmu_dev_add_resource(struct acpi_resource *ares, void *data)
-{
-	struct resource *res = data;
-
-	if (ares->type == ACPI_RESOURCE_TYPE_FIXED_MEMORY32)
-		acpi_dev_resource_memory(ares, res);
-
-	/* Always tell the ACPI core to skip this resource */
-	return 1;
-}
-
 static struct
 xgene_pmu_dev_ctx *acpi_get_pmu_hw_inf(struct xgene_pmu *xgene_pmu,
 				       struct acpi_device *adev, u32 type)
@@ -1475,6 +1464,7 @@ xgene_pmu_dev_ctx *acpi_get_pmu_hw_inf(struct xgene_pmu *xgene_pmu,
 	struct hw_pmu_info *inf;
 	void __iomem *dev_csr;
 	struct resource res;
+	struct resource_entry *rentry;
 	int enable_bit;
 	int rc;
 
@@ -1483,11 +1473,23 @@ xgene_pmu_dev_ctx *acpi_get_pmu_hw_inf(struct xgene_pmu *xgene_pmu,
 		return NULL;
 
 	INIT_LIST_HEAD(&resource_list);
-	rc = acpi_dev_get_resources(adev, &resource_list,
-				    acpi_pmu_dev_add_resource, &res);
+	rc = acpi_dev_get_resources(adev, &resource_list, NULL, NULL);
+	if (rc <= 0) {
+		dev_err(dev, "PMU type %d: No resources found\n", type);
+		return NULL;
+	}
+
+	list_for_each_entry(rentry, &resource_list, node) {
+		if (resource_type(rentry->res) == IORESOURCE_MEM) {
+			res = *rentry->res;
+			rentry = NULL;
+			break;
+		}
+	}
 	acpi_dev_free_resource_list(&resource_list);
-	if (rc < 0) {
-		dev_err(dev, "PMU type %d: No resource address found\n", type);
+
+	if (rentry) {
+		dev_err(dev, "PMU type %d: No memory resource found\n", type);
 		return NULL;
 	}
 
-- 
2.25.1



