Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 287946AEBB9
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:48:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232194AbjCGRsT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:48:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232066AbjCGRsB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:48:01 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73F378F50D
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:42:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D0A836150F
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:41:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDA29C433D2;
        Tue,  7 Mar 2023 17:41:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678210912;
        bh=LU+1oG37GVp9ieO4whK8pU3+qJA8YQyavvKZccwQgxQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pmq69VFju85x0CCqOBk5vjJq4H1s1qjSGR8pBFy9AVWaRfIdWOsiJsyf5FUmCXrmn
         xrlIx2a/EsOk/HwWkW7qHzFTcpCh3jtBluKOO6dF3V8fQFCyMSAFmYLbAIL2gVh/k0
         KaPzdxjXGV4HhNwJIoxx19Op3Y7qSNLfOH6jbT+o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0663/1001] s390/mm,ptdump: avoid Kasan vs Memcpy Real markers swapping
Date:   Tue,  7 Mar 2023 17:57:15 +0100
Message-Id: <20230307170050.374879908@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vasily Gorbik <gor@linux.ibm.com>

[ Upstream commit 05178996e1a77e2a4664536e6d101a086a905034 ]

---[ Real Memory Copy Area Start ]---
0x001bfffffffff000-0x001c000000000000         4K PTE I
---[ Kasan Shadow Start ]---
---[ Real Memory Copy Area End ]---
0x001c000000000000-0x001c000200000000         8G PMD RW NX
...
---[ Kasan Shadow End ]---

ptdump does a stable sort of markers. Move kasan markers after
memcpy real to avoid swapping.

Reviewed-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/mm/dump_pagetables.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/s390/mm/dump_pagetables.c b/arch/s390/mm/dump_pagetables.c
index 9953819d79596..ba5f802688781 100644
--- a/arch/s390/mm/dump_pagetables.c
+++ b/arch/s390/mm/dump_pagetables.c
@@ -33,10 +33,6 @@ enum address_markers_idx {
 #endif
 	IDENTITY_AFTER_NR,
 	IDENTITY_AFTER_END_NR,
-#ifdef CONFIG_KASAN
-	KASAN_SHADOW_START_NR,
-	KASAN_SHADOW_END_NR,
-#endif
 	VMEMMAP_NR,
 	VMEMMAP_END_NR,
 	VMALLOC_NR,
@@ -47,6 +43,10 @@ enum address_markers_idx {
 	ABS_LOWCORE_END_NR,
 	MEMCPY_REAL_NR,
 	MEMCPY_REAL_END_NR,
+#ifdef CONFIG_KASAN
+	KASAN_SHADOW_START_NR,
+	KASAN_SHADOW_END_NR,
+#endif
 };
 
 static struct addr_marker address_markers[] = {
@@ -62,10 +62,6 @@ static struct addr_marker address_markers[] = {
 #endif
 	[IDENTITY_AFTER_NR]	= {(unsigned long)_end, "Identity Mapping Start"},
 	[IDENTITY_AFTER_END_NR]	= {0, "Identity Mapping End"},
-#ifdef CONFIG_KASAN
-	[KASAN_SHADOW_START_NR]	= {KASAN_SHADOW_START, "Kasan Shadow Start"},
-	[KASAN_SHADOW_END_NR]	= {KASAN_SHADOW_END, "Kasan Shadow End"},
-#endif
 	[VMEMMAP_NR]		= {0, "vmemmap Area Start"},
 	[VMEMMAP_END_NR]	= {0, "vmemmap Area End"},
 	[VMALLOC_NR]		= {0, "vmalloc Area Start"},
@@ -76,6 +72,10 @@ static struct addr_marker address_markers[] = {
 	[ABS_LOWCORE_END_NR]	= {0, "Lowcore Area End"},
 	[MEMCPY_REAL_NR]	= {0, "Real Memory Copy Area Start"},
 	[MEMCPY_REAL_END_NR]	= {0, "Real Memory Copy Area End"},
+#ifdef CONFIG_KASAN
+	[KASAN_SHADOW_START_NR]	= {KASAN_SHADOW_START, "Kasan Shadow Start"},
+	[KASAN_SHADOW_END_NR]	= {KASAN_SHADOW_END, "Kasan Shadow End"},
+#endif
 	{ -1, NULL }
 };
 
-- 
2.39.2



