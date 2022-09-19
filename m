Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66F415BD593
	for <lists+stable@lfdr.de>; Mon, 19 Sep 2022 22:16:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229645AbiISUQz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Sep 2022 16:16:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229546AbiISUQy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Sep 2022 16:16:54 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99D2A3ECCC
        for <stable@vger.kernel.org>; Mon, 19 Sep 2022 13:16:53 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id l10so252953plb.10
        for <stable@vger.kernel.org>; Mon, 19 Sep 2022 13:16:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=WBdO0q1Vu+HcHQ9Ius//czL20IevKrEflqwUrM1KSMM=;
        b=Ty4gKC/4TkZyRQW6CBD1IAeVodTeekkH+uQUEdrLdpgsUtXRVv97YXKiMUDHCDxZnP
         2vkfdFDS6lvAZp/jLT4JmyuroGp4Tq9fViFjRX89s9sGUUcb2tCW5rfBiejSduKzztcS
         219dy0VIFHHi6CRdTC1dgeR5yORE4DCU/wnGU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=WBdO0q1Vu+HcHQ9Ius//czL20IevKrEflqwUrM1KSMM=;
        b=UVwCEGO1SwnkWSolMGWr1pRQrOKHZCFFYgyw5UTxsRGKgMQjiZbIdlL67poFf5k6aG
         gKugzhNfAr7CLkRNiEXzgeJCWLVoyRwnHULJ2sUdDTkD9ifjZMX2nvNO76NMZhKwbcaI
         H9qnFzDACfTxIMsJgWtvMQoWrxTKZnVnrLq4GMsHTa1o6PSxfbEcGIyKRqG8359wkGbx
         o0Ai6UMbFJ5vMONi3jbTchhwsgPYGspP+zSsN1Q5W0VkUZa5d6gFJowjhC/bQKiNL0Yg
         n4dgvyO/FZFE5QGCYP8z8lCXJdwlNPjRNxasFQxkZGGGZbH9vV8jEfsknX/mmdl0NjeE
         ALOA==
X-Gm-Message-State: ACrzQf14BMWbMhODzwmkOzi0Qv5gaCm+zV+Oe2UH93SRWetbdRBg8gab
        j4AFCXMWfJubVcZfOUzyVf8qFg==
X-Google-Smtp-Source: AMsMyM45J8dUTKuzhH8ytcQIk4o7i5T+/qBS3EdVAReIHWoir0iQpQeHo617CNtpN3P7qw3uOkozUg==
X-Received: by 2002:a17:90b:4ac4:b0:202:6d3d:3b60 with SMTP id mh4-20020a17090b4ac400b002026d3d3b60mr21678691pjb.197.1663618613077;
        Mon, 19 Sep 2022 13:16:53 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id j7-20020a17090276c700b00176acd80f69sm14926223plt.102.2022.09.19.13.16.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Sep 2022 13:16:52 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Kees Cook <keescook@chromium.org>, Yu Zhao <yuzhao@google.com>,
        dev@der-flo.net, Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        stable@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Arnd Bergmann <arnd@arndb.de>,
        Al Viro <viro@zeniv.linux.org.uk>,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: [PATCH v2] x86/uaccess: Avoid check_object_size() in copy_from_user_nmi()
Date:   Mon, 19 Sep 2022 13:16:48 -0700
Message-Id: <20220919201648.2250764-1-keescook@chromium.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2452; h=from:subject; bh=xBKIj8xDAkGKVbJ5AWdGFtVHxKNqrP8mAf0eb08IA9w=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBjKM4w/mv+2+IcarOwGG7EEYI5jpmWaMgZlKFemi3f dvVG79qJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCYyjOMAAKCRCJcvTf3G3AJkCtD/ 9gxNevZi6/8CjjkhkW1FOwIhJRnPq08fMU7/cTBdLVodGWPb7yeZpTUXKXlaQvTdAdnLA91kgGieDT cdloPkkcfj9C0+9lA5CfMcOAQuYePYmEKgPe7IKZjoioalpufUON+2Ao4LQL70hlaPmWLQEmUG/taT B7JFZinDvdig3zr/lRxunypycGLgyxnI2MTQTPYtV3kl+pQn+owMb7t7YptMhjgOwOsCnEdITmeZNZ 2LqKke1qRAptdOOGNbNBxVLQ/b3phKGtdwHcm2gPOXNTNe9u3vZwq12CFqmI4VyEcee26QKkgRSxbq x95BSUxKyLdWsPUIbgL+1URX0XZFzQvUhj/4h+0DUjNio7/3CG5GOpnDeB9QIUkEEiN/T9gCHRpAnQ jkKBnTow1mRV4kU8FXo0Acd9g6WYyUB/9vqHrrNTJvOgjw+GJqtceS8Xr9pZweh27yjdh9r9IqdEZW r5woqIsunQA+hdoS6CutBI4zQOW33URy9bcsh95kBU7bGdnlBm/izWhSdDPzgc6/44WV/cDte/52K1 o7EzKmj/007c9dx0susXEG3GTFY83uXyOA3/KZaj4jsX6DfldnJDJj50zLkWPki5IZ+qNSPKP4OEKl 6zvZPwZY9m+bbb+DSU1LNIP3/xhSOSoo1rQRMfgb5m5KQ5G7uTYECFxKyk7g==
X-Developer-Key: i=keescook@chromium.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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

Reported-by: Yu Zhao <yuzhao@google.com>
Link: https://lore.kernel.org/all/CAOUHufaPshtKrTWOz7T7QFYUNVGFm0JBjvM700Nhf9qEL9b3EQ@mail.gmail.com
Reported-by: dev@der-flo.net
Suggested-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: x86@kernel.org
Fixes: 0aef499f3172 ("mm/usercopy: Detect vmalloc overruns")
Cc: stable@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
---
v2: drop the call explicitly instead of using inline to do it
v1: https://lore.kernel.org/lkml/20220916135953.1320601-1-keescook@chromium.org
---
 arch/x86/lib/usercopy.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/lib/usercopy.c b/arch/x86/lib/usercopy.c
index ad0139d25401..d2aff9b176cf 100644
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
-- 
2.34.1

