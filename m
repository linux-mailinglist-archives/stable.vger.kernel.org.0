Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50CC06580F9
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:23:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231635AbiL1QXe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:23:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234978AbiL1QWm (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:22:42 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF1FB1C10C
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:20:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 671EAB816F4
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:20:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D28E7C433EF;
        Wed, 28 Dec 2022 16:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672244411;
        bh=GmCXSwPE5NP+SaO5s7kju7LigtOKyGlQFSX61WElufY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t44ORpTiDSDa776QHbcnH60CVlN4By90so++gj4vhXSZYEwABAAIl9rM3P/cGwH/V
         8Nc91lhOPPwMGgjZri67b/am8qeMZSYshKwp3HwJ5f87nd7FmWAG25agffr2w6Ane3
         hokHql7iOvlAp39rq5a1eOm46rDdYhRIMBqyJ2Ek=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Tong Tiangen <tongtiangen@huawei.com>,
        Palmer Dabbelt <palmer@rivosinc.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0665/1146] riscv/mm: add arch hook arch_clear_hugepage_flags
Date:   Wed, 28 Dec 2022 15:36:44 +0100
Message-Id: <20221228144348.214959183@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
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

From: Tong Tiangen <tongtiangen@huawei.com>

[ Upstream commit d8bf77a1dc3079692f54be3087a5fd16d90027b0 ]

With the PG_arch_1 we keep track if the page's data cache is clean,
architecture rely on this property to treat new pages as dirty with
respect to the data cache and perform the flushing before mapping the pages
into userspace.

This patch adds a new architecture hook, arch_clear_hugepage_flags,so that
architectures which rely on the page flags being in a particular state for
fresh allocations can adjust the flags accordingly when a page is freed
into the pool.

Fixes: 9e953cda5cdf ("riscv: Introduce huge page support for 32/64bit kernel")
Signed-off-by: Tong Tiangen <tongtiangen@huawei.com>
Link: https://lore.kernel.org/r/20221024094725.3054311-3-tongtiangen@huawei.com
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/include/asm/hugetlb.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/riscv/include/asm/hugetlb.h b/arch/riscv/include/asm/hugetlb.h
index a5c2ca1d1cd8..ec19d6afc896 100644
--- a/arch/riscv/include/asm/hugetlb.h
+++ b/arch/riscv/include/asm/hugetlb.h
@@ -5,4 +5,10 @@
 #include <asm-generic/hugetlb.h>
 #include <asm/page.h>
 
+static inline void arch_clear_hugepage_flags(struct page *page)
+{
+	clear_bit(PG_dcache_clean, &page->flags);
+}
+#define arch_clear_hugepage_flags arch_clear_hugepage_flags
+
 #endif /* _ASM_RISCV_HUGETLB_H */
-- 
2.35.1



