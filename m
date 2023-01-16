Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6692966C16C
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 15:11:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232222AbjAPOLj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 09:11:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231933AbjAPOLA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 09:11:00 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DE7A2A985;
        Mon, 16 Jan 2023 06:04:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B0C5760FCA;
        Mon, 16 Jan 2023 14:04:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF6B0C433EF;
        Mon, 16 Jan 2023 14:04:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673877863;
        bh=uGUWA/oN2eEinqgBURcjr5T3ScL0DtjpUiZbqKT/3zc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ncOjGbkirtFU/dECLJdHnzz7tsMLiWGcAvcLbCwIYX8t+Qk0JiRLieHBHUbA/imLp
         ZCC0cnBvl3h4H81rW29lu6Ijk/mzRrOWzbiugJiGL2Q6+j4tH7p6n/RTNfMKpm9lBv
         ZvDZcOeKv2CUC4N21nKPnPFpCfJpHVc/NlS8ZmpijkSe7Va//MNpNqXKUY+zgcP+Kh
         mHLGZV8GdbKPbI9fwBxctIcDwIbIN0XS7A9Lki873hBO83wBuUdBMX1xo80CdgNe8K
         OKKA447Xn/qLAwp5RedVirr6u/tzFOPqs+vjDrm9OQfzLVLZREH3ej4HIHGe9OwR7s
         XzC94Wyw62IKw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Will Deacon <will@kernel.org>, kernel test robot <lkp@intel.com>,
        Sasha Levin <sashal@kernel.org>, catalin.marinas@arm.com,
        anshuman.khandual@arm.com, akpm@linux-foundation.org,
        wangkefeng.wang@huawei.com, liushixin2@huawei.com,
        david@redhat.com, tongtiangen@huawei.com, yuzhao@google.com,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.15 12/24] arm64/mm: Define dummy pud_user_exec() when using 2-level page-table
Date:   Mon, 16 Jan 2023 09:03:47 -0500
Message-Id: <20230116140359.115716-12-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20230116140359.115716-1-sashal@kernel.org>
References: <20230116140359.115716-1-sashal@kernel.org>
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

From: Will Deacon <will@kernel.org>

[ Upstream commit 4e4ff23a35ee3a145fbc8378ecfeaab2d235cddd ]

With only two levels of page-table, the generic 'pud_*' macros are
implemented using dummy operations in pgtable-nopmd.h. Since commit
730a11f982e6 ("arm64/mm: add pud_user_exec() check in
pud_user_accessible_page()"), pud_user_accessible_page() unconditionally
calls pud_user_exec(), which is an arm64-specific helper and therefore
isn't defined by pgtable-nopmd.h. This results in a build failure for
configurations with only two levels of page table:

   arch/arm64/include/asm/pgtable.h: In function 'pud_user_accessible_page':
>> arch/arm64/include/asm/pgtable.h:870:51: error: implicit declaration of function 'pud_user_exec'; did you mean 'pmd_user_exec'? [-Werror=implicit-function-declaration]
     870 |         return pud_leaf(pud) && (pud_user(pud) || pud_user_exec(pud));
         |                                                   ^~~~~~~~~~~~~
         |                                                   pmd_user_exec

Fix the problem by defining pud_user_exec() as pud_user() in this case.

Link: https://lore.kernel.org/r/202301080515.z6zEksU4-lkp@intel.com
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/include/asm/pgtable.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index ed57717cd004..cabbc03533b7 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -675,6 +675,7 @@ static inline pmd_t *pud_pgtable(pud_t pud)
 #else
 
 #define pud_page_paddr(pud)	({ BUILD_BUG(); 0; })
+#define pud_user_exec(pud)	pud_user(pud) /* Always 0 with folding */
 
 /* Match pmd_offset folding in <asm/generic/pgtable-nopmd.h> */
 #define pmd_set_fixmap(addr)		NULL
-- 
2.35.1

