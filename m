Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4D125FB65E
	for <lists+stable@lfdr.de>; Tue, 11 Oct 2022 17:04:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230089AbiJKPEP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Oct 2022 11:04:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231383AbiJKPCw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Oct 2022 11:02:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E22B5A4BA6;
        Tue, 11 Oct 2022 07:58:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EBC47B8124C;
        Tue, 11 Oct 2022 14:53:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D8CAC4314C;
        Tue, 11 Oct 2022 14:53:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665499990;
        bh=emIx/+3Q8BsgCf+v6rmowQa5eTKpefi3ZwOFOIBfSkg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oi0POXSBdZcy3Nty7Qj2gvcEkqT30BQK/H3HSM0WScypoRcKlakEvVwhnXfEDCfbl
         KgTSv3iVepuyxWZPyNjzSJe7Xx2SumEa8OV9LdaG3Cy8luAozjw3cY2oq6U3q/keU6
         22NFZTWRuZjc8SMxI0bqCxqsOAxt5k9MSVh8SMJWIOeh9jroI/EZuF6SSrURh48U7V
         Apj/2Xmbb5HsmUJ8TTs0kNrEbOJH9ZbKg6m3ONdHO/w+H4hB69C5HRIuhs/DPUbn4V
         pDvpPK8Mo+Ynsa2y/Sus+qvTFQqJktPq6ydVyRyKUxq6QCSqiNq8EdxctxwIzxgXIT
         p1vOJfpDwFS7A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alex Sverdlin <alexander.sverdlin@nokia.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Sasha Levin <sashal@kernel.org>, aryabinin@virtuozzo.com,
        linux@armlinux.org.uk, kasan-dev@googlegroups.com,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.15 25/26] ARM: 9242/1: kasan: Only map modules if CONFIG_KASAN_VMALLOC=n
Date:   Tue, 11 Oct 2022 10:52:32 -0400
Message-Id: <20221011145233.1624013-25-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221011145233.1624013-1-sashal@kernel.org>
References: <20221011145233.1624013-1-sashal@kernel.org>
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

From: Alex Sverdlin <alexander.sverdlin@nokia.com>

[ Upstream commit 823f606ab6b4759a1faf0388abcf4fb0776710d2 ]

In case CONFIG_KASAN_VMALLOC=y kasan_populate_vmalloc() allocates the
shadow pages dynamically. But even worse is that kasan_release_vmalloc()
releases them, which is not compatible with create_mapping() of
MODULES_VADDR..MODULES_END range:

BUG: Bad page state in process kworker/9:1  pfn:2068b
page:e5e06160 refcount:0 mapcount:0 mapping:00000000 index:0x0
flags: 0x1000(reserved)
raw: 00001000 e5e06164 e5e06164 00000000 00000000 00000000 ffffffff 00000000
page dumped because: PAGE_FLAGS_CHECK_AT_FREE flag(s) set
bad because of flags: 0x1000(reserved)
Modules linked in: ip_tables
CPU: 9 PID: 154 Comm: kworker/9:1 Not tainted 5.4.188-... #1
Hardware name: LSI Axxia AXM55XX
Workqueue: events do_free_init
unwind_backtrace
show_stack
dump_stack
bad_page
free_pcp_prepare
free_unref_page
kasan_depopulate_vmalloc_pte
__apply_to_page_range
apply_to_existing_page_range
kasan_release_vmalloc
__purge_vmap_area_lazy
_vm_unmap_aliases.part.0
__vunmap
do_free_init
process_one_work
worker_thread
kthread

Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Alexander Sverdlin <alexander.sverdlin@nokia.com>
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mm/kasan_init.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mm/kasan_init.c b/arch/arm/mm/kasan_init.c
index 4b1619584b23..948ada4a2938 100644
--- a/arch/arm/mm/kasan_init.c
+++ b/arch/arm/mm/kasan_init.c
@@ -264,12 +264,17 @@ void __init kasan_init(void)
 
 	/*
 	 * 1. The module global variables are in MODULES_VADDR ~ MODULES_END,
-	 *    so we need to map this area.
+	 *    so we need to map this area if CONFIG_KASAN_VMALLOC=n. With
+	 *    VMALLOC support KASAN will manage this region dynamically,
+	 *    refer to kasan_populate_vmalloc() and ARM's implementation of
+	 *    module_alloc().
 	 * 2. PKMAP_BASE ~ PKMAP_BASE+PMD_SIZE's shadow and MODULES_VADDR
 	 *    ~ MODULES_END's shadow is in the same PMD_SIZE, so we can't
 	 *    use kasan_populate_zero_shadow.
 	 */
-	create_mapping((void *)MODULES_VADDR, (void *)(PKMAP_BASE + PMD_SIZE));
+	if (!IS_ENABLED(CONFIG_KASAN_VMALLOC) && IS_ENABLED(CONFIG_MODULES))
+		create_mapping((void *)MODULES_VADDR, (void *)(MODULES_END));
+	create_mapping((void *)PKMAP_BASE, (void *)(PKMAP_BASE + PMD_SIZE));
 
 	/*
 	 * KAsan may reuse the contents of kasan_early_shadow_pte directly, so
-- 
2.35.1

