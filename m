Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2ED87417418
	for <lists+stable@lfdr.de>; Fri, 24 Sep 2021 15:02:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345792AbhIXNC2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Sep 2021 09:02:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:54138 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345336AbhIXNA0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Sep 2021 09:00:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 211D2613E6;
        Fri, 24 Sep 2021 12:53:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632488034;
        bh=o2dRQZAbvlwPiirfqSbQNcm6jSSNfVqJBaMIViSSfdE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lLC0sCsa820VomHbdlYdy6Ny0ZdZx4klpm7qDD1f1HslNIcV2hLT1s+OnwlacPZYi
         7zdeeqXT0apYbmDN0MqBA4c42YP9IaQQGxe53Zxzj5Xh65jdRiB1M6e+hhif5out/z
         rVTgJnhRW/1FNUvD0lVX94XUvHDqjxhSfec52R9U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Ben Widawsky <ben.widawsky@intel.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 057/100] cxl: Move cxl_core to new directory
Date:   Fri, 24 Sep 2021 14:44:06 +0200
Message-Id: <20210924124343.339559432@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210924124341.214446495@linuxfoundation.org>
References: <20210924124341.214446495@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ben Widawsky <ben.widawsky@intel.com>

[ Upstream commit 5161a55c069f53d88da49274cbef6e3c74eadea9 ]

CXL core is growing, and it's already arguably unmanageable. To support
future growth, move core functionality to a new directory and rename the
file to represent just bus support. Future work will remove non-bus
functionality.

Note that mem.h is renamed to cxlmem.h to avoid a namespace collision
with the global ARCH=um mem.h header.

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Ben Widawsky <ben.widawsky@intel.com>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Link: https://lore.kernel.org/r/162792537866.368511.8915631504621088321.stgit@dwillia2-desk3.amr.corp.intel.com
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/driver-api/cxl/memory-devices.rst | 2 +-
 drivers/cxl/Makefile                            | 4 +---
 drivers/cxl/core/Makefile                       | 5 +++++
 drivers/cxl/{core.c => core/bus.c}              | 4 ++--
 drivers/cxl/{mem.h => cxlmem.h}                 | 0
 drivers/cxl/pci.c                               | 2 +-
 drivers/cxl/pmem.c                              | 2 +-
 7 files changed, 11 insertions(+), 8 deletions(-)
 create mode 100644 drivers/cxl/core/Makefile
 rename drivers/cxl/{core.c => core/bus.c} (99%)
 rename drivers/cxl/{mem.h => cxlmem.h} (100%)

diff --git a/Documentation/driver-api/cxl/memory-devices.rst b/Documentation/driver-api/cxl/memory-devices.rst
index 487ce4f41d77..a86e2c7c551a 100644
--- a/Documentation/driver-api/cxl/memory-devices.rst
+++ b/Documentation/driver-api/cxl/memory-devices.rst
@@ -36,7 +36,7 @@ CXL Core
 .. kernel-doc:: drivers/cxl/cxl.h
    :internal:
 
-.. kernel-doc:: drivers/cxl/core.c
+.. kernel-doc:: drivers/cxl/core/bus.c
    :doc: cxl core
 
 External Interfaces
diff --git a/drivers/cxl/Makefile b/drivers/cxl/Makefile
index 32954059b37b..d1aaabc940f3 100644
--- a/drivers/cxl/Makefile
+++ b/drivers/cxl/Makefile
@@ -1,11 +1,9 @@
 # SPDX-License-Identifier: GPL-2.0
-obj-$(CONFIG_CXL_BUS) += cxl_core.o
+obj-$(CONFIG_CXL_BUS) += core/
 obj-$(CONFIG_CXL_MEM) += cxl_pci.o
 obj-$(CONFIG_CXL_ACPI) += cxl_acpi.o
 obj-$(CONFIG_CXL_PMEM) += cxl_pmem.o
 
-ccflags-y += -DDEFAULT_SYMBOL_NAMESPACE=CXL
-cxl_core-y := core.o
 cxl_pci-y := pci.o
 cxl_acpi-y := acpi.o
 cxl_pmem-y := pmem.o
diff --git a/drivers/cxl/core/Makefile b/drivers/cxl/core/Makefile
new file mode 100644
index 000000000000..ad137f96e5c8
--- /dev/null
+++ b/drivers/cxl/core/Makefile
@@ -0,0 +1,5 @@
+# SPDX-License-Identifier: GPL-2.0
+obj-$(CONFIG_CXL_BUS) += cxl_core.o
+
+ccflags-y += -DDEFAULT_SYMBOL_NAMESPACE=CXL -I$(srctree)/drivers/cxl
+cxl_core-y := bus.o
diff --git a/drivers/cxl/core.c b/drivers/cxl/core/bus.c
similarity index 99%
rename from drivers/cxl/core.c
rename to drivers/cxl/core/bus.c
index a2e4d54fc7bc..0815eec23944 100644
--- a/drivers/cxl/core.c
+++ b/drivers/cxl/core/bus.c
@@ -6,8 +6,8 @@
 #include <linux/pci.h>
 #include <linux/slab.h>
 #include <linux/idr.h>
-#include "cxl.h"
-#include "mem.h"
+#include <cxlmem.h>
+#include <cxl.h>
 
 /**
  * DOC: cxl core
diff --git a/drivers/cxl/mem.h b/drivers/cxl/cxlmem.h
similarity index 100%
rename from drivers/cxl/mem.h
rename to drivers/cxl/cxlmem.h
diff --git a/drivers/cxl/pci.c b/drivers/cxl/pci.c
index 145ad4bc305f..e7ee148ad7ee 100644
--- a/drivers/cxl/pci.c
+++ b/drivers/cxl/pci.c
@@ -12,9 +12,9 @@
 #include <linux/pci.h>
 #include <linux/io.h>
 #include <linux/io-64-nonatomic-lo-hi.h>
+#include "cxlmem.h"
 #include "pci.h"
 #include "cxl.h"
-#include "mem.h"
 
 /**
  * DOC: cxl pci
diff --git a/drivers/cxl/pmem.c b/drivers/cxl/pmem.c
index 0088e41dd2f3..9652c3ee41e7 100644
--- a/drivers/cxl/pmem.c
+++ b/drivers/cxl/pmem.c
@@ -6,7 +6,7 @@
 #include <linux/ndctl.h>
 #include <linux/async.h>
 #include <linux/slab.h>
-#include "mem.h"
+#include "cxlmem.h"
 #include "cxl.h"
 
 /*
-- 
2.33.0



