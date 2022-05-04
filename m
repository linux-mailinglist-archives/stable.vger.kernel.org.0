Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE41A51A94F
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 19:17:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356211AbiEDRQm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 13:16:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355927AbiEDRI4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 13:08:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70AE5522E8;
        Wed,  4 May 2022 09:54:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 466A761505;
        Wed,  4 May 2022 16:54:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9143FC385A4;
        Wed,  4 May 2022 16:54:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651683281;
        bh=aEDMA/3oe/qWVXNiG9wL+UoIZG5uPLMm54IzJ4kwM5c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q5A9/qREI3rr1L6UwIbajqV94SHLVNF7eXTP4tu9S+WMMgjgvZJuvJh/6jDYpj2op
         dr0qg41VwhoPblEmEU+MEXutqTlZ7ff77fY+Q/hyKrWpd80TZnRkv1v2hZLk3QAaZF
         gZ8JuEOhCeaCyi0TK2MOCAHhwZfpea6ahaJnyMyU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mikulas Patocka <mpatocka@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 134/177] x86: __memcpy_flushcache: fix wrong alignment if size > 2^32
Date:   Wed,  4 May 2022 18:45:27 +0200
Message-Id: <20220504153105.187160754@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220504153053.873100034@linuxfoundation.org>
References: <20220504153053.873100034@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
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
index 508c81e97ab1..f1c0befb62df 100644
--- a/arch/x86/lib/usercopy_64.c
+++ b/arch/x86/lib/usercopy_64.c
@@ -121,7 +121,7 @@ void __memcpy_flushcache(void *_dst, const void *_src, size_t size)
 
 	/* cache copy and flush to align dest */
 	if (!IS_ALIGNED(dest, 8)) {
-		unsigned len = min_t(unsigned, size, ALIGN(dest, 8) - dest);
+		size_t len = min_t(size_t, size, ALIGN(dest, 8) - dest);
 
 		memcpy((void *) dest, (void *) source, len);
 		clean_cache_range((void *) dest, len);
-- 
2.35.1



