Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADEB751B202
	for <lists+stable@lfdr.de>; Thu,  5 May 2022 00:39:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235969AbiEDWnc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 18:43:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229881AbiEDWnb (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 18:43:31 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A104849F21
        for <stable@vger.kernel.org>; Wed,  4 May 2022 15:39:54 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id h14-20020a25e20e000000b006484e4a1da2so2297179ybe.9
        for <stable@vger.kernel.org>; Wed, 04 May 2022 15:39:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=9KNnM460PFQh9bd+g+TUlotbh4k+D9X+5xMpP3xFsxM=;
        b=hyQ4aQV9XR0AtG8rtBHsPJbSX1T9/73qTv2ZA7BTnKF3f2l78CwcF++E/TqdQa7GE6
         /+DJ74W6R5Cw3SB7HPYbZMMniqZ51GOCocOjpS7KAr2KoLcqzLdsl3lL+uyWHE3q5fT0
         geZ6H53DdmMh5rWmZk6tv24s+QmTBv3vYNspjLje1GHIe7WT1tzxYTGGHh/80TPqRT5F
         tFyWaTpZQ4Kkv67NqoIsIRxGr8aVcAHDjzVapHxQ9JA3aS3wUY0WItvcvqnSe98xQWtZ
         /MfFUGQ7PeV9BcZ5RgKHulKGPovUYNbpg+Hn5S2IEqCnObPJSeweLIQNi6V14dXhiqel
         +CuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=9KNnM460PFQh9bd+g+TUlotbh4k+D9X+5xMpP3xFsxM=;
        b=Mup/MibYaoqm//hAn/EvdkZCbwpL5leHOQjSg9SIscsn2te3hq2gBfCUV5o9sCtSzO
         Sm8+zwPdWSxxzw/+uPErsXNXljlbF2u5n5wkEynvbfnTXh0b8eBgu1Aznso0P5bKsCBI
         +14uNyqBHYNxE7KKcCPzhYGmgFZIVVhIOeZ2UHko+VZE0dNwbK+bXUnjuZqMZFd0xIFn
         7yXlNdcnd/dIXd9XhkwcgPqUrZdVWrql3uS72aBXfd6amDhqP8/ODL0BeMzsWI/XO9ge
         oR4hgdm21bkUfVRKD06aHxGKGBUxehH9RFDtoriTcQZ8uUIDfoYelU8P1aY/qJs/RFHV
         CfqA==
X-Gm-Message-State: AOAM530u+44k2Lrm/mYJh7vLI9c6ITD2+nQjJ+PdX44QL9kLfNi/c3Lr
        z+RO/1ktzEulM/K+vxNP6UIfXqgERcpxjukf4bt+faiNpK/xdY2F7/vGcyQVFiD/u/0UIQuv328
        LtNCqko83y8BXTqYpepwCpEAESKMDn7HRh9ETZ+PDq8SAwMxzD62JOezNaunbuzkrlaVbd1ya/i
        N6Ng==
X-Google-Smtp-Source: ABdhPJx0hj0i2okuFFvIqeHqku1Qn7yP1lnGhQV/qpzjR9+7WmjzgqQA8VHvb9kwfLNnLRC/CPnl5VesNwmj1U9u8j0=
X-Received: from nobelbarakat.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:62d])
 (user=nobelbarakat job=sendgmr) by 2002:a25:8043:0:b0:648:51c2:8a69 with SMTP
 id a3-20020a258043000000b0064851c28a69mr20001686ybn.10.1651703993765; Wed, 04
 May 2022 15:39:53 -0700 (PDT)
Date:   Wed,  4 May 2022 22:39:50 +0000
Message-Id: <20220504223950.2372905-1-nobelbarakat@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
Subject: [PATCH 5.4] block-map: add __GFP_ZERO flag for alloc_page in function bio_copy_kern
From:   Nobel Barakat <nobelbarakat@google.com>
To:     stable@vger.kernel.org
Cc:     Nobel Barakat <nobelbarakat@google.com>,
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

commit cc8f7fe1f5eab010191aa4570f27641876fa1267 upstream

Add __GFP_ZERO flag for alloc_page in function bio_copy_kern to initialize
the buffer of a bio.

Signed-off-by: Haimin Zhang <tcs.kernel@gmail.com>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/20220216084038.15635-1-tcs.kernel@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
[nobelbarakat: Backported to 5.4: Manually added __GFP_ZERO flag]
Signed-off-by: Nobel Barakat <nobelbarakat@google.com>
---
This changes fixes a kernel info leak since it's possible for bio_copy_kern to
copy unitialized memory into userspace.

This change had to be manually backported since bio_copy_kern is in a different
file (bio.c) than the upstream commit (blk-map.c)

 block/bio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/bio.c b/block/bio.c
index b1170ec18464..363294afc394 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -1570,7 +1570,7 @@ struct bio *bio_copy_kern(struct request_queue *q, void *data, unsigned int len,
 		if (bytes > len)
 			bytes = len;
 
-		page = alloc_page(q->bounce_gfp | gfp_mask);
+		page = alloc_page(q->bounce_gfp | __GFP_ZERO | gfp_mask);
 		if (!page)
 			goto cleanup;
 
-- 
2.36.0.464.gb9c8b46e94-goog

