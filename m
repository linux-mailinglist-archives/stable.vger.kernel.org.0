Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD6B034C7CA
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:19:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231572AbhC2ISP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:18:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:57846 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232756AbhC2IQy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:16:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B5471619A7;
        Mon, 29 Mar 2021 08:16:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617005777;
        bh=CPoIX7dP6d66bbp56DcfdrUV7Uqa+Xop0lvyNuYwMPA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G1WAOiXQhfxig2HGiCI7cC0REMKboZa6tAVJ/9RGN+MwJpAu5dxSzELd3168WRl3W
         WPZJGsSb0kBIHKn3CJm0Ynj4yEkcaEXIcyherIo4UN343no3naPNf4Ye+t/aqcBuPf
         ikHwWTQKhO3LPI9r0e4G33GpswYbqF62lNW2jgiU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Louis Peens <louis.peens@corigine.com>,
        Simon Horman <simon.horman@netronome.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 078/111] nfp: flower: fix pre_tun mask id allocation
Date:   Mon, 29 Mar 2021 09:58:26 +0200
Message-Id: <20210329075617.813665488@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075615.186199980@linuxfoundation.org>
References: <20210329075615.186199980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Louis Peens <louis.peens@corigine.com>

[ Upstream commit d8ce0275e45ec809a33f98fc080fe7921b720dfb ]

pre_tun_rule flows does not follow the usual add-flow path, instead
they are used to update the pre_tun table on the firmware. This means
that if the mask-id gets allocated here the firmware will never see the
"NFP_FL_META_FLAG_MANAGE_MASK" flag for the specific mask id, which
triggers the allocation on the firmware side. This leads to the firmware
mask being corrupted and causing all sorts of strange behaviour.

Fixes: f12725d98cbe ("nfp: flower: offload pre-tunnel rules")
Signed-off-by: Louis Peens <louis.peens@corigine.com>
Signed-off-by: Simon Horman <simon.horman@netronome.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/netronome/nfp/flower/metadata.c  | 24 +++++++++++++------
 1 file changed, 17 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/flower/metadata.c b/drivers/net/ethernet/netronome/nfp/flower/metadata.c
index 5defd31d481c..aa06fcb38f8b 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/metadata.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/metadata.c
@@ -327,8 +327,14 @@ int nfp_compile_flow_metadata(struct nfp_app *app,
 		goto err_free_ctx_entry;
 	}
 
+	/* Do net allocate a mask-id for pre_tun_rules. These flows are used to
+	 * configure the pre_tun table and are never actually send to the
+	 * firmware as an add-flow message. This causes the mask-id allocation
+	 * on the firmware to get out of sync if allocated here.
+	 */
 	new_mask_id = 0;
-	if (!nfp_check_mask_add(app, nfp_flow->mask_data,
+	if (!nfp_flow->pre_tun_rule.dev &&
+	    !nfp_check_mask_add(app, nfp_flow->mask_data,
 				nfp_flow->meta.mask_len,
 				&nfp_flow->meta.flags, &new_mask_id)) {
 		NL_SET_ERR_MSG_MOD(extack, "invalid entry: cannot allocate a new mask id");
@@ -359,7 +365,8 @@ int nfp_compile_flow_metadata(struct nfp_app *app,
 			goto err_remove_mask;
 		}
 
-		if (!nfp_check_mask_remove(app, nfp_flow->mask_data,
+		if (!nfp_flow->pre_tun_rule.dev &&
+		    !nfp_check_mask_remove(app, nfp_flow->mask_data,
 					   nfp_flow->meta.mask_len,
 					   NULL, &new_mask_id)) {
 			NL_SET_ERR_MSG_MOD(extack, "invalid entry: cannot release mask id");
@@ -374,8 +381,10 @@ int nfp_compile_flow_metadata(struct nfp_app *app,
 	return 0;
 
 err_remove_mask:
-	nfp_check_mask_remove(app, nfp_flow->mask_data, nfp_flow->meta.mask_len,
-			      NULL, &new_mask_id);
+	if (!nfp_flow->pre_tun_rule.dev)
+		nfp_check_mask_remove(app, nfp_flow->mask_data,
+				      nfp_flow->meta.mask_len,
+				      NULL, &new_mask_id);
 err_remove_rhash:
 	WARN_ON_ONCE(rhashtable_remove_fast(&priv->stats_ctx_table,
 					    &ctx_entry->ht_node,
@@ -406,9 +415,10 @@ int nfp_modify_flow_metadata(struct nfp_app *app,
 
 	__nfp_modify_flow_metadata(priv, nfp_flow);
 
-	nfp_check_mask_remove(app, nfp_flow->mask_data,
-			      nfp_flow->meta.mask_len, &nfp_flow->meta.flags,
-			      &new_mask_id);
+	if (!nfp_flow->pre_tun_rule.dev)
+		nfp_check_mask_remove(app, nfp_flow->mask_data,
+				      nfp_flow->meta.mask_len, &nfp_flow->meta.flags,
+				      &new_mask_id);
 
 	/* Update flow payload with mask ids. */
 	nfp_flow->unmasked_data[NFP_FL_MASK_ID_LOCATION] = new_mask_id;
-- 
2.30.1



