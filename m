Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 919085941AA
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 23:51:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240581AbiHOVJO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 17:09:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347788AbiHOVHe (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 17:07:34 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D29CD5DFC;
        Mon, 15 Aug 2022 12:15:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id C0D11CE12C5;
        Mon, 15 Aug 2022 19:15:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5DF5C433D7;
        Mon, 15 Aug 2022 19:15:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660590954;
        bh=Q8Hc5xyH/xwarte89q54kVHnwt5Jx0tft9JuJvXgEEw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WCZVbsqQ8W09FXShZlp49xw3HVlN0MpQ29i01U5FX5aHbBcXru/yOjfaD6i8Nk7eU
         fXErA1dqVe+NNIp5EVjEEw7aL5dM+XPWll/PpXd52IkfDv9lsYu5kw6fXtfRaxEtKT
         +JWaM/DzINMZv2MuSBTMZAqj1KyOyeHNa7y9pLnU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alex Deucher <alexander.deucher@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        "Pan, Xinhui" <Xinhui.Pan@amd.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>, Jonathan Gray <jsg@jsg.id.au>,
        =?UTF-8?q?Mateusz=20Jo=C5=84czyk?= <mat.jonczyk@o2.pl>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0424/1095] drm/radeon: avoid bogus "vram limit (0) must be a power of 2" warning
Date:   Mon, 15 Aug 2022 19:57:03 +0200
Message-Id: <20220815180447.272844505@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mateusz Jończyk <mat.jonczyk@o2.pl>

[ Upstream commit 9da2902609f7519c48eda84f953f72fee53f2b71 ]

I was getting the following message on boot on Linux 5.19-rc5:
        radeon 0000:01:05.0: vram limit (0) must be a power of 2
(I didn't use any radeon.vramlimit commandline parameter).

This is caused by
commit 8c2d34eb53b9 ("drm/radeon: use kernel is_power_of_2 rather than local version")
which removed radeon_check_pot_argument() and converted its users to
is_power_of_2(). The two functions differ in its handling of 0, which is
the default value of radeon_vram_limit: radeon_check_pot_argument()
"incorrectly" considered it a power of 2, while is_power_of_2() does not.

An appropriate conditional silences the warning message.

It is not necessary to add a similar test to other callers of
is_power_of_2() in radeon_device.c. The matching commit in amdgpu:
commit 761175078466 ("drm/amdgpu: use kernel is_power_of_2 rather than local version")
is unaffected by this bug.

Tested on Radeon HD 3200.

Not ccing stable, this is not serious enough.

Fixes: 8c2d34eb53b9 ("drm/radeon: use kernel is_power_of_2 rather than local version")
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: Christian König <christian.koenig@amd.com>
Cc: "Pan, Xinhui" <Xinhui.Pan@amd.com>
Cc: David Airlie <airlied@linux.ie>
Cc: Daniel Vetter <daniel@ffwll.ch>
Cc: Jonathan Gray <jsg@jsg.id.au>
Signed-off-by: Mateusz Jończyk <mat.jonczyk@o2.pl>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/radeon/radeon_device.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/radeon/radeon_device.c b/drivers/gpu/drm/radeon/radeon_device.c
index 15692cb241fc..429644d5ddc6 100644
--- a/drivers/gpu/drm/radeon/radeon_device.c
+++ b/drivers/gpu/drm/radeon/radeon_device.c
@@ -1113,7 +1113,7 @@ static int radeon_gart_size_auto(enum radeon_family family)
 static void radeon_check_arguments(struct radeon_device *rdev)
 {
 	/* vramlimit must be a power of two */
-	if (!is_power_of_2(radeon_vram_limit)) {
+	if (radeon_vram_limit != 0 && !is_power_of_2(radeon_vram_limit)) {
 		dev_warn(rdev->dev, "vram limit (%d) must be a power of 2\n",
 				radeon_vram_limit);
 		radeon_vram_limit = 0;
-- 
2.35.1



