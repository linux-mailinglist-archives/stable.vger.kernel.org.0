Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 982DF59475B
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 01:59:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242559AbiHOXLi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 19:11:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353018AbiHOXJh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 19:09:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2187B8709C;
        Mon, 15 Aug 2022 12:59:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8956AB8106C;
        Mon, 15 Aug 2022 19:59:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE574C433C1;
        Mon, 15 Aug 2022 19:59:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660593592;
        bh=PStUmSJuDh/2XlYej5na14v1ex14KuMW3PONNUSXsr0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OedSWArpZg4DrAe6VsSlJu1h8pu5UFwMCWzx10OTIu8fljKDtzWu3U4te+IRxfgmI
         I/Bys0o8b6FDSvcki7rnwm12jROcawxbhL8in67W7FDmX8n2IF9yLf0+4W3/zxC9lF
         qYP40mfgB5qlC0GG6GgaCSUQrqyAwEiZNtwtQ/BY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0293/1157] io_uring: move to separate directory
Date:   Mon, 15 Aug 2022 19:54:09 +0200
Message-Id: <20220815180451.345977044@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
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
index 64379c699903..08620b9a44fc 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -7773,9 +7773,6 @@ F:	include/linux/fs.h
 F:	include/linux/fs_types.h
 F:	include/uapi/linux/fs.h
 F:	include/uapi/linux/openat2.h
-X:	fs/io-wq.c
-X:	fs/io-wq.h
-X:	fs/io_uring.c
 
 FINTEK F75375S HARDWARE MONITOR AND FAN CONTROLLER DRIVER
 M:	Riku Voipio <riku.voipio@iki.fi>
@@ -10476,9 +10473,7 @@ L:	io-uring@vger.kernel.org
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
index cef467fc574e..68b3da2babd5 100644
--- a/Makefile
+++ b/Makefile
@@ -1102,6 +1102,7 @@ export MODULES_NSDEPS := $(extmod_prefix)modules.nsdeps
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
index e8e769be9ed0..b63956975109 100644
--- a/fs/io_uring.c
+++ b/io_uring/io_uring.c
@@ -87,7 +87,7 @@
 
 #include <uapi/linux/io_uring.h>
 
-#include "internal.h"
+#include "../fs/internal.h"
 #include "io-wq.h"
 
 #define IORING_MAX_ENTRIES	32768
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index f1e070551aa9..91471ba8dbd2 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -91,7 +91,7 @@
 #include "stats.h"
 
 #include "../workqueue_internal.h"
-#include "../../fs/io-wq.h"
+#include "../../io_uring/io-wq.h"
 #include "../smpboot.h"
 
 /*
-- 
2.35.1



