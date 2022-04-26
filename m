Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 628135107F6
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 21:02:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353734AbiDZTF1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 15:05:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353558AbiDZTFS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 15:05:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40DB519916B;
        Tue, 26 Apr 2022 12:02:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CC7A16199D;
        Tue, 26 Apr 2022 19:02:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D44BC385A0;
        Tue, 26 Apr 2022 19:02:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650999727;
        bh=XtYdCKKZ7/RbwsonQHN6VD23oGwc3Zi25SgQJ6Oj4q8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hWH7gK9BR0aQ+BfmPPzfWtkz2UGwmd0XpBJsmd8wdj6cuTYKvbnpaXBumpaJ9bDej
         AgsW9dXwuzj9HJmHBqxmI/HuRzKDsnnY9zyOp96Jrz0D5FxG/3vP5U5gTqK9CG3fHU
         2zdlvlCkjvAGJNXhV0EfPoU0d+axJgUwG/6fF8bV91HrPchQwKO8hWgP/eIEaeJBoW
         QMdmuXj0aoM5+c01hV2+9cJ2q3KJgDufCLCaQ+9WoSMu1fZJCWmjxqdLikjpTmrS77
         2CvsoQo8g0LJ5wwMOweLuocs57unZsyV/1UnxHZ+72p+Zchq2xoytHvjYtGDu38Jgo
         E8Ao4z8sYupbA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mikulas Patocka <mpatocka@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, peterz@infradead.org, jpoimboe@redhat.com
Subject: [PATCH AUTOSEL 5.17 15/22] x86: __memcpy_flushcache: fix wrong alignment if size > 2^32
Date:   Tue, 26 Apr 2022 15:01:38 -0400
Message-Id: <20220426190145.2351135-15-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220426190145.2351135-1-sashal@kernel.org>
References: <20220426190145.2351135-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mikulas Patocka <mpatocka@redhat.com>

[ Upstream commit a6823e4e360fe975bd3da4ab156df7c74c8b07f3 ]

The first "if" condition in __memcpy_flushcache is supposed to align the
"dest" variable to 8 bytes and copy data up to this alignment.  However,
this condition may misbehave if "size" is greater than 4GiB.

The statement min_t(unsigned, size, ALIGN(dest, 8) - dest); casts both
arguments to unsigned int and selects the smaller one.  However, the
cast truncates high bits in "size" and it results in misbehavior.

For example:

	suppose that size == 0x100000001, dest == 0x200000002
	min_t(unsigned, size, ALIGN(dest, 8) - dest) == min_t(0x1, 0xe) == 0x1;
	...
	dest += 0x1;

so we copy just one byte "and" dest remains unaligned.

This patch fixes the bug by replacing unsigned with size_t.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/lib/usercopy_64.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/lib/usercopy_64.c b/arch/x86/lib/usercopy_64.c
index 0402a749f3a0..0ae6cf804197 100644
--- a/arch/x86/lib/usercopy_64.c
+++ b/arch/x86/lib/usercopy_64.c
@@ -119,7 +119,7 @@ void __memcpy_flushcache(void *_dst, const void *_src, size_t size)
 
 	/* cache copy and flush to align dest */
 	if (!IS_ALIGNED(dest, 8)) {
-		unsigned len = min_t(unsigned, size, ALIGN(dest, 8) - dest);
+		size_t len = min_t(size_t, size, ALIGN(dest, 8) - dest);
 
 		memcpy((void *) dest, (void *) source, len);
 		clean_cache_range((void *) dest, len);
-- 
2.35.1

