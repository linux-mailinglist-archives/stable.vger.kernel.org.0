Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA579593829
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 21:30:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245595AbiHOTMM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 15:12:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343877AbiHOTLL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 15:11:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79F1847B92;
        Mon, 15 Aug 2022 11:36:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BEACB610A4;
        Mon, 15 Aug 2022 18:36:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7E89C433B5;
        Mon, 15 Aug 2022 18:36:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660588613;
        bh=AoWZxuR6WXPi8Pqjbv7dEunLrV46Cyhu9vllKRjqP4s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f8cJ2wSiItzkzeAtjpykZeLIaFg6n0s/AW9e39IORCKVcPugAvyAfzMHm/B05H9Gk
         GdpwL2CdmUJEl74gWo1jw3sA6zQWb0movJtjjtO29xjym4+oC00LPmiMp+82JPKyu+
         KpDu1tGgcPmLprob4iyC7s9Kk4YnCS3bKVhH8XUg=
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
Subject: [PATCH 5.15 429/779] lib/test_hmm: avoid accessing uninitialized pages
Date:   Mon, 15 Aug 2022 20:01:13 +0200
Message-Id: <20220815180355.612757882@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
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
index ac794e354069..a89cb4281c9d 100644
--- a/lib/test_hmm.c
+++ b/lib/test_hmm.c
@@ -731,7 +731,7 @@ static int dmirror_exclusive(struct dmirror *dmirror,
 
 	mmap_read_lock(mm);
 	for (addr = start; addr < end; addr = next) {
-		unsigned long mapped;
+		unsigned long mapped = 0;
 		int i;
 
 		if (end < addr + (ARRAY_SIZE(pages) << PAGE_SHIFT))
@@ -740,7 +740,13 @@ static int dmirror_exclusive(struct dmirror *dmirror,
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



