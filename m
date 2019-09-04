Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 453EEA8B28
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 21:27:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733166AbfIDQCF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 12:02:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:37776 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733153AbfIDQCE (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Sep 2019 12:02:04 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2D2E82087E;
        Wed,  4 Sep 2019 16:02:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567612923;
        bh=ahnRj9CrAKKpZqt1LnrLdaVtCpkOtW2N/SPvWQjSWnM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K3QJQwdzXnbt6yLUmtGlcZP/iBQzd4bjKDXGKK4+J1gXi9sZJGkZ4E9Nwc5Q2eBQj
         oZc7Rz22vlNcSH2R2pg/rAcTEjLbBUf45iE6aCkq1xQCW2KOtDY8Rq7b4xINUSTrt2
         MKrbaqzR0LlX9wx+te8V0jo1ARW77fUkA1hH0zQo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     zhaoyang <huangzhaoyang@gmail.com>,
        Zhaoyang Huang <zhaoyang.huang@unisoc.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.14 26/36] ARM: 8901/1: add a criteria for pfn_valid of arm
Date:   Wed,  4 Sep 2019 12:01:12 -0400
Message-Id: <20190904160122.4179-26-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190904160122.4179-1-sashal@kernel.org>
References: <20190904160122.4179-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: zhaoyang <huangzhaoyang@gmail.com>

[ Upstream commit 5b3efa4f1479c91cb8361acef55f9c6662feba57 ]

pfn_valid can be wrong when parsing a invalid pfn whose phys address
exceeds BITS_PER_LONG as the MSB will be trimed when shifted.

The issue originally arise from bellowing call stack, which corresponding to
an access of the /proc/kpageflags from userspace with a invalid pfn parameter
and leads to kernel panic.

[46886.723249] c7 [<c031ff98>] (stable_page_flags) from [<c03203f8>]
[46886.723264] c7 [<c0320368>] (kpageflags_read) from [<c0312030>]
[46886.723280] c7 [<c0311fb0>] (proc_reg_read) from [<c02a6e6c>]
[46886.723290] c7 [<c02a6e24>] (__vfs_read) from [<c02a7018>]
[46886.723301] c7 [<c02a6f74>] (vfs_read) from [<c02a778c>]
[46886.723315] c7 [<c02a770c>] (SyS_pread64) from [<c0108620>]
(ret_fast_syscall+0x0/0x28)

Signed-off-by: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mm/init.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm/mm/init.c b/arch/arm/mm/init.c
index 4fa12fcf1f5d8..27a40101dd3a7 100644
--- a/arch/arm/mm/init.c
+++ b/arch/arm/mm/init.c
@@ -195,6 +195,11 @@ static void __init zone_sizes_init(unsigned long min, unsigned long max_low,
 #ifdef CONFIG_HAVE_ARCH_PFN_VALID
 int pfn_valid(unsigned long pfn)
 {
+	phys_addr_t addr = __pfn_to_phys(pfn);
+
+	if (__phys_to_pfn(addr) != pfn)
+		return 0;
+
 	return memblock_is_map_memory(__pfn_to_phys(pfn));
 }
 EXPORT_SYMBOL(pfn_valid);
-- 
2.20.1

