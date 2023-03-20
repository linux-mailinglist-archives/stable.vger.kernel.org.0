Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C8266C16CC
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 16:09:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232294AbjCTPJH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 11:09:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231714AbjCTPIs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 11:08:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B75A72E822
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 08:04:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C65DAB80ECF
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 15:03:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D112C433D2;
        Mon, 20 Mar 2023 15:03:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679324615;
        bh=rtQ/HnCrUnoteNyq2QuJ6AIEG2aqcyuB0hOIvaq0nCA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rQNRJxXfSzsgUm4Rx4SAswidiiaRSsgaGQ/s2ohd7hDFJuwibrlgueEHJrwXLgvkY
         d72YQ+hd/C/BMc8KTsxKrlUE3/+tK/OaDM2CS/PxQ5uZX+wVJaSt9sHhd9kybQrcVJ
         4CqdZSU+yx6VwtzVVKOS1XJ+YxGsay7a7UbVeiEU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Bart Van Assche <bvanassche@acm.org>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 27/99] null_blk: Move driver into its own directory
Date:   Mon, 20 Mar 2023 15:54:05 +0100
Message-Id: <20230320145444.507923844@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145443.333824603@linuxfoundation.org>
References: <20230320145443.333824603@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Damien Le Moal <damien.lemoal@wdc.com>

[ Upstream commit eebf34a85c8c724676eba502d15202854f199b05 ]

Move null_blk driver code into the new sub-directory
drivers/block/null_blk.

Suggested-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: 63f886597085 ("block: null_blk: Fix handling of fake timeout request")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/Kconfig                                |  8 +-------
 drivers/block/Makefile                               |  7 +------
 drivers/block/null_blk/Kconfig                       | 12 ++++++++++++
 drivers/block/null_blk/Makefile                      | 11 +++++++++++
 drivers/block/{null_blk_main.c => null_blk/main.c}   |  0
 drivers/block/{ => null_blk}/null_blk.h              |  0
 drivers/block/{null_blk_trace.c => null_blk/trace.c} |  2 +-
 drivers/block/{null_blk_trace.h => null_blk/trace.h} |  2 +-
 drivers/block/{null_blk_zoned.c => null_blk/zoned.c} |  2 +-
 9 files changed, 28 insertions(+), 16 deletions(-)
 create mode 100644 drivers/block/null_blk/Kconfig
 create mode 100644 drivers/block/null_blk/Makefile
 rename drivers/block/{null_blk_main.c => null_blk/main.c} (100%)
 rename drivers/block/{ => null_blk}/null_blk.h (100%)
 rename drivers/block/{null_blk_trace.c => null_blk/trace.c} (93%)
 rename drivers/block/{null_blk_trace.h => null_blk/trace.h} (97%)
 rename drivers/block/{null_blk_zoned.c => null_blk/zoned.c} (99%)

diff --git a/drivers/block/Kconfig b/drivers/block/Kconfig
index 40c53632512b7..9617688b58b32 100644
--- a/drivers/block/Kconfig
+++ b/drivers/block/Kconfig
@@ -16,13 +16,7 @@ menuconfig BLK_DEV
 
 if BLK_DEV
 
-config BLK_DEV_NULL_BLK
-	tristate "Null test block driver"
-	select CONFIGFS_FS
-
-config BLK_DEV_NULL_BLK_FAULT_INJECTION
-	bool "Support fault injection for Null test block driver"
-	depends on BLK_DEV_NULL_BLK && FAULT_INJECTION
+source "drivers/block/null_blk/Kconfig"
 
 config BLK_DEV_FD
 	tristate "Normal floppy disk support"
diff --git a/drivers/block/Makefile b/drivers/block/Makefile
index e1f63117ee94f..a3170859e01d4 100644
--- a/drivers/block/Makefile
+++ b/drivers/block/Makefile
@@ -41,12 +41,7 @@ obj-$(CONFIG_BLK_DEV_RSXX) += rsxx/
 obj-$(CONFIG_ZRAM) += zram/
 obj-$(CONFIG_BLK_DEV_RNBD)	+= rnbd/
 
-obj-$(CONFIG_BLK_DEV_NULL_BLK)	+= null_blk.o
-null_blk-objs	:= null_blk_main.o
-ifeq ($(CONFIG_BLK_DEV_ZONED), y)
-null_blk-$(CONFIG_TRACING) += null_blk_trace.o
-endif
-null_blk-$(CONFIG_BLK_DEV_ZONED) += null_blk_zoned.o
+obj-$(CONFIG_BLK_DEV_NULL_BLK)	+= null_blk/
 
 skd-y		:= skd_main.o
 swim_mod-y	:= swim.o swim_asm.o
diff --git a/drivers/block/null_blk/Kconfig b/drivers/block/null_blk/Kconfig
new file mode 100644
index 0000000000000..6bf1f8ca20a24
--- /dev/null
+++ b/drivers/block/null_blk/Kconfig
@@ -0,0 +1,12 @@
+# SPDX-License-Identifier: GPL-2.0
+#
+# Null block device driver configuration
+#
+
+config BLK_DEV_NULL_BLK
+	tristate "Null test block driver"
+	select CONFIGFS_FS
+
+config BLK_DEV_NULL_BLK_FAULT_INJECTION
+	bool "Support fault injection for Null test block driver"
+	depends on BLK_DEV_NULL_BLK && FAULT_INJECTION
diff --git a/drivers/block/null_blk/Makefile b/drivers/block/null_blk/Makefile
new file mode 100644
index 0000000000000..84c36e512ab89
--- /dev/null
+++ b/drivers/block/null_blk/Makefile
@@ -0,0 +1,11 @@
+# SPDX-License-Identifier: GPL-2.0
+
+# needed for trace events
+ccflags-y			+= -I$(src)
+
+obj-$(CONFIG_BLK_DEV_NULL_BLK)	+= null_blk.o
+null_blk-objs			:= main.o
+ifeq ($(CONFIG_BLK_DEV_ZONED), y)
+null_blk-$(CONFIG_TRACING) 	+= trace.o
+endif
+null_blk-$(CONFIG_BLK_DEV_ZONED) += zoned.o
diff --git a/drivers/block/null_blk_main.c b/drivers/block/null_blk/main.c
similarity index 100%
rename from drivers/block/null_blk_main.c
rename to drivers/block/null_blk/main.c
diff --git a/drivers/block/null_blk.h b/drivers/block/null_blk/null_blk.h
similarity index 100%
rename from drivers/block/null_blk.h
rename to drivers/block/null_blk/null_blk.h
diff --git a/drivers/block/null_blk_trace.c b/drivers/block/null_blk/trace.c
similarity index 93%
rename from drivers/block/null_blk_trace.c
rename to drivers/block/null_blk/trace.c
index f246e7bff6982..3711cba160715 100644
--- a/drivers/block/null_blk_trace.c
+++ b/drivers/block/null_blk/trace.c
@@ -4,7 +4,7 @@
  *
  * Copyright (C) 2020 Western Digital Corporation or its affiliates.
  */
-#include "null_blk_trace.h"
+#include "trace.h"
 
 /*
  * Helper to use for all null_blk traces to extract disk name.
diff --git a/drivers/block/null_blk_trace.h b/drivers/block/null_blk/trace.h
similarity index 97%
rename from drivers/block/null_blk_trace.h
rename to drivers/block/null_blk/trace.h
index 4f83032eb5441..ce3b430e88c57 100644
--- a/drivers/block/null_blk_trace.h
+++ b/drivers/block/null_blk/trace.h
@@ -73,7 +73,7 @@ TRACE_EVENT(nullb_report_zones,
 #undef TRACE_INCLUDE_PATH
 #define TRACE_INCLUDE_PATH .
 #undef TRACE_INCLUDE_FILE
-#define TRACE_INCLUDE_FILE null_blk_trace
+#define TRACE_INCLUDE_FILE trace
 
 /* This part must be outside protection */
 #include <trace/define_trace.h>
diff --git a/drivers/block/null_blk_zoned.c b/drivers/block/null_blk/zoned.c
similarity index 99%
rename from drivers/block/null_blk_zoned.c
rename to drivers/block/null_blk/zoned.c
index f5df82c26c16f..41220ce59659b 100644
--- a/drivers/block/null_blk_zoned.c
+++ b/drivers/block/null_blk/zoned.c
@@ -4,7 +4,7 @@
 #include "null_blk.h"
 
 #define CREATE_TRACE_POINTS
-#include "null_blk_trace.h"
+#include "trace.h"
 
 #define MB_TO_SECTS(mb) (((sector_t)mb * SZ_1M) >> SECTOR_SHIFT)
 
-- 
2.39.2



