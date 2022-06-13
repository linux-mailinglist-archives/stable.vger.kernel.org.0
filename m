Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5EC07548F0D
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:21:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377976AbiFMNkx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 09:40:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378921AbiFMNjY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 09:39:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5734B79381;
        Mon, 13 Jun 2022 04:28:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D71F1B80EA7;
        Mon, 13 Jun 2022 11:28:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 547E1C34114;
        Mon, 13 Jun 2022 11:28:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655119691;
        bh=KyJdAkux9PQxnAy6KAB2uuLEtkTXx+7bKUbe7lIz1jM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WW31FXYOdi1a8QV7DGV3kiWkpFXTZgo74J8rFQidH694ROZGw5f1v/zMyTLPYaQx+
         J40HwBlAMUPGa6aXU+CdaCxuyV8bGy/IUJzAX5lzA7EQAYcqeMpYtE6+ccFndKKrJS
         LYeK0s/FMv9JCWdPKlW2+vaf9losP5JgWMDMq9jg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 105/339] block: take destination bvec offsets into account in bio_copy_data_iter
Date:   Mon, 13 Jun 2022 12:08:50 +0200
Message-Id: <20220613094929.697184068@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094926.497929857@linuxfoundation.org>
References: <20220613094926.497929857@linuxfoundation.org>
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

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 403d50341cce6b5481a92eb481e6df60b1f49b55 ]

Appartly bcache can copy into bios that do not just contain fresh
pages but can have offsets into the bio_vecs.  Restore support for tht
in bio_copy_data_iter.

Fixes: f8b679a070c5 ("block: rewrite bio_copy_data_iter to use bvec_kmap_local and memcpy_to_bvec")
Signed-off-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/20220524143919.1155501-1-hch@lst.de
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/bio.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index 4259125e16ab..ac29c87c6735 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -1336,10 +1336,12 @@ void bio_copy_data_iter(struct bio *dst, struct bvec_iter *dst_iter,
 		struct bio_vec src_bv = bio_iter_iovec(src, *src_iter);
 		struct bio_vec dst_bv = bio_iter_iovec(dst, *dst_iter);
 		unsigned int bytes = min(src_bv.bv_len, dst_bv.bv_len);
-		void *src_buf;
+		void *src_buf = bvec_kmap_local(&src_bv);
+		void *dst_buf = bvec_kmap_local(&dst_bv);
 
-		src_buf = bvec_kmap_local(&src_bv);
-		memcpy_to_bvec(&dst_bv, src_buf);
+		memcpy(dst_buf, src_buf, bytes);
+
+		kunmap_local(dst_buf);
 		kunmap_local(src_buf);
 
 		bio_advance_iter_single(src, src_iter, bytes);
-- 
2.35.1



