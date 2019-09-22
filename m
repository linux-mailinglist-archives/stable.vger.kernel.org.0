Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 75906BA5FE
	for <lists+stable@lfdr.de>; Sun, 22 Sep 2019 21:45:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390307AbfIVSq7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Sep 2019 14:46:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:43306 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390447AbfIVSq7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 22 Sep 2019 14:46:59 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8C474206C2;
        Sun, 22 Sep 2019 18:46:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569178018;
        bh=/1Doc4+p/q9z3gLW6wxPhUbWI8u6hlwl8Sqo2S/AsAA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kvq2TLNnwkj4Fu27nigvSEuBnsYImFMRq7/AFkHlvpAdkiS1JyffbzDW60x1Doh21
         HsRBl6wh/I+KfgjkaoXmtRLm5F4oxPWEoG13GGw4IJOpPAe8w432snnVxBEqH4d5I3
         nWuaPUm/CxbvbuIQqcgCN+OmAWIDTByQuZdLoNjI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Liguang Zhang <zhangliguang@linux.alibaba.com>,
        Borislav Petkov <bp@suse.de>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>, linux-acpi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.3 104/203] ACPI / APEI: Release resources if gen_pool_add() fails
Date:   Sun, 22 Sep 2019 14:42:10 -0400
Message-Id: <20190922184350.30563-104-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190922184350.30563-1-sashal@kernel.org>
References: <20190922184350.30563-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

