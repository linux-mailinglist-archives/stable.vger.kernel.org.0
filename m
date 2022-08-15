Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93B6E5940A7
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 23:49:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346341AbiHOUt2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 16:49:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345628AbiHOUsr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 16:48:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12DC7B8F1F;
        Mon, 15 Aug 2022 12:09:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3589460BBF;
        Mon, 15 Aug 2022 19:09:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20395C433D7;
        Mon, 15 Aug 2022 19:09:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660590542;
        bh=b73m9hpZsq1LPof4CJ65b/MGPVplSqIlbYsDVlENReA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H0BVWg85ek9rDqxammAbu0q/Acsp01NELHopSR9PBk6Po7efX4Vr8JuO3Q0WMQL8H
         KIu6w16gkHc9UxsJiS+XJQSglxuCuXBadSKHPy7FBYTy52UVo0cYa4nD92dFzmfVIV
         CAb05D0mkqXUY563gX1eHPBLUpjJ8MoCv0bUkGyc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0291/1095] io_uring: move to separate directory
Date:   Mon, 15 Aug 2022 19:54:50 +0200
Message-Id: <20220815180441.830696103@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

[ Upstream commit ed29b0b4fd835b058ddd151c49d021e28d631ee6 ]

In preparation for splitting io_uring up a bit, move it into its own
top level directory. It didn't really belong in fs/ anyway, as it's
not a file system only API.

This adds io_uring/ and moves the core files in there, and updates the
MAINTAINERS file for the new location.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 MAINTAINERS                 | 7 +------
 Makefile                    | 1 +
 fs/Makefile                 | 2 --
 io_uring/Makefile           | 6 ++++++
 {fs => io_uring}/io-wq.c    | 0
 {fs => io_uring}/io-wq.h    | 0
 {fs => io_uring}/io_uring.c | 2 +-
 kernel/sched/core.c         | 2 +-
 8 files changed, 10 insertions(+), 10 deletions(-)
 create mode 100644 io_uring/Makefile
 rename {fs => io_uring}/io-wq.c (100%)
 rename {fs => io_uring}/io-wq.h (100%)
 rename {fs => io_uring}/io_uring.c (99%)

diff --git a/MAINTAINERS b/MAINTAINERS
index 2b70e2d21405..c7c7a96b62a8 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -7599,9 +7599,6 @@ F:	include/linux/fs.h
 F:	include/linux/fs_types.h
 F:	include/uapi/linux/fs.h
 F:	include/uapi/linux/openat2.h
-X:	fs/io-wq.c
-X:	fs/io-wq.h
-X:	fs/io_uring.c
 
 FINTEK F75375S HARDWARE MONITOR AND FAN CONTROLLER DRIVER
 M:	Riku Voipio <riku.voipio@iki.fi>
@@ -10277,9 +10274,7 @@ L:	io-uring@vger.kernel.org
 S:	Maintained
 T:	git git://git.kernel.dk/linux-block
 T:	git git://git.kernel.dk/liburing
-F:	fs/io-wq.c
-F:	fs/io-wq.h
-F:	fs/io_uring.c
+F:	io_uring/
 F:	include/linux/io_uring.h
 F:	include/uapi/linux/io_uring.h
 F:	tools/io_uring/
diff --git a/Makefile b/Makefile
index 13dd4bd226cb..90e2129a3b80 100644
--- a/Makefile
+++ b/Makefile
@@ -1100,6 +1100,7 @@ export MODULES_NSDEPS := $(extmod_prefix)modules.nsdeps
 ifeq ($(KBUILD_EXTMOD),)
 core-y			+= kernel/ certs/ mm/ fs/ ipc/ security/ crypto/
 core-$(CONFIG_BLOCK)	+= block/
+core-$(CONFIG_IO_URING)	+= io_uring/
 
 vmlinux-dirs	:= $(patsubst %/,%,$(filter %/, \
 		     $(core-y) $(core-m) $(drivers-y) $(drivers-m) \
diff --git a/fs/Makefile b/fs/Makefile
index 208a74e0b00e..93b80529f8e8 100644
--- a/fs/Makefile
+++ b/fs/Makefile
@@ -34,8 +34,6 @@ obj-$(CONFIG_TIMERFD)		+= timerfd.o
 obj-$(CONFIG_EVENTFD)		+= eventfd.o
 obj-$(CONFIG_USERFAULTFD)	+= userfaultfd.o
 obj-$(CONFIG_AIO)               += aio.o
-obj-$(CONFIG_IO_URING)		+= io_uring.o
-obj-$(CONFIG_IO_WQ)		+= io-wq.o
 obj-$(CONFIG_FS_DAX)		+= dax.o
 obj-$(CONFIG_FS_ENCRYPTION)	+= crypto/
 obj-$(CONFIG_FS_VERITY)		+= verity/
diff --git a/io_uring/Makefile b/io_uring/Makefile
new file mode 100644
index 000000000000..3680425df947
--- /dev/null
+++ b/io_uring/Makefile
@@ -0,0 +1,6 @@
+# SPDX-License-Identifier: GPL-2.0
+#
+# Makefile for io_uring
+
+obj-$(CONFIG_IO_URING)		+= io_uring.o
+obj-$(CONFIG_IO_WQ)		+= io-wq.o
diff --git a/fs/io-wq.c b/io_uring/io-wq.c
similarity index 100%
rename from fs/io-wq.c
rename to io_uring/io-wq.c
diff --git a/fs/io-wq.h b/io_uring/io-wq.h
similarity index 100%
rename from fs/io-wq.h
rename to io_uring/io-wq.h
diff --git a/fs/io_uring.c b/io_uring/io_uring.c
similarity index 99%
rename from fs/io_uring.c
rename to io_uring/io_uring.c
index 3d97372e811e..b25e59da129f 100644
--- a/fs/io_uring.c
+++ b/io_uring/io_uring.c
@@ -86,7 +86,7 @@
 
 #include <uapi/linux/io_uring.h>
 
-#include "internal.h"
+#include "../fs/internal.h"
 #include "io-wq.h"
 
 #define IORING_MAX_ENTRIES	32768
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 6baf96d2fa39..72b2f277b0dd 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -88,7 +88,7 @@
 #include "stats.h"
 
 #include "../workqueue_internal.h"
-#include "../../fs/io-wq.h"
+#include "../../io_uring/io-wq.h"
 #include "../smpboot.h"
 
 /*
-- 
2.35.1



