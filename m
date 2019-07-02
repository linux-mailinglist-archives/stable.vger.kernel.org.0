Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 393265CBDE
	for <lists+stable@lfdr.de>; Tue,  2 Jul 2019 10:16:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727401AbfGBIDW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Jul 2019 04:03:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:48338 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727399AbfGBIDW (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Jul 2019 04:03:22 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B823C21841;
        Tue,  2 Jul 2019 08:03:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562054601;
        bh=FWX6yoUmqpeNc3UXbOoiOv73WGfgMq7r2DRCslZmUHM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=byqQbkwwIW/3aHxCXxjoOwLbGJXfJLjIz3/cvVLLYBsCHsAN86/XsDldBiPQ4KEjG
         8TYZ9AHrJZlsUPb5gM+ffGy3g0G9ot08TZ7O9HZFk6GeuKQByro8y4ipxS3t3tZAdY
         Q73i9R2H2zrWMbEflzTgt/Kv8VDey8Ej51ZqJitQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jonathan Richardson <jonathan.richardson@broadcom.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 5.1 25/55] efi/memreserve: deal with memreserve entries in unmapped memory
Date:   Tue,  2 Jul 2019 10:01:33 +0200
Message-Id: <20190702080125.373828717@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190702080124.103022729@linuxfoundation.org>
References: <20190702080124.103022729@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ard Biesheuvel <ard.biesheuvel@linaro.org>

commit 18df7577adae6c6c778bf774b3aebcacbc1fb439 upstream.

Ensure that the EFI memreserve entries can be accessed, even if they
are located in memory that the kernel (e.g., a crashkernel) omits from
the linear map.

Fixes: 80424b02d42b ("efi: Reduce the amount of memblock reservations ...")
Cc: <stable@vger.kernel.org> # 5.0+
Reported-by: Jonathan Richardson <jonathan.richardson@broadcom.com>
Reviewed-by: Jonathan Richardson <jonathan.richardson@broadcom.com>
Tested-by: Jonathan Richardson <jonathan.richardson@broadcom.com>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/firmware/efi/efi.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -1007,14 +1007,16 @@ int __ref efi_mem_reserve_persistent(phy
 
 	/* first try to find a slot in an existing linked list entry */
 	for (prsv = efi_memreserve_root->next; prsv; prsv = rsv->next) {
-		rsv = __va(prsv);
+		rsv = memremap(prsv, sizeof(*rsv), MEMREMAP_WB);
 		index = atomic_fetch_add_unless(&rsv->count, 1, rsv->size);
 		if (index < rsv->size) {
 			rsv->entry[index].base = addr;
 			rsv->entry[index].size = size;
 
+			memunmap(rsv);
 			return 0;
 		}
+		memunmap(rsv);
 	}
 
 	/* no slot found - allocate a new linked list entry */
@@ -1022,7 +1024,13 @@ int __ref efi_mem_reserve_persistent(phy
 	if (!rsv)
 		return -ENOMEM;
 
-	rsv->size = EFI_MEMRESERVE_COUNT(PAGE_SIZE);
+	/*
+	 * The memremap() call above assumes that a linux_efi_memreserve entry
+	 * never crosses a page boundary, so let's ensure that this remains true
+	 * even when kexec'ing a 4k pages kernel from a >4k pages kernel, by
+	 * using SZ_4K explicitly in the size calculation below.
+	 */
+	rsv->size = EFI_MEMRESERVE_COUNT(SZ_4K);
 	atomic_set(&rsv->count, 1);
 	rsv->entry[0].base = addr;
 	rsv->entry[0].size = size;


