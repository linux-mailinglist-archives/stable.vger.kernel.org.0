Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A92146799E7
	for <lists+stable@lfdr.de>; Tue, 24 Jan 2023 14:43:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234297AbjAXNnI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Jan 2023 08:43:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234319AbjAXNmw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Jan 2023 08:42:52 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2893C45235;
        Tue, 24 Jan 2023 05:42:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DA42F611F4;
        Tue, 24 Jan 2023 13:42:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2256C4339B;
        Tue, 24 Jan 2023 13:42:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674567726;
        bh=jmVxCeavWO+FBi8yxOKCkQ7COU927JaLBNSDf/y4n/w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XZiqvLF9hbEAvczjGpp92ZDbSuAVa9Qz0SgHgCspWhVMk8ai5oJf2O3FlWZ5E/ufT
         Lxe2w1pwYf05JzI6XCqBVJ+9/pHA0qHGsMTxC643ZBtSoAqGGv5g1hEMAuHHDKBqbQ
         EuqpTOnMbtaAUzijwY0joCM4aCKYWi2iI9xZHWli1MnKRyE4WZPaX9qIPSCEYP8TPv
         Ssy9RocH4KI+PTJZdYvGycNeEM7ZHQy/IH4jDEPnQNxXoBnlSv8D9ygsPfeWySwFLz
         r9ST88QPiE1jMOqucbDXRNq3VXknxEG1ine+8iUN6RjAccxJpLWb3H12cBEHGrEk+h
         0O4OS7HC+td3Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yu Kuai <yukuai3@huawei.com>, Tejun Heo <tj@kernel.org>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>,
        josef@toxicpanda.com, cgroups@vger.kernel.org,
        linux-block@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 16/35] blk-cgroup: fix missing pd_online_fn() while activating policy
Date:   Tue, 24 Jan 2023 08:41:12 -0500
Message-Id: <20230124134131.637036-16-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230124134131.637036-1-sashal@kernel.org>
References: <20230124134131.637036-1-sashal@kernel.org>
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
index fcf9cf49f5de..7c91d9195da8 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -1408,6 +1408,10 @@ int blkcg_activate_policy(struct request_queue *q,
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

