Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3ACE51AED6
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 22:12:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377941AbiEDUQJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 16:16:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377938AbiEDUQE (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 16:16:04 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B1E24F442
        for <stable@vger.kernel.org>; Wed,  4 May 2022 13:12:27 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-2eb7d137101so21029427b3.12
        for <stable@vger.kernel.org>; Wed, 04 May 2022 13:12:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=8j3GLxixxuO/GETj6Ut9d2IxMNOK7b2AVE1IjGLesCI=;
        b=lBlqCEdDTsulb1AGGQBfPtWENzmQUlUqqnjEQE3wosizZIBbsPAqXmoiarMJ4rH0uN
         aHnstz8ihVu8k0y6qQiHnjKKbt1w9pCRynYUSKwXU2kJ9mGsvVogoTh3VJQdPAnI/1Xq
         edLdghtRjXbHvdCSLThVqDUg+nlIsJIBZfyxWb66DEcytZLWz4qFJiLaD9yEYo+zMm+D
         AUuJMbWaO7G91+oIXounLcSh9BiyeS4T7tSsmu/pj+5KGX3Un4E09kfxUYLmvJ7PP/n4
         GBSB8xFcqkKlGC2XW1+pfuHpSzTUgkv47JESSEMkMkTjHfmwMms5ZoHeOAqkddm/ybNy
         j5iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=8j3GLxixxuO/GETj6Ut9d2IxMNOK7b2AVE1IjGLesCI=;
        b=uEalx58vn9L+1bjzeTRDdWRPUR7UlyV7pYmtmZmmySKp07GBmzfrxs7DBjd6bwAiKU
         3Rw5afPam4/Cqbu+NhI71IuuXquoy0f/k0SgJiFC8X9sU0wI7P7E8FNod1ezjqmOQesb
         oD3zAHDdP6VxGiKQzFG7pdTmJJ18ifQHM+CmEl7/fA9GuSKcxClgt9MLXPmXAOD+JvJk
         kYQ09FsaVtxjyi95atimBAFciP1jSlXWrdM7tqnTAIkz49YzcXIZQq5psaxWckDQyH8r
         wbHsZDn16gGkQ/JARRLtID3BtmEFONIWpEa7lBv3Kd7U84XHnqHySvXPItPGPzA/Bmk/
         1sOw==
X-Gm-Message-State: AOAM533k5wLLU0OhUOn4ceQVH7XUmHQPguHstYR6ElIP4AZG5Yr4aBhO
        pfw2N8Er9/8VjcX2O9TBqcTAnfQ4/mkT0EbZO/JOw1neohjdyLbxtNgmp3GscJgB7YK/rHBjpoY
        RVCk9MPCEVJVBQ5jAP+tz0IyrvN5UmQ986MySqP1RkWXXHoGeHQf4NYKrF7BctyvoLJ9z7wOFxz
        IfaQ==
X-Google-Smtp-Source: ABdhPJz/Tm6SwAoVs25PCtGHCN8Da0h1WFPNtlscqsm1uYbwSAmTC3/GMb39O47Od7BJxfGMeUip2Jl3nULI6rcLLA8=
X-Received: from nobelbarakat.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:62d])
 (user=nobelbarakat job=sendgmr) by 2002:a0d:cb93:0:b0:2f7:ce41:5311 with SMTP
 id n141-20020a0dcb93000000b002f7ce415311mr21302628ywd.497.1651695145431; Wed,
 04 May 2022 13:12:25 -0700 (PDT)
Date:   Wed,  4 May 2022 20:12:07 +0000
Message-Id: <20220504201207.2352621-1-nobelbarakat@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
Subject: [PATCH 5.10] block-map: add __GFP_ZERO flag for alloc_page in
 function bio_copy_kern
From:   Nobel Barakat <nobelbarakat@google.com>
To:     stable@vger.kernel.org
Cc:     gregkh@linuxfoundation.org,
        Nobel Barakat <nobelbarakat@google.com>,
        Haimin Zhang <tcs.kernel@gmail.com>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit cc8f7fe1f5eab010191aa4570f27641876fa1267 ]

Add __GFP_ZERO flag for alloc_page in function bio_copy_kern to initialize
the buffer of a bio.

Signed-off-by: Haimin Zhang <tcs.kernel@gmail.com>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/20220216084038.15635-1-tcs.kernel@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
[nobelbarakat: Backported to 5.10: Manually added flag] 
Signed-off-by: Nobel Barakat <nobelbarakat@google.com>
---
This changes fixes a kernel info leak since it's possible for bio_copy_kern to
copy unitialized memory into userspace. 

For the backport, I had to manually add the __GFP_ZERO
flag since alloc_page on 5.10 uses a different parameter
than on 5.15. On 5.10, alloc_page is called with q->bounce_gfp
whereas on 5.15 it's called with GFP_NOIO.

Version 5.4 is also affected, and I intend to submit a backport
there as well.

 block/blk-map.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/blk-map.c b/block/blk-map.c
index 21630dccac62..ede73f4f7014 100644
--- a/block/blk-map.c
+++ b/block/blk-map.c
@@ -488,7 +488,7 @@
 		if (bytes > len)
 			bytes = len;
 
-		page = alloc_page(q->bounce_gfp | gfp_mask);
+		page = alloc_page(q->bounce_gfp | __GFP_ZERO | gfp_mask);
 		if (!page)
 			goto cleanup;
 
-- 
2.36.0.464.gb9c8b46e94-goog

