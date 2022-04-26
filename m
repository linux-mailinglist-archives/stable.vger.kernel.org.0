Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35EA051082A
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 21:05:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348812AbiDZTGq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 15:06:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353875AbiDZTGO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 15:06:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82EE919ADB1;
        Tue, 26 Apr 2022 12:02:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3568BB81DC2;
        Tue, 26 Apr 2022 19:02:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BED8EC385A4;
        Tue, 26 Apr 2022 19:02:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650999774;
        bh=Q4Y3SyK/jeyCZmbyzItTJ1Zzlro6NPXoyjvomzCp6lw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W87+kEnJWcXdg6jAMsD9Jfe9IxnzJibXIBT/WL1+WwVPYGDdLuvYA4hsQmjOH72hR
         uGfV4+3L2l9ylRkhDjhTWGELRtzyl6EGzl1bfAyWBB/tPNYHnMwkFClQ2xtMgqHaRa
         Opwym4sd9UztVldmPLwa0y0giXL1JXxhWPV9/KfY5NTjEoPb5rz878CNS8v0qatRzX
         LxsGKl9FxIMXUU39rHKyyBfImWyMkgW/8A4x6F+fF8htTL75o+GykyNkZ9mzAGH/FG
         4a5E75HqI9NtDN+FCjsc3av4B/OX9GbIneMxoaa0CtdSWUBiw5JYbZrTkgK5Z04jbi
         WnBrOSi0rlUmw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mikulas Patocka <mpatocka@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, peterz@infradead.org, jpoimboe@redhat.com
Subject: [PATCH AUTOSEL 4.19 3/6] x86: __memcpy_flushcache: fix wrong alignment if size > 2^32
Date:   Tue, 26 Apr 2022 15:02:46 -0400
Message-Id: <20220426190251.2351817-3-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220426190251.2351817-1-sashal@kernel.org>
References: <20220426190251.2351817-1-sashal@kernel.org>
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
index 40dbbd8f1fe4..8c6d0fb72b3a 100644
--- a/arch/x86/lib/usercopy_64.c
+++ b/arch/x86/lib/usercopy_64.c
@@ -161,7 +161,7 @@ void memcpy_flushcache(void *_dst, const void *_src, size_t size)
 
 	/* cache copy and flush to align dest */
 	if (!IS_ALIGNED(dest, 8)) {
-		unsigned len = min_t(unsigned, size, ALIGN(dest, 8) - dest);
+		size_t len = min_t(size_t, size, ALIGN(dest, 8) - dest);
 
 		memcpy((void *) dest, (void *) source, len);
 		clean_cache_range((void *) dest, len);
-- 
2.35.1

