Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7124151A9A4
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 19:18:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356662AbiEDRSi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 13:18:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357329AbiEDRO7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 13:14:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79287541AC;
        Wed,  4 May 2022 09:58:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3CEEE617D5;
        Wed,  4 May 2022 16:58:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C2DAC385A4;
        Wed,  4 May 2022 16:58:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651683507;
        bh=LqikQVruDlTPY4W8yio5ZihTYRkdGJY8fqc90o2rNZU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uNc8ULnaN9rkQig+4xwoqdJPIm8Aw1v5/Nx5+11OIKgslFKeHbNIuWpAE+HoDbkVr
         3W1L81CN0X6uNjwu+e/K5j/6hffU3iB1dp22CRBetRR7bTjFiXNHPGBt+EcbChDmgG
         z93SqBH66D4LFl/FEZ4YKjKe9u8ukUkaiiOYwHfs=
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
Subject: [PATCH 5.17 182/225] kasan: prevent cpu_quarantine corruption when CPU offline and cache shrink occur at same time
Date:   Wed,  4 May 2022 18:47:00 +0200
Message-Id: <20220504153126.695302662@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220504153110.096069935@linuxfoundation.org>
References: <20220504153110.096069935@linuxfoundation.org>
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


