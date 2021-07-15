Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CFA63CA79F
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 20:53:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241401AbhGOSzh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 14:55:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:59220 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242312AbhGOSzC (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 14:55:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5CEF3613CC;
        Thu, 15 Jul 2021 18:52:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626375127;
        bh=VaSw8eXxJwYqDAsNRRTpRkjq+fkc9jcRrS0A8LIPC8g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EZrgEfLB3+JBBLdkruBeMMd3IaOu1wmPCS0Nhl6v9gRtMRk9mQORqZSudYwKWkhqh
         6JOwafpLrgqBYwmUHbDySid24PaawE3Qd/maFi1j8ts5ano73KY8+mrLw8+5wCPljw
         MjAnX01yYOi3CzLZDZhWDoOB7tha2t78p9DFybZc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
        ZhuRui <zhurui3@huawei.com>, Zhenyu Ye <yezhenyu2@huawei.com>,
        Will Deacon <will@kernel.org>
Subject: [PATCH 5.10 171/215] arm64: tlb: fix the TTL value of tlb_get_level
Date:   Thu, 15 Jul 2021 20:39:03 +0200
Message-Id: <20210715182629.786403180@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182558.381078833@linuxfoundation.org>
References: <20210715182558.381078833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhenyu Ye <yezhenyu2@huawei.com>

commit 52218fcd61cb42bde0d301db4acb3ffdf3463cc7 upstream.

The TTL field indicates the level of page table walk holding the *leaf*
entry for the address being invalidated. But currently, the TTL field
may be set to an incorrent value in the following stack:

pte_free_tlb
    __pte_free_tlb
        tlb_remove_table
            tlb_table_invalidate
                tlb_flush_mmu_tlbonly
                    tlb_flush

In this case, we just want to flush a PTE page, but the tlb->cleared_pmds
is set and we get tlb_level = 2 in the tlb_get_level() function. This may
cause some unexpected problems.

This patch set the TTL field to 0 if tlb->freed_tables is set. The
tlb->freed_tables indicates page table pages are freed, not the leaf
entry.

Cc: <stable@vger.kernel.org> # 5.9.x
Fixes: c4ab2cbc1d87 ("arm64: tlb: Set the TTL field in flush_tlb_range")
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Reported-by: ZhuRui <zhurui3@huawei.com>
Signed-off-by: Zhenyu Ye <yezhenyu2@huawei.com>
Link: https://lore.kernel.org/r/b80ead47-1f88-3a00-18e1-cacc22f54cc4@huawei.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm64/include/asm/tlb.h |    4 ++++
 1 file changed, 4 insertions(+)

--- a/arch/arm64/include/asm/tlb.h
+++ b/arch/arm64/include/asm/tlb.h
@@ -28,6 +28,10 @@ static void tlb_flush(struct mmu_gather
  */
 static inline int tlb_get_level(struct mmu_gather *tlb)
 {
+	/* The TTL field is only valid for the leaf entry. */
+	if (tlb->freed_tables)
+		return 0;
+
 	if (tlb->cleared_ptes && !(tlb->cleared_pmds ||
 				   tlb->cleared_puds ||
 				   tlb->cleared_p4ds))


