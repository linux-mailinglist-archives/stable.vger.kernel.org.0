Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8868C4D32F5
	for <lists+stable@lfdr.de>; Wed,  9 Mar 2022 17:16:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234454AbiCIQHk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Mar 2022 11:07:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234564AbiCIQHN (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Mar 2022 11:07:13 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB2EF141FD6;
        Wed,  9 Mar 2022 08:03:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BB52AB82224;
        Wed,  9 Mar 2022 16:03:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17EBEC340EF;
        Wed,  9 Mar 2022 16:03:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646841790;
        bh=yxgoumT1YLDdhdq5IBgheUbGQSZm44o0PVleM4hr8QE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p/clB6DpbDge5C8iKls60b/T87z4jMWstj9Kc8170AlmcAGRmmqjMt04orSfCUAbr
         /rCt3LOgPqEohZ70bnEYE264AOg/NJhev5fll9CcToX4dfmbPcQpVqPYmxVgldaIlZ
         BZyqaO8N1gP4bwStI4aDCiJLxtBcOLk63dEYN91s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Subject: [PATCH 4.19 14/18] ARM: early traps initialisation
Date:   Wed,  9 Mar 2022 16:59:51 +0100
Message-Id: <20220309155856.578724010@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220309155856.155540075@linuxfoundation.org>
References: <20220309155856.155540075@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>

commit 04e91b7324760a377a725e218b5ee783826d30f5 upstream.

Provide a couple of helpers to copy the vectors and stubs, and also
to flush the copied vectors and stubs.

Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/kernel/traps.c |   27 +++++++++++++++++++++------
 1 file changed, 21 insertions(+), 6 deletions(-)

--- a/arch/arm/kernel/traps.c
+++ b/arch/arm/kernel/traps.c
@@ -830,10 +830,22 @@ static inline void __init kuser_init(voi
 }
 #endif
 
+#ifndef CONFIG_CPU_V7M
+static void copy_from_lma(void *vma, void *lma_start, void *lma_end)
+{
+	memcpy(vma, lma_start, lma_end - lma_start);
+}
+
+static void flush_vectors(void *vma, size_t offset, size_t size)
+{
+	unsigned long start = (unsigned long)vma + offset;
+	unsigned long end = start + size;
+
+	flush_icache_range(start, end);
+}
+
 void __init early_trap_init(void *vectors_base)
 {
-#ifndef CONFIG_CPU_V7M
-	unsigned long vectors = (unsigned long)vectors_base;
 	extern char __stubs_start[], __stubs_end[];
 	extern char __vectors_start[], __vectors_end[];
 	unsigned i;
@@ -854,17 +866,20 @@ void __init early_trap_init(void *vector
 	 * into the vector page, mapped at 0xffff0000, and ensure these
 	 * are visible to the instruction stream.
 	 */
-	memcpy((void *)vectors, __vectors_start, __vectors_end - __vectors_start);
-	memcpy((void *)vectors + 0x1000, __stubs_start, __stubs_end - __stubs_start);
+	copy_from_lma(vectors_base, __vectors_start, __vectors_end);
+	copy_from_lma(vectors_base + 0x1000, __stubs_start, __stubs_end);
 
 	kuser_init(vectors_base);
 
-	flush_icache_range(vectors, vectors + PAGE_SIZE * 2);
+	flush_vectors(vectors_base, 0, PAGE_SIZE * 2);
+}
 #else /* ifndef CONFIG_CPU_V7M */
+void __init early_trap_init(void *vectors_base)
+{
 	/*
 	 * on V7-M there is no need to copy the vector table to a dedicated
 	 * memory area. The address is configurable and so a table in the kernel
 	 * image can be used.
 	 */
-#endif
 }
+#endif


