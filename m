Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F10456B888
	for <lists+stable@lfdr.de>; Fri,  8 Jul 2022 13:29:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237345AbiGHL2y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Jul 2022 07:28:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237346AbiGHL2x (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 8 Jul 2022 07:28:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 879C42CCA9
        for <stable@vger.kernel.org>; Fri,  8 Jul 2022 04:28:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E00F8624DE
        for <stable@vger.kernel.org>; Fri,  8 Jul 2022 11:28:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F07A7C341C0;
        Fri,  8 Jul 2022 11:28:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657279731;
        bh=t6bc4bXiWhf0FlMQQ4mQfBuY0jXZQDBBe97WliKuORE=;
        h=Subject:To:Cc:From:Date:From;
        b=WXqErasf2uOOSFxASkGCBaUHYIWvS36PATVo/b74FeyA2poZE803qMmQPx8W8b/W8
         tEFaRd5Rvw/tjcGi8lB0eSMi6ES6RuCCoKu5yyh3+GTjNgVYUJ8t75z4rHkOd/Yx7Q
         bwwM6erQq3P/BUbef+GjMbbWxPZlbyuKKtAcfxyc=
Subject: FAILED: patch "[PATCH] net/mlx5e: Fix matchall police parameters validation" failed to apply to 5.18-stable tree
To:     vladbu@nvidia.com, davem@davemloft.net, saeedm@nvidia.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 08 Jul 2022 13:28:48 +0200
Message-ID: <1657279728158241@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.18-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 4d1e07d83ccc87f210e5b852b0a5ea812a2f191c Mon Sep 17 00:00:00 2001
From: Vlad Buslov <vladbu@nvidia.com>
Date: Mon, 4 Jul 2022 22:44:05 +0200
Subject: [PATCH] net/mlx5e: Fix matchall police parameters validation

Referenced commit prepared the code for upcoming extension that allows mlx5
to offload police action attached to flower classifier. However, with
regard to existing matchall classifier offload validation should be
reversed as FLOW_ACTION_CONTINUE is the only supported notexceed police
action type. Fix the problem by allowing FLOW_ACTION_CONTINUE for police
action and extend scan_tc_matchall_fdb_actions() to only allow such actions
with matchall classifier.

Fixes: d97b4b105ce7 ("flow_offload: reject offload for all drivers with invalid police parameters")
Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
Acked-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 34bf11cdf90f..3a39a50146dd 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -4529,13 +4529,6 @@ static int mlx5e_policer_validate(const struct flow_action *action,
 		return -EOPNOTSUPP;
 	}
 
-	if (act->police.notexceed.act_id != FLOW_ACTION_PIPE &&
-	    act->police.notexceed.act_id != FLOW_ACTION_ACCEPT) {
-		NL_SET_ERR_MSG_MOD(extack,
-				   "Offload not supported when conform action is not pipe or ok");
-		return -EOPNOTSUPP;
-	}
-
 	if (act->police.notexceed.act_id == FLOW_ACTION_ACCEPT &&
 	    !flow_action_is_last_entry(action, act)) {
 		NL_SET_ERR_MSG_MOD(extack,
@@ -4586,6 +4579,12 @@ static int scan_tc_matchall_fdb_actions(struct mlx5e_priv *priv,
 	flow_action_for_each(i, act, flow_action) {
 		switch (act->id) {
 		case FLOW_ACTION_POLICE:
+			if (act->police.notexceed.act_id != FLOW_ACTION_CONTINUE) {
+				NL_SET_ERR_MSG_MOD(extack,
+						   "Offload not supported when conform action is not continue");
+				return -EOPNOTSUPP;
+			}
+
 			err = mlx5e_policer_validate(flow_action, act, extack);
 			if (err)
 				return err;

