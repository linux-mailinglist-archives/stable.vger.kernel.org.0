Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DDBF6AEF79
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:23:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232745AbjCGSXs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:23:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232628AbjCGSXb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:23:31 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACA0D5580
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:18:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 414CA61520
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:18:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05CBDC433D2;
        Tue,  7 Mar 2023 18:18:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678213109;
        bh=wGZfxjhGE9qBVjyg3PF/jqOVziJK7LJT+bAvv8mPIvY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s3SPxdOkbH/DU4wuhJflWWtZafF04CzoZLZ0sz0G2W4ev8RXEgBkqqb44aK0jAwC3
         3+Gs/ZI/9eyjdxq7Ld4FNy+bgl+/BE+AtR0XJGQaZE+SYJGXq/7isC78TVPawAfcmr
         OPZymAcTIrFlu6VnV2+u7D4g0PhbOaDNsbgAC3pI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Arnd Bergmann <arnd@arndb.de>,
        Marco Elver <elver@google.com>,
        Alexander Potapenko <glider@google.com>,
        Andrey Konovalov <andreyknvl@gmail.com>,
        Andrey Ryabinin <ryabinin.a.a@gmail.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Kuan-Ying Lee <Kuan-Ying.Lee@mediatek.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 401/885] objtool: add UACCESS exceptions for __tsan_volatile_read/write
Date:   Tue,  7 Mar 2023 17:55:35 +0100
Message-Id: <20230307170019.827542195@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit d5d469247264e56960705dc5ae7e1d014861fe40 ]

A lot of the tsan helpers are already excempt from the UACCESS warnings,
but some more functions were added that need the same thing:

kernel/kcsan/core.o: warning: objtool: __tsan_volatile_read16+0x0: call to __tsan_unaligned_read16() with UACCESS enabled
kernel/kcsan/core.o: warning: objtool: __tsan_volatile_write16+0x0: call to __tsan_unaligned_write16() with UACCESS enabled
vmlinux.o: warning: objtool: __tsan_unaligned_volatile_read16+0x4: call to __tsan_unaligned_read16() with UACCESS enabled
vmlinux.o: warning: objtool: __tsan_unaligned_volatile_write16+0x4: call to __tsan_unaligned_write16() with UACCESS enabled

As Marco points out, these functions don't even call each other
explicitly but instead gcc (but not clang) notices the functions
being identical and turns one symbol into a direct branch to the
other.

Link: https://lkml.kernel.org/r/20230215130058.3836177-4-arnd@kernel.org
Fixes: 75d75b7a4d54 ("kcsan: Support distinguishing volatile accesses")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: Kuan-Ying Lee <Kuan-Ying.Lee@mediatek.com>
Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/objtool/check.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/objtool/check.c b/tools/objtool/check.c
index 51494c3002d91..0c1b6acad141f 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -1059,6 +1059,8 @@ static const char *uaccess_safe_builtin[] = {
 	"__tsan_atomic64_compare_exchange_val",
 	"__tsan_atomic_thread_fence",
 	"__tsan_atomic_signal_fence",
+	"__tsan_unaligned_read16",
+	"__tsan_unaligned_write16",
 	/* KCOV */
 	"write_comp_data",
 	"check_kcov_mode",
-- 
2.39.2



