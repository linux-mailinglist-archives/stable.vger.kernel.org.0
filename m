Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81EB856FBC1
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 11:34:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232710AbiGKJez (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 05:34:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232887AbiGKJdX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 05:33:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EB0246D88;
        Mon, 11 Jul 2022 02:18:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9B827B80DB7;
        Mon, 11 Jul 2022 09:17:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0D5EC34115;
        Mon, 11 Jul 2022 09:17:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657531078;
        bh=3C2xL54NrtXzg4JDawT+H0GFUdMSUjJmyWE0vulAu6k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IvphS3EUIAE3yQDDBIbnfHxGRSSr/shh21GRVaZ+IkDtn1tbPNpzq+lOMC6FwyeoJ
         IURnUGltS68ospz50SIRIEGWudoSFWjrGJqSg80YckYSeAE+86FnEKD2uOwcd+/ttb
         07/PvrvRXpPj961I4IaR9JumJ8Sln7OOHh9fR1Z0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vlad Buslov <vladbu@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 089/112] net/mlx5e: Fix matchall police parameters validation
Date:   Mon, 11 Jul 2022 11:07:29 +0200
Message-Id: <20220711090552.097643334@linuxfoundation.org>
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

[ Upstream commit 4d1e07d83ccc87f210e5b852b0a5ea812a2f191c ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index ec2dfecd7f0f..c01651047448 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -4503,13 +4503,6 @@ static int mlx5e_policer_validate(const struct flow_action *action,
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
@@ -4560,6 +4553,12 @@ static int scan_tc_matchall_fdb_actions(struct mlx5e_priv *priv,
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
-- 
2.35.1



