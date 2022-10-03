Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFC0D5F2955
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 09:17:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230141AbiJCHRt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Oct 2022 03:17:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229986AbiJCHRH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Oct 2022 03:17:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 554524686D;
        Mon,  3 Oct 2022 00:14:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D4AF160F9B;
        Mon,  3 Oct 2022 07:14:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E88CCC433C1;
        Mon,  3 Oct 2022 07:13:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664781240;
        bh=oKI7NKRGrfksCR9P5ES2xz6H45saQiR1p4Qbpz+75vI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=18KUM+xOYNNDD2kax8P2vT2JH4BteYNlNoPCyafiBbOaDf5mQ4muDMqK1OOvnZnQF
         eSW+E9rd8XEMQ5JfJzVO0x2FbGM6DcUssVeOHMTO/sdBvjNaNVGZfggaAdfLgelk4M
         +E/ZBEwpuCV9/zMoEVwx7boJbfgeP1Cz80TBfZNo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        Yu Zhao <yuzhao@google.com>, Florian Lehner <dev@der-flo.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Matthew Wilcox <willy@infradead.org>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>
Subject: [PATCH 5.19 021/101] x86/uaccess: avoid check_object_size() in copy_from_user_nmi()
Date:   Mon,  3 Oct 2022 09:10:17 +0200
Message-Id: <20221003070725.020436093@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221003070724.490989164@linuxfoundation.org>
References: <20221003070724.490989164@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kees Cook <keescook@chromium.org>

commit 59298997df89e19aad426d4ae0a7e5037074da5a upstream.

The check_object_size() helper under CONFIG_HARDENED_USERCOPY is designed
to skip any checks where the length is known at compile time as a
reasonable heuristic to avoid "likely known-good" cases.  However, it can
only do this when the copy_*_user() helpers are, themselves, inline too.

Using find_vmap_area() requires taking a spinlock.  The
check_object_size() helper can call find_vmap_area() when the destination
is in vmap memory.  If show_regs() is called in interrupt context, it will
attempt a call to copy_from_user_nmi(), which may call check_object_size()
and then find_vmap_area().  If something in normal context happens to be
in the middle of calling find_vmap_area() (with the spinlock held), the
interrupt handler will hang forever.

The copy_from_user_nmi() call is actually being called with a fixed-size
length, so check_object_size() should never have been called in the first
place.  Given the narrow constraints, just replace the
__copy_from_user_inatomic() call with an open-coded version that calls
only into the sanitizers and not check_object_size(), followed by a call
to raw_copy_from_user().

[akpm@linux-foundation.org: no instrument_copy_from_user() in my tree...]
Link: https://lkml.kernel.org/r/20220919201648.2250764-1-keescook@chromium.org
Link: https://lore.kernel.org/all/CAOUHufaPshtKrTWOz7T7QFYUNVGFm0JBjvM700Nhf9qEL9b3EQ@mail.gmail.com
Fixes: 0aef499f3172 ("mm/usercopy: Detect vmalloc overruns")
Signed-off-by: Kees Cook <keescook@chromium.org>
Reported-by: Yu Zhao <yuzhao@google.com>
Reported-by: Florian Lehner <dev@der-flo.net>
Suggested-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Tested-by: Florian Lehner <dev@der-flo.net>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/lib/usercopy.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/lib/usercopy.c b/arch/x86/lib/usercopy.c
index ad0139d25401..f1bb18617156 100644
--- a/arch/x86/lib/usercopy.c
+++ b/arch/x86/lib/usercopy.c
@@ -44,7 +44,7 @@ copy_from_user_nmi(void *to, const void __user *from, unsigned long n)
 	 * called from other contexts.
 	 */
 	pagefault_disable();
-	ret = __copy_from_user_inatomic(to, from, n);
+	ret = raw_copy_from_user(to, from, n);
 	pagefault_enable();
 
 	return ret;
-- 
2.37.3



