Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7464B1E2D6D
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 21:24:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391661AbgEZTKB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 15:10:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:39106 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403989AbgEZTJ6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 May 2020 15:09:58 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DC5E720873;
        Tue, 26 May 2020 19:09:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590520197;
        bh=SbiT9tShyeJeTrafTHaX26vSwjPfBaUpDXmf1AKE84s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zfaUG+JjtHxf0EpzqiNj4ItmoMeNVDuY4/eaWbRdg5bI60D6M+pZ26rJMabtOQtdn
         ywb6WypMK0jCQreOJqSJrYUrkVwcZzhLgxhUSfaExxl//qRcwQp3+oPIHjLTvyPDlp
         wtD6/WFEHGMekYVr0wSZkWTK4ETbcmSCeNeVKMAs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <rong.a.chen@intel.com>,
        Marco Elver <elver@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrey Konovalov <andreyknvl@google.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Alexander Potapenko <glider@google.com>,
        Andrey Ryabinin <aryabinin@virtuozzo.com>,
        Qian Cai <cai@lca.pw>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.4 096/111] kasan: disable branch tracing for core runtime
Date:   Tue, 26 May 2020 20:53:54 +0200
Message-Id: <20200526183942.024415645@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200526183932.245016380@linuxfoundation.org>
References: <20200526183932.245016380@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
 mm/kasan/Makefile  |    8 ++++----
 mm/kasan/generic.c |    1 -
 mm/kasan/tags.c    |    1 -
 3 files changed, 4 insertions(+), 6 deletions(-)

--- a/mm/kasan/Makefile
+++ b/mm/kasan/Makefile
@@ -14,10 +14,10 @@ CFLAGS_REMOVE_tags.o = $(CC_FLAGS_FTRACE
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
--- a/mm/kasan/generic.c
+++ b/mm/kasan/generic.c
@@ -15,7 +15,6 @@
  */
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
-#define DISABLE_BRANCH_PROFILING
 
 #include <linux/export.h>
 #include <linux/interrupt.h>
--- a/mm/kasan/tags.c
+++ b/mm/kasan/tags.c
@@ -12,7 +12,6 @@
  */
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
-#define DISABLE_BRANCH_PROFILING
 
 #include <linux/export.h>
 #include <linux/interrupt.h>


