Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2205B540939
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 20:07:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241475AbiFGSGv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 14:06:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351072AbiFGSBl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 14:01:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BFC614E2E8;
        Tue,  7 Jun 2022 10:43:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C99636146F;
        Tue,  7 Jun 2022 17:43:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D60FBC385A5;
        Tue,  7 Jun 2022 17:43:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654623835;
        bh=7Cf6JB2q1A9OGemJDYVSx1pjXiSzVu0Yuw1kwfazgNM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DXA3QmfUBijiuXMPpseangAEC4M1Kcttlptx1aubs9/hQLT5KXoQ5d94BSgp7qfHN
         CsM927ODsIFyTDvAn0/gMnmhm2LiWPmlZyt9kvJFeB3ZfSMeqX5ecSbR0OaY0fibgk
         v4mhwcP3XDM1/t9DkTcflvve4QUaXvq6yt1+42NU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mikulas Patocka <mpatocka@redhat.com>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 109/667] dma-debug: change allocation mode from GFP_NOWAIT to GFP_ATIOMIC
Date:   Tue,  7 Jun 2022 18:56:14 +0200
Message-Id: <20220607164938.091474045@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164934.766888869@linuxfoundation.org>
References: <20220607164934.766888869@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mikulas Patocka <mpatocka@redhat.com>

[ Upstream commit 84bc4f1dbbbb5f8aa68706a96711dccb28b518e5 ]

We observed the error "cacheline tracking ENOMEM, dma-debug disabled"
during a light system load (copying some files). The reason for this error
is that the dma_active_cacheline radix tree uses GFP_NOWAIT allocation -
so it can't access the emergency memory reserves and it fails as soon as
anybody reaches the watermark.

This patch changes GFP_NOWAIT to GFP_ATOMIC, so that it can access the
emergency memory reserves.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/dma/debug.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/dma/debug.c b/kernel/dma/debug.c
index f8ff598596b8..ac740630c79c 100644
--- a/kernel/dma/debug.c
+++ b/kernel/dma/debug.c
@@ -448,7 +448,7 @@ void debug_dma_dump_mappings(struct device *dev)
  * other hand, consumes a single dma_debug_entry, but inserts 'nents'
  * entries into the tree.
  */
-static RADIX_TREE(dma_active_cacheline, GFP_NOWAIT);
+static RADIX_TREE(dma_active_cacheline, GFP_ATOMIC);
 static DEFINE_SPINLOCK(radix_lock);
 #define ACTIVE_CACHELINE_MAX_OVERLAP ((1 << RADIX_TREE_MAX_TAGS) - 1)
 #define CACHELINE_PER_PAGE_SHIFT (PAGE_SHIFT - L1_CACHE_SHIFT)
-- 
2.35.1



