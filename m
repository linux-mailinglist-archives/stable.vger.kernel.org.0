Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D52BD6AEE4B
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:11:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232419AbjCGSLC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:11:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231539AbjCGSKb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:10:31 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07AA44E5F2
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:05:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4CD0CB819BF
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:05:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8075DC4339B;
        Tue,  7 Mar 2023 18:05:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678212329;
        bh=i4EQkBQjrY4UOYfGmyeCf48T6yASAB++zF052nG9G1Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JlBKAO+e7906ZZsy0FUWQhc0rKdG+L0N3pHgWDAcjSxqYDqb6xpypcDJyJztUP2GO
         O5Z0mRyZMVgUCkjoAJB67eUzz/zFOLBhApTwVaqmNv5+Zw/upTtlGWZZJRpQX59jXf
         RYNK8EAuZ7nM+8FoQdfE7glfIn8GxPSTjRBVYG74=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, kernel test robot <lkp@intel.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 110/885] block: use proper return value from bio_failfast()
Date:   Tue,  7 Mar 2023 17:50:44 +0100
Message-Id: <20230307170006.656770777@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

[ Upstream commit f3ca73862453ac1e64fc6968a14bf66d839cd2d8 ]

kernel test robot complains about a type mismatch:

   block/blk-merge.c:984:42: sparse:     expected restricted blk_opf_t const [usertype] ff
   block/blk-merge.c:984:42: sparse:     got unsigned int
   block/blk-merge.c:1010:42: sparse: sparse: incorrect type in initializer (different base types) @@     expected restricted blk_opf_t const [usertype] ff @@     got unsigned int @@
   block/blk-merge.c:1010:42: sparse:     expected restricted blk_opf_t const [usertype] ff
   block/blk-merge.c:1010:42: sparse:     got unsigned int

because bio_failfast() is return an unsigned int rather than the
appropriate blk_opt_f type. Fix it up.

Fixes: 3ce6a115980c ("block: sync mixed merged request's failfast with 1st bio's")
Reported-by: kernel test robot <lkp@intel.com>
Link: https://lore.kernel.org/oe-kbuild-all/202302170743.GXypM9Rt-lkp@intel.com/
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-merge.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/blk-merge.c b/block/blk-merge.c
index 914da38523b5a..17ac532105a97 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -747,7 +747,7 @@ void blk_rq_set_mixed_merge(struct request *rq)
 	rq->rq_flags |= RQF_MIXED_MERGE;
 }
 
-static inline unsigned int bio_failfast(const struct bio *bio)
+static inline blk_opf_t bio_failfast(const struct bio *bio)
 {
 	if (bio->bi_opf & REQ_RAHEAD)
 		return REQ_FAILFAST_MASK;
-- 
2.39.2



