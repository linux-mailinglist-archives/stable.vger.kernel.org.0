Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21BCB510865
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 21:05:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353940AbiDZTGa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 15:06:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353832AbiDZTF5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 15:05:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B75AF1999D1;
        Tue, 26 Apr 2022 12:02:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2DF256199A;
        Tue, 26 Apr 2022 19:02:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BFF0C385A4;
        Tue, 26 Apr 2022 19:02:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650999767;
        bh=IwX2/NnejUzN7u8g7KsKfNNxuvUqvIN8hWL1MrCgCGU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kZKAMdrowE6rh9B/YmCRioYpxaP6wKjzqAbrUocW8SVRApy8WSrgN4x1nmlXY72Dn
         wrysT70SjEahiwmmyWZUtvVIxRvMwvHFz+9pLLG8kYoX78B2D3nMAoUAGtCqV5W0FD
         VFUDORCYHnGchSCCu1xEhzKquyhT3F88AjVIQdpIBMmQCYWflI6K2gbPBRqJOzg1Qe
         wkD1Fzveg+M8z/ErauBMPyBSyNvFDVEa/cSs4WnEjJXfUTTs3rlHPsoBbSyXXOx9Ew
         jS7vC7lyDV8l5XYzABf7CamgiNrXi1nVj93Lz2F9XH8UQAK1KBlKe5LhnDBbpeD4V/
         +OA5MRejd2NuQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mikulas Patocka <mpatocka@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, peterz@infradead.org, jpoimboe@redhat.com
Subject: [PATCH AUTOSEL 5.4 3/6] x86: __memcpy_flushcache: fix wrong alignment if size > 2^32
Date:   Tue, 26 Apr 2022 15:02:39 -0400
Message-Id: <20220426190243.2351733-3-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220426190243.2351733-1-sashal@kernel.org>
References: <20220426190243.2351733-1-sashal@kernel.org>
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
index 1847e993ac63..f3f7f4cb15a6 100644
--- a/arch/x86/lib/usercopy_64.c
+++ b/arch/x86/lib/usercopy_64.c
@@ -142,7 +142,7 @@ void __memcpy_flushcache(void *_dst, const void *_src, size_t size)
 
 	/* cache copy and flush to align dest */
 	if (!IS_ALIGNED(dest, 8)) {
-		unsigned len = min_t(unsigned, size, ALIGN(dest, 8) - dest);
+		size_t len = min_t(size_t, size, ALIGN(dest, 8) - dest);
 
 		memcpy((void *) dest, (void *) source, len);
 		clean_cache_range((void *) dest, len);
-- 
2.35.1

