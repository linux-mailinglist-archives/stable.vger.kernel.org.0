Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0907C34CAC6
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:41:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234980AbhC2Ijv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:39:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:32900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234080AbhC2Iii (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:38:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2F50C61581;
        Mon, 29 Mar 2021 08:38:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617007117;
        bh=+Dguk+tlJHUA0wg2xs5ieUr1BlRyk8E9wgOK0mSAPqo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BwaudfTWJJgqqDlxPg8fXQRuQEH0e6KiPE4OKwf2ATsIhKHVRoAD0aMW73401EcVW
         xPpfNiY3M3td0mm27dtj8zl2iknVrgIeqIo2DFGr+58NQs2+0exffenGdFd4lmMPCc
         QgDHJdwHF1KlA5o67WAr/uCu+MATfYbFQ8CWLyqs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Tatashin <pasha.tatashin@soleen.com>,
        Tyler Hicks <tyhicks@linux.microsoft.com>,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 226/254] arm64: mm: correct the inside linear map range during hotplug check
Date:   Mon, 29 Mar 2021 09:59:02 +0200
Message-Id: <20210329075640.512816658@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075633.135869143@linuxfoundation.org>
References: <20210329075633.135869143@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Tatashin <pasha.tatashin@soleen.com>

[ Upstream commit ee7febce051945be28ad86d16a15886f878204de ]

Memory hotplug may fail on systems with CONFIG_RANDOMIZE_BASE because the
linear map range is not checked correctly.

The start physical address that linear map covers can be actually at the
end of the range because of randomization. Check that and if so reduce it
to 0.

This can be verified on QEMU with setting kaslr-seed to ~0ul:

memstart_offset_seed = 0xffff
START: __pa(_PAGE_OFFSET(vabits_actual)) = ffff9000c0000000
END:   __pa(PAGE_END - 1) =  1000bfffffff

Signed-off-by: Pavel Tatashin <pasha.tatashin@soleen.com>
Fixes: 58284a901b42 ("arm64/mm: Validate hotplug range before creating linear mapping")
Tested-by: Tyler Hicks <tyhicks@linux.microsoft.com>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Link: https://lore.kernel.org/r/20210216150351.129018-2-pasha.tatashin@soleen.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/mm/mmu.c | 21 +++++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index 92b3be127796..3ca02e917598 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -1446,6 +1446,22 @@ static void __remove_pgd_mapping(pgd_t *pgdir, unsigned long start, u64 size)
 struct range arch_get_mappable_range(void)
 {
 	struct range mhp_range;
+	u64 start_linear_pa = __pa(_PAGE_OFFSET(vabits_actual));
+	u64 end_linear_pa = __pa(PAGE_END - 1);
+
+	if (IS_ENABLED(CONFIG_RANDOMIZE_BASE)) {
+		/*
+		 * Check for a wrap, it is possible because of randomized linear
+		 * mapping the start physical address is actually bigger than
+		 * the end physical address. In this case set start to zero
+		 * because [0, end_linear_pa] range must still be able to cover
+		 * all addressable physical addresses.
+		 */
+		if (start_linear_pa > end_linear_pa)
+			start_linear_pa = 0;
+	}
+
+	WARN_ON(start_linear_pa > end_linear_pa);
 
 	/*
 	 * Linear mapping region is the range [PAGE_OFFSET..(PAGE_END - 1)]
@@ -1453,8 +1469,9 @@ struct range arch_get_mappable_range(void)
 	 * range which can be mapped inside this linear mapping range, must
 	 * also be derived from its end points.
 	 */
-	mhp_range.start = __pa(_PAGE_OFFSET(vabits_actual));
-	mhp_range.end =  __pa(PAGE_END - 1);
+	mhp_range.start = start_linear_pa;
+	mhp_range.end =  end_linear_pa;
+
 	return mhp_range;
 }
 
-- 
2.30.1



