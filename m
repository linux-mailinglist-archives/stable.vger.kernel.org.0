Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40FA53FDC67
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 15:19:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244518AbhIAMup (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 08:50:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:49254 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344224AbhIAMrI (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Sep 2021 08:47:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 38A8F6112E;
        Wed,  1 Sep 2021 12:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630500011;
        bh=PR5+UzwjhjiHksRjiJxo2SybVQtKJ2lalyfiAKsmi+Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E8EFUZUuTYUG/MEiQDBt2dP0gbKpnBZVeMXe9H1X7vIyJhYUua83eE/LNqJ6XK2hP
         wt0cOfXnENC0wzonc1G5oICX+niCttzqsZeEGrNN8BXOm+QsQDHKRdlyhx3AfwNxZc
         GoiGtETTZbMo8wiotb8grJND+b75u84ybwC5F5LA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        Kan Liang <kan.liang@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 070/113] perf/x86/intel/uncore: Fix integer overflow on 23 bit left shift of a u32
Date:   Wed,  1 Sep 2021 14:28:25 +0200
Message-Id: <20210901122304.330892212@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210901122301.984263453@linuxfoundation.org>
References: <20210901122301.984263453@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

[ Upstream commit 0b3a8738b76fe2087f7bc2bd59f4c78504c79180 ]

The u32 variable pci_dword is being masked with 0x1fffffff and then left
shifted 23 places. The shift is a u32 operation,so a value of 0x200 or
more in pci_dword will overflow the u32 and only the bottow 32 bits
are assigned to addr. I don't believe this was the original intent.
Fix this by casting pci_dword to a resource_size_t to ensure no
overflow occurs.

Note that the mask and 12 bit left shift operation does not need this
because the mask SNR_IMC_MMIO_MEM0_MASK and shift is always a 32 bit
value.

Fixes: ee49532b38dd ("perf/x86/intel/uncore: Add IMC uncore support for Snow Ridge")
Addresses-Coverity: ("Unintentional integer overflow")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Reviewed-by: Kan Liang <kan.liang@linux.intel.com>
Link: https://lore.kernel.org/r/20210706114553.28249-1-colin.king@canonical.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/events/intel/uncore_snbep.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/events/intel/uncore_snbep.c b/arch/x86/events/intel/uncore_snbep.c
index 1f7bb4898a9d..a8f02c889ae8 100644
--- a/arch/x86/events/intel/uncore_snbep.c
+++ b/arch/x86/events/intel/uncore_snbep.c
@@ -4701,7 +4701,7 @@ static void __snr_uncore_mmio_init_box(struct intel_uncore_box *box,
 		return;
 
 	pci_read_config_dword(pdev, SNR_IMC_MMIO_BASE_OFFSET, &pci_dword);
-	addr = (pci_dword & SNR_IMC_MMIO_BASE_MASK) << 23;
+	addr = ((resource_size_t)pci_dword & SNR_IMC_MMIO_BASE_MASK) << 23;
 
 	pci_read_config_dword(pdev, mem_offset, &pci_dword);
 	addr |= (pci_dword & SNR_IMC_MMIO_MEM0_MASK) << 12;
-- 
2.30.2



