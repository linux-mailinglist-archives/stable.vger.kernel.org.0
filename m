Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E55F766E8C2
	for <lists+stable@lfdr.de>; Tue, 17 Jan 2023 22:56:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229436AbjAQVz6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Jan 2023 16:55:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230299AbjAQVwB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Jan 2023 16:52:01 -0500
Received: from smtpout.efficios.com (smtpout.efficios.com [167.114.26.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D023826589;
        Tue, 17 Jan 2023 12:17:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=efficios.com;
        s=smtpout1; t=1673986651;
        bh=NRUcz2fK3YLgCJTvpRoqM6mbeBJkpUGmRcIKzxdFTrM=;
        h=From:To:Cc:Subject:Date:From;
        b=imYBfYSamkju0zbdb552loTeKisDIsjn2N1gUv89OO4lM7NzwKRnGJeCqtABR7Zyv
         SgHBHqn1e4d0V+z6uSmWnzgwTbpbEFOIyyiNOqWN715Xx8Yje10rfGVcMT5fbXiFGt
         9c9xtUABMoYTtOJcwttwhTIUhb4QGSf/5fn+0ZqjK+8PIIXDy/R9k4/f+kVU5wjpvN
         4pKt0t4nPFshmyCchYrEs/AO+rzFjccWdw8LhT8y2m3bTxeSio/B2aGCx8pieULKdz
         uf2ozwhO3Jp6m1gE4Dvpg09vdMDOBjcYW0f/K8IBObM/pkm4Bxk/1TuI7vEy79Kx/q
         5ZT2ZD65dwbyQ==
Received: from localhost.localdomain (192-222-180-24.qc.cable.ebox.net [192.222.180.24])
        by smtpout.efficios.com (Postfix) with ESMTPSA id 4NxKtz4FfDzgsn;
        Tue, 17 Jan 2023 15:17:31 -0500 (EST)
From:   Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To:     Shuah Khan <shuah@kernel.org>
Cc:     linux-kernel@vger.kernel.org,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        linux-kselftest@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        stable@vger.kernel.org
Subject: [RFC PATCH] selftests: Fix: search kernel headers in $(KHDR_INCLUDES)
Date:   Tue, 17 Jan 2023 15:17:24 -0500
Message-Id: <20230117201724.11869-1-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Use $(KHDR_INCLUDES) as lookup path for kernel headers. This prevents
building against kernel headers from the build environment in scenarios
where kernel headers are installed into a specific output directory
(O=...).

[ Hopefully I did not break too many things with this selftests-wide
  change. Additional testing would be welcome before merging, especially
  given that whenever we get this wrong, it appears to fall-back on the
  build environment system headers, which hides issues. This applies on
  top of v6.2-rc3. ]

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: linux-kselftest@vger.kernel.org
Cc: Ingo Molnar <mingo@redhat.com>
Cc: <stable@vger.kernel.org>	[5.18+]
---
 tools/testing/selftests/arm64/fp/Makefile               | 2 +-
 tools/testing/selftests/arm64/tags/Makefile             | 2 +-
 tools/testing/selftests/bpf/Makefile                    | 2 +-
 tools/testing/selftests/clone3/Makefile                 | 2 +-
 tools/testing/selftests/core/Makefile                   | 2 +-
 tools/testing/selftests/dma/Makefile                    | 2 +-
 tools/testing/selftests/drivers/dma-buf/Makefile        | 2 +-
 tools/testing/selftests/drivers/s390x/uvdevice/Makefile | 3 +--
 tools/testing/selftests/filesystems/Makefile            | 2 +-
 tools/testing/selftests/filesystems/binderfs/Makefile   | 2 +-
 tools/testing/selftests/filesystems/epoll/Makefile      | 2 +-
 tools/testing/selftests/futex/functional/Makefile       | 2 +-
 tools/testing/selftests/gpio/Makefile                   | 2 +-
 tools/testing/selftests/ipc/Makefile                    | 2 +-
 tools/testing/selftests/kcmp/Makefile                   | 2 +-
 tools/testing/selftests/media_tests/Makefile            | 2 +-
 tools/testing/selftests/membarrier/Makefile             | 2 +-
 tools/testing/selftests/memfd/Makefile                  | 2 +-
 tools/testing/selftests/mount_setattr/Makefile          | 2 +-
 tools/testing/selftests/move_mount_set_group/Makefile   | 2 +-
 tools/testing/selftests/net/Makefile                    | 2 +-
 tools/testing/selftests/net/bpf/Makefile                | 2 +-
 tools/testing/selftests/net/mptcp/Makefile              | 2 +-
 tools/testing/selftests/net/openvswitch/Makefile        | 2 +-
 tools/testing/selftests/perf_events/Makefile            | 2 +-
 tools/testing/selftests/pid_namespace/Makefile          | 2 +-
 tools/testing/selftests/pidfd/Makefile                  | 2 +-
 tools/testing/selftests/powerpc/ptrace/Makefile         | 2 +-
 tools/testing/selftests/powerpc/security/Makefile       | 2 +-
 tools/testing/selftests/powerpc/syscalls/Makefile       | 2 +-
 tools/testing/selftests/powerpc/tm/Makefile             | 2 +-
 tools/testing/selftests/ptp/Makefile                    | 2 +-
 tools/testing/selftests/rseq/Makefile                   | 2 +-
 tools/testing/selftests/sched/Makefile                  | 2 +-
 tools/testing/selftests/seccomp/Makefile                | 2 +-
 tools/testing/selftests/sync/Makefile                   | 2 +-
 tools/testing/selftests/user_events/Makefile            | 2 +-
 tools/testing/selftests/vm/Makefile                     | 2 +-
 38 files changed, 38 insertions(+), 39 deletions(-)

diff --git a/tools/testing/selftests/arm64/fp/Makefile b/tools/testing/selftests/arm64/fp/Makefile
index 36db61358ed5..932ec8792316 100644
--- a/tools/testing/selftests/arm64/fp/Makefile
+++ b/tools/testing/selftests/arm64/fp/Makefile
@@ -3,7 +3,7 @@
 # A proper top_srcdir is needed by KSFT(lib.mk)
 top_srcdir = $(realpath ../../../../../)
 
-CFLAGS += -I$(top_srcdir)/usr/include/
+CFLAGS += $(KHDR_INCLUDES)
 
 TEST_GEN_PROGS := fp-stress \
 	sve-ptrace sve-probe-vls \
diff --git a/tools/testing/selftests/arm64/tags/Makefile b/tools/testing/selftests/arm64/tags/Makefile
index 41cb75070511..6d29cfde43a2 100644
--- a/tools/testing/selftests/arm64/tags/Makefile
+++ b/tools/testing/selftests/arm64/tags/Makefile
@@ -1,6 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0
 
-CFLAGS += -I../../../../../usr/include/
+CFLAGS += $(KHDR_INCLUDES)
 TEST_GEN_PROGS := tags_test
 TEST_PROGS := run_tags_test.sh
 
diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index c22c43bbee19..6998c816afef 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -327,7 +327,7 @@ endif
 CLANG_SYS_INCLUDES = $(call get_sys_includes,$(CLANG),$(CLANG_TARGET_ARCH))
 BPF_CFLAGS = -g -Werror -D__TARGET_ARCH_$(SRCARCH) $(MENDIAN) 		\
 	     -I$(INCLUDE_DIR) -I$(CURDIR) -I$(APIDIR)			\
-	     -I$(abspath $(OUTPUT)/../usr/include)
+	     $(KHDR_INCLUDES)
 
 CLANG_CFLAGS = $(CLANG_SYS_INCLUDES) \
 	       -Wno-compare-distinct-pointer-types
diff --git a/tools/testing/selftests/clone3/Makefile b/tools/testing/selftests/clone3/Makefile
index 79b19a2863a0..84832c369a2e 100644
--- a/tools/testing/selftests/clone3/Makefile
+++ b/tools/testing/selftests/clone3/Makefile
@@ -1,5 +1,5 @@
 # SPDX-License-Identifier: GPL-2.0
-CFLAGS += -g -std=gnu99 -I../../../../usr/include/
+CFLAGS += -g -std=gnu99 $(KHDR_INCLUDES)
 LDLIBS += -lcap
 
 TEST_GEN_PROGS := clone3 clone3_clear_sighand clone3_set_tid \
diff --git a/tools/testing/selftests/core/Makefile b/tools/testing/selftests/core/Makefile
index f6f2d6f473c6..ce262d097269 100644
--- a/tools/testing/selftests/core/Makefile
+++ b/tools/testing/selftests/core/Makefile
@@ -1,5 +1,5 @@
 # SPDX-License-Identifier: GPL-2.0-only
-CFLAGS += -g -I../../../../usr/include/
+CFLAGS += -g $(KHDR_INCLUDES)
 
 TEST_GEN_PROGS := close_range_test
 
diff --git a/tools/testing/selftests/dma/Makefile b/tools/testing/selftests/dma/Makefile
index cd8c5ece1cba..dd7f746f3e84 100644
--- a/tools/testing/selftests/dma/Makefile
+++ b/tools/testing/selftests/dma/Makefile
@@ -1,5 +1,5 @@
 # SPDX-License-Identifier: GPL-2.0
-CFLAGS += -I../../../../usr/include/
+CFLAGS += $(KHDR_INCLUDES)
 CFLAGS += -I../../../../include/
 
 TEST_GEN_PROGS := dma_map_benchmark
diff --git a/tools/testing/selftests/drivers/dma-buf/Makefile b/tools/testing/selftests/drivers/dma-buf/Makefile
index 79cb16b4e01a..441407bb0e80 100644
--- a/tools/testing/selftests/drivers/dma-buf/Makefile
+++ b/tools/testing/selftests/drivers/dma-buf/Makefile
@@ -1,5 +1,5 @@
 # SPDX-License-Identifier: GPL-2.0-only
-CFLAGS += -I../../../../../usr/include/
+CFLAGS += $(KHDR_INCLUDES)
 
 TEST_GEN_PROGS := udmabuf
 
diff --git a/tools/testing/selftests/drivers/s390x/uvdevice/Makefile b/tools/testing/selftests/drivers/s390x/uvdevice/Makefile
index 891215a7dc8a..755d164384c4 100644
--- a/tools/testing/selftests/drivers/s390x/uvdevice/Makefile
+++ b/tools/testing/selftests/drivers/s390x/uvdevice/Makefile
@@ -11,10 +11,9 @@ else
 TEST_GEN_PROGS := test_uvdevice
 
 top_srcdir ?= ../../../../../..
-khdr_dir = $(top_srcdir)/usr/include
 LINUX_TOOL_ARCH_INCLUDE = $(top_srcdir)/tools/arch/$(ARCH)/include
 
-CFLAGS += -Wall -Werror -static -I$(khdr_dir) -I$(LINUX_TOOL_ARCH_INCLUDE)
+CFLAGS += -Wall -Werror -static $(KHDR_INCLUDES) -I$(LINUX_TOOL_ARCH_INCLUDE)
 
 include ../../../lib.mk
 
diff --git a/tools/testing/selftests/filesystems/Makefile b/tools/testing/selftests/filesystems/Makefile
index 129880fb42d3..c647fd6a0446 100644
--- a/tools/testing/selftests/filesystems/Makefile
+++ b/tools/testing/selftests/filesystems/Makefile
@@ -1,6 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0
 
-CFLAGS += -I../../../../usr/include/
+CFLAGS += $(KHDR_INCLUDES)
 TEST_GEN_PROGS := devpts_pts
 TEST_GEN_PROGS_EXTENDED := dnotify_test
 
diff --git a/tools/testing/selftests/filesystems/binderfs/Makefile b/tools/testing/selftests/filesystems/binderfs/Makefile
index 8af25ae96049..c2f7cef919c0 100644
--- a/tools/testing/selftests/filesystems/binderfs/Makefile
+++ b/tools/testing/selftests/filesystems/binderfs/Makefile
@@ -1,6 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0
 
-CFLAGS += -I../../../../../usr/include/ -pthread
+CFLAGS += $(KHDR_INCLUDES) -pthread
 TEST_GEN_PROGS := binderfs_test
 
 binderfs_test: binderfs_test.c ../../kselftest.h ../../kselftest_harness.h
diff --git a/tools/testing/selftests/filesystems/epoll/Makefile b/tools/testing/selftests/filesystems/epoll/Makefile
index 78ae4aaf7141..0788a7dc8004 100644
--- a/tools/testing/selftests/filesystems/epoll/Makefile
+++ b/tools/testing/selftests/filesystems/epoll/Makefile
@@ -1,6 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0
 
-CFLAGS += -I../../../../../usr/include/
+CFLAGS += $(KHDR_INCLUDES)
 LDLIBS += -lpthread
 TEST_GEN_PROGS := epoll_wakeup_test
 
diff --git a/tools/testing/selftests/futex/functional/Makefile b/tools/testing/selftests/futex/functional/Makefile
index 5a0e0df8de9b..a392d0917b4e 100644
--- a/tools/testing/selftests/futex/functional/Makefile
+++ b/tools/testing/selftests/futex/functional/Makefile
@@ -1,5 +1,5 @@
 # SPDX-License-Identifier: GPL-2.0
-INCLUDES := -I../include -I../../ -I../../../../../usr/include/
+INCLUDES := -I../include -I../../ $(KHDR_INCLUDES)
 CFLAGS := $(CFLAGS) -g -O2 -Wall -D_GNU_SOURCE -pthread $(INCLUDES) $(KHDR_INCLUDES)
 LDLIBS := -lpthread -lrt
 
diff --git a/tools/testing/selftests/gpio/Makefile b/tools/testing/selftests/gpio/Makefile
index 616ed4019655..e0884390447d 100644
--- a/tools/testing/selftests/gpio/Makefile
+++ b/tools/testing/selftests/gpio/Makefile
@@ -3,6 +3,6 @@
 TEST_PROGS := gpio-mockup.sh gpio-sim.sh
 TEST_FILES := gpio-mockup-sysfs.sh
 TEST_GEN_PROGS_EXTENDED := gpio-mockup-cdev gpio-chip-info gpio-line-name
-CFLAGS += -O2 -g -Wall -I../../../../usr/include/ $(KHDR_INCLUDES)
+CFLAGS += -O2 -g -Wall $(KHDR_INCLUDES)
 
 include ../lib.mk
diff --git a/tools/testing/selftests/ipc/Makefile b/tools/testing/selftests/ipc/Makefile
index 1c4448a843a4..50e9c299fc4a 100644
--- a/tools/testing/selftests/ipc/Makefile
+++ b/tools/testing/selftests/ipc/Makefile
@@ -10,7 +10,7 @@ ifeq ($(ARCH),x86_64)
 	CFLAGS := -DCONFIG_X86_64 -D__x86_64__
 endif
 
-CFLAGS += -I../../../../usr/include/
+CFLAGS += $(KHDR_INCLUDES)
 
 TEST_GEN_PROGS := msgque
 
diff --git a/tools/testing/selftests/kcmp/Makefile b/tools/testing/selftests/kcmp/Makefile
index b4d39f6b5124..59a1e5379018 100644
--- a/tools/testing/selftests/kcmp/Makefile
+++ b/tools/testing/selftests/kcmp/Makefile
@@ -1,5 +1,5 @@
 # SPDX-License-Identifier: GPL-2.0-only
-CFLAGS += -I../../../../usr/include/
+CFLAGS += $(KHDR_INCLUDES)
 
 TEST_GEN_PROGS := kcmp_test
 
diff --git a/tools/testing/selftests/media_tests/Makefile b/tools/testing/selftests/media_tests/Makefile
index 60826d7d37d4..471d83e61d95 100644
--- a/tools/testing/selftests/media_tests/Makefile
+++ b/tools/testing/selftests/media_tests/Makefile
@@ -1,6 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0
 #
-CFLAGS += -I../ -I../../../../usr/include/
+CFLAGS += -I../ $(KHDR_INCLUDES)
 TEST_GEN_PROGS := media_device_test media_device_open video_device_test
 
 include ../lib.mk
diff --git a/tools/testing/selftests/membarrier/Makefile b/tools/testing/selftests/membarrier/Makefile
index 34d1c81a2324..fc840e06ff56 100644
--- a/tools/testing/selftests/membarrier/Makefile
+++ b/tools/testing/selftests/membarrier/Makefile
@@ -1,5 +1,5 @@
 # SPDX-License-Identifier: GPL-2.0-only
-CFLAGS += -g -I../../../../usr/include/
+CFLAGS += -g $(KHDR_INCLUDES)
 LDLIBS += -lpthread
 
 TEST_GEN_PROGS := membarrier_test_single_thread \
diff --git a/tools/testing/selftests/memfd/Makefile b/tools/testing/selftests/memfd/Makefile
index 4da8b565fa32..b798b341cc08 100644
--- a/tools/testing/selftests/memfd/Makefile
+++ b/tools/testing/selftests/memfd/Makefile
@@ -2,7 +2,7 @@
 CFLAGS += -D_FILE_OFFSET_BITS=64
 CFLAGS += -I../../../../include/uapi/
 CFLAGS += -I../../../../include/
-CFLAGS += -I../../../../usr/include/
+CFLAGS += $(KHDR_INCLUDES)
 
 TEST_GEN_PROGS := memfd_test
 TEST_PROGS := run_fuse_test.sh run_hugetlbfs_test.sh
diff --git a/tools/testing/selftests/mount_setattr/Makefile b/tools/testing/selftests/mount_setattr/Makefile
index 2250f7dcb81e..fde72df01b11 100644
--- a/tools/testing/selftests/mount_setattr/Makefile
+++ b/tools/testing/selftests/mount_setattr/Makefile
@@ -1,6 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0
 # Makefile for mount selftests.
-CFLAGS = -g -I../../../../usr/include/ -Wall -O2 -pthread
+CFLAGS = -g $(KHDR_INCLUDES) -Wall -O2 -pthread
 
 TEST_GEN_FILES += mount_setattr_test
 
diff --git a/tools/testing/selftests/move_mount_set_group/Makefile b/tools/testing/selftests/move_mount_set_group/Makefile
index 80c2d86812b0..94235846b6f9 100644
--- a/tools/testing/selftests/move_mount_set_group/Makefile
+++ b/tools/testing/selftests/move_mount_set_group/Makefile
@@ -1,6 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0
 # Makefile for mount selftests.
-CFLAGS = -g -I../../../../usr/include/ -Wall -O2
+CFLAGS = -g $(KHDR_INCLUDES) -Wall -O2
 
 TEST_GEN_FILES += move_mount_set_group_test
 
diff --git a/tools/testing/selftests/net/Makefile b/tools/testing/selftests/net/Makefile
index 3007e98a6d64..bab1222c7d50 100644
--- a/tools/testing/selftests/net/Makefile
+++ b/tools/testing/selftests/net/Makefile
@@ -2,7 +2,7 @@
 # Makefile for net selftests
 
 CFLAGS =  -Wall -Wl,--no-as-needed -O2 -g
-CFLAGS += -I../../../../usr/include/ $(KHDR_INCLUDES)
+CFLAGS += $(KHDR_INCLUDES)
 
 TEST_PROGS := run_netsocktests run_afpackettests test_bpf.sh netdevice.sh \
 	      rtnetlink.sh xfrm_policy.sh test_blackhole_dev.sh
diff --git a/tools/testing/selftests/net/bpf/Makefile b/tools/testing/selftests/net/bpf/Makefile
index 4abaf16d2077..207b6b958f66 100644
--- a/tools/testing/selftests/net/bpf/Makefile
+++ b/tools/testing/selftests/net/bpf/Makefile
@@ -7,7 +7,7 @@ BPFDIR := $(abspath ../../../lib/bpf)
 APIDIR := $(abspath ../../../include/uapi)
 
 CCINCLUDE += -I../../bpf
-CCINCLUDE += -I../../../../../usr/include/
+CCINCLUDE += $(KHDR_INCLUDES)
 CCINCLUDE += -I$(SCRATCH_DIR)/include
 
 BPFOBJ := $(BUILD_DIR)/libbpf/libbpf.a
diff --git a/tools/testing/selftests/net/mptcp/Makefile b/tools/testing/selftests/net/mptcp/Makefile
index 43a723626126..06bba013bcef 100644
--- a/tools/testing/selftests/net/mptcp/Makefile
+++ b/tools/testing/selftests/net/mptcp/Makefile
@@ -2,7 +2,7 @@
 
 top_srcdir = ../../../../..
 
-CFLAGS =  -Wall -Wl,--no-as-needed -O2 -g -I$(top_srcdir)/usr/include $(KHDR_INCLUDES)
+CFLAGS =  -Wall -Wl,--no-as-needed -O2 -g $(KHDR_INCLUDES)
 
 TEST_PROGS := mptcp_connect.sh pm_netlink.sh mptcp_join.sh diag.sh \
 	      simult_flows.sh mptcp_sockopt.sh userspace_pm.sh
diff --git a/tools/testing/selftests/net/openvswitch/Makefile b/tools/testing/selftests/net/openvswitch/Makefile
index 2f1508abc826..41ddfa9fdd1d 100644
--- a/tools/testing/selftests/net/openvswitch/Makefile
+++ b/tools/testing/selftests/net/openvswitch/Makefile
@@ -2,7 +2,7 @@
 
 top_srcdir = ../../../../..
 
-CFLAGS =  -Wall -Wl,--no-as-needed -O2 -g -I$(top_srcdir)/usr/include $(KHDR_INCLUDES)
+CFLAGS =  -Wall -Wl,--no-as-needed -O2 -g $(KHDR_INCLUDES)
 
 TEST_PROGS := openvswitch.sh
 
diff --git a/tools/testing/selftests/perf_events/Makefile b/tools/testing/selftests/perf_events/Makefile
index fcafa5f0d34c..db93c4ff081a 100644
--- a/tools/testing/selftests/perf_events/Makefile
+++ b/tools/testing/selftests/perf_events/Makefile
@@ -1,5 +1,5 @@
 # SPDX-License-Identifier: GPL-2.0
-CFLAGS += -Wl,-no-as-needed -Wall -I../../../../usr/include
+CFLAGS += -Wl,-no-as-needed -Wall $(KHDR_INCLUDES)
 LDFLAGS += -lpthread
 
 TEST_GEN_PROGS := sigtrap_threads remove_on_exec
diff --git a/tools/testing/selftests/pid_namespace/Makefile b/tools/testing/selftests/pid_namespace/Makefile
index edafaca1aeb3..9286a1d22cd3 100644
--- a/tools/testing/selftests/pid_namespace/Makefile
+++ b/tools/testing/selftests/pid_namespace/Makefile
@@ -1,5 +1,5 @@
 # SPDX-License-Identifier: GPL-2.0
-CFLAGS += -g -I../../../../usr/include/
+CFLAGS += -g $(KHDR_INCLUDES)
 
 TEST_GEN_PROGS = regression_enomem
 
diff --git a/tools/testing/selftests/pidfd/Makefile b/tools/testing/selftests/pidfd/Makefile
index 778b6cdc8aed..d731e3e76d5b 100644
--- a/tools/testing/selftests/pidfd/Makefile
+++ b/tools/testing/selftests/pidfd/Makefile
@@ -1,5 +1,5 @@
 # SPDX-License-Identifier: GPL-2.0-only
-CFLAGS += -g -I../../../../usr/include/ -pthread -Wall
+CFLAGS += -g $(KHDR_INCLUDES) -pthread -Wall
 
 TEST_GEN_PROGS := pidfd_test pidfd_fdinfo_test pidfd_open_test \
 	pidfd_poll_test pidfd_wait pidfd_getfd_test pidfd_setns_test
diff --git a/tools/testing/selftests/powerpc/ptrace/Makefile b/tools/testing/selftests/powerpc/ptrace/Makefile
index 2f02cb54224d..cbeeaeae8837 100644
--- a/tools/testing/selftests/powerpc/ptrace/Makefile
+++ b/tools/testing/selftests/powerpc/ptrace/Makefile
@@ -33,7 +33,7 @@ TESTS_64 := $(patsubst %,$(OUTPUT)/%,$(TESTS_64))
 $(TESTS_64): CFLAGS += -m64
 $(TM_TESTS): CFLAGS += -I../tm -mhtm
 
-CFLAGS += -I../../../../../usr/include -fno-pie
+CFLAGS += $(KHDR_INCLUDES) -fno-pie
 
 $(OUTPUT)/ptrace-gpr: ptrace-gpr.S
 $(OUTPUT)/ptrace-pkey $(OUTPUT)/core-pkey: LDLIBS += -pthread
diff --git a/tools/testing/selftests/powerpc/security/Makefile b/tools/testing/selftests/powerpc/security/Makefile
index 7488315fd847..e0d979ab0204 100644
--- a/tools/testing/selftests/powerpc/security/Makefile
+++ b/tools/testing/selftests/powerpc/security/Makefile
@@ -5,7 +5,7 @@ TEST_PROGS := mitigation-patching.sh
 
 top_srcdir = ../../../../..
 
-CFLAGS += -I../../../../../usr/include
+CFLAGS += $(KHDR_INCLUDES)
 
 include ../../lib.mk
 
diff --git a/tools/testing/selftests/powerpc/syscalls/Makefile b/tools/testing/selftests/powerpc/syscalls/Makefile
index b63f8459c704..d1f2648b112b 100644
--- a/tools/testing/selftests/powerpc/syscalls/Makefile
+++ b/tools/testing/selftests/powerpc/syscalls/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0-only
 TEST_GEN_PROGS := ipc_unmuxed rtas_filter
 
-CFLAGS += -I../../../../../usr/include
+CFLAGS += $(KHDR_INCLUDES)
 
 top_srcdir = ../../../../..
 include ../../lib.mk
diff --git a/tools/testing/selftests/powerpc/tm/Makefile b/tools/testing/selftests/powerpc/tm/Makefile
index 5881e97c73c1..3876805c2f31 100644
--- a/tools/testing/selftests/powerpc/tm/Makefile
+++ b/tools/testing/selftests/powerpc/tm/Makefile
@@ -17,7 +17,7 @@ $(TEST_GEN_PROGS): ../harness.c ../utils.c
 CFLAGS += -mhtm
 
 $(OUTPUT)/tm-syscall: tm-syscall-asm.S
-$(OUTPUT)/tm-syscall: CFLAGS += -I../../../../../usr/include
+$(OUTPUT)/tm-syscall: CFLAGS += $(KHDR_INCLUDES)
 $(OUTPUT)/tm-tmspr: CFLAGS += -pthread
 $(OUTPUT)/tm-vmx-unavail: CFLAGS += -pthread -m64
 $(OUTPUT)/tm-resched-dscr: ../pmu/lib.c
diff --git a/tools/testing/selftests/ptp/Makefile b/tools/testing/selftests/ptp/Makefile
index ef06de0898b7..eeab44cc6863 100644
--- a/tools/testing/selftests/ptp/Makefile
+++ b/tools/testing/selftests/ptp/Makefile
@@ -1,5 +1,5 @@
 # SPDX-License-Identifier: GPL-2.0
-CFLAGS += -I../../../../usr/include/
+CFLAGS += $(KHDR_INCLUDES)
 TEST_PROGS := testptp
 LDLIBS += -lrt
 all: $(TEST_PROGS)
diff --git a/tools/testing/selftests/rseq/Makefile b/tools/testing/selftests/rseq/Makefile
index 215e1067f037..3a173e184566 100644
--- a/tools/testing/selftests/rseq/Makefile
+++ b/tools/testing/selftests/rseq/Makefile
@@ -4,7 +4,7 @@ ifneq ($(shell $(CC) --version 2>&1 | head -n 1 | grep clang),)
 CLANG_FLAGS += -no-integrated-as
 endif
 
-CFLAGS += -O2 -Wall -g -I./ -I../../../../usr/include/ -L$(OUTPUT) -Wl,-rpath=./ \
+CFLAGS += -O2 -Wall -g -I./ $(KHDR_INCLUDES) -L$(OUTPUT) -Wl,-rpath=./ \
 	  $(CLANG_FLAGS)
 LDLIBS += -lpthread -ldl
 
diff --git a/tools/testing/selftests/sched/Makefile b/tools/testing/selftests/sched/Makefile
index 10c72f14fea9..099ee9213557 100644
--- a/tools/testing/selftests/sched/Makefile
+++ b/tools/testing/selftests/sched/Makefile
@@ -4,7 +4,7 @@ ifneq ($(shell $(CC) --version 2>&1 | head -n 1 | grep clang),)
 CLANG_FLAGS += -no-integrated-as
 endif
 
-CFLAGS += -O2 -Wall -g -I./ -I../../../../usr/include/  -Wl,-rpath=./ \
+CFLAGS += -O2 -Wall -g -I./ $(KHDR_INCLUDES) -Wl,-rpath=./ \
 	  $(CLANG_FLAGS)
 LDLIBS += -lpthread
 
diff --git a/tools/testing/selftests/seccomp/Makefile b/tools/testing/selftests/seccomp/Makefile
index f017c382c036..584fba487037 100644
--- a/tools/testing/selftests/seccomp/Makefile
+++ b/tools/testing/selftests/seccomp/Makefile
@@ -1,5 +1,5 @@
 # SPDX-License-Identifier: GPL-2.0
-CFLAGS += -Wl,-no-as-needed -Wall -isystem ../../../../usr/include/
+CFLAGS += -Wl,-no-as-needed -Wall $(KHDR_INCLUDES)
 LDFLAGS += -lpthread
 LDLIBS += -lcap
 
diff --git a/tools/testing/selftests/sync/Makefile b/tools/testing/selftests/sync/Makefile
index d0121a8a3523..df0f91bf6890 100644
--- a/tools/testing/selftests/sync/Makefile
+++ b/tools/testing/selftests/sync/Makefile
@@ -1,6 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0
 CFLAGS += -O2 -g -std=gnu89 -pthread -Wall -Wextra
-CFLAGS += -I../../../../usr/include/
+CFLAGS += $(KHDR_INCLUDES)
 LDFLAGS += -pthread
 
 .PHONY: all clean
diff --git a/tools/testing/selftests/user_events/Makefile b/tools/testing/selftests/user_events/Makefile
index c765d8635d9a..87d54c640068 100644
--- a/tools/testing/selftests/user_events/Makefile
+++ b/tools/testing/selftests/user_events/Makefile
@@ -1,5 +1,5 @@
 # SPDX-License-Identifier: GPL-2.0
-CFLAGS += -Wl,-no-as-needed -Wall -I../../../../usr/include
+CFLAGS += -Wl,-no-as-needed -Wall $(KHDR_INCLUDES)
 LDLIBS += -lrt -lpthread -lm
 
 TEST_GEN_PROGS = ftrace_test dyn_test perf_test
diff --git a/tools/testing/selftests/vm/Makefile b/tools/testing/selftests/vm/Makefile
index 89c14e41bd43..ac9366065fd2 100644
--- a/tools/testing/selftests/vm/Makefile
+++ b/tools/testing/selftests/vm/Makefile
@@ -25,7 +25,7 @@ MACHINE ?= $(shell echo $(uname_M) | sed -e 's/aarch64.*/arm64/' -e 's/ppc64.*/p
 # LDLIBS.
 MAKEFLAGS += --no-builtin-rules
 
-CFLAGS = -Wall -I $(top_srcdir) -I $(top_srcdir)/usr/include $(EXTRA_CFLAGS) $(KHDR_INCLUDES)
+CFLAGS = -Wall -I $(top_srcdir) $(EXTRA_CFLAGS) $(KHDR_INCLUDES)
 LDLIBS = -lrt -lpthread
 TEST_GEN_FILES = cow
 TEST_GEN_FILES += compaction_test
-- 
2.25.1

