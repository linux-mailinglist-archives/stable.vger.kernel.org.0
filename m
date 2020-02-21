Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D24F91673BC
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 09:18:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733270AbgBUIPF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 03:15:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:51732 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733267AbgBUIPD (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 03:15:03 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 19A902467B;
        Fri, 21 Feb 2020 08:15:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582272902;
        bh=L/7k3m7ujjUJpg6AZQAv5OmhaIa7hFweHAdzA6ZUDXQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xB5moCMJBUzmAs+hTQB6nQ1hlk/8Jx5Ro9Qa+euTuEVnM85L2V9JtRMRV/7cY2RME
         pOhKUeZN+WEu6+LO+SYsA4FWrkHD4Xbf1U9FmBU1JRoJkYp+BI9UWcxZwoICKEtYex
         yrTwAhYkgNptk/dvYctCIpXWsn3gNIWE7HdNrhXI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Masahiro Yamada <masahiroy@kernel.org>,
        Gang He <ghe@suse.com>, Mark Fasheh <mark@fasheh.com>,
        Joel Becker <jlbec@evilplan.org>,
        Junxiao Bi <junxiao.bi@oracle.com>,
        Joseph Qi <jiangqi903@gmail.com>,
        Changwei Ge <gechangwei@live.cn>,
        Jun Piao <piaojun@huawei.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 318/344] ocfs2: make local header paths relative to C files
Date:   Fri, 21 Feb 2020 08:41:57 +0100
Message-Id: <20200221072419.012837068@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221072349.335551332@linuxfoundation.org>
References: <20200221072349.335551332@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masahiro Yamada <masahiroy@kernel.org>

[ Upstream commit ca322fb6030956c2337fbf1c1beeb08c5dd5c943 ]

Gang He reports the failure of building fs/ocfs2/ as an external module
of the kernel installed on the system:

 $ cd fs/ocfs2
 $ make -C /lib/modules/`uname -r`/build M=`pwd` modules

If you want to make it work reliably, I'd recommend to remove ccflags-y
from the Makefiles, and to make header paths relative to the C files.  I
think this is the correct usage of the #include "..." directive.

Link: http://lkml.kernel.org/r/20191227022950.14804-1-ghe@suse.com
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Gang He <ghe@suse.com>
Reported-by: Gang He <ghe@suse.com>
Reviewed-by: Gang He <ghe@suse.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Joseph Qi <jiangqi903@gmail.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ocfs2/dlm/Makefile      | 2 --
 fs/ocfs2/dlm/dlmast.c      | 8 ++++----
 fs/ocfs2/dlm/dlmconvert.c  | 8 ++++----
 fs/ocfs2/dlm/dlmdebug.c    | 8 ++++----
 fs/ocfs2/dlm/dlmdomain.c   | 8 ++++----
 fs/ocfs2/dlm/dlmlock.c     | 8 ++++----
 fs/ocfs2/dlm/dlmmaster.c   | 8 ++++----
 fs/ocfs2/dlm/dlmrecovery.c | 8 ++++----
 fs/ocfs2/dlm/dlmthread.c   | 8 ++++----
 fs/ocfs2/dlm/dlmunlock.c   | 8 ++++----
 fs/ocfs2/dlmfs/Makefile    | 2 --
 fs/ocfs2/dlmfs/dlmfs.c     | 4 ++--
 fs/ocfs2/dlmfs/userdlm.c   | 6 +++---
 13 files changed, 41 insertions(+), 45 deletions(-)

diff --git a/fs/ocfs2/dlm/Makefile b/fs/ocfs2/dlm/Makefile
index 38b2243727763..5e700b45d32d2 100644
--- a/fs/ocfs2/dlm/Makefile
+++ b/fs/ocfs2/dlm/Makefile
@@ -1,6 +1,4 @@
 # SPDX-License-Identifier: GPL-2.0-only
-ccflags-y := -I $(srctree)/$(src)/..
-
 obj-$(CONFIG_OCFS2_FS_O2CB) += ocfs2_dlm.o
 
 ocfs2_dlm-objs := dlmdomain.o dlmdebug.o dlmthread.o dlmrecovery.o \
diff --git a/fs/ocfs2/dlm/dlmast.c b/fs/ocfs2/dlm/dlmast.c
index 4de89af96abf0..6abaded3ff6bd 100644
--- a/fs/ocfs2/dlm/dlmast.c
+++ b/fs/ocfs2/dlm/dlmast.c
@@ -23,15 +23,15 @@
 #include <linux/spinlock.h>
 
 
-#include "cluster/heartbeat.h"
-#include "cluster/nodemanager.h"
-#include "cluster/tcp.h"
+#include "../cluster/heartbeat.h"
+#include "../cluster/nodemanager.h"
+#include "../cluster/tcp.h"
 
 #include "dlmapi.h"
 #include "dlmcommon.h"
 
 #define MLOG_MASK_PREFIX ML_DLM
-#include "cluster/masklog.h"
+#include "../cluster/masklog.h"
 
 static void dlm_update_lvb(struct dlm_ctxt *dlm, struct dlm_lock_resource *res,
 			   struct dlm_lock *lock);
diff --git a/fs/ocfs2/dlm/dlmconvert.c b/fs/ocfs2/dlm/dlmconvert.c
index 965f45dbe17bf..6051edc33aefa 100644
--- a/fs/ocfs2/dlm/dlmconvert.c
+++ b/fs/ocfs2/dlm/dlmconvert.c
@@ -23,9 +23,9 @@
 #include <linux/spinlock.h>
 
 
-#include "cluster/heartbeat.h"
-#include "cluster/nodemanager.h"
-#include "cluster/tcp.h"
+#include "../cluster/heartbeat.h"
+#include "../cluster/nodemanager.h"
+#include "../cluster/tcp.h"
 
 #include "dlmapi.h"
 #include "dlmcommon.h"
@@ -33,7 +33,7 @@
 #include "dlmconvert.h"
 
 #define MLOG_MASK_PREFIX ML_DLM
-#include "cluster/masklog.h"
+#include "../cluster/masklog.h"
 
 /* NOTE: __dlmconvert_master is the only function in here that
  * needs a spinlock held on entry (res->spinlock) and it is the
diff --git a/fs/ocfs2/dlm/dlmdebug.c b/fs/ocfs2/dlm/dlmdebug.c
index 4d0b452012b25..c5c6efba7b5e2 100644
--- a/fs/ocfs2/dlm/dlmdebug.c
+++ b/fs/ocfs2/dlm/dlmdebug.c
@@ -17,9 +17,9 @@
 #include <linux/debugfs.h>
 #include <linux/export.h>
 
-#include "cluster/heartbeat.h"
-#include "cluster/nodemanager.h"
-#include "cluster/tcp.h"
+#include "../cluster/heartbeat.h"
+#include "../cluster/nodemanager.h"
+#include "../cluster/tcp.h"
 
 #include "dlmapi.h"
 #include "dlmcommon.h"
@@ -27,7 +27,7 @@
 #include "dlmdebug.h"
 
 #define MLOG_MASK_PREFIX ML_DLM
-#include "cluster/masklog.h"
+#include "../cluster/masklog.h"
 
 static int stringify_lockname(const char *lockname, int locklen, char *buf,
 			      int len);
diff --git a/fs/ocfs2/dlm/dlmdomain.c b/fs/ocfs2/dlm/dlmdomain.c
index ee6f459f97706..357cfc702ce36 100644
--- a/fs/ocfs2/dlm/dlmdomain.c
+++ b/fs/ocfs2/dlm/dlmdomain.c
@@ -20,9 +20,9 @@
 #include <linux/debugfs.h>
 #include <linux/sched/signal.h>
 
-#include "cluster/heartbeat.h"
-#include "cluster/nodemanager.h"
-#include "cluster/tcp.h"
+#include "../cluster/heartbeat.h"
+#include "../cluster/nodemanager.h"
+#include "../cluster/tcp.h"
 
 #include "dlmapi.h"
 #include "dlmcommon.h"
@@ -30,7 +30,7 @@
 #include "dlmdebug.h"
 
 #define MLOG_MASK_PREFIX (ML_DLM|ML_DLM_DOMAIN)
-#include "cluster/masklog.h"
+#include "../cluster/masklog.h"
 
 /*
  * ocfs2 node maps are array of long int, which limits to send them freely
diff --git a/fs/ocfs2/dlm/dlmlock.c b/fs/ocfs2/dlm/dlmlock.c
index baff087f38632..83f0760e4fbaa 100644
--- a/fs/ocfs2/dlm/dlmlock.c
+++ b/fs/ocfs2/dlm/dlmlock.c
@@ -25,9 +25,9 @@
 #include <linux/delay.h>
 
 
-#include "cluster/heartbeat.h"
-#include "cluster/nodemanager.h"
-#include "cluster/tcp.h"
+#include "../cluster/heartbeat.h"
+#include "../cluster/nodemanager.h"
+#include "../cluster/tcp.h"
 
 #include "dlmapi.h"
 #include "dlmcommon.h"
@@ -35,7 +35,7 @@
 #include "dlmconvert.h"
 
 #define MLOG_MASK_PREFIX ML_DLM
-#include "cluster/masklog.h"
+#include "../cluster/masklog.h"
 
 static struct kmem_cache *dlm_lock_cache;
 
diff --git a/fs/ocfs2/dlm/dlmmaster.c b/fs/ocfs2/dlm/dlmmaster.c
index 74b768ca1cd88..c9d7037b6793c 100644
--- a/fs/ocfs2/dlm/dlmmaster.c
+++ b/fs/ocfs2/dlm/dlmmaster.c
@@ -25,9 +25,9 @@
 #include <linux/delay.h>
 
 
-#include "cluster/heartbeat.h"
-#include "cluster/nodemanager.h"
-#include "cluster/tcp.h"
+#include "../cluster/heartbeat.h"
+#include "../cluster/nodemanager.h"
+#include "../cluster/tcp.h"
 
 #include "dlmapi.h"
 #include "dlmcommon.h"
@@ -35,7 +35,7 @@
 #include "dlmdebug.h"
 
 #define MLOG_MASK_PREFIX (ML_DLM|ML_DLM_MASTER)
-#include "cluster/masklog.h"
+#include "../cluster/masklog.h"
 
 static void dlm_mle_node_down(struct dlm_ctxt *dlm,
 			      struct dlm_master_list_entry *mle,
diff --git a/fs/ocfs2/dlm/dlmrecovery.c b/fs/ocfs2/dlm/dlmrecovery.c
index 064ce5bbc3f6c..bcaaca5112d6e 100644
--- a/fs/ocfs2/dlm/dlmrecovery.c
+++ b/fs/ocfs2/dlm/dlmrecovery.c
@@ -26,16 +26,16 @@
 #include <linux/delay.h>
 
 
-#include "cluster/heartbeat.h"
-#include "cluster/nodemanager.h"
-#include "cluster/tcp.h"
+#include "../cluster/heartbeat.h"
+#include "../cluster/nodemanager.h"
+#include "../cluster/tcp.h"
 
 #include "dlmapi.h"
 #include "dlmcommon.h"
 #include "dlmdomain.h"
 
 #define MLOG_MASK_PREFIX (ML_DLM|ML_DLM_RECOVERY)
-#include "cluster/masklog.h"
+#include "../cluster/masklog.h"
 
 static void dlm_do_local_recovery_cleanup(struct dlm_ctxt *dlm, u8 dead_node);
 
diff --git a/fs/ocfs2/dlm/dlmthread.c b/fs/ocfs2/dlm/dlmthread.c
index 61c51c268460a..fd40c17cd0225 100644
--- a/fs/ocfs2/dlm/dlmthread.c
+++ b/fs/ocfs2/dlm/dlmthread.c
@@ -25,16 +25,16 @@
 #include <linux/delay.h>
 
 
-#include "cluster/heartbeat.h"
-#include "cluster/nodemanager.h"
-#include "cluster/tcp.h"
+#include "../cluster/heartbeat.h"
+#include "../cluster/nodemanager.h"
+#include "../cluster/tcp.h"
 
 #include "dlmapi.h"
 #include "dlmcommon.h"
 #include "dlmdomain.h"
 
 #define MLOG_MASK_PREFIX (ML_DLM|ML_DLM_THREAD)
-#include "cluster/masklog.h"
+#include "../cluster/masklog.h"
 
 static int dlm_thread(void *data);
 static void dlm_flush_asts(struct dlm_ctxt *dlm);
diff --git a/fs/ocfs2/dlm/dlmunlock.c b/fs/ocfs2/dlm/dlmunlock.c
index 3883633e82eb9..dcb17ca8ae74d 100644
--- a/fs/ocfs2/dlm/dlmunlock.c
+++ b/fs/ocfs2/dlm/dlmunlock.c
@@ -23,15 +23,15 @@
 #include <linux/spinlock.h>
 #include <linux/delay.h>
 
-#include "cluster/heartbeat.h"
-#include "cluster/nodemanager.h"
-#include "cluster/tcp.h"
+#include "../cluster/heartbeat.h"
+#include "../cluster/nodemanager.h"
+#include "../cluster/tcp.h"
 
 #include "dlmapi.h"
 #include "dlmcommon.h"
 
 #define MLOG_MASK_PREFIX ML_DLM
-#include "cluster/masklog.h"
+#include "../cluster/masklog.h"
 
 #define DLM_UNLOCK_FREE_LOCK           0x00000001
 #define DLM_UNLOCK_CALL_AST            0x00000002
diff --git a/fs/ocfs2/dlmfs/Makefile b/fs/ocfs2/dlmfs/Makefile
index a9874e441bd4a..c7895f65be0ea 100644
--- a/fs/ocfs2/dlmfs/Makefile
+++ b/fs/ocfs2/dlmfs/Makefile
@@ -1,6 +1,4 @@
 # SPDX-License-Identifier: GPL-2.0-only
-ccflags-y := -I $(srctree)/$(src)/..
-
 obj-$(CONFIG_OCFS2_FS) += ocfs2_dlmfs.o
 
 ocfs2_dlmfs-objs := userdlm.o dlmfs.o
diff --git a/fs/ocfs2/dlmfs/dlmfs.c b/fs/ocfs2/dlmfs/dlmfs.c
index 4f1668c81e1f1..8e4f1ace467c1 100644
--- a/fs/ocfs2/dlmfs/dlmfs.c
+++ b/fs/ocfs2/dlmfs/dlmfs.c
@@ -33,11 +33,11 @@
 
 #include <linux/uaccess.h>
 
-#include "stackglue.h"
+#include "../stackglue.h"
 #include "userdlm.h"
 
 #define MLOG_MASK_PREFIX ML_DLMFS
-#include "cluster/masklog.h"
+#include "../cluster/masklog.h"
 
 
 static const struct super_operations dlmfs_ops;
diff --git a/fs/ocfs2/dlmfs/userdlm.c b/fs/ocfs2/dlmfs/userdlm.c
index 525b14ddfba50..3df5be25bfb1f 100644
--- a/fs/ocfs2/dlmfs/userdlm.c
+++ b/fs/ocfs2/dlmfs/userdlm.c
@@ -21,12 +21,12 @@
 #include <linux/types.h>
 #include <linux/crc32.h>
 
-#include "ocfs2_lockingver.h"
-#include "stackglue.h"
+#include "../ocfs2_lockingver.h"
+#include "../stackglue.h"
 #include "userdlm.h"
 
 #define MLOG_MASK_PREFIX ML_DLMFS
-#include "cluster/masklog.h"
+#include "../cluster/masklog.h"
 
 
 static inline struct user_lock_res *user_lksb_to_lock_res(struct ocfs2_dlm_lksb *lksb)
-- 
2.20.1



