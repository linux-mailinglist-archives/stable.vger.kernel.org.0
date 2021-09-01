Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 008473FDABA
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 15:16:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343935AbhIAMeq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 08:34:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:33492 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244820AbhIAMdU (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Sep 2021 08:33:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 96C7C610D2;
        Wed,  1 Sep 2021 12:31:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630499512;
        bh=xGeeZpq2HAygFPk++Gk7ModHNahau+QWrL/yPLyjIIk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wGFdPhjHTP49kS3laur1ITZ2OYUJT/i5Fwt6mxUE9vBnX/0iAcdHZYeiCxqaghss0
         ev00XpgS9/T9Zmzew0I1FvbVsFev1xRaC1RenC8XM3wv8KTxzDSAqtqX9bxXK8W7yy
         aIUvNpb/96aNg7u70itSAlU4UcIyfnNV7+RFk2EI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        Kan Liang <kan.liang@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 27/48] perf/x86/intel/uncore: Fix integer overflow on 23 bit left shift of a u32
Date:   Wed,  1 Sep 2021 14:28:17 +0200
Message-Id: <20210901122254.310509992@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210901122253.388326997@linuxfoundation.org>
References: <20210901122253.388326997@linuxfoundation.org>
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
index 40751af62dd3..9096a1693942 100644
--- a/arch/x86/events/intel/uncore_snbep.c
+++ b/arch/x86/events/intel/uncore_snbep.c
@@ -4382,7 +4382,7 @@ static void snr_uncore_mmio_init_box(struct intel_uncore_box *box)
 		return;
 
 	pci_read_config_dword(pdev, SNR_IMC_MMIO_BASE_OFFSET, &pci_dword);
-	addr = (pci_dword & SNR_IMC_MMIO_BASE_MASK) << 23;
+	addr = ((resource_size_t)pci_dword & SNR_IMC_MMIO_BASE_MASK) << 23;
 
 	pci_read_config_dword(pdev, SNR_IMC_MMIO_MEM0_OFFSET, &pci_dword);
 	addr |= (pci_dword & SNR_IMC_MMIO_MEM0_MASK) << 12;
-- 
2.30.2



