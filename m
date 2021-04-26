Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 663C336AD10
	for <lists+stable@lfdr.de>; Mon, 26 Apr 2021 09:31:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232348AbhDZHcP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Apr 2021 03:32:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:42880 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232381AbhDZHcN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Apr 2021 03:32:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ABFA2613C1;
        Mon, 26 Apr 2021 07:31:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1619422288;
        bh=Ew3eZz1A7AARzihvbY2139f+yYZ87nnlDO80F4sd2Sc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DmLgkPn39KXiXQ/hIlLxmMXJQEp67nYQzNiobj8gSFf2V48WrnTxnatx1KHqFOlfb
         su+32RLz76uVOHCe7ou2qRt0nj40TTza4H1NgLyH9+tLcxqUTfHsDARYjXdUdBDsQt
         xtlecTLB+3Ngh6KsGydNPRW94OqgkPSV2/uMLyVQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Nathan Chancellor <nathan@kernel.org>,
        Santosh Shilimkar <ssantosh@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 07/32] ARM: keystone: fix integer overflow warning
Date:   Mon, 26 Apr 2021 09:29:05 +0200
Message-Id: <20210426072816.843441846@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210426072816.574319312@linuxfoundation.org>
References: <20210426072816.574319312@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 844b85dda2f569943e1e018fdd63b6f7d1d6f08e ]

clang warns about an impossible condition when building with 32-bit
phys_addr_t:

arch/arm/mach-keystone/keystone.c:79:16: error: result of comparison of constant 51539607551 with expression of type 'phys_addr_t' (aka 'unsigned int') is always false [-Werror,-Wtautological-constant-out-of-range-compare]
            mem_end   > KEYSTONE_HIGH_PHYS_END) {
            ~~~~~~~   ^ ~~~~~~~~~~~~~~~~~~~~~~
arch/arm/mach-keystone/keystone.c:78:16: error: result of comparison of constant 34359738368 with expression of type 'phys_addr_t' (aka 'unsigned int') is always true [-Werror,-Wtautological-constant-out-of-range-compare]
        if (mem_start < KEYSTONE_HIGH_PHYS_START ||
            ~~~~~~~~~ ^ ~~~~~~~~~~~~~~~~~~~~~~~~

Change the temporary variable to a fixed-size u64 to avoid the warning.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Nathan Chancellor <nathan@kernel.org>
Acked-by: Santosh Shilimkar <ssantosh@kernel.org>
Link: https://lore.kernel.org/r/20210323131814.2751750-1-arnd@kernel.org'
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mach-keystone/keystone.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-keystone/keystone.c b/arch/arm/mach-keystone/keystone.c
index c279293f084c..0f1f5c4141d5 100644
--- a/arch/arm/mach-keystone/keystone.c
+++ b/arch/arm/mach-keystone/keystone.c
@@ -71,7 +71,7 @@ static phys_addr_t keystone_virt_to_idmap(unsigned long x)
 static long long __init keystone_pv_fixup(void)
 {
 	long long offset;
-	phys_addr_t mem_start, mem_end;
+	u64 mem_start, mem_end;
 
 	mem_start = memblock_start_of_DRAM();
 	mem_end = memblock_end_of_DRAM();
@@ -84,7 +84,7 @@ static long long __init keystone_pv_fixup(void)
 	if (mem_start < KEYSTONE_HIGH_PHYS_START ||
 	    mem_end   > KEYSTONE_HIGH_PHYS_END) {
 		pr_crit("Invalid address space for memory (%08llx-%08llx)\n",
-		        (u64)mem_start, (u64)mem_end);
+		        mem_start, mem_end);
 		return 0;
 	}
 
-- 
2.30.2



