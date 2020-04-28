Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F7A01BC7BC
	for <lists+stable@lfdr.de>; Tue, 28 Apr 2020 20:26:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728710AbgD1S0V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Apr 2020 14:26:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:37748 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728700AbgD1S0U (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Apr 2020 14:26:20 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D408D2137B;
        Tue, 28 Apr 2020 18:26:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588098378;
        bh=gepK8epY5y1X2So4zmONyxVbZIzOOcoBP1WVOXiBqls=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vl4z8MefVfuMsFk5pObC85rtwoKbAlaqiIx5JEORS9NN6qtyoW/3/S9wFUkeJMMg9
         mjUVDKFSPiu319w7W/dP5EnRaVpCx04YORyXZnotVE5RLoCGGJSWEmpVCrIuM1CM95
         hE6UC7/5hCfZHcsccFciP0PVtit/RF0X0NlGD0jQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
        Santosh Sivaraj <santosh@fossix.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.6 016/167] tools/test/nvdimm: Fix out of tree build
Date:   Tue, 28 Apr 2020 20:23:12 +0200
Message-Id: <20200428182227.276694339@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200428182225.451225420@linuxfoundation.org>
References: <20200428182225.451225420@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Santosh Sivaraj <santosh@fossix.org>

[ Upstream commit 1f776799628139d0da47e710ad86eb58d987ff66 ]

Out of tree build using

   make M=tools/test/nvdimm O=/tmp/build -C /tmp/build

fails with the following error

make: Entering directory '/tmp/build'
  CC [M]  tools/testing/nvdimm/test/nfit.o
linux/tools/testing/nvdimm/test/nfit.c:19:10: fatal error: nd-core.h: No such file or directory
   19 | #include <nd-core.h>
      |          ^~~~~~~~~~~
compilation terminated.

That is because the kbuild file uses $(src) which points to
tools/testing/nvdimm, $(srctree) correctly points to root of the linux
source tree.

Reported-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Signed-off-by: Santosh Sivaraj <santosh@fossix.org>
Link: https://lore.kernel.org/r/20200114054051.4115790-1-santosh@fossix.org
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/nvdimm/Kbuild      | 4 ++--
 tools/testing/nvdimm/test/Kbuild | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/testing/nvdimm/Kbuild b/tools/testing/nvdimm/Kbuild
index dbebf05f59313..47f9cc9dcd94b 100644
--- a/tools/testing/nvdimm/Kbuild
+++ b/tools/testing/nvdimm/Kbuild
@@ -21,8 +21,8 @@ DRIVERS := ../../../drivers
 NVDIMM_SRC := $(DRIVERS)/nvdimm
 ACPI_SRC := $(DRIVERS)/acpi/nfit
 DAX_SRC := $(DRIVERS)/dax
-ccflags-y := -I$(src)/$(NVDIMM_SRC)/
-ccflags-y += -I$(src)/$(ACPI_SRC)/
+ccflags-y := -I$(srctree)/drivers/nvdimm/
+ccflags-y += -I$(srctree)/drivers/acpi/nfit/
 
 obj-$(CONFIG_LIBNVDIMM) += libnvdimm.o
 obj-$(CONFIG_BLK_DEV_PMEM) += nd_pmem.o
diff --git a/tools/testing/nvdimm/test/Kbuild b/tools/testing/nvdimm/test/Kbuild
index fb3c3d7cdb9bd..75baebf8f4ba1 100644
--- a/tools/testing/nvdimm/test/Kbuild
+++ b/tools/testing/nvdimm/test/Kbuild
@@ -1,6 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0
-ccflags-y := -I$(src)/../../../../drivers/nvdimm/
-ccflags-y += -I$(src)/../../../../drivers/acpi/nfit/
+ccflags-y := -I$(srctree)/drivers/nvdimm/
+ccflags-y += -I$(srctree)/drivers/acpi/nfit/
 
 obj-m += nfit_test.o
 obj-m += nfit_test_iomap.o
-- 
2.20.1



