Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB042409FBA
	for <lists+stable@lfdr.de>; Tue, 14 Sep 2021 00:33:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343596AbhIMWfE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 18:35:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:50092 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245355AbhIMWfB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 18:35:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AA277610CE;
        Mon, 13 Sep 2021 22:33:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631572424;
        bh=TPisBgC+/AkvYuRI6mVcJsHZlYaY2djoSzgyABiD+hY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q9xSTxSubTfSDnYrGE7CxOv3izfqaKqDBMisXNsiOvvQknEvw7yhbpvrOrZv7H+mx
         +soOug156/m0iATJG1dF8XnQ0Jw5KJECEkbukk2lR+HxtaLp7r4wmMm/6lxtR6HcjQ
         xAN2tg5zTqj6xDYWSgLx1IFxID50lfDD8+vLxQJzbzTzILqqlPL+meeN4jgr9uLm8+
         8Ju1/gVSXTNnwFwMKj9iclcNhkJU1/5JvjozrlI1E/w9nwbSWAggIgavSmRnhRa/uK
         0UxQQB4lV9Qf5mRe+zhMNxSJULpu3r97sHT6mv6Gh6KwtK/0eKyrANIHoezVbZ8l9e
         R/q3l8MNtncoA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ben Widawsky <ben.widawsky@intel.com>,
        kernel test robot <lkp@intel.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Sasha Levin <sashal@kernel.org>, linux-doc@vger.kernel.org,
        linux-cxl@vger.kernel.org
Subject: [PATCH AUTOSEL 5.14 03/25] cxl: Move cxl_core to new directory
Date:   Mon, 13 Sep 2021 18:33:17 -0400
Message-Id: <20210913223339.435347-3-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210913223339.435347-1-sashal@kernel.org>
References: <20210913223339.435347-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 4cf351a3cf99..a945c5fda292 100644
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
2.30.2

