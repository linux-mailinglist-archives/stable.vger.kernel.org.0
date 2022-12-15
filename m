Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3082964E29E
	for <lists+stable@lfdr.de>; Thu, 15 Dec 2022 21:58:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229480AbiLOU63 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Dec 2022 15:58:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbiLOU62 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Dec 2022 15:58:28 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E683B528B1;
        Thu, 15 Dec 2022 12:58:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9167AB81C8B;
        Thu, 15 Dec 2022 20:58:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3666AC433EF;
        Thu, 15 Dec 2022 20:58:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1671137905;
        bh=p+Iy+x3rh//nuiR0eD3ZThqu+7W1+jYfAC3chLBABRk=;
        h=Date:To:From:Subject:From;
        b=ditmimO4u1Y62naziTRtoCYk0ngjtQkwI33EQJcU9oyD5AmfUHw7ntWcAhoGXDaxm
         LZw3qg1tSSfewodf0QEXvhC07N+/TUnd+HW5pcS5x8Z/Gt8DU9wZ39iqWS1xZNFA8M
         NSW9Y6qTX7F3T9R8gTW15CmbHiXDYEWP/PS4m1iA=
Date:   Thu, 15 Dec 2022 12:58:24 -0800
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        glider@google.com, elver@google.com, dvyukov@google.com,
        arnd@arndb.de, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + kmsan-include-linux-vmalloch.patch added to mm-hotfixes-unstable branch
Message-Id: <20221215205825.3666AC433EF@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: kmsan: include linux/vmalloc.h
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     kmsan-include-linux-vmalloch.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kmsan-include-linux-vmalloch.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: kmsan: include linux/vmalloc.h
Date: Thu, 15 Dec 2022 17:30:17 +0100

This is needed for the vmap/vunmap declarations:

mm/kmsan/kmsan_test.c:316:9: error: implicit declaration of function 'vmap' is invalid in C99 [-Werror,-Wimplicit-function-declaration]
        vbuf = vmap(pages, npages, VM_MAP, PAGE_KERNEL);
               ^
mm/kmsan/kmsan_test.c:316:29: error: use of undeclared identifier 'VM_MAP'
        vbuf = vmap(pages, npages, VM_MAP, PAGE_KERNEL);
                                   ^
mm/kmsan/kmsan_test.c:322:3: error: implicit declaration of function 'vunmap' is invalid in C99 [-Werror,-Wimplicit-function-declaration]
                vunmap(vbuf);
                ^

Link: https://lkml.kernel.org/r/20221215163046.4079767-1-arnd@kernel.org
Fixes: 8ed691b02ade ("kmsan: add tests for KMSAN")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Marco Elver <elver@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kmsan/kmsan_test.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/kmsan/kmsan_test.c~kmsan-include-linux-vmalloch
+++ a/mm/kmsan/kmsan_test.c
@@ -22,6 +22,7 @@
 #include <linux/spinlock.h>
 #include <linux/string.h>
 #include <linux/tracepoint.h>
+#include <linux/vmalloc.h>
 #include <trace/events/printk.h>
 
 static DEFINE_PER_CPU(int, per_cpu_var);
_

Patches currently in -mm which might be from arnd@arndb.de are

kmsan-include-linux-vmalloch.patch

