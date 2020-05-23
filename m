Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F6FB1DF4F6
	for <lists+stable@lfdr.de>; Sat, 23 May 2020 07:23:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387583AbgEWFXB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 23 May 2020 01:23:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:55412 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387426AbgEWFXB (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 23 May 2020 01:23:01 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ED67E2072C;
        Sat, 23 May 2020 05:22:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590211380;
        bh=6Al+SkICH/jLZY2HHCcqAsSYeyztBjz+vMLiq6kUOMo=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=LMxV1qJi5XlzPpOmMC9HLzFqgIowhRXOJIfctcbQeVQHgjcXviwYXpUfjkq4ondtm
         RvbJtiYf1ZjTRHbY4mHlXv/kU3DhjLady5RMGVJT0UPoAam67JqcqLE9W346F4C8ks
         x1/9w+eP+Xq+1Q02BY2cmr5DJoNsWhEwPGtXFNlg=
Date:   Fri, 22 May 2020 22:22:59 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, andreyknvl@google.com,
        aryabinin@virtuozzo.com, cai@lca.pw, dvyukov@google.com,
        elver@google.com, glider@google.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, rong.a.chen@intel.com,
        stable@vger.kernel.org, torvalds@linux-foundation.org
Subject:  [patch 06/11] kasan: disable branch tracing for core
 runtime
Message-ID: <20200523052259.86QThphG9%akpm@linux-foundation.org>
In-Reply-To: <20200522222217.ee14ad7eda7aab1e6697da6c@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marco Elver <elver@google.com>
Subject: kasan: disable branch tracing for core runtime

During early boot, while KASAN is not yet initialized, it is possible to
enter reporting code-path and end up in kasan_report().  While
uninitialized, the branch there prevents generating any reports, however,
under certain circumstances when branches are being traced
(TRACE_BRANCH_PROFILING), we may recurse deep enough to cause kernel
reboots without warning.

To prevent similar issues in future, we should disable branch tracing for
the core runtime.

[elver@google.com: remove duplicate DISABLE_BRANCH_PROFILING, per Qian Cai]
  Link: https://lore.kernel.org/lkml/20200517011732.GE24705@shao2-debian/
  Link: http://lkml.kernel.org/r/20200522075207.157349-1-elver@google.com
Link: http://lkml.kernel.org/r//20200517011732.GE24705@shao2-debian/
Link: http://lkml.kernel.org/r/20200519182459.87166-1-elver@google.com
Signed-off-by: Marco Elver <elver@google.com>
Reported-by: kernel test robot <rong.a.chen@intel.com>
Reviewed-by: Andrey Konovalov <andreyknvl@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Qian Cai <cai@lca.pw>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/Makefile  |   16 ++++++++--------
 mm/kasan/generic.c |    1 -
 mm/kasan/tags.c    |    1 -
 3 files changed, 8 insertions(+), 10 deletions(-)

--- a/mm/kasan/generic.c~kasan-disable-branch-tracing-for-core-runtime
+++ a/mm/kasan/generic.c
@@ -15,7 +15,6 @@
  */
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
-#define DISABLE_BRANCH_PROFILING
 
 #include <linux/export.h>
 #include <linux/interrupt.h>
--- a/mm/kasan/Makefile~kasan-disable-branch-tracing-for-core-runtime
+++ a/mm/kasan/Makefile
@@ -15,14 +15,14 @@ CFLAGS_REMOVE_tags_report.o = $(CC_FLAGS
 
 # Function splitter causes unnecessary splits in __asan_load1/__asan_store1
 # see: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=63533
-CFLAGS_common.o := $(call cc-option, -fno-conserve-stack -fno-stack-protector)
-CFLAGS_generic.o := $(call cc-option, -fno-conserve-stack -fno-stack-protector)
-CFLAGS_generic_report.o := $(call cc-option, -fno-conserve-stack -fno-stack-protector)
-CFLAGS_init.o := $(call cc-option, -fno-conserve-stack -fno-stack-protector)
-CFLAGS_quarantine.o := $(call cc-option, -fno-conserve-stack -fno-stack-protector)
-CFLAGS_report.o := $(call cc-option, -fno-conserve-stack -fno-stack-protector)
-CFLAGS_tags.o := $(call cc-option, -fno-conserve-stack -fno-stack-protector)
-CFLAGS_tags_report.o := $(call cc-option, -fno-conserve-stack -fno-stack-protector)
+CFLAGS_common.o := $(call cc-option, -fno-conserve-stack -fno-stack-protector) -DDISABLE_BRANCH_PROFILING
+CFLAGS_generic.o := $(call cc-option, -fno-conserve-stack -fno-stack-protector) -DDISABLE_BRANCH_PROFILING
+CFLAGS_generic_report.o := $(call cc-option, -fno-conserve-stack -fno-stack-protector) -DDISABLE_BRANCH_PROFILING
+CFLAGS_init.o := $(call cc-option, -fno-conserve-stack -fno-stack-protector) -DDISABLE_BRANCH_PROFILING
+CFLAGS_quarantine.o := $(call cc-option, -fno-conserve-stack -fno-stack-protector) -DDISABLE_BRANCH_PROFILING
+CFLAGS_report.o := $(call cc-option, -fno-conserve-stack -fno-stack-protector) -DDISABLE_BRANCH_PROFILING
+CFLAGS_tags.o := $(call cc-option, -fno-conserve-stack -fno-stack-protector) -DDISABLE_BRANCH_PROFILING
+CFLAGS_tags_report.o := $(call cc-option, -fno-conserve-stack -fno-stack-protector) -DDISABLE_BRANCH_PROFILING
 
 obj-$(CONFIG_KASAN) := common.o init.o report.o
 obj-$(CONFIG_KASAN_GENERIC) += generic.o generic_report.o quarantine.o
--- a/mm/kasan/tags.c~kasan-disable-branch-tracing-for-core-runtime
+++ a/mm/kasan/tags.c
@@ -12,7 +12,6 @@
  */
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
-#define DISABLE_BRANCH_PROFILING
 
 #include <linux/export.h>
 #include <linux/interrupt.h>
_
