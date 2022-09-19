Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 075F45BD5D0
	for <lists+stable@lfdr.de>; Mon, 19 Sep 2022 22:46:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229717AbiISUqj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Sep 2022 16:46:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229698AbiISUqi (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Sep 2022 16:46:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B72214A13E;
        Mon, 19 Sep 2022 13:46:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6A92DB8075E;
        Mon, 19 Sep 2022 20:46:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 412CFC433D7;
        Mon, 19 Sep 2022 20:46:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1663620395;
        bh=u1SDgvSXYjTwmjtA4RdrNikaaGPV+fMFiGpOU+oQPzw=;
        h=Date:To:From:Subject:From;
        b=sRT5/QRKdGWOiJZZ9SoCfgjelRnmAxbOEde1Th5fRhV6q32/1Xx1+A/b12ZnNonNF
         MvC/lAXgz6f0x827t2YA1OZEij7CfiDg3/ZiOcPzzzNi95opLIKd6WDJVDt2xT9BOn
         GA2UjvKVN8JAWdcKs3zzg15WRhitswns++GqJqI0=
Date:   Mon, 19 Sep 2022 13:46:26 -0700
To:     mm-commits@vger.kernel.org, yuzhao@google.com, willy@infradead.org,
        stable@vger.kernel.org, peterz@infradead.org, jpoimboe@kernel.org,
        dev@der-flo.net, dave.hansen@linux.intel.com,
        akpm@linux-foundation.org, keescook@chromium.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + x86-uaccess-avoid-check_object_size-in-copy_from_user_nmi.patch added to mm-hotfixes-unstable branch
Message-Id: <20220919204634.412CFC433D7@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: x86/uaccess: avoid check_object_size() in copy_from_user_nmi()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     x86-uaccess-avoid-check_object_size-in-copy_from_user_nmi.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/x86-uaccess-avoid-check_object_size-in-copy_from_user_nmi.patch

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

Link: https://lkml.kernel.org/r/20220919201648.2250764-1-keescook@chromium.org
Link: https://lore.kernel.org/all/CAOUHufaPshtKrTWOz7T7QFYUNVGFm0JBjvM700Nhf9qEL9b3EQ@mail.gmail.com
Fixes: 0aef499f3172 ("mm/usercopy: Detect vmalloc overruns")
Signed-off-by: Kees Cook <keescook@chromium.org>
Reported-by: Yu Zhao <yuzhao@google.com>
Reported-by: <dev@der-flo.net>
Suggested-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/arch/x86/lib/usercopy.c~x86-uaccess-avoid-check_object_size-in-copy_from_user_nmi
+++ a/arch/x86/lib/usercopy.c
@@ -44,7 +44,8 @@ copy_from_user_nmi(void *to, const void
 	 * called from other contexts.
 	 */
 	pagefault_disable();
-	ret = __copy_from_user_inatomic(to, from, n);
+	instrument_copy_from_user(to, from, n);
+	ret = raw_copy_from_user(to, from, n);
 	pagefault_enable();
 
 	return ret;
_

Patches currently in -mm which might be from keescook@chromium.org are

x86-uaccess-avoid-check_object_size-in-copy_from_user_nmi.patch

