Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F7614F263C
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 09:54:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232622AbiDEH4A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 03:56:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232489AbiDEHza (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 03:55:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F22C37036;
        Tue,  5 Apr 2022 00:50:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 60ABBB81BB1;
        Tue,  5 Apr 2022 07:50:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7EC1C340EE;
        Tue,  5 Apr 2022 07:50:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649145030;
        bh=nK806L/HXQjI0JbXIYqotYrEiT9JChqTmGRmHJKNS4I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UUaEJFViSY75cR1fd1UvBUKGqTuvE2hfrKgvMk7e3/XCL8DiQU1lztHC//GibkcWW
         OFR8KXSSEQqEtic5diMf/x2HeMf4O3p89L0EwnKfs+6JYJ2WKe4T89jhYcWlKsI7EJ
         mxJGvKqhdlXbTTQdurgprAVOvt3TEAtXR5AcnJH4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jianyong Wu <jianyong.wu@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0220/1126] arm64/mm: avoid fixmap race condition when create pud mapping
Date:   Tue,  5 Apr 2022 09:16:07 +0200
Message-Id: <20220405070414.067288639@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Jianyong Wu <jianyong.wu@arm.com>

[ Upstream commit ee017ee353506fcec58e481673e4331ff198a80e ]

The 'fixmap' is a global resource and is used recursively by
create pud mapping(), leading to a potential race condition in the
presence of a concurrent call to alloc_init_pud():

kernel_init thread                          virtio-mem workqueue thread
==================                          ===========================

  alloc_init_pud(...)                       alloc_init_pud(...)
  pudp = pud_set_fixmap_offset(...)         pudp = pud_set_fixmap_offset(...)
  READ_ONCE(*pudp)
  pud_clear_fixmap(...)
                                            READ_ONCE(*pudp) // CRASH!

As kernel may sleep during creating pud mapping, introduce a mutex lock to
serialise use of the fixmap entries by alloc_init_pud(). However, there is
no need for locking in early boot stage and it doesn't work well with
KASLR enabled when early boot. So, enable lock when system_state doesn't
equal to "SYSTEM_BOOTING".

Signed-off-by: Jianyong Wu <jianyong.wu@arm.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Fixes: f4710445458c ("arm64: mm: use fixmap when creating page tables")
Link: https://lore.kernel.org/r/20220201114400.56885-1-jianyong.wu@arm.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/mm/mmu.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index 044d2021c20c..37b8230cda6a 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -63,6 +63,7 @@ static pmd_t bm_pmd[PTRS_PER_PMD] __page_aligned_bss __maybe_unused;
 static pud_t bm_pud[PTRS_PER_PUD] __page_aligned_bss __maybe_unused;
 
 static DEFINE_SPINLOCK(swapper_pgdir_lock);
+static DEFINE_MUTEX(fixmap_lock);
 
 void set_swapper_pgd(pgd_t *pgdp, pgd_t pgd)
 {
@@ -329,6 +330,12 @@ static void alloc_init_pud(pgd_t *pgdp, unsigned long addr, unsigned long end,
 	}
 	BUG_ON(p4d_bad(p4d));
 
+	/*
+	 * No need for locking during early boot. And it doesn't work as
+	 * expected with KASLR enabled.
+	 */
+	if (system_state != SYSTEM_BOOTING)
+		mutex_lock(&fixmap_lock);
 	pudp = pud_set_fixmap_offset(p4dp, addr);
 	do {
 		pud_t old_pud = READ_ONCE(*pudp);
@@ -359,6 +366,8 @@ static void alloc_init_pud(pgd_t *pgdp, unsigned long addr, unsigned long end,
 	} while (pudp++, addr = next, addr != end);
 
 	pud_clear_fixmap();
+	if (system_state != SYSTEM_BOOTING)
+		mutex_unlock(&fixmap_lock);
 }
 
 static void __create_pgd_mapping(pgd_t *pgdir, phys_addr_t phys,
-- 
2.34.1



