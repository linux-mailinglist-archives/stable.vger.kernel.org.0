Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 971F66AF13C
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:41:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232893AbjCGSlj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:41:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232995AbjCGSlJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:41:09 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20B97B04BD
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:31:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7E36CB819D0
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:31:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D918EC433D2;
        Tue,  7 Mar 2023 18:31:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678213884;
        bh=iekUbFaHy0iI7ba32ARR5AJyI2XPJiiHfOfw7/xv9UU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RJJOfVpxBNlL89EHhVzdosYjtYsH757y7lOn1gbccJRk0j4mxr2f0C+Y8l8irBRXE
         7u+uPh2o/rhTwdXaVKNrAiB7kgMb0LzPHtdRqAWRrQpWe+jx2NRfCn4HW0uRoffJ/U
         vWx0arwwDs68HDKNcLJaWFh5VhjXHG4mVRCLVDtA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Keith Busch <kbusch@kernel.org>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.1 651/885] block: clear bio->bi_bdev when putting a bio back in the cache
Date:   Tue,  7 Mar 2023 17:59:45 +0100
Message-Id: <20230307170030.427928548@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

commit 11eb695feb636fa5211067189cad25ac073e7fe5 upstream.

This isn't strictly needed in terms of correctness, but it does allow
polling to know if the bio has been put already by a different task
and hence avoid polling something that we don't need to.

Cc: stable@vger.kernel.org
Fixes: be4d234d7aeb ("bio: add allocation cache abstraction")
Reviewed-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/bio.c |    1 +
 1 file changed, 1 insertion(+)

--- a/block/bio.c
+++ b/block/bio.c
@@ -747,6 +747,7 @@ void bio_put(struct bio *bio)
 		bio_uninit(bio);
 		cache = per_cpu_ptr(bio->bi_pool->cache, get_cpu());
 		bio->bi_next = cache->free_list;
+		bio->bi_bdev = NULL;
 		cache->free_list = bio;
 		if (++cache->nr > ALLOC_CACHE_MAX + ALLOC_CACHE_SLACK)
 			bio_alloc_cache_prune(cache, ALLOC_CACHE_SLACK);


