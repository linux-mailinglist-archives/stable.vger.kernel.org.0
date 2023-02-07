Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9196B68D7B3
	for <lists+stable@lfdr.de>; Tue,  7 Feb 2023 14:02:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232043AbjBGNCf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Feb 2023 08:02:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232168AbjBGNCY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Feb 2023 08:02:24 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2D1D3A58C
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 05:02:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6C41A611AA
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 13:02:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E147C433D2;
        Tue,  7 Feb 2023 13:02:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675774923;
        bh=Tg2di0cyajyHM2SnIK5d7yOWen8H8U6QWF5NkdhuHf8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LLQLWYbxrxoJm+PMX3Y58GaITwBgQ58Lyg7nGU2qoXxG0rR2FbN9n8egEIIqOpC61
         52YCMy8k4kIJUKNblbZkvtAhetG6kurWwCqEwrW49igyXHKnG7SqaECfSl48ZvHXts
         bUV9pN9r4NkfbA2j9GqAnSJoG/OhoaY2ixEDVlVY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Ratheesh Kannoth <rkannoth@marvell.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 078/208] octeontx2-af: Fix devlink unregister
Date:   Tue,  7 Feb 2023 13:55:32 +0100
Message-Id: <20230207125637.860886235@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230207125634.292109991@linuxfoundation.org>
References: <20230207125634.292109991@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ratheesh Kannoth <rkannoth@marvell.com>

[ Upstream commit 917d5e04d4dd2bbbf36fc6976ba442e284ccc42d ]

Exact match feature is only available in CN10K-B.
Unregister exact match devlink entry only for
this silicon variant.

Fixes: 87e4ea29b030 ("octeontx2-af: Debugsfs support for exact match.")
Signed-off-by: Ratheesh Kannoth <rkannoth@marvell.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Link: https://lore.kernel.org/r/20230131061659.1025137-1-rkannoth@marvell.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../marvell/octeontx2/af/rvu_devlink.c        | 35 ++++++++++++++-----
 1 file changed, 27 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.c
index 88dee589cb21..dc7bd2ce78f7 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.c
@@ -1500,6 +1500,9 @@ static const struct devlink_param rvu_af_dl_params[] = {
 			     BIT(DEVLINK_PARAM_CMODE_RUNTIME),
 			     rvu_af_dl_dwrr_mtu_get, rvu_af_dl_dwrr_mtu_set,
 			     rvu_af_dl_dwrr_mtu_validate),
+};
+
+static const struct devlink_param rvu_af_dl_param_exact_match[] = {
 	DEVLINK_PARAM_DRIVER(RVU_AF_DEVLINK_PARAM_ID_NPC_EXACT_FEATURE_DISABLE,
 			     "npc_exact_feature_disable", DEVLINK_PARAM_TYPE_STRING,
 			     BIT(DEVLINK_PARAM_CMODE_RUNTIME),
@@ -1563,7 +1566,6 @@ int rvu_register_dl(struct rvu *rvu)
 {
 	struct rvu_devlink *rvu_dl;
 	struct devlink *dl;
-	size_t size;
 	int err;
 
 	dl = devlink_alloc(&rvu_devlink_ops, sizeof(struct rvu_devlink),
@@ -1585,21 +1587,32 @@ int rvu_register_dl(struct rvu *rvu)
 		goto err_dl_health;
 	}
 
+	err = devlink_params_register(dl, rvu_af_dl_params, ARRAY_SIZE(rvu_af_dl_params));
+	if (err) {
+		dev_err(rvu->dev,
+			"devlink params register failed with error %d", err);
+		goto err_dl_health;
+	}
+
 	/* Register exact match devlink only for CN10K-B */
-	size = ARRAY_SIZE(rvu_af_dl_params);
 	if (!rvu_npc_exact_has_match_table(rvu))
-		size -= 1;
+		goto done;
 
-	err = devlink_params_register(dl, rvu_af_dl_params, size);
+	err = devlink_params_register(dl, rvu_af_dl_param_exact_match,
+				      ARRAY_SIZE(rvu_af_dl_param_exact_match));
 	if (err) {
 		dev_err(rvu->dev,
-			"devlink params register failed with error %d", err);
-		goto err_dl_health;
+			"devlink exact match params register failed with error %d", err);
+		goto err_dl_exact_match;
 	}
 
+done:
 	devlink_register(dl);
 	return 0;
 
+err_dl_exact_match:
+	devlink_params_unregister(dl, rvu_af_dl_params, ARRAY_SIZE(rvu_af_dl_params));
+
 err_dl_health:
 	rvu_health_reporters_destroy(rvu);
 	devlink_free(dl);
@@ -1612,8 +1625,14 @@ void rvu_unregister_dl(struct rvu *rvu)
 	struct devlink *dl = rvu_dl->dl;
 
 	devlink_unregister(dl);
-	devlink_params_unregister(dl, rvu_af_dl_params,
-				  ARRAY_SIZE(rvu_af_dl_params));
+
+	devlink_params_unregister(dl, rvu_af_dl_params, ARRAY_SIZE(rvu_af_dl_params));
+
+	/* Unregister exact match devlink only for CN10K-B */
+	if (rvu_npc_exact_has_match_table(rvu))
+		devlink_params_unregister(dl, rvu_af_dl_param_exact_match,
+					  ARRAY_SIZE(rvu_af_dl_param_exact_match));
+
 	rvu_health_reporters_destroy(rvu);
 	devlink_free(dl);
 }
-- 
2.39.0



