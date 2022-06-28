Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D94B55CD21
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:02:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243549AbiF1CWp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 22:22:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243609AbiF1CVa (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 22:21:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26B8924F13;
        Mon, 27 Jun 2022 19:21:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B78CF617CA;
        Tue, 28 Jun 2022 02:21:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17A15C341CC;
        Tue, 28 Jun 2022 02:21:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656382878;
        bh=WfxWBIpku8sGa/2eIW1WWz589oUqjHx3Q1CNU29m1JY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hjnboY9tSpK7XaeW8TiZiagiHS+RGapQkiizRHdNzknL6bVEKCSlNEdtsgNEmI07G
         kcdoSuBr1bYLV1eqa/sNeA6y+qP8U9d3IWD3+5ea1qHVJaDs5pBcH1Nc8ZXxpZLQne
         eSwO93REtXwdERhnPXX3i8ZE+qI9rSGytpbdlIpKjmLRNPT71bkhPeP5mFKnkOVQ9y
         Ly2y7ISuu/A7W6DtyussYyarDRPX5pReYdgUhHM4HNTP/BGsckaRtbUCMzDO4W272z
         iwLzMDMk2ijcw9bc9ni7/LTrQzrJm+P4AgH/oowxA278EK4X2wAjl495LSanKuFnkV
         DyqjPkZlAqdXg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Maxime Ripard <maxime@cerno.tech>, Melissa Wen <mwen@igalia.com>,
        Sasha Levin <sashal@kernel.org>, emma@anholt.net,
        mripard@kernel.org, airlied@linux.ie, daniel@ffwll.ch,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.15 08/41] drm/vc4: plane: Prevent async update if we don't have a dlist
Date:   Mon, 27 Jun 2022 22:20:27 -0400
Message-Id: <20220628022100.595243-8-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220628022100.595243-1-sashal@kernel.org>
References: <20220628022100.595243-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maxime Ripard <maxime@cerno.tech>

[ Upstream commit cb468c7d84d174ab9cd638be9f5b3f1ba2b311a0 ]

The vc4 planes are setup in hardware by creating a hardware descriptor
in a dedicated RAM. As part of the process to setup a plane in KMS, we
thus need to allocate some part of that dedicated RAM to store our
descriptor there.

The async update path will just reuse the descriptor already allocated
for that plane and will modify it directly in RAM to match whatever has
been asked for.

In order to do that, it will compare the descriptor for the old plane
state and the new plane state, will make sure they fit in the same size,
and check that only the position or buffer address have changed.

Reviewed-by: Melissa Wen <mwen@igalia.com>
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Link: https://lore.kernel.org/r/20220610115149.964394-2-maxime@cerno.tech
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vc4/vc4_plane.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/gpu/drm/vc4/vc4_plane.c b/drivers/gpu/drm/vc4/vc4_plane.c
index 19161b6ab27f..c085c750f1e9 100644
--- a/drivers/gpu/drm/vc4/vc4_plane.c
+++ b/drivers/gpu/drm/vc4/vc4_plane.c
@@ -1219,6 +1219,10 @@ static int vc4_plane_atomic_async_check(struct drm_plane *plane,
 
 	old_vc4_state = to_vc4_plane_state(plane->state);
 	new_vc4_state = to_vc4_plane_state(new_plane_state);
+
+	if (!new_vc4_state->hw_dlist)
+		return -EINVAL;
+
 	if (old_vc4_state->dlist_count != new_vc4_state->dlist_count ||
 	    old_vc4_state->pos0_offset != new_vc4_state->pos0_offset ||
 	    old_vc4_state->pos2_offset != new_vc4_state->pos2_offset ||
-- 
2.35.1

