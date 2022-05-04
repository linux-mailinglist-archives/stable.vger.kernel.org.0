Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F04CB51A703
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 18:58:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354669AbiEDRB3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 13:01:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355537AbiEDRAO (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 13:00:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D363D4B84F;
        Wed,  4 May 2022 09:51:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4EEA0B827AA;
        Wed,  4 May 2022 16:51:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE404C385A5;
        Wed,  4 May 2022 16:51:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651683104;
        bh=xM5Gy52mF7BEsiFWmHdJksaZ8bgXdg0D7bEd5jt04ko=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1MksxrBuooV15Z9iogsO6HOfQKTcgzVwEOHQ6u1tb6lSQZZZkEYRHw+538rw1UBmy
         T1xzZgH4m6oSRKY6MalLVU1p+uxut17ZEgidsmXi8HLmSLFmGykkE6mRZVr17Xv3hH
         A1sPYYUGMUQ9HENnHvDXvBIfEbr0EGjKhAynQIqk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zqiang <qiang1.zhang@intel.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Andrey Ryabinin <ryabinin.a.a@gmail.com>,
        Alexander Potapenko <glider@google.com>,
        Andrey Konovalov <andreyknvl@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.10 108/129] kasan: prevent cpu_quarantine corruption when CPU offline and cache shrink occur at same time
Date:   Wed,  4 May 2022 18:45:00 +0200
Message-Id: <20220504153029.633200099@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220504153021.299025455@linuxfoundation.org>
References: <20220504153021.299025455@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zqiang <qiang1.zhang@intel.com>

commit 31fa985b4196f8a66f027672e9bf2b81fea0417c upstream.

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
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/kasan/quarantine.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/mm/kasan/quarantine.c
+++ b/mm/kasan/quarantine.c
@@ -299,6 +299,13 @@ static void per_cpu_remove_cache(void *a
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


