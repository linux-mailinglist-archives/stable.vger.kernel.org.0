Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C49B26896C2
	for <lists+stable@lfdr.de>; Fri,  3 Feb 2023 11:32:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233635AbjBCKcW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Feb 2023 05:32:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233666AbjBCKay (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Feb 2023 05:30:54 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 764A84DCF4
        for <stable@vger.kernel.org>; Fri,  3 Feb 2023 02:29:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0A48F61EBF
        for <stable@vger.kernel.org>; Fri,  3 Feb 2023 10:29:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C659FC433D2;
        Fri,  3 Feb 2023 10:29:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675420198;
        bh=6IPvLjmhgSXxnwws/KoW+dUYQVKEQRL1CCrrjuWAOiE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CGF8BZU+ZoPHJ9vbtHwCvfv4F9a6ZT02yawjzuDoGtWhVeMk8khrIfX+tmx6zNMOs
         yWJu/X7uaQxgCAm2Gq/v56GSKezBC9stBJr73rBzHIZoJrWiFZHaV8dznsQITDrnXT
         YC8udo3g+WLbq/FlJTNO4r9sw6LPjt7f25Jmh+Kw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yu Kuai <yukuai3@huawei.com>,
        Tejun Heo <tj@kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 112/134] blk-cgroup: fix missing pd_online_fn() while activating policy
Date:   Fri,  3 Feb 2023 11:13:37 +0100
Message-Id: <20230203101028.869720807@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230203101023.832083974@linuxfoundation.org>
References: <20230203101023.832083974@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



