Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2810A6357B2
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:46:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238152AbiKWJpV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:45:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238154AbiKWJpA (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:45:00 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 487651FCC0
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:42:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EA46BB81E54
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:42:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6BB6C433D6;
        Wed, 23 Nov 2022 09:42:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669196556;
        bh=tHt+YtnEBQI4DI4rbzjAz+77/2jeNxo6qq8BeSOWjb4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iqHp0Hbqb/zWia7Q15zqmHX/5pJ1E/7umQdkiO75TQpRMlELihWu2/5WT+sFp3pC1
         xFw9BRD0JRotiJaRLlADXdqcvS36Anbs0/C8xkVeHfy03SvtsS4uREgCmIc+1Ldeyo
         4U4P3RC6Jqy6p40QYLXBHfFV4y6VDbxCo99kRzwM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Ard Biesheuvel <ardb@kernel.org>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 064/314] arm64: fix rodata=full again
Date:   Wed, 23 Nov 2022 09:48:29 +0100
Message-Id: <20221123084628.385340221@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084625.457073469@linuxfoundation.org>
References: <20221123084625.457073469@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ard Biesheuvel <ardb@kernel.org>

[ Upstream commit 2081b3bd0c11757725dcab9ba5d38e1bddb03459 ]

Commit 2e8cff0a0eee87b2 ("arm64: fix rodata=full") addressed a couple of
issues with the rodata= kernel command line option, which is not a
simple boolean on arm64, and inadvertently got broken due to changes in
the generic bool handling.

Unfortunately, the resulting code never clears the rodata_full boolean
variable if it defaults to true and rodata=on or rodata=off is passed,
as the generic code is not aware of the existence of this variable.

Given the way this code is plumbed together, clearing rodata_full when
returning false from arch_parse_debug_rodata() may result in
inconsistencies if the generic code decides that it cannot parse the
right hand side, so the best way to deal with this is to only take
rodata_full in account if rodata_enabled is also true.

Fixes: 2e8cff0a0eee ("arm64: fix rodata=full")
Cc: <stable@vger.kernel.org> # 6.0.x
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Acked-by: Will Deacon <will@kernel.org>
Link: https://lore.kernel.org/r/20221103170015.4124426-1-ardb@kernel.org
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/mm/pageattr.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/mm/pageattr.c b/arch/arm64/mm/pageattr.c
index d107c3d434e2..5922178d7a06 100644
--- a/arch/arm64/mm/pageattr.c
+++ b/arch/arm64/mm/pageattr.c
@@ -26,7 +26,7 @@ bool can_set_direct_map(void)
 	 * mapped at page granularity, so that it is possible to
 	 * protect/unprotect single pages.
 	 */
-	return rodata_full || debug_pagealloc_enabled() ||
+	return (rodata_enabled && rodata_full) || debug_pagealloc_enabled() ||
 		IS_ENABLED(CONFIG_KFENCE);
 }
 
@@ -102,7 +102,8 @@ static int change_memory_common(unsigned long addr, int numpages,
 	 * If we are manipulating read-only permissions, apply the same
 	 * change to the linear mapping of the pages that back this VM area.
 	 */
-	if (rodata_full && (pgprot_val(set_mask) == PTE_RDONLY ||
+	if (rodata_enabled &&
+	    rodata_full && (pgprot_val(set_mask) == PTE_RDONLY ||
 			    pgprot_val(clear_mask) == PTE_RDONLY)) {
 		for (i = 0; i < area->nr_pages; i++) {
 			__change_memory_common((u64)page_address(area->pages[i]),
-- 
2.35.1



