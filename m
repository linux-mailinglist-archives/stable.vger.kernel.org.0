Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D4644CF95D
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 11:04:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239835AbiCGKEx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 05:04:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238803AbiCGKC2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 05:02:28 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE1447486F;
        Mon,  7 Mar 2022 01:51:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 87EACB80F9F;
        Mon,  7 Mar 2022 09:51:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E21BFC340F4;
        Mon,  7 Mar 2022 09:51:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646646709;
        bh=Y0ydCJdLcvb/muRQhxCjXoK2Jvm2kqf39/xsowfr3bs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EhKIsnwaEEFZkjJ+DTcXt3jOm1SFibm9b0az7LEh8JRz0acgcojdLBs5o5wlhTr6T
         8uw2jt8IuAaBxGSuuXdtfEzvkx7hsQcqIjTGkWBnILTMqW0XS9EJ0ePadiB3YMaycO
         Hh9ajOZCEPhLiP0yH4gRP+H2eHQOGup1MCPdJYZ4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Haimin Zhang <tcs.kernel@gmail.com>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 027/186] block-map: add __GFP_ZERO flag for alloc_page in function bio_copy_kern
Date:   Mon,  7 Mar 2022 10:17:45 +0100
Message-Id: <20220307091654.854214847@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091654.092878898@linuxfoundation.org>
References: <20220307091654.092878898@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Haimin Zhang <tcs.kernel@gmail.com>

[ Upstream commit cc8f7fe1f5eab010191aa4570f27641876fa1267 ]

Add __GFP_ZERO flag for alloc_page in function bio_copy_kern to initialize
the buffer of a bio.

Signed-off-by: Haimin Zhang <tcs.kernel@gmail.com>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/20220216084038.15635-1-tcs.kernel@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-map.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/blk-map.c b/block/blk-map.c
index 4526adde01564..c7f71d83eff18 100644
--- a/block/blk-map.c
+++ b/block/blk-map.c
@@ -446,7 +446,7 @@ static struct bio *bio_copy_kern(struct request_queue *q, void *data,
 		if (bytes > len)
 			bytes = len;
 
-		page = alloc_page(GFP_NOIO | gfp_mask);
+		page = alloc_page(GFP_NOIO | __GFP_ZERO | gfp_mask);
 		if (!page)
 			goto cleanup;
 
-- 
2.34.1



