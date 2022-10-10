Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6D215F999B
	for <lists+stable@lfdr.de>; Mon, 10 Oct 2022 09:14:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231936AbiJJHON (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Oct 2022 03:14:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231935AbiJJHNI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Oct 2022 03:13:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31E6D1DF26;
        Mon, 10 Oct 2022 00:08:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D7C9A60EA4;
        Mon, 10 Oct 2022 07:08:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED4E4C433D6;
        Mon, 10 Oct 2022 07:08:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665385707;
        bh=rXyLc+XCddYaDMFkJudemWyHhYs0ddAqHy+Misg8YLY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G6XSkCPPXfsGeG9fuBf+qagqRjIWiQoo7ncAiNsQneDgEyzYKjkqD1Sb8rQtyQzZ3
         h1LHsRZxeth4+YsSTntmvhNiYvAysPwXGsslkZTLgRKU5qouyL+t1SYvWq5h4+pb4f
         OjmHkzEM0x22yKuGEDLMTksvMd+FXK1Q05aY/ivQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaohe Lin <linmiaohe@huawei.com>,
        Matthew Wilcox <willy@infradead.org>,
        Muchun Song <songmuchun@bytedance.com>,
        Yang Shi <shy828301@gmail.com>,
        Zach OKeefe <zokeefe@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 31/37] mm/huge_memory: minor cleanup for split_huge_pages_all
Date:   Mon, 10 Oct 2022 09:05:50 +0200
Message-Id: <20221010070332.099770932@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221010070331.211113813@linuxfoundation.org>
References: <20221010070331.211113813@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miaohe Lin <linmiaohe@huawei.com>

[ Upstream commit a17206dac7b262e7abed5a05e34a6bd6bd0a9b06 ]

There is nothing to do if a zone doesn't have any pages managed by the
buddy allocator. So we should check managed_zone instead. Also if a thp
is found, there's no need to traverse the subpages again.

Link: https://lkml.kernel.org/r/20220704132201.14611-13-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Zach O'Keefe <zokeefe@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: 2b7aa91ba0e8 ("mm/huge_memory: use pfn_to_online_page() in split_huge_pages_all()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/huge_memory.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 8cc150a88361..34d2979489fd 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2879,9 +2879,12 @@ static void split_huge_pages_all(void)
 	unsigned long total = 0, split = 0;
 
 	pr_debug("Split all THPs\n");
-	for_each_populated_zone(zone) {
+	for_each_zone(zone) {
+		if (!managed_zone(zone))
+			continue;
 		max_zone_pfn = zone_end_pfn(zone);
 		for (pfn = zone->zone_start_pfn; pfn < max_zone_pfn; pfn++) {
+			int nr_pages;
 			if (!pfn_valid(pfn))
 				continue;
 
@@ -2897,8 +2900,10 @@ static void split_huge_pages_all(void)
 
 			total++;
 			lock_page(page);
+			nr_pages = thp_nr_pages(page);
 			if (!split_huge_page(page))
 				split++;
+			pfn += nr_pages - 1;
 			unlock_page(page);
 next:
 			put_page(page);
-- 
2.35.1



