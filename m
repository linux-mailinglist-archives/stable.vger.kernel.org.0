Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF8E55BEF62
	for <lists+stable@lfdr.de>; Tue, 20 Sep 2022 23:50:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229663AbiITVuV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Sep 2022 17:50:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230426AbiITVuT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Sep 2022 17:50:19 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71C882180E;
        Tue, 20 Sep 2022 14:50:17 -0700 (PDT)
Date:   Tue, 20 Sep 2022 21:50:13 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1663710615;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZjzWjp2mR7KNavC4NQ2XVbJMIOQAxuWxGFL/2GffVuU=;
        b=O/w80v/2nM0cMDtDzz9QBPJhACPnxInxeqGbxCdklwizacfojzCBgHyDLHXdszCIkusTSx
        x7iXbRYekUo1coQiJbaIpkD7b/s0414pd3v/u60aNfQSPZxnnk7PAJOdyw4Lp2sZ7qOMKs
        8nII+qSxYfbylpIwLr2HubdNOmw6Xp2+GfdvJNvP16/EeSfSRYVMTDtkfC6o2yWkUfgnTC
        +Oul0e81U5JwGvexz9B33dQf1n2tyoAI8VIfVCEFgpR74avw2IMhVSLCbzN7eAn/B10lJ2
        5FISD2iHA3qnAw1/oRSDwqOrCo14kMcrSXEdiFmi33ao5jKIypgZBec0kmWl1w==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1663710615;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZjzWjp2mR7KNavC4NQ2XVbJMIOQAxuWxGFL/2GffVuU=;
        b=0T7pdgB8ranrI9QnGDASi2HUowfDWk/x05yTa7bt5S1/OINSmQz7iY5Hz7qEuILpCUkd6M
        VglzWrQWo038M+AA==
From:   "tip-bot2 for Kees Cook" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: x86/urgent] x86/uaccess: Avoid check_object_size() in
 copy_from_user_nmi()
Cc:     Yu Zhao <yuzhao@google.com>, dev@der-flo.net,
        Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        stable@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <CAOUHufaPshtKrTWOz7T7QFYUNVGFm0JBjvM700Nhf9qEL9b3EQ@mail.gmail.com>
References: <CAOUHufaPshtKrTWOz7T7QFYUNVGFm0JBjvM700Nhf9qEL9b3EQ@mail.gmail.com>
MIME-Version: 1.0
Message-ID: <166371061341.401.16240146052010103408.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the x86/urgent branch of tip:

Commit-ID:     80d82ca9562bb881f2884ccb33b5530d40144450
Gitweb:        https://git.kernel.org/tip/80d82ca9562bb881f2884ccb33b5530d40144450
Author:        Kees Cook <keescook@chromium.org>
AuthorDate:    Mon, 19 Sep 2022 13:16:48 -07:00
Committer:     Dave Hansen <dave.hansen@linux.intel.com>
CommitterDate: Tue, 20 Sep 2022 14:43:49 -07:00

x86/uaccess: Avoid check_object_size() in copy_from_user_nmi()

The check_object_size() helper under CONFIG_HARDENED_USERCOPY is
designed to skip any checks where the length is known at compile time as
a reasonable heuristic to avoid "likely known-good" cases. However, it can
only do this when the copy_*_user() helpers are, themselves, inline too.

Using find_vmap_area() requires taking a spinlock. The check_object_size()
helper can call find_vmap_area() when the destination is in vmap memory.
If show_regs() is called in interrupt context, it will attempt a call to
copy_from_user_nmi(), which may call check_object_size() and then
find_vmap_area(). If something in normal context happens to be in the
middle of calling find_vmap_area() (with the spinlock held), the interrupt
handler will hang forever.

The copy_from_user_nmi() call is actually being called with a fixed-size
length, so check_object_size() should never have been called in
the first place. Given the narrow constraints, just replace the
__copy_from_user_inatomic() call with an open-coded version that calls
only into the sanitizers and not check_object_size(), followed by a call
to raw_copy_from_user().

Fixes: 0aef499f3172 ("mm/usercopy: Detect vmalloc overruns")
Reported-by: Yu Zhao <yuzhao@google.com>
Reported-by: dev@der-flo.net
Suggested-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Tested-by: Florian Lehner <dev@der-flo.net>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/all/CAOUHufaPshtKrTWOz7T7QFYUNVGFm0JBjvM700Nhf9qEL9b3EQ@mail.gmail.com
Link: https://lkml.kernel.org/r/20220919201648.2250764-1-keescook@chromium.org
---
 arch/x86/lib/usercopy.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/lib/usercopy.c b/arch/x86/lib/usercopy.c
index ad0139d..d2aff9b 100644
--- a/arch/x86/lib/usercopy.c
+++ b/arch/x86/lib/usercopy.c
@@ -44,7 +44,8 @@ copy_from_user_nmi(void *to, const void __user *from, unsigned long n)
 	 * called from other contexts.
 	 */
 	pagefault_disable();
-	ret = __copy_from_user_inatomic(to, from, n);
+	instrument_copy_from_user(to, from, n);
+	ret = raw_copy_from_user(to, from, n);
 	pagefault_enable();
 
 	return ret;
