Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9243F5486A9
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 17:57:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382863AbiFMOZ7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 10:25:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383383AbiFMOXQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 10:23:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26DFA46661;
        Mon, 13 Jun 2022 04:44:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8EB41612AC;
        Mon, 13 Jun 2022 11:44:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BCA3C34114;
        Mon, 13 Jun 2022 11:44:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655120659;
        bh=B6GC9o5GZjVAdcvKBkcQ0xllpRE3UeM87D2CQFb1Hm0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EDkUP8azt75xPMM+0ZVYLIxLe8pVEQ/l37AEVtFuaWpCf6LzZ9cJUSklXimFT3oQ9
         /w1tj2lU/f/3J2KyXyXAe6yH3OWzp9vSrs0xRiKzg/X+jyCiMNd9oUDI11vxYEaBLu
         KC83OFDvYN+pAMOHQFgewesQaMtFHZuHBjIl27vM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paul Blakey <paulb@nvidia.com>,
        Ariel Levkovich <lariel@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 110/298] net/mlx5: CT: Fix header-rewrite re-use for tupels
Date:   Mon, 13 Jun 2022 12:10:04 +0200
Message-Id: <20220613094928.284868469@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094924.913340374@linuxfoundation.org>
References: <20220613094924.913340374@linuxfoundation.org>
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
index 9028e9958c72..cf9d48d934ef 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
@@ -692,7 +692,7 @@ mlx5_tc_ct_entry_create_mod_hdr(struct mlx5_tc_ct_priv *ct_priv,
 				struct mlx5_flow_attr *attr,
 				struct flow_rule *flow_rule,
 				struct mlx5e_mod_hdr_handle **mh,
-				u8 zone_restore_id, bool nat)
+				u8 zone_restore_id, bool nat_table, bool has_nat)
 {
 	DECLARE_MOD_HDR_ACTS_ACTIONS(actions_arr, MLX5_CT_MIN_MOD_ACTS);
 	DECLARE_MOD_HDR_ACTS(mod_acts, actions_arr);
@@ -708,11 +708,12 @@ mlx5_tc_ct_entry_create_mod_hdr(struct mlx5_tc_ct_priv *ct_priv,
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
@@ -727,7 +728,7 @@ mlx5_tc_ct_entry_create_mod_hdr(struct mlx5_tc_ct_priv *ct_priv,
 	if (err)
 		goto err_mapping;
 
-	if (nat) {
+	if (nat_table && has_nat) {
 		attr->modify_hdr = mlx5_modify_header_alloc(ct_priv->dev, ct_priv->ns_type,
 							    mod_acts.num_actions,
 							    mod_acts.actions);
@@ -795,7 +796,9 @@ mlx5_tc_ct_entry_add_rule(struct mlx5_tc_ct_priv *ct_priv,
 
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



