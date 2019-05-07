Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 800E015C0B
	for <lists+stable@lfdr.de>; Tue,  7 May 2019 08:00:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727346AbfEGGAV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 May 2019 02:00:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:56346 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728058AbfEGFgT (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 May 2019 01:36:19 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CE2C120C01;
        Tue,  7 May 2019 05:36:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557207378;
        bh=hBXc9T7g7moBL7FY6MAsud/UaYKdYSvABg4/xdbFYrU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FqY9Die9YDgr1BSpEgLN2rrJisEtgB7ZKMSffg0q8vFJJrMAethJPzA2coR0OMl/F
         QEHps3lHx5Ql/s8tnSHa0mdzoHZRmHGykSkneEGhEcHUBjZA8lr0ap5b9Zw2MXWlhx
         zPnA2HIBZAOJ14DoRewc9CxEeHiEDChlj3csaBIY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Li RongQing <lirongqing@baidu.com>,
        Liang ZhiCheng <liangzhicheng@baidu.com>,
        Ira Weiny <ira.weiny@intel.com>,
        Jeff Moyer <jmoyer@redhat.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Sasha Levin <sashal@kernel.org>, linux-nvdimm@lists.01.org
Subject: [PATCH AUTOSEL 4.19 17/81] libnvdimm/pmem: fix a possible OOB access when read and write pmem
Date:   Tue,  7 May 2019 01:34:48 -0400
Message-Id: <20190507053554.30848-17-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190507053554.30848-1-sashal@kernel.org>
References: <20190507053554.30848-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Li RongQing <lirongqing@baidu.com>

[ Upstream commit 9dc6488e84b0f64df17672271664752488cd6a25 ]

If offset is not zero and length is bigger than PAGE_SIZE,
this will cause to out of boundary access to a page memory

Fixes: 98cc093cba1e ("block, THP: make block_device_operations.rw_page support THP")
Co-developed-by: Liang ZhiCheng <liangzhicheng@baidu.com>
Signed-off-by: Liang ZhiCheng <liangzhicheng@baidu.com>
Signed-off-by: Li RongQing <lirongqing@baidu.com>
Reviewed-by: Ira Weiny <ira.weiny@intel.com>
Reviewed-by: Jeff Moyer <jmoyer@redhat.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvdimm/pmem.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index 1d432c5ed275..cff027fc2676 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -113,13 +113,13 @@ static void write_pmem(void *pmem_addr, struct page *page,
 
 	while (len) {
 		mem = kmap_atomic(page);
-		chunk = min_t(unsigned int, len, PAGE_SIZE);
+		chunk = min_t(unsigned int, len, PAGE_SIZE - off);
 		memcpy_flushcache(pmem_addr, mem + off, chunk);
 		kunmap_atomic(mem);
 		len -= chunk;
 		off = 0;
 		page++;
-		pmem_addr += PAGE_SIZE;
+		pmem_addr += chunk;
 	}
 }
 
@@ -132,7 +132,7 @@ static blk_status_t read_pmem(struct page *page, unsigned int off,
 
 	while (len) {
 		mem = kmap_atomic(page);
-		chunk = min_t(unsigned int, len, PAGE_SIZE);
+		chunk = min_t(unsigned int, len, PAGE_SIZE - off);
 		rem = memcpy_mcsafe(mem + off, pmem_addr, chunk);
 		kunmap_atomic(mem);
 		if (rem)
@@ -140,7 +140,7 @@ static blk_status_t read_pmem(struct page *page, unsigned int off,
 		len -= chunk;
 		off = 0;
 		page++;
-		pmem_addr += PAGE_SIZE;
+		pmem_addr += chunk;
 	}
 	return BLK_STS_OK;
 }
-- 
2.20.1

