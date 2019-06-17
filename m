Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D35B749415
	for <lists+stable@lfdr.de>; Mon, 17 Jun 2019 23:35:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729163AbfFQVWi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jun 2019 17:22:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:47350 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729161AbfFQVWh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Jun 2019 17:22:37 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9517D20673;
        Mon, 17 Jun 2019 21:22:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560806557;
        bh=2e7A53annMYC4DBAnjO+iL8q4XmGX+sB8eyrmNVCA+g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SvWUnrxB3BZTn378tU93Dzv2Z/6li0daet0aiBmPZf3kfidIdd6Ghmncf9tVWVr51
         HXEvD513LaoV8Hng195e4kDNJt8KCPmhsgRoIZQYOa04DSDhfrLjGoImulN8D9atTL
         Z9M37ttBV4P7vk/6Do4Xq+ViLabOGgZ+18bOwsXU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Hanjun Guo <guohanjun@huawei.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 048/115] drivers/perf: arm_spe: Dont error on high-order pages for aux buf
Date:   Mon, 17 Jun 2019 23:09:08 +0200
Message-Id: <20190617210802.812561090@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190617210759.929316339@linuxfoundation.org>
References: <20190617210759.929316339@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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



