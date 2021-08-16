Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B25DB3ED670
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 15:22:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239272AbhHPNVV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 09:21:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:44618 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239213AbhHPNSs (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Aug 2021 09:18:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 10A16632A9;
        Mon, 16 Aug 2021 13:14:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1629119665;
        bh=9I19CVjzRFMAqjf5ap1zDjUFU8VQHXVP1hc56kXyw5A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=siFNa4YVnRYH7DuMJTCDhhAlTqxrMX1Yb0konNqwM8y3I4/lAc5nWxkWKHskAxI6g
         Mu+aPa1G9kVf3UAFCwGdmisSIUShKqd+R8vXbW2ZnVBqvjUB2Y0Z3FDsdqLNKuVWO1
         3CJzqrk/ZgFTMf6GFLqDxKskN9yMYLtXrEX2Yfx4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 114/151] arm64: efi: kaslr: Fix occasional random alloc (and boot) failure
Date:   Mon, 16 Aug 2021 15:02:24 +0200
Message-Id: <20210816125447.810959705@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210816125444.082226187@linuxfoundation.org>
References: <20210816125444.082226187@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Benjamin Herrenschmidt <benh@kernel.crashing.org>

[ Upstream commit 4152433c397697acc4b02c4a10d17d5859c2730d ]

The EFI stub random allocator used for kaslr on arm64 has a subtle
bug. In function get_entry_num_slots() which counts the number of
possible allocation "slots" for the image in a given chunk of free
EFI memory, "last_slot" can become negative if the chunk is smaller
than the requested allocation size.

The test "if (first_slot > last_slot)" doesn't catch it because
both first_slot and last_slot are unsigned.

I chose not to make them signed to avoid problems if this is ever
used on architectures where there are meaningful addresses with the
top bit set. Instead, fix it with an additional test against the
allocation size.

This can cause a boot failure in addition to a loss of randomisation
due to another bug in the arm64 stub fixed separately.

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Fixes: 2ddbfc81eac8 ("efi: stub: add implementation of efi_random_alloc()")
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/efi/libstub/randomalloc.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/firmware/efi/libstub/randomalloc.c b/drivers/firmware/efi/libstub/randomalloc.c
index a408df474d83..724155b9e10d 100644
--- a/drivers/firmware/efi/libstub/randomalloc.c
+++ b/drivers/firmware/efi/libstub/randomalloc.c
@@ -30,6 +30,8 @@ static unsigned long get_entry_num_slots(efi_memory_desc_t *md,
 
 	region_end = min(md->phys_addr + md->num_pages * EFI_PAGE_SIZE - 1,
 			 (u64)ULONG_MAX);
+	if (region_end < size)
+		return 0;
 
 	first_slot = round_up(md->phys_addr, align);
 	last_slot = round_down(region_end - size + 1, align);
-- 
2.30.2



