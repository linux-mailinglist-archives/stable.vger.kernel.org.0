Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D3005175F6
	for <lists+stable@lfdr.de>; Mon,  2 May 2022 19:36:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244052AbiEBRjh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 May 2022 13:39:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236975AbiEBRjg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 May 2022 13:39:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69E2EBE36
        for <stable@vger.kernel.org>; Mon,  2 May 2022 10:36:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F2CB161411
        for <stable@vger.kernel.org>; Mon,  2 May 2022 17:36:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 441D2C385AC;
        Mon,  2 May 2022 17:36:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651512966;
        bh=7sqUKp0gBjRcSuW2kjvo95RV3HnxWi5Jg821IzZCmes=;
        h=Subject:To:Cc:From:Date:From;
        b=fjWhaClBTrNIzib/Jja9g51w8z0R3tFAiG0Vk1bsUEQZ/pNGvZUyysnm9vDp0F4EG
         FaLxeV40ooGOKMkw+nDwF76giJZoP6tRdkFkM3rtz5Gp3GS2b4CyejITCu+CFDl1JX
         0SygfNLC/Gdob61Tp4hdw408TtUbjesn+P6NhSss=
Subject: FAILED: patch "[PATCH] kasan: prevent cpu_quarantine corruption when CPU offline and" failed to apply to 4.19-stable tree
To:     qiang1.zhang@intel.com, akpm@linux-foundation.org,
        andreyknvl@gmail.com, dvyukov@google.com, glider@google.com,
        ryabinin.a.a@gmail.com, stable@vger.kernel.org,
        torvalds@linux-foundation.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 02 May 2022 19:36:04 +0200
Message-ID: <165151296450141@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 31fa985b4196f8a66f027672e9bf2b81fea0417c Mon Sep 17 00:00:00 2001
From: Zqiang <qiang1.zhang@intel.com>
Date: Wed, 27 Apr 2022 12:41:56 -0700
Subject: [PATCH] kasan: prevent cpu_quarantine corruption when CPU offline and
 cache shrink occur at same time

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

diff --git a/mm/kasan/quarantine.c b/mm/kasan/quarantine.c
index 08291ed33e93..0a9def8ce5e8 100644
--- a/mm/kasan/quarantine.c
+++ b/mm/kasan/quarantine.c
@@ -315,6 +315,13 @@ static void per_cpu_remove_cache(void *arg)
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

