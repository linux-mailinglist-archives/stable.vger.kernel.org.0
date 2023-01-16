Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B8D666C4A4
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 16:57:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231854AbjAPP5F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 10:57:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231644AbjAPP4n (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 10:56:43 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2512023C46
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 07:56:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8FAE8B8105C
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 15:56:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7153C433EF;
        Mon, 16 Jan 2023 15:56:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673884592;
        bh=G5EF7PpFZVglgHIPseKb+yxPqD94SmCDv24+S47++xM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Es/qzbvCyEouQWm9dkkYtrUKyk4Avbvo47CPXrMwiTXN3TmXtS/0J4eDNOdiI4UWQ
         cW2XwFsPMrM2ekizGBIhuG6AhIDvz/S/MdNeiUgFLM7OCdeZf9gyxRu+UbSTaYjtU9
         To8FhE4m5YhpCCYr9fIvKF9d/AtqbdD9wDQEICfI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Denys Vlasenko <dvlasenk@redhat.com>,
        Liu Shixin <liushixin2@huawei.com>,
        Pasha Tatashin <pasha.tatashin@soleen.com>,
        David Hildenbrand <david@redhat.com>,
        Kefeng Wang <wangkefeng.wang@huawei.com>,
        Will Deacon <will@kernel.org>
Subject: [PATCH 6.1 064/183] arm64/mm: fix incorrect file_map_count for invalid pmd
Date:   Mon, 16 Jan 2023 16:49:47 +0100
Message-Id: <20230116154806.047835359@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154803.321528435@linuxfoundation.org>
References: <20230116154803.321528435@linuxfoundation.org>
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

From: Liu Shixin <liushixin2@huawei.com>

commit 74c2f81054510d45b813548cb0a1c4ebf87cdd5f upstream.

The page table check trigger BUG_ON() unexpectedly when split hugepage:

 ------------[ cut here ]------------
 kernel BUG at mm/page_table_check.c:119!
 Internal error: Oops - BUG: 00000000f2000800 [#1] SMP
 Dumping ftrace buffer:
    (ftrace buffer empty)
 Modules linked in:
 CPU: 7 PID: 210 Comm: transhuge-stres Not tainted 6.1.0-rc3+ #748
 Hardware name: linux,dummy-virt (DT)
 pstate: 20000005 (nzCv daif -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
 pc : page_table_check_set.isra.0+0x398/0x468
 lr : page_table_check_set.isra.0+0x1c0/0x468
[...]
 Call trace:
  page_table_check_set.isra.0+0x398/0x468
  __page_table_check_pte_set+0x160/0x1c0
  __split_huge_pmd_locked+0x900/0x1648
  __split_huge_pmd+0x28c/0x3b8
  unmap_page_range+0x428/0x858
  unmap_single_vma+0xf4/0x1c8
  zap_page_range+0x2b0/0x410
  madvise_vma_behavior+0xc44/0xe78
  do_madvise+0x280/0x698
  __arm64_sys_madvise+0x90/0xe8
  invoke_syscall.constprop.0+0xdc/0x1d8
  do_el0_svc+0xf4/0x3f8
  el0_svc+0x58/0x120
  el0t_64_sync_handler+0xb8/0xc0
  el0t_64_sync+0x19c/0x1a0
[...]

On arm64, pmd_leaf() will return true even if the pmd is invalid due to
pmd_present_invalid() check. So in pmdp_invalidate() the file_map_count
will not only decrease once but also increase once. Then in set_pte_at(),
the file_map_count increase again, and so trigger BUG_ON() unexpectedly.

Add !pmd_present_invalid() check in pmd_user_accessible_page() to fix the
problem.

Fixes: 42b2547137f5 ("arm64/mm: enable ARCH_SUPPORTS_PAGE_TABLE_CHECK")
Reported-by: Denys Vlasenko <dvlasenk@redhat.com>
Signed-off-by: Liu Shixin <liushixin2@huawei.com>
Acked-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Acked-by: Will Deacon <will@kernel.org>
Link: https://lore.kernel.org/r/20221121073608.4183459-1-liushixin2@huawei.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/include/asm/pgtable.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -863,7 +863,7 @@ static inline bool pte_user_accessible_p
 
 static inline bool pmd_user_accessible_page(pmd_t pmd)
 {
-	return pmd_leaf(pmd) && (pmd_user(pmd) || pmd_user_exec(pmd));
+	return pmd_leaf(pmd) && !pmd_present_invalid(pmd) && (pmd_user(pmd) || pmd_user_exec(pmd));
 }
 
 static inline bool pud_user_accessible_page(pud_t pud)


