Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E840A4CF9AF
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 11:14:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235782AbiCGKOC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 05:14:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242342AbiCGKL0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 05:11:26 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2AD38A304;
        Mon,  7 Mar 2022 01:54:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4F77B60A23;
        Mon,  7 Mar 2022 09:54:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C52CC340E9;
        Mon,  7 Mar 2022 09:54:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646646896;
        bh=x+/m0XSob4i8XhaSbKnkLEgxtn13mwwPLD6Br4nANn4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gzcLiA7Gc/P1kWMvwxbL6rrB6C4qXdm0L+Jtnj5qCrBdWM7Pt+KoBcY6am/cvIvdB
         53ISOGtHvVtuhzju+ZDJrYLng9hEIOq8ogbmbCBM1pBaKYSwj7F9xSvEJr2jxhMIFR
         +IzJcu9qXkPFQjAWiJe5y6A70nX5g4/+84ZT8w7g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rui Salvaterra <rsalvaterra@gmail.com>,
        Chuanhong Guo <gch981213@gmail.com>,
        Sergio Paracuellos <sergio.paracuellos@gmail.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 127/186] MIPS: ralink: mt7621: do memory detection on KSEG1
Date:   Mon,  7 Mar 2022 10:19:25 +0100
Message-Id: <20220307091657.630682691@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091654.092878898@linuxfoundation.org>
References: <20220307091654.092878898@linuxfoundation.org>
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

From: Chuanhong Guo <gch981213@gmail.com>

[ Upstream commit cc19db8b312a6c75645645f5cc1b45166b109006 ]

It's reported that current memory detection code occasionally detects
larger memory under some bootloaders.
Current memory detection code tests whether address space wraps around
on KSEG0, which is unreliable because it's cached.

Rewrite memory size detection to perform the same test on KSEG1 instead.
While at it, this patch also does the following two things:
1. use a fixed pattern instead of a random function pointer as the magic
   value.
2. add an additional memory write and a second comparison as part of the
   test to prevent possible smaller memory detection result due to
   leftover values in memory.

Fixes: 139c949f7f0a MIPS: ("ralink: mt7621: add memory detection support")
Reported-by: Rui Salvaterra <rsalvaterra@gmail.com>
Signed-off-by: Chuanhong Guo <gch981213@gmail.com>
Tested-by: Sergio Paracuellos <sergio.paracuellos@gmail.com>
Tested-by: Rui Salvaterra <rsalvaterra@gmail.com>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/ralink/mt7621.c | 36 +++++++++++++++++++++++-------------
 1 file changed, 23 insertions(+), 13 deletions(-)

diff --git a/arch/mips/ralink/mt7621.c b/arch/mips/ralink/mt7621.c
index bd71f5b14238..fd9a872d5713 100644
--- a/arch/mips/ralink/mt7621.c
+++ b/arch/mips/ralink/mt7621.c
@@ -20,31 +20,41 @@
 
 #include "common.h"
 
-static void *detect_magic __initdata = detect_memory_region;
+#define MT7621_MEM_TEST_PATTERN         0xaa5555aa
+
+static u32 detect_magic __initdata;
 
 phys_addr_t mips_cpc_default_phys_base(void)
 {
 	panic("Cannot detect cpc address");
 }
 
+static bool __init mt7621_addr_wraparound_test(phys_addr_t size)
+{
+	void *dm = (void *)KSEG1ADDR(&detect_magic);
+
+	if (CPHYSADDR(dm + size) >= MT7621_LOWMEM_MAX_SIZE)
+		return true;
+	__raw_writel(MT7621_MEM_TEST_PATTERN, dm);
+	if (__raw_readl(dm) != __raw_readl(dm + size))
+		return false;
+	__raw_writel(!MT7621_MEM_TEST_PATTERN, dm);
+	return __raw_readl(dm) == __raw_readl(dm + size);
+}
+
 static void __init mt7621_memory_detect(void)
 {
-	void *dm = &detect_magic;
 	phys_addr_t size;
 
-	for (size = 32 * SZ_1M; size < 256 * SZ_1M; size <<= 1) {
-		if (!__builtin_memcmp(dm, dm + size, sizeof(detect_magic)))
-			break;
+	for (size = 32 * SZ_1M; size <= 256 * SZ_1M; size <<= 1) {
+		if (mt7621_addr_wraparound_test(size)) {
+			memblock_add(MT7621_LOWMEM_BASE, size);
+			return;
+		}
 	}
 
-	if ((size == 256 * SZ_1M) &&
-	    (CPHYSADDR(dm + size) < MT7621_LOWMEM_MAX_SIZE) &&
-	    __builtin_memcmp(dm, dm + size, sizeof(detect_magic))) {
-		memblock_add(MT7621_LOWMEM_BASE, MT7621_LOWMEM_MAX_SIZE);
-		memblock_add(MT7621_HIGHMEM_BASE, MT7621_HIGHMEM_SIZE);
-	} else {
-		memblock_add(MT7621_LOWMEM_BASE, size);
-	}
+	memblock_add(MT7621_LOWMEM_BASE, MT7621_LOWMEM_MAX_SIZE);
+	memblock_add(MT7621_HIGHMEM_BASE, MT7621_HIGHMEM_SIZE);
 }
 
 void __init ralink_of_remap(void)
-- 
2.34.1



