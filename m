Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52BF65830DE
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 19:43:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242967AbiG0RnO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 13:43:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242910AbiG0Rmr (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 13:42:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B7FF54ACA;
        Wed, 27 Jul 2022 09:52:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7DB1CB821D4;
        Wed, 27 Jul 2022 16:52:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBCB1C433C1;
        Wed, 27 Jul 2022 16:52:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658940731;
        bh=W/HHsRq2sC87P8Jl6L/qDVBFwjJgLDL+rERMXNdKZ0E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=or/Y+9hG4ZTKz4NPsfuENi0KzFrBYEJkivuagANuG9iNOAyG/dg7XcKvAhCWN2kEp
         x5Fc4DVOCbbI85JyRftd09j0BMfdEqIfo8FI5o+GuhPcSoqeBHe2GGaq1m/Mlt8Mp3
         UULdzwZlLIxG70qyWqT9SPi855HTUhY8TM9NOU00=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oz Shlomo <ozsh@nvidia.com>,
        Roi Dayan <roid@nvidia.com>,
        Baowen Zheng <baowen.zheng@corigine.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 127/158] net/sched: cls_api: Fix flow action initialization
Date:   Wed, 27 Jul 2022 18:13:11 +0200
Message-Id: <20220727161026.492887422@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727161021.428340041@linuxfoundation.org>
References: <20220727161021.428340041@linuxfoundation.org>
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

From: Oz Shlomo <ozsh@nvidia.com>

[ Upstream commit c0f47c2822aadeb8b2829f3e4c3792f184c7be33 ]

The cited commit refactored the flow action initialization sequence to
use an interface method when translating tc action instances to flow
offload objects. The refactored version skips the initialization of the
generic flow action attributes for tc actions, such as pedit, that allocate
more than one offload entry. This can cause potential issues for drivers
mapping flow action ids.

Populate the generic flow action fields for all the flow action entries.

Fixes: c54e1d920f04 ("flow_offload: add ops to tc_action_ops for flow action setup")
Signed-off-by: Oz Shlomo <ozsh@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>

----
v1 -> v2:
 - coalese the generic flow action fields initialization to a single loop
Reviewed-by: Baowen Zheng <baowen.zheng@corigine.com>

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/cls_api.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index 2d4dc1468a9a..6fd33c75d6bb 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -3531,7 +3531,7 @@ int tc_setup_action(struct flow_action *flow_action,
 		    struct tc_action *actions[],
 		    struct netlink_ext_ack *extack)
 {
-	int i, j, index, err = 0;
+	int i, j, k, index, err = 0;
 	struct tc_action *act;
 
 	BUILD_BUG_ON(TCA_ACT_HW_STATS_ANY != FLOW_ACTION_HW_STATS_ANY);
@@ -3551,14 +3551,18 @@ int tc_setup_action(struct flow_action *flow_action,
 		if (err)
 			goto err_out_locked;
 
-		entry->hw_stats = tc_act_hw_stats(act->hw_stats);
-		entry->hw_index = act->tcfa_index;
 		index = 0;
 		err = tc_setup_offload_act(act, entry, &index, extack);
-		if (!err)
-			j += index;
-		else
+		if (err)
 			goto err_out_locked;
+
+		for (k = 0; k < index ; k++) {
+			entry[k].hw_stats = tc_act_hw_stats(act->hw_stats);
+			entry[k].hw_index = act->tcfa_index;
+		}
+
+		j += index;
+
 		spin_unlock_bh(&act->tcfa_lock);
 	}
 
-- 
2.35.1



