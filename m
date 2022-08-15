Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB6EA594B67
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 02:23:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233247AbiHPARb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 20:17:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357655AbiHPAN7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 20:13:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A70D1782AE;
        Mon, 15 Aug 2022 13:30:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6A6A7611B1;
        Mon, 15 Aug 2022 20:30:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A126C433C1;
        Mon, 15 Aug 2022 20:30:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660595423;
        bh=bZ788B6z466vmlS6LVITTCvYlqYe/U/IhX4N2/r73Is=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EoroEjCmFOVGV5KfVxdfwd8dedhu8kGHYMjmIBcB3rNjCQDHO37n2Jdj6IRIvWkAM
         hbmfwogzabzDD1HBNa4J4DBdfsJi7+K92bZCrUNfVr6e105oYWbWcm/74S4V2JT8wQ
         Tv8jhaf22ppsSVJoXNCYukFvI7XqnB5Q2i5ukdM0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaohe Lin <linmiaohe@huawei.com>,
        Jerome Glisse <jglisse@redhat.com>,
        Alistair Popple <apopple@nvidia.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Ralph Campbell <rcampbell@nvidia.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0727/1157] lib/test_hmm: avoid accessing uninitialized pages
Date:   Mon, 15 Aug 2022 20:01:23 +0200
Message-Id: <20220815180508.560058174@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miaohe Lin <linmiaohe@huawei.com>

[ Upstream commit ed913b055a74b723976f8e885a3395162a0371e6 ]

If make_device_exclusive_range() fails or returns pages marked for
exclusive access less than required, remaining fields of pages will left
uninitialized.  So dmirror_atomic_map() will access those yet
uninitialized fields of pages.  To fix it, do dmirror_atomic_map() iff all
pages are marked for exclusive access (we will break if mapped is less
than required anyway) so we won't access those uninitialized fields of
pages.

Link: https://lkml.kernel.org/r/20220609130835.35110-1-linmiaohe@huawei.com
Fixes: b659baea7546 ("mm: selftests for exclusive device memory")
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Jerome Glisse <jglisse@redhat.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/test_hmm.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/lib/test_hmm.c b/lib/test_hmm.c
index cfe632047839..f2c3015c5c82 100644
--- a/lib/test_hmm.c
+++ b/lib/test_hmm.c
@@ -732,7 +732,7 @@ static int dmirror_exclusive(struct dmirror *dmirror,
 
 	mmap_read_lock(mm);
 	for (addr = start; addr < end; addr = next) {
-		unsigned long mapped;
+		unsigned long mapped = 0;
 		int i;
 
 		if (end < addr + (ARRAY_SIZE(pages) << PAGE_SHIFT))
@@ -741,7 +741,13 @@ static int dmirror_exclusive(struct dmirror *dmirror,
 			next = addr + (ARRAY_SIZE(pages) << PAGE_SHIFT);
 
 		ret = make_device_exclusive_range(mm, addr, next, pages, NULL);
-		mapped = dmirror_atomic_map(addr, next, pages, dmirror);
+		/*
+		 * Do dmirror_atomic_map() iff all pages are marked for
+		 * exclusive access to avoid accessing uninitialized
+		 * fields of pages.
+		 */
+		if (ret == (next - addr) >> PAGE_SHIFT)
+			mapped = dmirror_atomic_map(addr, next, pages, dmirror);
 		for (i = 0; i < ret; i++) {
 			if (pages[i]) {
 				unlock_page(pages[i]);
-- 
2.35.1



