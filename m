Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1082E679A4D
	for <lists+stable@lfdr.de>; Tue, 24 Jan 2023 14:46:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234656AbjAXNqC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Jan 2023 08:46:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234571AbjAXNpU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Jan 2023 08:45:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A35247433;
        Tue, 24 Jan 2023 05:43:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4A8B7611E6;
        Tue, 24 Jan 2023 13:43:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3216C433A0;
        Tue, 24 Jan 2023 13:43:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674567833;
        bh=6IPvLjmhgSXxnwws/KoW+dUYQVKEQRL1CCrrjuWAOiE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TF2wAcBisTklAE76e1L7YiQZsgEQFu48EsoIjvv0kL90NUsdltP1DMEILGhcJ0WHf
         0pACkEIqV6Vp8mHTf1HOcFKnuXoO4b2PEHSuTkN3tVPngWTLP33bISnn/xra1M6OOs
         +9yaqwPgKAwF4LcKUlGZKiw/76+XXb1vrMwoyYmR8w6R1m3qqyzwXqM2emvIm70d3n
         WevnK7GCGtPBpY1BEyq3IPRtgF2Z544r7w7Nqf5MAht5s+Up740EKN97ph2AIeLx21
         fxMp5JlPAuDglZn4av/TqfyUn5Soibpeo8xAUrtBKuYmzmz9ZpxaafltLjCyB6e/bM
         +hIKKWjqmk0pw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yu Kuai <yukuai3@huawei.com>, Tejun Heo <tj@kernel.org>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>,
        josef@toxicpanda.com, cgroups@vger.kernel.org,
        linux-block@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 4/6] blk-cgroup: fix missing pd_online_fn() while activating policy
Date:   Tue, 24 Jan 2023 08:43:42 -0500
Message-Id: <20230124134344.637846-4-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230124134344.637846-1-sashal@kernel.org>
References: <20230124134344.637846-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yu Kuai <yukuai3@huawei.com>

[ Upstream commit e3ff8887e7db757360f97634e0d6f4b8e27a8c46 ]

If the policy defines pd_online_fn(), it should be called after
pd_init_fn(), like blkg_create().

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Acked-by: Tejun Heo <tj@kernel.org>
Link: https://lore.kernel.org/r/20230103112833.2013432-1-yukuai1@huaweicloud.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-cgroup.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index dde8d0acfb34..cd085a0e5e4a 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -1445,6 +1445,10 @@ int blkcg_activate_policy(struct request_queue *q,
 		list_for_each_entry_reverse(blkg, &q->blkg_list, q_node)
 			pol->pd_init_fn(blkg->pd[pol->plid]);
 
+	if (pol->pd_online_fn)
+		list_for_each_entry_reverse(blkg, &q->blkg_list, q_node)
+			pol->pd_online_fn(blkg->pd[pol->plid]);
+
 	__set_bit(pol->plid, q->blkcg_pols);
 	ret = 0;
 
-- 
2.39.0

