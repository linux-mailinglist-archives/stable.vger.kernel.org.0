Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18E386AAC22
	for <lists+stable@lfdr.de>; Sat,  4 Mar 2023 20:40:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229661AbjCDTkF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 4 Mar 2023 14:40:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229656AbjCDTkE (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 4 Mar 2023 14:40:04 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41EE3CDC4;
        Sat,  4 Mar 2023 11:40:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D2DAC60A55;
        Sat,  4 Mar 2023 19:40:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2D13C4339C;
        Sat,  4 Mar 2023 19:40:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677958802;
        bh=uVtft0lxTja3jBPQPJpnoQbKRCxZP/ST9hjfus9mMms=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e3nKr5Xsgp0MN2UPq7FxyhDz5NDDfGt1VW+xC+uwXKXl/fw5Ie91/IKKZwhFgi+yh
         9CFrNXy26L4W8ttmk7TxHUh28ikksODKGfRMLce15uwQC3XqMYNKtV7Vj7ORG+oyDP
         mlPZ/o1VpAT8fNgpNrqGke2yktJx4RWUtx1oHDmE6d0G9zaqXuHyE7Tlxmgl0RG6sB
         e4OzERuIHep+cFfGL6RNdEEtI2fzu0E7JvEyAElXtJXvcoO/LwD4tObncoLD/62A/t
         CcLHJgqyFqenktJMegZbT/nUoR0mfKR9Bav6rvN2UVlatGynzpKP55fHXEDqUGwAEf
         AZ9ZkvF6WyUMQ==
From:   SeongJae Park <sj@kernel.org>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     SeongJae Park <sj@kernel.org>,
        Kefeng Wang <wangkefeng.wang@huawei.com>,
        "Vishal Moola (Oracle)" <vishal.moola@gmail.com>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        damon@lists.linux.dev, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH 2/2] mm/damon/paddr: fix folio_nr_pages() after folio_put() in damon_pa_mark_accessed_or_deactivate()
Date:   Sat,  4 Mar 2023 19:39:49 +0000
Message-Id: <20230304193949.296391-3-sj@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230304193949.296391-1-sj@kernel.org>
References: <20230304193949.296391-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

damon_pa_mark_accessed_or_deactivate() is accessing a folio via
folio_nr_pages() after folio_put() for the folio has invoked.  Fix it.

Fixes: f70da5ee8fe1 ("mm/damon: convert damon_pa_mark_accessed_or_deactivate() to use folios")
Cc: <stable@vger.kernel.org> # 6.3.x
Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/paddr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/damon/paddr.c b/mm/damon/paddr.c
index 10f159b315ea..0db724aec5cb 100644
--- a/mm/damon/paddr.c
+++ b/mm/damon/paddr.c
@@ -277,8 +277,8 @@ static inline unsigned long damon_pa_mark_accessed_or_deactivate(
 			folio_mark_accessed(folio);
 		else
 			folio_deactivate(folio);
-		folio_put(folio);
 		applied += folio_nr_pages(folio);
+		folio_put(folio);
 	}
 	return applied * PAGE_SIZE;
 }
-- 
2.25.1

