Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6FC01541942
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:21:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378923AbiFGVT5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:19:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380748AbiFGVQ4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:16:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51F9A49F17;
        Tue,  7 Jun 2022 11:57:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E1AE76159D;
        Tue,  7 Jun 2022 18:57:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F22A4C385A5;
        Tue,  7 Jun 2022 18:57:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654628232;
        bh=Kp9lSNG9ZMRLzWcdumWHugzb7Zr7YUX0zq3Ss2UvdWA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JA4f6WaNqku7BL5owwsO1oeZ/Wu9GepcUPt7xlVEj2o87fheIH7TelIiV045rWY/m
         VuS7UJV0Jw4QiV7QraratfKORWYAi+S3D/MVduJz8fyNjk6jU9/5c8QsNHiOpkk4Y+
         TZ8ouy7KMOZF4kAIr1ynD2BBfYUFm56+p6CLJ/ec=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Arunpravin <Arunpravin.PaneerSelvam@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 255/879] drm/selftests: missing error code in igt_buddy_alloc_smoke()
Date:   Tue,  7 Jun 2022 18:56:13 +0200
Message-Id: <20220607165010.251403464@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
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

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 016d1ca3f6ad05676fd9e418715ddce1f4ab5a73 ]

Set the error code to -ENOMEM if drm_random_order() fails.

Fixes: e6ff5ef81170 ("drm/selftests: add drm buddy smoke testcase")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Arunpravin <Arunpravin.PaneerSelvam@amd.com>
Signed-off-by: Christian König <christian.koenig@amd.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20220307125458.GA16710@kili
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/selftests/test-drm_buddy.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/selftests/test-drm_buddy.c b/drivers/gpu/drm/selftests/test-drm_buddy.c
index 913cbd7eae04..aca0c491040f 100644
--- a/drivers/gpu/drm/selftests/test-drm_buddy.c
+++ b/drivers/gpu/drm/selftests/test-drm_buddy.c
@@ -488,8 +488,10 @@ static int igt_buddy_alloc_smoke(void *arg)
 	}
 
 	order = drm_random_order(mm.max_order + 1, &prng);
-	if (!order)
+	if (!order) {
+		err = -ENOMEM;
 		goto out_fini;
+	}
 
 	for (i = 0; i <= mm.max_order; ++i) {
 		struct drm_buddy_block *block;
-- 
2.35.1



