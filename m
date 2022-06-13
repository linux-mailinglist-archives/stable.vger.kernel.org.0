Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D041C5491EE
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:29:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378475AbiFMNlj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 09:41:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379168AbiFMNj5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 09:39:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 104E03DDCD;
        Mon, 13 Jun 2022 04:29:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C2C51B80E59;
        Mon, 13 Jun 2022 11:29:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21CAFC34114;
        Mon, 13 Jun 2022 11:29:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655119749;
        bh=nv0D8rN2bgCyxG7rkiqi0EAeO1ejq2lTO03o1B3qvd8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C37OSLsbh2ZYTtmIIOcwioZKTV0uIu1rQSb3ReP6WsiM3iYxtJJpptsAI0yhN80f0
         RUj8QjPtVTadK7qcdJGDJANU+krnW8wd7n29F4TdHag/zCv5KyhlYfo1PgmtlsI7Mt
         TMybON1EeYYa5HijR6Hfrp/S+bLpA/7og+FJfxy0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paul Blakey <paulb@nvidia.com>,
        Ariel Levkovich <lariel@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 126/339] net/mlx5: CT: Fix header-rewrite re-use for tupels
Date:   Mon, 13 Jun 2022 12:09:11 +0200
Message-Id: <20220613094930.331085779@linuxfoundation.org>
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

From: Paul Blakey <paulb@nvidia.com>

[ Upstream commit 1f2856cde64baa78475e6d3c601fb7b7f693a161 ]

Tuple entries that don't have nat configured for them
which are added to the ct nat table will always create
a new modify header, as we don't check for possible
re-use on them. The same for tuples that have nat configured
for them but are added to ct table.

Fix the above by only avoiding wasteful re-use lookup
for actually natted entries in ct nat table.

Fixes: 7fac5c2eced3 ("net/mlx5: CT: Avoid reusing modify header context for natted entries")
Signed-off-by: Paul Blakey <paulb@nvidia.com>
Reviewed-by: Ariel Levkovich <lariel@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/mellanox/mlx5/core/en/tc_ct.c    | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
index ab4b0f3ee2a0..1ff7a07bcd06 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
@@ -701,7 +701,7 @@ mlx5_tc_ct_entry_create_mod_hdr(struct mlx5_tc_ct_priv *ct_priv,
 				struct mlx5_flow_attr *attr,
 				struct flow_rule *flow_rule,
 				struct mlx5e_mod_hdr_handle **mh,
-				u8 zone_restore_id, bool nat)
+				u8 zone_restore_id, bool nat_table, bool has_nat)
 {
 	DECLARE_MOD_HDR_ACTS_ACTIONS(actions_arr, MLX5_CT_MIN_MOD_ACTS);
 	DECLARE_MOD_HDR_ACTS(mod_acts, actions_arr);
@@ -717,11 +717,12 @@ mlx5_tc_ct_entry_create_mod_hdr(struct mlx5_tc_ct_priv *ct_priv,
 				     &attr->ct_attr.ct_labels_id);
 	if (err)
 		return -EOPNOTSUPP;
-	if (nat) {
-		err = mlx5_tc_ct_entry_create_nat(ct_priv, flow_rule,
-						  &mod_acts);
-		if (err)
-			goto err_mapping;
+	if (nat_table) {
+		if (has_nat) {
+			err = mlx5_tc_ct_entry_create_nat(ct_priv, flow_rule, &mod_acts);
+			if (err)
+				goto err_mapping;
+		}
 
 		ct_state |= MLX5_CT_STATE_NAT_BIT;
 	}
@@ -736,7 +737,7 @@ mlx5_tc_ct_entry_create_mod_hdr(struct mlx5_tc_ct_priv *ct_priv,
 	if (err)
 		goto err_mapping;
 
-	if (nat) {
+	if (nat_table && has_nat) {
 		attr->modify_hdr = mlx5_modify_header_alloc(ct_priv->dev, ct_priv->ns_type,
 							    mod_acts.num_actions,
 							    mod_acts.actions);
@@ -804,7 +805,9 @@ mlx5_tc_ct_entry_add_rule(struct mlx5_tc_ct_priv *ct_priv,
 
 	err = mlx5_tc_ct_entry_create_mod_hdr(ct_priv, attr, flow_rule,
 					      &zone_rule->mh,
-					      zone_restore_id, nat);
+					      zone_restore_id,
+					      nat,
+					      mlx5_tc_ct_entry_has_nat(entry));
 	if (err) {
 		ct_dbg("Failed to create ct entry mod hdr");
 		goto err_mod_hdr;
-- 
2.35.1



