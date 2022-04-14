Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16EB6501D48
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 23:18:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244700AbiDNVUm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 17:20:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241346AbiDNVUk (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 17:20:40 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 983207CB02;
        Thu, 14 Apr 2022 14:18:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 077F1CE273A;
        Thu, 14 Apr 2022 21:18:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 405F0C385A5;
        Thu, 14 Apr 2022 21:18:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1649971091;
        bh=es13VYXNe+2WAbC2sQXpF363bAvDsf0OrOPdmbW5uJo=;
        h=Date:To:From:Subject:From;
        b=e1kNTw33T5Az69cKz1dkjEQ7tUhLS+/D0UIBUo6Yxr1wJMZao/zEHLEteyeTI9HEK
         UWU+Y4w8GYp56ewGMcMNP3XhC+y5HMyu8tHVdzlNY4akVxyARoZjudpc4xSEN5x0ex
         CgvN+vHf4wKSXu9Bp+FVrxfPSdQm45JS3BnjFn9c=
Date:   Thu, 14 Apr 2022 14:18:10 -0700
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        ryabinin.a.a@gmail.com, glider@google.com, dvyukov@google.com,
        andreyknvl@gmail.com, qiang1.zhang@intel.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + kasan-prevent-cpu_quarantine-corruption-when-cpu-offline-and-cache-shrink-occur-at-same-time.patch added to -mm tree
Message-Id: <20220414211811.405F0C385A5@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: kasan: prevent cpu_quarantine corruption when CPU offline and cache shrink occur at same time
has been added to the -mm tree.  Its filename is
     kasan-prevent-cpu_quarantine-corruption-when-cpu-offline-and-cache-shrink-occur-at-same-time.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kasan-prevent-cpu_quarantine-corruption-when-cpu-offline-and-cache-shrink-occur-at-same-time.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kasan-prevent-cpu_quarantine-corruption-when-cpu-offline-and-cache-shrink-occur-at-same-time.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Zqiang <qiang1.zhang@intel.com>
Subject: kasan: prevent cpu_quarantine corruption when CPU offline and cache shrink occur at same time

kasan_quarantine_remove_cache() is called in kmem_cache_shrink()/
destroy().  The kasan_quarantine_remove_cache() call is protected by
cpuslock in kmem_cache_destroy() to ensure serialization with
kasan_cpu_offline().

However the kasan_quarantine_remove_cache() call is not protected by
cpuslock in kmem_cache_shrink().  When a CPU is going offline and cache
shrink occurs at same time, the cpu_quarantine may be corrupted by
interrupt (per_cpu_remove_cache operation).

So add a cpu_quarantine offline flags check in per_cpu_remove_cache().

Link: https://lkml.kernel.org/r/20220414025925.2423818-1-qiang1.zhang@intel.com
Signed-off-by: Zqiang <qiang1.zhang@intel.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/kasan/quarantine.c~kasan-prevent-cpu_quarantine-corruption-when-cpu-offline-and-cache-shrink-occur-at-same-time
+++ a/mm/kasan/quarantine.c
@@ -315,6 +315,8 @@ static void per_cpu_remove_cache(void *a
 	struct qlist_head *q;
 
 	q = this_cpu_ptr(&cpu_quarantine);
+	if (READ_ONCE(q->offline))
+		return;
 	qlist_move_cache(q, &to_free, cache);
 	qlist_free_all(&to_free, cache);
 }
_

Patches currently in -mm which might be from qiang1.zhang@intel.com are

irq_work-use-kasan_record_aux_stack_noalloc-record-callstack.patch
kasan-prevent-cpu_quarantine-corruption-when-cpu-offline-and-cache-shrink-occur-at-same-time.patch
kasan-fix-sleeping-function-called-from-invalid-context-on-rt-kernel.patch

