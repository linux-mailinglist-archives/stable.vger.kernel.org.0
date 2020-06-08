Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A643F1F3053
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 02:58:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726918AbgFIA6A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 20:58:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:54314 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728254AbgFHXIr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jun 2020 19:08:47 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E31642085B;
        Mon,  8 Jun 2020 23:08:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591657727;
        bh=1nqs4DqbgeZgMHpBxJQRypqiP9gwPyGbe6RIQZ4mk84=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0BRn2WIjjQ03Ek9hdYmcEyS6PMaWSSzEayPDWM9pRaoeLG1ss2o4h9DQiXH+1f4fh
         8Jz7gMlr6EDJD/dzVgyePWHA0qQ9nplP9cB1bjd9LVmLiigFgV6etgbqwbDURjgkmr
         IxcPAAvo2SwBl8vfnNiPSKJ+NpA4weWL77JxbLFY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ard Biesheuvel <ardb@kernel.org>, Sasha Levin <sashal@kernel.org>,
        linux-efi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.7 119/274] efi/libstub/random: Align allocate size to EFI_ALLOC_ALIGN
Date:   Mon,  8 Jun 2020 19:03:32 -0400
Message-Id: <20200608230607.3361041-119-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608230607.3361041-1-sashal@kernel.org>
References: <20200608230607.3361041-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ard Biesheuvel <ardb@kernel.org>

[ Upstream commit e1df73e2d18b3b7d66f2ec38d81d9566b3a7fb21 ]

The EFI stub uses a per-architecture #define for the minimum base
and size alignment of page allocations, which is set to 4 KB for
all architecures except arm64, which uses 64 KB, to ensure that
allocations can always be (un)mapped efficiently, regardless of
the page size used by the kernel proper, which could be a kexec'ee

The API wrappers around page based allocations assume that this
alignment is always taken into account, and so efi_free() will
also round up its size argument to EFI_ALLOC_ALIGN.

Currently, efi_random_alloc() does not honour this alignment for
the allocated size, and so freeing such an allocation may result
in unrelated memory to be freed, potentially leading to issues
after boot. So let's round up size in efi_random_alloc() as well.

Fixes: 2ddbfc81eac84a29 ("efi: stub: add implementation of efi_random_alloc()")
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/efi/libstub/randomalloc.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/firmware/efi/libstub/randomalloc.c b/drivers/firmware/efi/libstub/randomalloc.c
index 4578f59e160c..6200dfa650f5 100644
--- a/drivers/firmware/efi/libstub/randomalloc.c
+++ b/drivers/firmware/efi/libstub/randomalloc.c
@@ -74,6 +74,8 @@ efi_status_t efi_random_alloc(unsigned long size,
 	if (align < EFI_ALLOC_ALIGN)
 		align = EFI_ALLOC_ALIGN;
 
+	size = round_up(size, EFI_ALLOC_ALIGN);
+
 	/* count the suitable slots in each memory map entry */
 	for (map_offset = 0; map_offset < map_size; map_offset += desc_size) {
 		efi_memory_desc_t *md = (void *)memory_map + map_offset;
@@ -109,7 +111,7 @@ efi_status_t efi_random_alloc(unsigned long size,
 		}
 
 		target = round_up(md->phys_addr, align) + target_slot * align;
-		pages = round_up(size, EFI_PAGE_SIZE) / EFI_PAGE_SIZE;
+		pages = size / EFI_PAGE_SIZE;
 
 		status = efi_bs_call(allocate_pages, EFI_ALLOCATE_ADDRESS,
 				     EFI_LOADER_DATA, pages, &target);
-- 
2.25.1

