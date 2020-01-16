Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E9DCD13E15E
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 17:49:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730333AbgAPQtR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 11:49:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:60142 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730321AbgAPQtR (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 11:49:17 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C9F66207FF;
        Thu, 16 Jan 2020 16:49:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579193355;
        bh=uBTz12lQjeNl6dqBlW6oEs/XlN8UvzzRTnlsXC4CCzA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iuXCNmOKNc6sLRch5zf7VzEAAz1uvEjyn79GMaqqWJWux9KMMBTBWXO1Q+FFXWp//
         uJ8PtJ60D7x1emq8QR4HSzICm/FbRXHVdvCI4oC28ZQobuK8diuBsSo2TBxldy0nfS
         Zn6tlOTQiTMdKEOrFpQOMjRSVo0FRUBY64/+NUSM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Arnd Bergmann <arnd@arndb.de>, Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 081/205] RDMA/hns: Fix build error again
Date:   Thu, 16 Jan 2020 11:40:56 -0500
Message-Id: <20200116164300.6705-81-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116164300.6705-1-sashal@kernel.org>
References: <20200116164300.6705-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit d5b60e26e86a463ca83bb5ec502dda6ea685159e ]

This is not the first attempt to fix building random configurations,
unfortunately the attempt in commit a07fc0bb483e ("RDMA/hns: Fix build
error") caused a new problem when CONFIG_INFINIBAND_HNS_HIP06=m and
CONFIG_INFINIBAND_HNS_HIP08=y:

drivers/infiniband/hw/hns/hns_roce_main.o:(.rodata+0xe60): undefined reference to `__this_module'

Revert commits a07fc0bb483e ("RDMA/hns: Fix build error") and
a3e2d4c7e766 ("RDMA/hns: remove obsolete Kconfig comment") to get back to
the previous state, then fix the issues described there differently, by
adding more specific dependencies: INFINIBAND_HNS can now only be built-in
if at least one of HNS or HNS3 are built-in, and the individual back-ends
are only available if that code is reachable from the main driver.

Fixes: a07fc0bb483e ("RDMA/hns: Fix build error")
Fixes: a3e2d4c7e766 ("RDMA/hns: remove obsolete Kconfig comment")
Fixes: dd74282df573 ("RDMA/hns: Initialize the PCI device for hip08 RoCE")
Fixes: 08805fdbeb2d ("RDMA/hns: Split hw v1 driver from hns roce driver")
Link: https://lore.kernel.org/r/20191007211826.3361202-1-arnd@arndb.de
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/Kconfig  | 17 ++++++++++++++---
 drivers/infiniband/hw/hns/Makefile |  8 ++++++--
 2 files changed, 20 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/hw/hns/Kconfig b/drivers/infiniband/hw/hns/Kconfig
index d602b698b57e..4921c1e40ccd 100644
--- a/drivers/infiniband/hw/hns/Kconfig
+++ b/drivers/infiniband/hw/hns/Kconfig
@@ -1,23 +1,34 @@
 # SPDX-License-Identifier: GPL-2.0-only
 config INFINIBAND_HNS
-	bool "HNS RoCE Driver"
+	tristate "HNS RoCE Driver"
 	depends on NET_VENDOR_HISILICON
 	depends on ARM64 || (COMPILE_TEST && 64BIT)
+	depends on (HNS_DSAF && HNS_ENET) || HNS3
 	---help---
 	  This is a RoCE/RDMA driver for the Hisilicon RoCE engine. The engine
 	  is used in Hisilicon Hip06 and more further ICT SoC based on
 	  platform device.
 
+	  To compile HIP06 or HIP08 driver as module, choose M here.
+
 config INFINIBAND_HNS_HIP06
-	tristate "Hisilicon Hip06 Family RoCE support"
+	bool "Hisilicon Hip06 Family RoCE support"
 	depends on INFINIBAND_HNS && HNS && HNS_DSAF && HNS_ENET
+	depends on INFINIBAND_HNS=m || (HNS_DSAF=y && HNS_ENET=y)
 	---help---
 	  RoCE driver support for Hisilicon RoCE engine in Hisilicon Hip06 and
 	  Hip07 SoC. These RoCE engines are platform devices.
 
+	  To compile this driver, choose Y here: if INFINIBAND_HNS is m, this
+	  module will be called hns-roce-hw-v1
+
 config INFINIBAND_HNS_HIP08
-	tristate "Hisilicon Hip08 Family RoCE support"
+	bool "Hisilicon Hip08 Family RoCE support"
 	depends on INFINIBAND_HNS && PCI && HNS3
+	depends on INFINIBAND_HNS=m || HNS3=y
 	---help---
 	  RoCE driver support for Hisilicon RoCE engine in Hisilicon Hip08 SoC.
 	  The RoCE engine is a PCI device.
+
+	  To compile this driver, choose Y here: if INFINIBAND_HNS is m, this
+	  module will be called hns-roce-hw-v2.
diff --git a/drivers/infiniband/hw/hns/Makefile b/drivers/infiniband/hw/hns/Makefile
index 449a2d81319d..e105945b94a1 100644
--- a/drivers/infiniband/hw/hns/Makefile
+++ b/drivers/infiniband/hw/hns/Makefile
@@ -9,8 +9,12 @@ hns-roce-objs := hns_roce_main.o hns_roce_cmd.o hns_roce_pd.o \
 	hns_roce_ah.o hns_roce_hem.o hns_roce_mr.o hns_roce_qp.o \
 	hns_roce_cq.o hns_roce_alloc.o hns_roce_db.o hns_roce_srq.o hns_roce_restrack.o
 
+ifdef CONFIG_INFINIBAND_HNS_HIP06
 hns-roce-hw-v1-objs := hns_roce_hw_v1.o $(hns-roce-objs)
-obj-$(CONFIG_INFINIBAND_HNS_HIP06) += hns-roce-hw-v1.o
+obj-$(CONFIG_INFINIBAND_HNS) += hns-roce-hw-v1.o
+endif
 
+ifdef CONFIG_INFINIBAND_HNS_HIP08
 hns-roce-hw-v2-objs := hns_roce_hw_v2.o hns_roce_hw_v2_dfx.o $(hns-roce-objs)
-obj-$(CONFIG_INFINIBAND_HNS_HIP08) += hns-roce-hw-v2.o
+obj-$(CONFIG_INFINIBAND_HNS) += hns-roce-hw-v2.o
+endif
-- 
2.20.1

