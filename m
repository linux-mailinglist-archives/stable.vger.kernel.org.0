Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F402272F30
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 18:55:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729395AbgIUQzR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 12:55:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:51876 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729503AbgIUQps (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 12:45:48 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 624DF20874;
        Mon, 21 Sep 2020 16:45:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600706747;
        bh=4BJVieK2MQpsQrM3gMlFxZYQf6Qf6grauSn0niykwFw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cUmneEljdTisIMjpLOD1znhj/Q00B/+FXmlySKXMO2uoh9gWbSGPPbzm7Y7RLNW0B
         46WxiKMLMc3MRehtQV14+5tv1DWPg5NfZ4PG4k2bSUExfrVumxg+IxZYzat4Hr4YHL
         +sB1iCWgtORHrDEUSDzFm7McD+NRNVOaWLqOZFK4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Syven Wang <syven.wang@sifive.com>,
        Greentime Hu <greentime.hu@sifive.com>,
        Anup Patel <anup@brainfault.org>,
        Palmer Dabbelt <palmerdabbelt@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 078/118] riscv: Add sfence.vma after early page table changes
Date:   Mon, 21 Sep 2020 18:28:10 +0200
Message-Id: <20200921162039.961172891@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200921162036.324813383@linuxfoundation.org>
References: <20200921162036.324813383@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greentime Hu <greentime.hu@sifive.com>

[ Upstream commit 21190b74bcf3a36ebab9a715088c29f59877e1f3 ]

This invalidates local TLB after modifying the page tables during early init as
it's too early to handle suprious faults as we otherwise do.

Fixes: f2c17aabc917 ("RISC-V: Implement compile-time fixed mappings")
Reported-by: Syven Wang <syven.wang@sifive.com>
Signed-off-by: Syven Wang <syven.wang@sifive.com>
Signed-off-by: Greentime Hu <greentime.hu@sifive.com>
Reviewed-by: Anup Patel <anup@brainfault.org>
[Palmer: Cleaned up the commit text]
Signed-off-by: Palmer Dabbelt <palmerdabbelt@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/mm/init.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/arch/riscv/mm/init.c b/arch/riscv/mm/init.c
index 79e9d55bdf1ac..e229d95f470b8 100644
--- a/arch/riscv/mm/init.c
+++ b/arch/riscv/mm/init.c
@@ -226,12 +226,11 @@ void __set_fixmap(enum fixed_addresses idx, phys_addr_t phys, pgprot_t prot)
 
 	ptep = &fixmap_pte[pte_index(addr)];
 
-	if (pgprot_val(prot)) {
+	if (pgprot_val(prot))
 		set_pte(ptep, pfn_pte(phys >> PAGE_SHIFT, prot));
-	} else {
+	else
 		pte_clear(&init_mm, addr, ptep);
-		local_flush_tlb_page(addr);
-	}
+	local_flush_tlb_page(addr);
 }
 
 static pte_t *__init get_pte_virt(phys_addr_t pa)
-- 
2.25.1



