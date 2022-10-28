Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED8DE6110A8
	for <lists+stable@lfdr.de>; Fri, 28 Oct 2022 14:07:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230229AbiJ1MHs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Oct 2022 08:07:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230236AbiJ1MHn (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 Oct 2022 08:07:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFA271D3768
        for <stable@vger.kernel.org>; Fri, 28 Oct 2022 05:07:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9FF32B829B9
        for <stable@vger.kernel.org>; Fri, 28 Oct 2022 12:07:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F05D1C433C1;
        Fri, 28 Oct 2022 12:07:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666958860;
        bh=/5DiX3fzDhxiCvwaypMTm5GNdUQ/9JXxBImOGAswOyw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jHsavcWnRUXm6uNRj8OqZ84oHI9bsQT/Y0qaviHJ8SyAeU2spidOH5cJjb8F8wTyH
         ByE20USqrszEHQ9v0Hr5ku1U1mbidlJfq6/zZBwupu1rA1TXakQ+zQZkHdLMXcP22E
         TaogIxU7fJ/yQi68FqC9OJQmZzMIMPlyXJj0DBmg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, kernel test robot <yujie.liu@intel.com>,
        Yu Kuai <yukuai3@huawei.com>, Ming Lei <ming.lei@redhat.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.10 72/73] blk-wbt: fix that rwb->wc is always set to 1 in wbt_init()
Date:   Fri, 28 Oct 2022 14:04:09 +0200
Message-Id: <20221028120235.497741436@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221028120232.344548477@linuxfoundation.org>
References: <20221028120232.344548477@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yu Kuai <yukuai3@huawei.com>

commit 285febabac4a16655372d23ff43e89ff6f216691 upstream.

commit 8c5035dfbb94 ("blk-wbt: call rq_qos_add() after wb_normal is
initialized") moves wbt_set_write_cache() before rq_qos_add(), which
is wrong because wbt_rq_qos() is still NULL.

Fix the problem by removing wbt_set_write_cache() and setting 'rwb->wc'
directly. Noted that this patch also remove the redundant setting of
'rab->wc'.

Fixes: 8c5035dfbb94 ("blk-wbt: call rq_qos_add() after wb_normal is initialized")
Reported-by: kernel test robot <yujie.liu@intel.com>
Link: https://lore.kernel.org/r/202210081045.77ddf59b-yujie.liu@intel.com
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Reviewed-by: Ming Lei <ming.lei@redhat.com>
Link: https://lore.kernel.org/r/20221009101038.1692875-1-yukuai1@huaweicloud.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/blk-wbt.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/block/blk-wbt.c
+++ b/block/blk-wbt.c
@@ -838,12 +838,11 @@ int wbt_init(struct request_queue *q)
 	rwb->last_comp = rwb->last_issue = jiffies;
 	rwb->win_nsec = RWB_WINDOW_NSEC;
 	rwb->enable_state = WBT_STATE_ON_DEFAULT;
-	rwb->wc = 1;
+	rwb->wc = test_bit(QUEUE_FLAG_WC, &q->queue_flags);
 	rwb->rq_depth.default_depth = RWB_DEF_DEPTH;
 	rwb->min_lat_nsec = wbt_default_latency_nsec(q);
 
 	wbt_queue_depth_changed(&rwb->rqos);
-	wbt_set_write_cache(q, test_bit(QUEUE_FLAG_WC, &q->queue_flags));
 
 	/*
 	 * Assign rwb and add the stats callback.


