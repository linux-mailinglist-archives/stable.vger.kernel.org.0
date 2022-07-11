Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13B5F56FBBE
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 11:34:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232541AbiGKJex (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 05:34:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232963AbiGKJeW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 05:34:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7801C7CB54;
        Mon, 11 Jul 2022 02:18:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DA92361211;
        Mon, 11 Jul 2022 09:18:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9164C34115;
        Mon, 11 Jul 2022 09:18:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657531103;
        bh=1lxe/7MLB2qdkeeIApXg0/WsPxJWzm5Ya/YAReb80k0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=coIVzrDMx69FDwXWD/YASJrD8ocM8y8nTo5/vlACsOfz148s0Gy+KkVQxz3X5/M3h
         iaEmjcESYLWIAUxObmFAv8VUzU7KNonDd2+prUBuPbZyGHuNQ/0aFApI7RGa2RIxIq
         QnOpInmHskrZcao3FIKgEflqg3bG54krbZqYYqaI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vlad Buslov <vladbu@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 097/112] net/sched: act_police: allow continue action offload
Date:   Mon, 11 Jul 2022 11:07:37 +0200
Message-Id: <20220711090552.323023513@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220711090549.543317027@linuxfoundation.org>
References: <20220711090549.543317027@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vlad Buslov <vladbu@nvidia.com>

[ Upstream commit 052f744f44462cc49b88a125b0f7b93a9e47a9dd ]

Offloading police with action TC_ACT_UNSPEC was erroneously disabled even
though it was supported by mlx5 matchall offload implementation, which
didn't verify the action type but instead assumed that any single police
action attached to matchall classifier is a 'continue' action. Lack of
action type check made it non-obvious what mlx5 matchall implementation
actually supports and caused implementers and reviewers of referenced
commits to disallow it as a part of improved validation code.

Fixes: b8cd5831c61c ("net: flow_offload: add tc police action parameters")
Fixes: b50e462bc22d ("net/sched: act_police: Add extack messages for offload failure")
Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Tested-by: Ido Schimmel <idosch@nvidia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/flow_offload.h | 1 +
 net/sched/act_police.c     | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
index 6484095a8c01..7ac313858037 100644
--- a/include/net/flow_offload.h
+++ b/include/net/flow_offload.h
@@ -152,6 +152,7 @@ enum flow_action_id {
 	FLOW_ACTION_PIPE,
 	FLOW_ACTION_VLAN_PUSH_ETH,
 	FLOW_ACTION_VLAN_POP_ETH,
+	FLOW_ACTION_CONTINUE,
 	NUM_FLOW_ACTIONS,
 };
 
diff --git a/net/sched/act_police.c b/net/sched/act_police.c
index 79c8901f66ab..b759628a47c2 100644
--- a/net/sched/act_police.c
+++ b/net/sched/act_police.c
@@ -442,7 +442,7 @@ static int tcf_police_act_to_flow_act(int tc_act, u32 *extval,
 		act_id = FLOW_ACTION_JUMP;
 		*extval = tc_act & TC_ACT_EXT_VAL_MASK;
 	} else if (tc_act == TC_ACT_UNSPEC) {
-		NL_SET_ERR_MSG_MOD(extack, "Offload not supported when conform/exceed action is \"continue\"");
+		act_id = FLOW_ACTION_CONTINUE;
 	} else {
 		NL_SET_ERR_MSG_MOD(extack, "Unsupported conform/exceed action offload");
 	}
-- 
2.35.1



