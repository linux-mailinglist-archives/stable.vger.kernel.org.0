Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FF9932170F
	for <lists+stable@lfdr.de>; Mon, 22 Feb 2021 13:42:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231373AbhBVMmL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Feb 2021 07:42:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:52816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231474AbhBVMjr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Feb 2021 07:39:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 22D2F64E83;
        Mon, 22 Feb 2021 12:38:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613997512;
        bh=+oYNYpsaeV4KKAxdzcy7SUYMvSfGV5fq4rHpoj7A70U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KGr5/wifT7ivK3nMW2crBZHEXPEK2b1JX7FOnq+/geqQZqoSTlt1Lo0C//bwmNaMW
         cwM6WJWoxeSgLX9GkbPhOW8NnN8YTypJc610L6OZaLGPFAKuvGR2UhKO9d7457qRkp
         5LAF54btxmHjlGprS+IPRHrIJw4/MMa+NC7Uykqs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jan Beulich <jbeulich@suse.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Juergen Gross <jgross@suse.com>
Subject: [PATCH 4.14 47/57] Xen/gntdev: correct dev_bus_addr handling in gntdev_map_grant_pages()
Date:   Mon, 22 Feb 2021 13:36:13 +0100
Message-Id: <20210222121034.010902487@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210222121027.174911182@linuxfoundation.org>
References: <20210222121027.174911182@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jan Beulich <jbeulich@suse.com>

commit dbe5283605b3bc12ca45def09cc721a0a5c853a2 upstream.

We may not skip setting the field in the unmap structure when
GNTMAP_device_map is in use - such an unmap would fail to release the
respective resources (a page ref in the hypervisor). Otoh the field
doesn't need setting at all when GNTMAP_device_map is not in use.

To record the value for unmapping, we also better don't use our local
p2m: In particular after a subsequent change it may not have got updated
for all the batch elements. Instead it can simply be taken from the
respective map's results.

We can additionally avoid playing this game altogether for the kernel
part of the mappings in (x86) PV mode.

This is part of XSA-361.

Signed-off-by: Jan Beulich <jbeulich@suse.com>
Cc: stable@vger.kernel.org
Reviewed-by: Stefano Stabellini <sstabellini@kernel.org>
Signed-off-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/xen/gntdev.c |   16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

--- a/drivers/xen/gntdev.c
+++ b/drivers/xen/gntdev.c
@@ -295,18 +295,25 @@ static int map_grant_pages(struct grant_
 		 * to the kernel linear addresses of the struct pages.
 		 * These ptes are completely different from the user ptes dealt
 		 * with find_grant_ptes.
+		 * Note that GNTMAP_device_map isn't needed here: The
+		 * dev_bus_addr output field gets consumed only from ->map_ops,
+		 * and by not requesting it when mapping we also avoid needing
+		 * to mirror dev_bus_addr into ->unmap_ops (and holding an extra
+		 * reference to the page in the hypervisor).
 		 */
+		unsigned int flags = (map->flags & ~GNTMAP_device_map) |
+				     GNTMAP_host_map;
+
 		for (i = 0; i < map->count; i++) {
 			unsigned long address = (unsigned long)
 				pfn_to_kaddr(page_to_pfn(map->pages[i]));
 			BUG_ON(PageHighMem(map->pages[i]));
 
-			gnttab_set_map_op(&map->kmap_ops[i], address,
-				map->flags | GNTMAP_host_map,
+			gnttab_set_map_op(&map->kmap_ops[i], address, flags,
 				map->grants[i].ref,
 				map->grants[i].domid);
 			gnttab_set_unmap_op(&map->kunmap_ops[i], address,
-				map->flags | GNTMAP_host_map, -1);
+				flags, -1);
 		}
 	}
 
@@ -322,6 +329,9 @@ static int map_grant_pages(struct grant_
 			continue;
 		}
 
+		if (map->flags & GNTMAP_device_map)
+			map->unmap_ops[i].dev_bus_addr = map->map_ops[i].dev_bus_addr;
+
 		map->unmap_ops[i].handle = map->map_ops[i].handle;
 		if (use_ptemod)
 			map->kunmap_ops[i].handle = map->kmap_ops[i].handle;


