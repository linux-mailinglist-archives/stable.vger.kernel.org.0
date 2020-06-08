Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B97C1F2269
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 01:08:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728094AbgFHXIF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 19:08:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:53008 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728088AbgFHXIE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jun 2020 19:08:04 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6F5B62087E;
        Mon,  8 Jun 2020 23:08:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591657684;
        bh=mTiX6BVUQ3jkX0Jh2seMK/MdH4mnuw+Iqv/QKtJSdaw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q/RrEdZFoYdnbeV5uhaByT/rfltudEfsIryDIin6zJfhYKoVEcp9e0cZ2C328Bv4p
         f7t7L9ZvTNgw/3B4uViJp2MkUgX0LWdUUs4OG54cP9O7VsCHo9aD3tSijRsV1pxaxF
         wkUGMk6IpKpLHzogGluIDzELIjl+3k0RkRheaIhU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Christoph Hellwig <hch@lst.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Christophe Leroy <christophe.leroy@c-s.fr>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        David Airlie <airlied@linux.ie>, Gao Xiang <xiang@kernel.org>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Laura Abbott <labbott@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Minchan Kim <minchan@kernel.org>,
        Nitin Gupta <ngupta@vflare.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Wei Liu <wei.liu@kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Will Deacon <will@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>, devel@driverdev.osuosl.org,
        dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org
Subject: [PATCH AUTOSEL 5.7 087/274] staging: android: ion: use vmap instead of vm_map_ram
Date:   Mon,  8 Jun 2020 19:03:00 -0400
Message-Id: <20200608230607.3361041-87-sashal@kernel.org>
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

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 5bf9917452112694b2c774465ee4dbe441c84b77 ]

vm_map_ram can keep mappings around after the vm_unmap_ram.  Using that
with non-PAGE_KERNEL mappings can lead to all kinds of aliasing issues.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Christophe Leroy <christophe.leroy@c-s.fr>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: David Airlie <airlied@linux.ie>
Cc: Gao Xiang <xiang@kernel.org>
Cc: Haiyang Zhang <haiyangz@microsoft.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: Laura Abbott <labbott@redhat.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Michael Kelley <mikelley@microsoft.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Cc: Robin Murphy <robin.murphy@arm.com>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Stephen Hemminger <sthemmin@microsoft.com>
Cc: Sumit Semwal <sumit.semwal@linaro.org>
Cc: Wei Liu <wei.liu@kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Paul Mackerras <paulus@ozlabs.org>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Will Deacon <will@kernel.org>
Link: http://lkml.kernel.org/r/20200414131348.444715-4-hch@lst.de
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/android/ion/ion_heap.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/android/ion/ion_heap.c b/drivers/staging/android/ion/ion_heap.c
index 473b465724f1..0755b11348ed 100644
--- a/drivers/staging/android/ion/ion_heap.c
+++ b/drivers/staging/android/ion/ion_heap.c
@@ -99,12 +99,12 @@ int ion_heap_map_user(struct ion_heap *heap, struct ion_buffer *buffer,
 
 static int ion_heap_clear_pages(struct page **pages, int num, pgprot_t pgprot)
 {
-	void *addr = vm_map_ram(pages, num, -1, pgprot);
+	void *addr = vmap(pages, num, VM_MAP, pgprot);
 
 	if (!addr)
 		return -ENOMEM;
 	memset(addr, 0, PAGE_SIZE * num);
-	vm_unmap_ram(addr, num);
+	vunmap(addr);
 
 	return 0;
 }
-- 
2.25.1

