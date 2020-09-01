Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FDF02598EA
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 18:36:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730307AbgIAP37 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 11:29:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:59900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730567AbgIAP35 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:29:57 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8AB752078B;
        Tue,  1 Sep 2020 15:29:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598974197;
        bh=kPvXC1q2GmkliQciWKKb/LdEJYKqO3ID4Wsv5KP+0Z4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FJOAwYpX/aj79Ax9quO/wk+jbX60ITBMR5GJTGf8/Zmyebw7RfCeoSRvNcG/M156y
         9wOvwZJ5X1OYssld/lPfJaEMTmuf+OwHaG+oger94G3jYgqCRqVdei4itoTOwkwXzs
         FSUp5D67D6gk+bChaFB7sPA4/Z8sfcFKqar1qWZY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yunfeng Ye <yeyunfeng@huawei.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mike Rapoport <rppt@linux.ibm.com>, Yue Hu <huyue2@yulong.com>,
        Peng Fan <peng.fan@nxp.com>,
        Andrey Ryabinin <aryabinin@virtuozzo.com>,
        Ryohei Suzuki <ryh.szk.cmnty@gmail.com>,
        Andrey Konovalov <andreyknvl@google.com>,
        Doug Berger <opendmb@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 082/214] mm/cma.c: switch to bitmap_zalloc() for cma bitmap allocation
Date:   Tue,  1 Sep 2020 17:09:22 +0200
Message-Id: <20200901150956.926570179@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901150952.963606936@linuxfoundation.org>
References: <20200901150952.963606936@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yunfeng Ye <yeyunfeng@huawei.com>

[ Upstream commit 2184f9928ab52f26c2ae5e9ba37faf29c78f50b8 ]

kzalloc() is used for cma bitmap allocation in cma_activate_area(),
switch to bitmap_zalloc() for clarity.

Link: http://lkml.kernel.org/r/895d4627-f115-c77a-d454-c0a196116426@huawei.com
Signed-off-by: Yunfeng Ye <yeyunfeng@huawei.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Cc: Yue Hu <huyue2@yulong.com>
Cc: Peng Fan <peng.fan@nxp.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Ryohei Suzuki <ryh.szk.cmnty@gmail.com>
Cc: Andrey Konovalov <andreyknvl@google.com>
Cc: Doug Berger <opendmb@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/cma.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/mm/cma.c b/mm/cma.c
index 7fe0b8356775f..be55d1988c675 100644
--- a/mm/cma.c
+++ b/mm/cma.c
@@ -95,13 +95,11 @@ static void cma_clear_bitmap(struct cma *cma, unsigned long pfn,
 
 static int __init cma_activate_area(struct cma *cma)
 {
-	int bitmap_size = BITS_TO_LONGS(cma_bitmap_maxno(cma)) * sizeof(long);
 	unsigned long base_pfn = cma->base_pfn, pfn = base_pfn;
 	unsigned i = cma->count >> pageblock_order;
 	struct zone *zone;
 
-	cma->bitmap = kzalloc(bitmap_size, GFP_KERNEL);
-
+	cma->bitmap = bitmap_zalloc(cma_bitmap_maxno(cma), GFP_KERNEL);
 	if (!cma->bitmap) {
 		cma->count = 0;
 		return -ENOMEM;
@@ -139,7 +137,7 @@ static int __init cma_activate_area(struct cma *cma)
 
 not_in_zone:
 	pr_err("CMA area %s could not be activated\n", cma->name);
-	kfree(cma->bitmap);
+	bitmap_free(cma->bitmap);
 	cma->count = 0;
 	return -EINVAL;
 }
-- 
2.25.1



