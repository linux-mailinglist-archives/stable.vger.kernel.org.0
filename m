Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CFFC8111DB2
	for <lists+stable@lfdr.de>; Tue,  3 Dec 2019 23:57:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730401AbfLCW4I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 17:56:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:50860 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730234AbfLCW4I (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 17:56:08 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CD48820865;
        Tue,  3 Dec 2019 22:56:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575413767;
        bh=WR6T0mnOrqv6UHDVnUtOymOZWoXeUtFqekFtmD/p8Bo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ypF/tfUwhl2Gd5OiEBaboING0ts6FFutU9F7cXc48VM9Ah3ccb7hmpwHg+Ommoh6l
         opPyYXaooDHc4ujVy73CDHGIQKBLGPeEigLf0ZCrh3NVLFk1nJ05TOHDBM3yxZX0+m
         5QS8HXq2TMpBh8tYdeqcokx9mVzTHcqu2iBfO0ek=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, James Morse <james.morse@arm.com>,
        Borislav Petkov <bp@suse.de>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 252/321] ACPI / APEI: Switch estatus pool to use vmalloc memory
Date:   Tue,  3 Dec 2019 23:35:18 +0100
Message-Id: <20191203223440.247127016@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191203223427.103571230@linuxfoundation.org>
References: <20191203223427.103571230@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Morse <james.morse@arm.com>

[ Upstream commit 0ac234be1a9497498e57d958f4251f5257b116b4 ]

The ghes code is careful to parse and round firmware's advertised
memory requirements for CPER records, up to a maximum of 64K.
However when ghes_estatus_pool_expand() does its work, it splits
the requested size into PAGE_SIZE granules.

This means if firmware generates 5K of CPER records, and correctly
describes this in the table, __process_error() will silently fail as it
is unable to allocate more than PAGE_SIZE.

Switch the estatus pool to vmalloc() memory. On x86 vmalloc() memory
may fault and be fixed up by vmalloc_fault(). To prevent this call
vmalloc_sync_all() before an NMI handler could discover the memory.

Signed-off-by: James Morse <james.morse@arm.com>
Reviewed-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/apei/ghes.c | 30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
index 0c46b79e31b1e..73177b8a07bd1 100644
--- a/drivers/acpi/apei/ghes.c
+++ b/drivers/acpi/apei/ghes.c
@@ -170,40 +170,40 @@ static int ghes_estatus_pool_init(void)
 	return 0;
 }
 
-static void ghes_estatus_pool_free_chunk_page(struct gen_pool *pool,
+static void ghes_estatus_pool_free_chunk(struct gen_pool *pool,
 					      struct gen_pool_chunk *chunk,
 					      void *data)
 {
-	free_page(chunk->start_addr);
+	vfree((void *)chunk->start_addr);
 }
 
 static void ghes_estatus_pool_exit(void)
 {
 	gen_pool_for_each_chunk(ghes_estatus_pool,
-				ghes_estatus_pool_free_chunk_page, NULL);
+				ghes_estatus_pool_free_chunk, NULL);
 	gen_pool_destroy(ghes_estatus_pool);
 }
 
 static int ghes_estatus_pool_expand(unsigned long len)
 {
-	unsigned long i, pages, size, addr;
-	int ret;
+	unsigned long size, addr;
 
 	ghes_estatus_pool_size_request += PAGE_ALIGN(len);
 	size = gen_pool_size(ghes_estatus_pool);
 	if (size >= ghes_estatus_pool_size_request)
 		return 0;
-	pages = (ghes_estatus_pool_size_request - size) / PAGE_SIZE;
-	for (i = 0; i < pages; i++) {
-		addr = __get_free_page(GFP_KERNEL);
-		if (!addr)
-			return -ENOMEM;
-		ret = gen_pool_add(ghes_estatus_pool, addr, PAGE_SIZE, -1);
-		if (ret)
-			return ret;
-	}
 
-	return 0;
+	addr = (unsigned long)vmalloc(PAGE_ALIGN(len));
+	if (!addr)
+		return -ENOMEM;
+
+	/*
+	 * New allocation must be visible in all pgd before it can be found by
+	 * an NMI allocating from the pool.
+	 */
+	vmalloc_sync_all();
+
+	return gen_pool_add(ghes_estatus_pool, addr, PAGE_ALIGN(len), -1);
 }
 
 static int map_gen_v2(struct ghes *ghes)
-- 
2.20.1



