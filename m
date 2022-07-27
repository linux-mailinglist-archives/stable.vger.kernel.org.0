Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1119582D86
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 19:00:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229546AbiG0Q7z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 12:59:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230173AbiG0Q6v (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 12:58:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D60C6759F;
        Wed, 27 Jul 2022 09:37:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 06B11B821A6;
        Wed, 27 Jul 2022 16:36:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 494D2C433D6;
        Wed, 27 Jul 2022 16:36:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658939785;
        bh=TRUEB7p4AbyqXNIiq6XMX+D4eko7r6zTCXx7Ibqm4S4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ip0nrFGvVOJjmq0MHmqJx8FmkV9ZrdvzconIDUXKST4UjOyP6HD6xfzlkxOuNlh6h
         Vgey0YKOMb44wVN7US4JiiGiQJVaJfe4ewTTEN+4ZUvh+YWI9aMa//LOuCmX527mM+
         wA5iNEcOTw+uCfia3F90R4uJtztbZzbpx1z/DLNM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.10 104/105] block: fix memory leak of bvec
Date:   Wed, 27 Jul 2022 18:11:30 +0200
Message-Id: <20220727161016.275605431@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727161012.056867467@linuxfoundation.org>
References: <20220727161012.056867467@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ming Lei <ming.lei@redhat.com>

commit 8358c28a5d44bf0223a55a2334086c3707bb4185 upstream.

bio_init() clears bio instance, so the bvec index has to be set after
bio_init(), otherwise bio->bi_io_vec may be leaked.

Fixes: 3175199ab0ac ("block: split bio_kmalloc from bio_alloc_bioset")
Cc: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Cc: Damien Le Moal <damien.lemoal@wdc.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/bio.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/block/bio.c
+++ b/block/bio.c
@@ -491,8 +491,8 @@ struct bio *bio_alloc_bioset(gfp_t gfp_m
 		if (unlikely(!bvl))
 			goto err_free;
 
-		bio->bi_flags |= idx << BVEC_POOL_OFFSET;
 		bio_init(bio, bvl, bvec_nr_vecs(idx));
+		bio->bi_flags |= idx << BVEC_POOL_OFFSET;
 	} else if (nr_iovecs) {
 		bio_init(bio, bio->bi_inline_vecs, BIO_INLINE_VECS);
 	} else {


