Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 209B535457
	for <lists+stable@lfdr.de>; Wed,  5 Jun 2019 01:33:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726341AbfFDXcy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Jun 2019 19:32:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:60868 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726797AbfFDXWf (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 4 Jun 2019 19:22:35 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 08C66206C1;
        Tue,  4 Jun 2019 23:22:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559690554;
        bh=MFvQLbZFWMv1yK43YcT32RchITP8hoxwzhGmIDsXnMY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ha666xvMafF3LrazDxxikjQReUFIppjepsuE5wvQgLKmr9XDROwBwfpLuuPnGbAVk
         5bY6e5DDSSenfqylFDKRsV3O+TVFRfNt2bURPODycZY4V5uHKdIRhaQOqMHoB9OUTp
         H1pdDQYQRzVPxSFCiz11ACJJMItw+o4by8VH1INs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Will Deacon <will.deacon@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Hanjun Guo <guohanjun@huawei.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.1 11/60] drivers/perf: arm_spe: Don't error on high-order pages for aux buf
Date:   Tue,  4 Jun 2019 19:21:21 -0400
Message-Id: <20190604232212.6753-11-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190604232212.6753-1-sashal@kernel.org>
References: <20190604232212.6753-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Will Deacon <will.deacon@arm.com>

[ Upstream commit 14ae42a6f0b13130a97d94d23481128961de5d38 ]

Since commit 5768402fd9c6 ("perf/ring_buffer: Use high order allocations
for AUX buffers optimistically"), the perf core tends to back aux buffer
allocations with high-order pages with the order encoded in the
PagePrivate data. The Arm SPE driver explicitly rejects such pages,
causing the perf tool to fail with:

  | failed to mmap with 12 (Cannot allocate memory)

In actual fact, we can simply treat these pages just like any other
since the perf core takes care to populate the page array appropriately.
In theory we could try to map with PMDs where possible, but for now,
let's just get things working again.

Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Fixes: 5768402fd9c6 ("perf/ring_buffer: Use high order allocations for AUX buffers optimistically")
Reported-by: Hanjun Guo <guohanjun@huawei.com>
Tested-by: Hanjun Guo <guohanjun@huawei.com>
Tested-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/perf/arm_spe_pmu.c | 10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff --git a/drivers/perf/arm_spe_pmu.c b/drivers/perf/arm_spe_pmu.c
index 7cb766dafe85..e120f933412a 100644
--- a/drivers/perf/arm_spe_pmu.c
+++ b/drivers/perf/arm_spe_pmu.c
@@ -855,16 +855,8 @@ static void *arm_spe_pmu_setup_aux(struct perf_event *event, void **pages,
 	if (!pglist)
 		goto out_free_buf;
 
-	for (i = 0; i < nr_pages; ++i) {
-		struct page *page = virt_to_page(pages[i]);
-
-		if (PagePrivate(page)) {
-			pr_warn("unexpected high-order page for auxbuf!");
-			goto out_free_pglist;
-		}
-
+	for (i = 0; i < nr_pages; ++i)
 		pglist[i] = virt_to_page(pages[i]);
-	}
 
 	buf->base = vmap(pglist, nr_pages, VM_MAP, PAGE_KERNEL);
 	if (!buf->base)
-- 
2.20.1

