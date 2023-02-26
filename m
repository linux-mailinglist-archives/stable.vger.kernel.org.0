Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 138F36A3088
	for <lists+stable@lfdr.de>; Sun, 26 Feb 2023 15:50:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230105AbjBZOu0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Feb 2023 09:50:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230104AbjBZOtk (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 26 Feb 2023 09:49:40 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9ADD712F37;
        Sun, 26 Feb 2023 06:48:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D17B660C19;
        Sun, 26 Feb 2023 14:45:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 687C6C433EF;
        Sun, 26 Feb 2023 14:45:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677422758;
        bh=WYkdGVS0vINTRDqZUVyCLihrwarBLyPRWPVvLsWnlwg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PomgW/yRaUxlrontCywq/L/02n0+GBXz62xHWm8kJKfOKdtRLO8jdrC0V3NFACKWG
         iQJuDDx7pDAu+HT/ELuBC+ZQQ02Yddkba66Q9vI5Zd/sIRka5tHyeUsHtIt+vEhyet
         ci6SvYO6w4RYWDYnyh01EfTFP0U4w53QMv7THzUdzNf63q49RaJuiueDkt2Uz2lqkl
         GTykl+Ob5vObEIZqB36YiY0XMbAhZcQpWtPtw8Fx3gyOL79kNnEk4l/VAQtXdXjwR/
         E/cmT7AiAY8OcK4J5+eUawdHUJy9RoerWjRy8p07jGzDpcCUtucptSWF2BVEcBaDyn
         /udYc7i7lQicQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>, gerald.schaefer@linux.ibm.com,
        linux-s390@vger.kernel.org
Subject: [PATCH AUTOSEL 6.2 29/53] s390/mm,ptdump: avoid Kasan vs Memcpy Real markers swapping
Date:   Sun, 26 Feb 2023 09:44:21 -0500
Message-Id: <20230226144446.824580-29-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230226144446.824580-1-sashal@kernel.org>
References: <20230226144446.824580-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
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
2.39.0

