Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E08735C0B1
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 11:22:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241313AbhDLJP0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 05:15:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:34856 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239808AbhDLJJT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 05:09:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 486AA61383;
        Mon, 12 Apr 2021 09:04:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618218290;
        bh=J1n92j6obGV3Ki7HcU/Q9lu7KmrSnOZ4jYG/jolQUXM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PwTn9iTX+5k/m3q4eLN2ZHOI2BcBmZtOsB2j9WOVQtegEhnp+dGWctOd9xND8qTS9
         mCWuxlK4LBqUGztWcXXeEFMSAyaiM1+ySJ7SuQ/aOSP3qM8kzdvHwbGugRU7E02qbl
         lCb6e0Lb5QqtT1OjYDx99i3I0xitivEqJn61rRas=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ariel Levkovich <lariel@nvidia.com>,
        Roi Dayan <roid@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 143/210] net/mlx5e: Fix mapping of ct_label zero
Date:   Mon, 12 Apr 2021 10:40:48 +0200
Message-Id: <20210412084020.763633326@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412084016.009884719@linuxfoundation.org>
References: <20210412084016.009884719@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ariel Levkovich <lariel@nvidia.com>

[ Upstream commit d24f847e54214049814b9515771622eaab3f42ab ]

ct_label 0 is a default label each flow has and therefore
there can be rules that match on ct_label=0 without a prior
rule that set the ct_label to this value.

The ct_label value is not used directly in the HW rules and
instead it is mapped to some id within a defined range and this
id is used to set and match the metadata register which carries
the ct_label.

If we have a rule that matches on ct_label=0, the hw rule will
perform matching on a value that is != 0 because of the mapping
from label to id. Since the metadata register default value is
0 and it was never set before to anything else by an action that
sets the ct_label, there will always be a mismatch between that
register and the value in the rule.

To support such rule, a forced mapping of ct_label 0 to id=0
is done so that it will match the metadata register default
value of 0.

Fixes: 54b154ecfb8c ("net/mlx5e: CT: Map 128 bits labels to 32 bit map ID")
Signed-off-by: Ariel Levkovich <lariel@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/mellanox/mlx5/core/en/tc_ct.c    | 36 +++++++++++++++----
 1 file changed, 29 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
index b42396df3111..0469f53dfb99 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
@@ -184,6 +184,28 @@ mlx5_tc_ct_entry_has_nat(struct mlx5_ct_entry *entry)
 	return !!(entry->tuple_nat_node.next);
 }
 
+static int
+mlx5_get_label_mapping(struct mlx5_tc_ct_priv *ct_priv,
+		       u32 *labels, u32 *id)
+{
+	if (!memchr_inv(labels, 0, sizeof(u32) * 4)) {
+		*id = 0;
+		return 0;
+	}
+
+	if (mapping_add(ct_priv->labels_mapping, labels, id))
+		return -EOPNOTSUPP;
+
+	return 0;
+}
+
+static void
+mlx5_put_label_mapping(struct mlx5_tc_ct_priv *ct_priv, u32 id)
+{
+	if (id)
+		mapping_remove(ct_priv->labels_mapping, id);
+}
+
 static int
 mlx5_tc_ct_rule_to_tuple(struct mlx5_ct_tuple *tuple, struct flow_rule *rule)
 {
@@ -435,7 +457,7 @@ mlx5_tc_ct_entry_del_rule(struct mlx5_tc_ct_priv *ct_priv,
 	mlx5_tc_rule_delete(netdev_priv(ct_priv->netdev), zone_rule->rule, attr);
 	mlx5e_mod_hdr_detach(ct_priv->dev,
 			     ct_priv->mod_hdr_tbl, zone_rule->mh);
-	mapping_remove(ct_priv->labels_mapping, attr->ct_attr.ct_labels_id);
+	mlx5_put_label_mapping(ct_priv, attr->ct_attr.ct_labels_id);
 	kfree(attr);
 }
 
@@ -638,8 +660,8 @@ mlx5_tc_ct_entry_create_mod_hdr(struct mlx5_tc_ct_priv *ct_priv,
 	if (!meta)
 		return -EOPNOTSUPP;
 
-	err = mapping_add(ct_priv->labels_mapping, meta->ct_metadata.labels,
-			  &attr->ct_attr.ct_labels_id);
+	err = mlx5_get_label_mapping(ct_priv, meta->ct_metadata.labels,
+				     &attr->ct_attr.ct_labels_id);
 	if (err)
 		return -EOPNOTSUPP;
 	if (nat) {
@@ -675,7 +697,7 @@ mlx5_tc_ct_entry_create_mod_hdr(struct mlx5_tc_ct_priv *ct_priv,
 
 err_mapping:
 	dealloc_mod_hdr_actions(&mod_acts);
-	mapping_remove(ct_priv->labels_mapping, attr->ct_attr.ct_labels_id);
+	mlx5_put_label_mapping(ct_priv, attr->ct_attr.ct_labels_id);
 	return err;
 }
 
@@ -743,7 +765,7 @@ mlx5_tc_ct_entry_add_rule(struct mlx5_tc_ct_priv *ct_priv,
 err_rule:
 	mlx5e_mod_hdr_detach(ct_priv->dev,
 			     ct_priv->mod_hdr_tbl, zone_rule->mh);
-	mapping_remove(ct_priv->labels_mapping, attr->ct_attr.ct_labels_id);
+	mlx5_put_label_mapping(ct_priv, attr->ct_attr.ct_labels_id);
 err_mod_hdr:
 	kfree(attr);
 err_attr:
@@ -1198,7 +1220,7 @@ void mlx5_tc_ct_match_del(struct mlx5_tc_ct_priv *priv, struct mlx5_ct_attr *ct_
 	if (!priv || !ct_attr->ct_labels_id)
 		return;
 
-	mapping_remove(priv->labels_mapping, ct_attr->ct_labels_id);
+	mlx5_put_label_mapping(priv, ct_attr->ct_labels_id);
 }
 
 int
@@ -1276,7 +1298,7 @@ mlx5_tc_ct_match_add(struct mlx5_tc_ct_priv *priv,
 		ct_labels[1] = key->ct_labels[1] & mask->ct_labels[1];
 		ct_labels[2] = key->ct_labels[2] & mask->ct_labels[2];
 		ct_labels[3] = key->ct_labels[3] & mask->ct_labels[3];
-		if (mapping_add(priv->labels_mapping, ct_labels, &ct_attr->ct_labels_id))
+		if (mlx5_get_label_mapping(priv, ct_labels, &ct_attr->ct_labels_id))
 			return -EOPNOTSUPP;
 		mlx5e_tc_match_to_reg_match(spec, LABELS_TO_REG, ct_attr->ct_labels_id,
 					    MLX5_CT_LABELS_MASK);
-- 
2.30.2



