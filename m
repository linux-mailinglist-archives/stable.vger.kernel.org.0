Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A857B3ED66D
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 15:22:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236272AbhHPNVU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 09:21:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:44620 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239196AbhHPNSs (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Aug 2021 09:18:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2DED463302;
        Mon, 16 Aug 2021 13:14:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1629119670;
        bh=K+GvTiJFFCUfHJ/UXmU2G6BQFQYKos2caBfARtJP4o0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cFqRzHMifWcSN0q4gSx8s7O6+GpKiUQsHijj0q96sPwu9EfoBao3RaZtWRG53u4X5
         5FlXkwN+SvWhljFM8ugKJWek9GHJw2heEMVSAoG8lo8G4f35R+xoUKvsSbcIPKRig4
         RTJ5Ai6JO5rnd5EKpPqWioJWbDnCiS36zW+B72Yk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 116/151] efi/libstub: arm64: Force Image reallocation if BSS was not reserved
Date:   Mon, 16 Aug 2021 15:02:26 +0200
Message-Id: <20210816125447.882504708@linuxfoundation.org>
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

From: Ard Biesheuvel <ardb@kernel.org>

[ Upstream commit 5b94046efb4706b3429c9c8e7377bd8d1621d588 ]

Distro versions of GRUB replace the usual LoadImage/StartImage calls
used to load the kernel image with some local code that fails to honor
the allocation requirements described in the PE/COFF header, as it
does not account for the image's BSS section at all: it fails to
allocate space for it, and fails to zero initialize it.

Since the EFI stub itself is allocated in the .init segment, which is
in the middle of the image, its BSS section is not impacted by this,
and the main consequence of this omission is that the BSS section may
overlap with memory regions that are already used by the firmware.

So let's warn about this condition, and force image reallocation to
occur in this case, which works around the problem.

Fixes: 82046702e288 ("efi/libstub/arm64: Replace 'preferred' offset with alignment check")
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Tested-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/efi/libstub/arm64-stub.c | 49 ++++++++++++++++++++++-
 1 file changed, 48 insertions(+), 1 deletion(-)

diff --git a/drivers/firmware/efi/libstub/arm64-stub.c b/drivers/firmware/efi/libstub/arm64-stub.c
index 7bf0a7acae5e..3698c1ce2940 100644
--- a/drivers/firmware/efi/libstub/arm64-stub.c
+++ b/drivers/firmware/efi/libstub/arm64-stub.c
@@ -34,6 +34,51 @@ efi_status_t check_platform_features(void)
 	return EFI_SUCCESS;
 }
 
+/*
+ * Distro versions of GRUB may ignore the BSS allocation entirely (i.e., fail
+ * to provide space, and fail to zero it). Check for this condition by double
+ * checking that the first and the last byte of the image are covered by the
+ * same EFI memory map entry.
+ */
+static bool check_image_region(u64 base, u64 size)
+{
+	unsigned long map_size, desc_size, buff_size;
+	efi_memory_desc_t *memory_map;
+	struct efi_boot_memmap map;
+	efi_status_t status;
+	bool ret = false;
+	int map_offset;
+
+	map.map =	&memory_map;
+	map.map_size =	&map_size;
+	map.desc_size =	&desc_size;
+	map.desc_ver =	NULL;
+	map.key_ptr =	NULL;
+	map.buff_size =	&buff_size;
+
+	status = efi_get_memory_map(&map);
+	if (status != EFI_SUCCESS)
+		return false;
+
+	for (map_offset = 0; map_offset < map_size; map_offset += desc_size) {
+		efi_memory_desc_t *md = (void *)memory_map + map_offset;
+		u64 end = md->phys_addr + md->num_pages * EFI_PAGE_SIZE;
+
+		/*
+		 * Find the region that covers base, and return whether
+		 * it covers base+size bytes.
+		 */
+		if (base >= md->phys_addr && base < end) {
+			ret = (base + size) <= end;
+			break;
+		}
+	}
+
+	efi_bs_call(free_pool, memory_map);
+
+	return ret;
+}
+
 /*
  * Although relocatable kernels can fix up the misalignment with respect to
  * MIN_KIMG_ALIGN, the resulting virtual text addresses are subtly out of
@@ -92,7 +137,9 @@ efi_status_t handle_kernel_image(unsigned long *image_addr,
 	}
 
 	if (status != EFI_SUCCESS) {
-		if (IS_ALIGNED((u64)_text, min_kimg_align())) {
+		if (!check_image_region((u64)_text, kernel_memsize)) {
+			efi_err("FIRMWARE BUG: Image BSS overlaps adjacent EFI memory region\n");
+		} else if (IS_ALIGNED((u64)_text, min_kimg_align())) {
 			/*
 			 * Just execute from wherever we were loaded by the
 			 * UEFI PE/COFF loader if the alignment is suitable.
-- 
2.30.2



