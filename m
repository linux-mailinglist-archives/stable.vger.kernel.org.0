Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F23F5944C8
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 00:59:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350487AbiHOWjg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 18:39:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351322AbiHOWh6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 18:37:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77A9C1322FE;
        Mon, 15 Aug 2022 12:51:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4F7FA61206;
        Mon, 15 Aug 2022 19:51:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3039CC433C1;
        Mon, 15 Aug 2022 19:50:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660593059;
        bh=f1yBoZdlxrrj+e56t5SpYyY3+I6Cwa8ohg4maem5XqM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Tf9sFFkKdx/lqKJtIVQZj0n3FcnqYVfZ8fmSnhiy3CoqVK4YZfZ0nrweKZIKGJb7H
         L/WhkuV/v08g/u+VPKhAzlk+IJo48CjgLE2Vy6ALsalT9bWv5lZReTLOSvZDdf9tnU
         0MGhtZr4NELe01nchIoUgfEtAcxZnhD/UzHMYWzU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        Serge Semin <fancer.lancer@gmail.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0886/1095] MIPS: Fixed __debug_virt_addr_valid()
Date:   Mon, 15 Aug 2022 20:04:45 +0200
Message-Id: <20220815180505.990184416@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
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

From: Florian Fainelli <f.fainelli@gmail.com>

[ Upstream commit 8a2b456665d1e797123669581524cbb095fb003b ]

It is permissible for kernel code to call virt_to_phys() against virtual
addresses that are in KSEG0 or KSEG1 and we need to be dealing with both
types. Rewrite the test condition to ensure that the kernel virtual
addresses are above PAGE_OFFSET which they must be, and below KSEG2
where the non-linear mapping starts.

For EVA, there is not much that we can do given the linear address range
that is offered, so just return any virtual address as being valid.

Finally, when HIGHMEM is not enabled, all virtual addresses are assumed
to be valid as well.

Fixes: dfad83cb7193 ("MIPS: Add support for CONFIG_DEBUG_VIRTUAL")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Reviewed-by: Serge Semin <fancer.lancer@gmail.com>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/mm/physaddr.c | 14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

diff --git a/arch/mips/mm/physaddr.c b/arch/mips/mm/physaddr.c
index a1ced5e44951..f9b8c85e9843 100644
--- a/arch/mips/mm/physaddr.c
+++ b/arch/mips/mm/physaddr.c
@@ -5,6 +5,7 @@
 #include <linux/mmdebug.h>
 #include <linux/mm.h>
 
+#include <asm/addrspace.h>
 #include <asm/sections.h>
 #include <asm/io.h>
 #include <asm/page.h>
@@ -12,15 +13,6 @@
 
 static inline bool __debug_virt_addr_valid(unsigned long x)
 {
-	/* high_memory does not get immediately defined, and there
-	 * are early callers of __pa() against PAGE_OFFSET
-	 */
-	if (!high_memory && x >= PAGE_OFFSET)
-		return true;
-
-	if (high_memory && x >= PAGE_OFFSET && x < (unsigned long)high_memory)
-		return true;
-
 	/*
 	 * MAX_DMA_ADDRESS is a virtual address that may not correspond to an
 	 * actual physical address. Enough code relies on
@@ -30,7 +22,9 @@ static inline bool __debug_virt_addr_valid(unsigned long x)
 	if (x == MAX_DMA_ADDRESS)
 		return true;
 
-	return false;
+	return x >= PAGE_OFFSET && (KSEGX(x) < KSEG2 ||
+	       IS_ENABLED(CONFIG_EVA) ||
+	       !IS_ENABLED(CONFIG_HIGHMEM));
 }
 
 phys_addr_t __virt_to_phys(volatile const void *x)
-- 
2.35.1



