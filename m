Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D90CB1F2CC9
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 02:30:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729349AbgFHXP7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 19:15:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:37138 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730136AbgFHXP6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jun 2020 19:15:58 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B42C120760;
        Mon,  8 Jun 2020 23:15:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591658158;
        bh=8oY5NOb43ECW2UuHijbZc/Fbrh+sjRf3T0dHqJZ28CQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jKMP9b2KNY0f7qAij0PKq6hIUuXj7vrfuB2kGJw7e1sUuHjjQWxV5/6aqFBRdUyej
         IEl4orlb0DzhOa04nSw2m5bnJ9peOWKnpLvvAqs1C96xMEC8aRCIuRf0gNKk3/9seL
         6YDb1x0f8o8gZd6Bl2cPUvY+KzSdtCFOPkVflBYY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Marco Elver <elver@google.com>,
        kernel test robot <rong.a.chen@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrey Konovalov <andreyknvl@google.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Alexander Potapenko <glider@google.com>,
        Andrey Ryabinin <aryabinin@virtuozzo.com>,
        Qian Cai <cai@lca.pw>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        kasan-dev@googlegroups.com, linux-mm@kvack.org
Subject: [PATCH AUTOSEL 5.6 188/606] kasan: disable branch tracing for core runtime
Date:   Mon,  8 Jun 2020 19:05:13 -0400
Message-Id: <20200608231211.3363633-188-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608231211.3363633-1-sashal@kernel.org>
References: <20200608231211.3363633-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marco Elver <elver@google.com>

commit 33cd65e73abd693c00c4156cf23677c453b41b3b upstream.

During early boot, while KASAN is not yet initialized, it is possible to
enter reporting code-path and end up in kasan_report().

While uninitialized, the branch there prevents generating any reports,
however, under certain circumstances when branches are being traced
(TRACE_BRANCH_PROFILING), we may recurse deep enough to cause kernel
reboots without warning.

To prevent similar issues in future, we should disable branch tracing
for the core runtime.

[elver@google.com: remove duplicate DISABLE_BRANCH_PROFILING, per Qian Cai]
  Link: https://lore.kernel.org/lkml/20200517011732.GE24705@shao2-debian/
  Link: http://lkml.kernel.org/r/20200522075207.157349-1-elver@google.com
Reported-by: kernel test robot <rong.a.chen@intel.com>
Signed-off-by: Marco Elver <elver@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Andrey Konovalov <andreyknvl@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Qian Cai <cai@lca.pw>
Cc: <stable@vger.kernel.org>
Link: http://lkml.kernel.org/r//20200517011732.GE24705@shao2-debian/
Link: http://lkml.kernel.org/r/20200519182459.87166-1-elver@google.com
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/kasan/Makefile  | 8 ++++----
 mm/kasan/generic.c | 1 -
 mm/kasan/tags.c    | 1 -
 3 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/mm/kasan/Makefile b/mm/kasan/Makefile
index 08b43de2383b..f36ffc090f5f 100644
--- a/mm/kasan/Makefile
+++ b/mm/kasan/Makefile
@@ -14,10 +14,10 @@ CFLAGS_REMOVE_tags.o = $(CC_FLAGS_FTRACE)
 # Function splitter causes unnecessary splits in __asan_load1/__asan_store1
 # see: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=63533
 
-CFLAGS_common.o := $(call cc-option, -fno-conserve-stack -fno-stack-protector)
-CFLAGS_generic.o := $(call cc-option, -fno-conserve-stack -fno-stack-protector)
-CFLAGS_generic_report.o := $(call cc-option, -fno-conserve-stack -fno-stack-protector)
-CFLAGS_tags.o := $(call cc-option, -fno-conserve-stack -fno-stack-protector)
+CFLAGS_common.o := $(call cc-option, -fno-conserve-stack -fno-stack-protector) -DDISABLE_BRANCH_PROFILING
+CFLAGS_generic.o := $(call cc-option, -fno-conserve-stack -fno-stack-protector) -DDISABLE_BRANCH_PROFILING
+CFLAGS_generic_report.o := $(call cc-option, -fno-conserve-stack -fno-stack-protector) -DDISABLE_BRANCH_PROFILING
+CFLAGS_tags.o := $(call cc-option, -fno-conserve-stack -fno-stack-protector) -DDISABLE_BRANCH_PROFILING
 
 obj-$(CONFIG_KASAN) := common.o init.o report.o
 obj-$(CONFIG_KASAN_GENERIC) += generic.o generic_report.o quarantine.o
diff --git a/mm/kasan/generic.c b/mm/kasan/generic.c
index 616f9dd82d12..76a80033e0b7 100644
--- a/mm/kasan/generic.c
+++ b/mm/kasan/generic.c
@@ -15,7 +15,6 @@
  */
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
-#define DISABLE_BRANCH_PROFILING
 
 #include <linux/export.h>
 #include <linux/interrupt.h>
diff --git a/mm/kasan/tags.c b/mm/kasan/tags.c
index 0e987c9ca052..caf4efd9888c 100644
--- a/mm/kasan/tags.c
+++ b/mm/kasan/tags.c
@@ -12,7 +12,6 @@
  */
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
-#define DISABLE_BRANCH_PROFILING
 
 #include <linux/export.h>
 #include <linux/interrupt.h>
-- 
2.25.1

