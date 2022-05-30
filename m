Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56FF0537BAD
	for <lists+stable@lfdr.de>; Mon, 30 May 2022 15:28:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236630AbiE3N0B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 May 2022 09:26:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236692AbiE3NZe (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 May 2022 09:25:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3564682150;
        Mon, 30 May 2022 06:25:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7125160EB4;
        Mon, 30 May 2022 13:25:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7578C36AE7;
        Mon, 30 May 2022 13:25:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653917116;
        bh=Aoq/ZnXVcKk+p7VdfH7dk2D2Y56VczJQo9MgI9eHjA8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PSDx1dpO0ytd9PdZR6lrDeLETu2aEjqNEZplrbWEkouDB7hHDkr9L2hSF/WLA0z3k
         MZDY2CkUr2YeN6eU5pR+RedOBFx5UJDIphuFG6EHLfBHjDEhUglaVbhcsKTjq16Ryt
         kd2Q4co45UOJDNItSrwRcODZRnOppeh8C2pzFPkSBoUMlWVZONDoU1En2G0Oh86APA
         3GwC5tx2CkuEdrE86WfGb+foh4CSOupBCXBqQg0OUP7mFiss2WO70QYOVWmkrmBVYc
         0QJ4XH1Natv9AnWUt6Qx3RG2edbiRzoJanVJyE7WXc7u3HTghsYwt4o/JobTYzqyBR
         LZX/66obdHeZQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Liviu Dudau <liviu.dudau@arm.com>,
        Steven Price <steven.price@arm.com>,
        Sasha Levin <sashal@kernel.org>, james.qian.wang@arm.com,
        mihail.atanassov@arm.com, brian.starkey@arm.com, airlied@linux.ie,
        daniel@ffwll.ch, dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.18 022/159] drm/komeda: return early if drm_universal_plane_init() fails.
Date:   Mon, 30 May 2022 09:22:07 -0400
Message-Id: <20220530132425.1929512-22-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220530132425.1929512-1-sashal@kernel.org>
References: <20220530132425.1929512-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

From: Liviu Dudau <liviu.dudau@arm.com>

[ Upstream commit c8f76c37cc3668ee45e081e76a15f24a352ebbdd ]

If drm_universal_plane_init() fails early we jump to the common cleanup code
that calls komeda_plane_destroy() which in turn could access the uninitalised
drm_plane and crash. Return early if an error is detected without going through
the common code.

Reported-by: Steven Price <steven.price@arm.com>
Reviewed-by: Steven Price <steven.price@arm.com>
Signed-off-by: Liviu Dudau <liviu.dudau@arm.com>
Link: https://lore.kernel.org/dri-devel/20211203100946.2706922-1-liviu.dudau@arm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/arm/display/komeda/komeda_plane.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/arm/display/komeda/komeda_plane.c b/drivers/gpu/drm/arm/display/komeda/komeda_plane.c
index d63d83800a8a..d646e3ae1a23 100644
--- a/drivers/gpu/drm/arm/display/komeda/komeda_plane.c
+++ b/drivers/gpu/drm/arm/display/komeda/komeda_plane.c
@@ -275,8 +275,10 @@ static int komeda_plane_add(struct komeda_kms_dev *kms,
 
 	komeda_put_fourcc_list(formats);
 
-	if (err)
-		goto cleanup;
+	if (err) {
+		kfree(kplane);
+		return err;
+	}
 
 	drm_plane_helper_add(plane, &komeda_plane_helper_funcs);
 
-- 
2.35.1

