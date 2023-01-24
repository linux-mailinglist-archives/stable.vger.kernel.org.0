Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 732FC67A1BF
	for <lists+stable@lfdr.de>; Tue, 24 Jan 2023 19:52:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234172AbjAXSwH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Jan 2023 13:52:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233815AbjAXSwF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Jan 2023 13:52:05 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1B6742DFD;
        Tue, 24 Jan 2023 10:52:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8FE5861333;
        Tue, 24 Jan 2023 18:52:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79868C433A1;
        Tue, 24 Jan 2023 18:52:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674586324;
        bh=yaiQwBn2rTDrZhwgXDYQi0ScGBCi5abPA1RpzOQ4srI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Vjt1XUXWDXluHlh8RrTj9/dFkQbxY9dm0cIDoLMWmF7SENFQrleiigF2tOKM09Jw/
         VZEeFsculLU9id7WocJkcfOuljqO7AsgHEYzm+GZFVsiTMplsKetB4g7pZrALuCG+P
         /SW6+QFS7vYl5gkb6bHUhVaMAzKaOKn/VnRZ7+IMYarn7xzAAnkohUlYXr/m5pu82a
         RcsTb53KAFetr51txcHdD+Zpvw9tAafssN3OiAmOShqZwQaIMPTGFjQfiIItGnec3F
         d2XMovkFJdqvIO0qUGV1C+LYCTIshLpy/X66caLpB1YoYi7GcWgitFsaoptL4bQHeE
         /2HhArVFOOEOw==
From:   Eric Biggers <ebiggers@kernel.org>
To:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Kees Cook <keescook@chromium.org>, SeongJae Park <sj@kernel.org>,
        Seth Jenkins <sethjenkins@google.com>,
        Jann Horn <jannh@google.com>,
        "Eric W . Biederman" <ebiederm@xmission.com>,
        linux-hardening@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrey Ryabinin <ryabinin.a.a@gmail.com>,
        Baoquan He <bhe@redhat.com>, Jonathan Corbet <corbet@lwn.net>,
        Xuefeng Li <lixuefeng@loongson.cn>,
        Tiezhu Yang <yangtiezhu@loongson.cn>,
        Marco Elver <elver@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.15 04/20] ubsan: no need to unset panic_on_warn in ubsan_epilogue()
Date:   Tue, 24 Jan 2023 10:50:54 -0800
Message-Id: <20230124185110.143857-5-ebiggers@kernel.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230124185110.143857-1-ebiggers@kernel.org>
References: <20230124185110.143857-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tiezhu Yang <yangtiezhu@loongson.cn>

commit d83ce027a54068fabb70d2c252e1ce2da86784a4 upstream.

panic_on_warn is unset inside panic(), so no need to unset it before
calling panic() in ubsan_epilogue().

Link: https://lkml.kernel.org/r/1644324666-15947-5-git-send-email-yangtiezhu@loongson.cn
Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
Reviewed-by: Marco Elver <elver@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Xuefeng Li <lixuefeng@loongson.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 lib/ubsan.c | 10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff --git a/lib/ubsan.c b/lib/ubsan.c
index bdc380ff5d5c7..36bd75e334263 100644
--- a/lib/ubsan.c
+++ b/lib/ubsan.c
@@ -154,16 +154,8 @@ static void ubsan_epilogue(void)
 
 	current->in_ubsan--;
 
-	if (panic_on_warn) {
-		/*
-		 * This thread may hit another WARN() in the panic path.
-		 * Resetting this prevents additional WARN() from panicking the
-		 * system on this thread.  Other threads are blocked by the
-		 * panic_mutex in panic().
-		 */
-		panic_on_warn = 0;
+	if (panic_on_warn)
 		panic("panic_on_warn set ...\n");
-	}
 }
 
 void __ubsan_handle_divrem_overflow(void *_data, void *lhs, void *rhs)
-- 
2.39.1

