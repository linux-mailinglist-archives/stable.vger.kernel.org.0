Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 642DD5946CE
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 01:03:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240705AbiHOXCD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 19:02:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352288AbiHOW73 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 18:59:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A0A27647F;
        Mon, 15 Aug 2022 12:57:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 825B46068D;
        Mon, 15 Aug 2022 19:57:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8634DC433B5;
        Mon, 15 Aug 2022 19:57:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660593443;
        bh=vy+XyJyxYwqtiCG9GXqA01ZwcmWqeKZo0Fjae8q2p/I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U8S1W5lCyo2+5pMoVUNP1bpNDeXGBmzsBpnSN6LOOc8uxbl36rCqcw/VHMbFScGBt
         Hpgz3ZNU4tARa2nuBlZBo89Ggl/saI2hrGd6c2/wv9SoIIKjAMwiJ+ND8xiEq0VmqF
         MZDX1KapHsAOu9Jl60de0/kIsQhUmOUjGPiewMw8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Matthew Wilcox <willy@infradead.org>,
        Uladzislau Rezki <urezki@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Joe Perches <joe@perches.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Kees Cook <keescook@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0246/1157] usercopy: use unsigned long instead of uintptr_t
Date:   Mon, 15 Aug 2022 19:53:22 +0200
Message-Id: <20220815180449.423777119@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason A. Donenfeld <Jason@zx2c4.com>

[ Upstream commit 170b2c350cfcb6f74074e44dd9f916787546db0d ]

A recent commit factored out a series of annoying (unsigned long) casts
into a single variable declaration, but made the pointer type a
`uintptr_t` rather than the usual `unsigned long`. This patch changes it
to be the integer type more typically used by the kernel to represent
addresses.

Fixes: 35fb9ae4aa2e ("usercopy: Cast pointer to an integer once")
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Uladzislau Rezki <urezki@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
Link: https://lore.kernel.org/r/20220616143617.449094-1-Jason@zx2c4.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/usercopy.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/usercopy.c b/mm/usercopy.c
index 4e1da708699b..c1ee15a98633 100644
--- a/mm/usercopy.c
+++ b/mm/usercopy.c
@@ -161,7 +161,7 @@ static inline void check_bogus_address(const unsigned long ptr, unsigned long n,
 static inline void check_heap_object(const void *ptr, unsigned long n,
 				     bool to_user)
 {
-	uintptr_t addr = (uintptr_t)ptr;
+	unsigned long addr = (unsigned long)ptr;
 	unsigned long offset;
 	struct folio *folio;
 
-- 
2.35.1



