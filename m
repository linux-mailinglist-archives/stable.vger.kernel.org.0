Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E06E6CA67E
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 18:55:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392121AbfJCQoU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:44:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:56310 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404319AbfJCQoT (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:44:19 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CE9C0222CF;
        Thu,  3 Oct 2019 16:44:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570121058;
        bh=/1Doc4+p/q9z3gLW6wxPhUbWI8u6hlwl8Sqo2S/AsAA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=quFdPjy4bQACQrQKandOoVKAT6bwrz0TwadTLFDbkq0aAogzUSqZQbPaSpzBrnSM0
         Y2M6Oo9y8DDA6byNNJvS95yciQe9OLrgyWKO+kt26oTvRbSLgMea4RkHBF+KfVwUdr
         DKMGBTejNR8fhpUibXdyXDE4wq7GpJwtckBztuC8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Liguang Zhang <zhangliguang@linux.alibaba.com>,
        Borislav Petkov <bp@suse.de>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 137/344] ACPI / APEI: Release resources if gen_pool_add() fails
Date:   Thu,  3 Oct 2019 17:51:42 +0200
Message-Id: <20191003154553.746892160@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154540.062170222@linuxfoundation.org>
References: <20191003154540.062170222@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Liguang Zhang <zhangliguang@linux.alibaba.com>

[ Upstream commit 6abc7622271dc520f241462e2474c71723638851 ]

Destroy ghes_estatus_pool and release memory allocated via vmalloc() on
errors in ghes_estatus_pool_init() in order to avoid memory leaks.

 [ bp: do the labels properly and with descriptive names and massage. ]

Signed-off-by: Liguang Zhang <zhangliguang@linux.alibaba.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Link: https://lkml.kernel.org/r/1563173924-47479-1-git-send-email-zhangliguang@linux.alibaba.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/apei/ghes.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
index a66e00fe31fec..66205ec545553 100644
--- a/drivers/acpi/apei/ghes.c
+++ b/drivers/acpi/apei/ghes.c
@@ -153,6 +153,7 @@ static void ghes_unmap(void __iomem *vaddr, enum fixed_addresses fixmap_idx)
 int ghes_estatus_pool_init(int num_ghes)
 {
 	unsigned long addr, len;
+	int rc;
 
 	ghes_estatus_pool = gen_pool_create(GHES_ESTATUS_POOL_MIN_ALLOC_ORDER, -1);
 	if (!ghes_estatus_pool)
@@ -164,7 +165,7 @@ int ghes_estatus_pool_init(int num_ghes)
 	ghes_estatus_pool_size_request = PAGE_ALIGN(len);
 	addr = (unsigned long)vmalloc(PAGE_ALIGN(len));
 	if (!addr)
-		return -ENOMEM;
+		goto err_pool_alloc;
 
 	/*
 	 * New allocation must be visible in all pgd before it can be found by
@@ -172,7 +173,19 @@ int ghes_estatus_pool_init(int num_ghes)
 	 */
 	vmalloc_sync_all();
 
-	return gen_pool_add(ghes_estatus_pool, addr, PAGE_ALIGN(len), -1);
+	rc = gen_pool_add(ghes_estatus_pool, addr, PAGE_ALIGN(len), -1);
+	if (rc)
+		goto err_pool_add;
+
+	return 0;
+
+err_pool_add:
+	vfree((void *)addr);
+
+err_pool_alloc:
+	gen_pool_destroy(ghes_estatus_pool);
+
+	return -ENOMEM;
 }
 
 static int map_gen_v2(struct ghes *ghes)
-- 
2.20.1



