Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0AD96512307
	for <lists+stable@lfdr.de>; Wed, 27 Apr 2022 21:45:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232220AbiD0TsN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Apr 2022 15:48:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234928AbiD0TrO (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Apr 2022 15:47:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D2064DF64;
        Wed, 27 Apr 2022 12:42:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CC9A0B8298A;
        Wed, 27 Apr 2022 19:41:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F393C385A7;
        Wed, 27 Apr 2022 19:41:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1651088517;
        bh=FzMaEt0ORKT14V9HyN2A3rQwOPnyIJUsEAiiAUmn1ow=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=AYxhAu9GR1UaXIaH8b+lS1CD0FklXZaCqihT922cdBzzEhD2SC8sbgUMPRUcBpkdX
         WP8thrukZpFvzkgiTArjsG4/e7MmLH3w6Fm4e1aZJ1ndY+TeNAGoS3+Lbx9cniZPNW
         giz/O0dkyoVzouuL+pH6n1Q2Km30wKNKESmTwPr8=
Date:   Wed, 27 Apr 2022 12:41:56 -0700
To:     stable@vger.kernel.org, ryabinin.a.a@gmail.com, glider@google.com,
        dvyukov@google.com, andreyknvl@gmail.com, qiang1.zhang@intel.com,
        akpm@linux-foundation.org, patches@lists.linux.dev,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220427124133.cc115bc8acb8de3dda921836@linux-foundation.org>
Subject: [patch 1/2] kasan: prevent cpu_quarantine corruption when CPU offline and cache shrink occur at same time
Message-Id: <20220427194157.8F393C385A7@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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

[akpm@linux-foundation.org: add comment, per Zqiang]
Link: https://lkml.kernel.org/r/20220414025925.2423818-1-qiang1.zhang@intel.com
Signed-off-by: Zqiang <qiang1.zhang@intel.com>
Reviewed-by: Dmitry Vyukov <dvyukov@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/quarantine.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/mm/kasan/quarantine.c~kasan-prevent-cpu_quarantine-corruption-when-cpu-offline-and-cache-shrink-occur-at-same-time
+++ a/mm/kasan/quarantine.c
@@ -315,6 +315,13 @@ static void per_cpu_remove_cache(void *a
 	struct qlist_head *q;
 
 	q = this_cpu_ptr(&cpu_quarantine);
+	/*
+	 * Ensure the ordering between the writing to q->offline and
+	 * per_cpu_remove_cache.  Prevent cpu_quarantine from being corrupted
+	 * by interrupt.
+	 */
+	if (READ_ONCE(q->offline))
+		return;
 	qlist_move_cache(q, &to_free, cache);
 	qlist_free_all(&to_free, cache);
 }
_
