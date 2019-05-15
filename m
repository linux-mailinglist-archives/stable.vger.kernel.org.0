Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C8BB1F003
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 13:41:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732236AbfEOL3R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:29:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:40466 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726542AbfEOL3P (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:29:15 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4F2F6206BF;
        Wed, 15 May 2019 11:29:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557919754;
        bh=3CBpc1fLJnHIj2l4Fa+AUaaNaeYCNUuCUI7rrM7kUBs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mHtbIE/XMTIL8vHX3oH3bos/k21d3Nn758Rx1qQK0UAoap0Cx5y3NBLlSKLi2OlgZ
         QCCjUgOYxz/zHrXOJZLokZyOmZp4nbJ1oLlxROgrs4aHwQqmOKTRcZV9D4Ts5/lBuC
         ZJrRXoX1hlEh0T8ps6ansGHnSh3Qfpb1RogACo/g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Liang ZhiCheng <liangzhicheng@baidu.com>,
        Li RongQing <lirongqing@baidu.com>,
        Ira Weiny <ira.weiny@intel.com>,
        Jeff Moyer <jmoyer@redhat.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.0 027/137] libnvdimm/pmem: fix a possible OOB access when read and write pmem
Date:   Wed, 15 May 2019 12:55:08 +0200
Message-Id: <20190515090655.255284245@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090651.633556783@linuxfoundation.org>
References: <20190515090651.633556783@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
index bc2f700feef8a..0279eb1da3ef5 100644
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



