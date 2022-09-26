Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33B1A5EB11D
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 21:16:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229632AbiIZTP6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 15:15:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229958AbiIZTPx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 15:15:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D3034B0C8;
        Mon, 26 Sep 2022 12:15:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DF3656125A;
        Mon, 26 Sep 2022 19:15:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4375EC433C1;
        Mon, 26 Sep 2022 19:15:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664219744;
        bh=rZVJT+JttxSzyyhB0MeLHuEC2E83EzkQrTrLuZ4KN/A=;
        h=Date:To:From:Subject:From;
        b=q2HKYhwSpUQBDayg2qNXCScBQo1OHUmfmOg1ilsiTmidjnfYfMErbaghWaMgC4Qyu
         YDysnWITrd+0M/gEmEFiUKg3Oi/PlBjgO8fT8/JP0hfIYPmb5vPfCgXZxugCto7i0c
         KRJlzCOe+8midXiuwF4JmYrITd5xwhW4cLvSDocg=
Date:   Mon, 26 Sep 2022 12:15:43 -0700
To:     mm-commits@vger.kernel.org, yuzhao@google.com, willy@infradead.org,
        stable@vger.kernel.org, peterz@infradead.org, jpoimboe@kernel.org,
        dev@der-flo.net, dave.hansen@linux.intel.com,
        akpm@linux-foundation.org, keescook@chromium.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] x86-uaccess-avoid-check_object_size-in-copy_from_user_nmi.patch removed from -mm tree
Message-Id: <20220926191544.4375EC433C1@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The quilt patch titled
     Subject: x86/uaccess: avoid check_object_size() in copy_from_user_nmi()
has been removed from the -mm tree.  Its filename was
     x86-uaccess-avoid-check_object_size-in-copy_from_user_nmi.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kees Cook <keescook@chromium.org>
Subject: x86/uaccess: avoid check_object_size() in copy_from_user_nmi()
Date: Mon, 19 Sep 2022 13:16:48 -0700

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
---

 arch/x86/lib/usercopy.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/lib/usercopy.c~x86-uaccess-avoid-check_object_size-in-copy_from_user_nmi
+++ a/arch/x86/lib/usercopy.c
@@ -44,7 +44,7 @@ copy_from_user_nmi(void *to, const void
 	 * called from other contexts.
 	 */
 	pagefault_disable();
-	ret = __copy_from_user_inatomic(to, from, n);
+	ret = raw_copy_from_user(to, from, n);
 	pagefault_enable();
 
 	return ret;
_

Patches currently in -mm which might be from keescook@chromium.org are


