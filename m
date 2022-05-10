Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3B5D5217A2
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 15:24:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242653AbiEJN2I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 09:28:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243500AbiEJN04 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 09:26:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1291F2375EA;
        Tue, 10 May 2022 06:19:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4C735615F8;
        Tue, 10 May 2022 13:19:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 561C9C385A6;
        Tue, 10 May 2022 13:19:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652188788;
        bh=Q4Y3SyK/jeyCZmbyzItTJ1Zzlro6NPXoyjvomzCp6lw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JrUML8G4HV2qMta6dzFeo7wJnRUmKewSerGL2AaKKZ7HGWevkha2VSQzU8sh3zIuV
         NQnQZfTx6JepTnI2me/uOZBl4NCZD5g7glXYY0OPvqciOYVw3WV7AoUiFJTL9MQSte
         gxD4+BRdjhViDfbt+UBBIqSM7q7prWrvHujPp8H4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mikulas Patocka <mpatocka@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 45/88] x86: __memcpy_flushcache: fix wrong alignment if size > 2^32
Date:   Tue, 10 May 2022 15:07:30 +0200
Message-Id: <20220510130735.057838356@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220510130733.735278074@linuxfoundation.org>
References: <20220510130733.735278074@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
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



