Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD2533441C4
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 13:37:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231460AbhCVMft (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 08:35:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:57626 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231561AbhCVMe0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 08:34:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 07C93619B0;
        Mon, 22 Mar 2021 12:34:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616416466;
        bh=Vs9X3DWpoNzidoByjxNF39t5YA8bOyKNWwrGousiYhg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QMqAEIc9SEhjTjI2k4qsCUHTSplWmWCGCBYYwCSQEHFgxYUOhLCKCeQHettUQoHo4
         frTlgN7qFdi8bQm0Mh94s/YbxAdoe0eMz1UUjJT7RtII7cFXyS1h18zV8MNYuL176A
         4CFvWUIGCGTWXnMl6geX6evYjQ7tx/G9PSArACMs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lv Yunlong <lyl2019@mail.ustc.edu.cn>,
        Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 5.11 118/120] firmware/efi: Fix a use after bug in efi_mem_reserve_persistent
Date:   Mon, 22 Mar 2021 13:28:21 +0100
Message-Id: <20210322121933.603602456@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210322121929.669628946@linuxfoundation.org>
References: <20210322121929.669628946@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lv Yunlong <lyl2019@mail.ustc.edu.cn>

commit 9ceee7d0841a8f7d7644021ba7d4cc1fbc7966e3 upstream.

In the for loop in efi_mem_reserve_persistent(), prsv = rsv->next
use the unmapped rsv. Use the unmapped pages will cause segment
fault.

Fixes: 18df7577adae6 ("efi/memreserve: deal with memreserve entries in unmapped memory")
Signed-off-by: Lv Yunlong <lyl2019@mail.ustc.edu.cn>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/firmware/efi/efi.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -927,7 +927,7 @@ int __ref efi_mem_reserve_persistent(phy
 	}
 
 	/* first try to find a slot in an existing linked list entry */
-	for (prsv = efi_memreserve_root->next; prsv; prsv = rsv->next) {
+	for (prsv = efi_memreserve_root->next; prsv; ) {
 		rsv = memremap(prsv, sizeof(*rsv), MEMREMAP_WB);
 		index = atomic_fetch_add_unless(&rsv->count, 1, rsv->size);
 		if (index < rsv->size) {
@@ -937,6 +937,7 @@ int __ref efi_mem_reserve_persistent(phy
 			memunmap(rsv);
 			return efi_mem_reserve_iomem(addr, size);
 		}
+		prsv = rsv->next;
 		memunmap(rsv);
 	}
 


