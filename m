Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08D115B8405
	for <lists+stable@lfdr.de>; Wed, 14 Sep 2022 11:06:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230501AbiINJGo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Sep 2022 05:06:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231158AbiINJFv (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Sep 2022 05:05:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC079786F4;
        Wed, 14 Sep 2022 02:03:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8C53361999;
        Wed, 14 Sep 2022 09:03:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1B68C433D6;
        Wed, 14 Sep 2022 09:03:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663146193;
        bh=2yO7puHfzJOIxQNrFfNlpnhlBPhO5+2j4Hz7mKYhH7w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u9SueBMzOXejq4Uuf2xnLbHALH/dXvc4/V0udCPkqPkU6clxZ/9u/BXIYQ5daKxf0
         xVNuneaETJqyf1yY5tLGnBLTpeIni0pSZqLk2yrVW1FKZ+tVs9RWmCGWAAdrzFBT5k
         oKZHy4OS6gJmfJCvd8XYfMbz5Kp46obsp8JO+xSdwWs6zZHfE/MN9Dq105gDdZjz5j
         XVjuwEeKKoBbQRr7WH9dL4FHOnhFUu6/Ufr8wZi+6ga55RaZ7HnXqY0/xIOt2MvRH8
         X2SfTYHYRvAd7Ig4H3ufwNemxoWH0NsbKuqYwIkKOrVZAGThwG5HfB/7x5kmuqXTih
         6sziyLdaTBlRQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Cl=C3=A9ment=20P=C3=A9ron?= <peron.clem@gmail.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Steven Price <steven.price@arm.com>,
        Sasha Levin <sashal@kernel.org>, robh@kernel.org,
        tomeu.vizoso@collabora.com, airlied@linux.ie, daniel@ffwll.ch,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.15 15/16] drm/panfrost: devfreq: set opp to the recommended one to configure regulator
Date:   Wed, 14 Sep 2022 05:02:23 -0400
Message-Id: <20220914090224.470913-15-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220914090224.470913-1-sashal@kernel.org>
References: <20220914090224.470913-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
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

From: Clément Péron <peron.clem@gmail.com>

[ Upstream commit d76034a427a2660b080bc155e4fd8f6393eefb48 ]

Enabling panfrost GPU OPP with dynamic regulator will make OPP
responsible to enable and configure it.

Unfortunately OPP configure and enable the regulator when an OPP
is asked to be set, which is not the case during
panfrost_devfreq_init().

This leave the regulator unconfigured and if no GPU load is
triggered, no OPP is asked to be set which make the regulator framework
switching it off during regulator_late_cleanup() without
noticing and therefore make the board hang as any access to GPU
memory space make bus locks up.

Call dev_pm_opp_set_opp() with the recommend OPP in
panfrost_devfreq_init() to enable the regulator, this will properly
configure and enable the regulator and will avoid any switch off
by regulator_late_cleanup().

Suggested-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Clément Péron <peron.clem@gmail.com>
Reviewed-by: Steven Price <steven.price@arm.com>
Signed-off-by: Steven Price <steven.price@arm.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20220906153034.153321-5-peron.clem@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panfrost/panfrost_devfreq.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/gpu/drm/panfrost/panfrost_devfreq.c b/drivers/gpu/drm/panfrost/panfrost_devfreq.c
index 194af7f607a6e..be36dd060a2b4 100644
--- a/drivers/gpu/drm/panfrost/panfrost_devfreq.c
+++ b/drivers/gpu/drm/panfrost/panfrost_devfreq.c
@@ -132,6 +132,17 @@ int panfrost_devfreq_init(struct panfrost_device *pfdev)
 		return PTR_ERR(opp);
 
 	panfrost_devfreq_profile.initial_freq = cur_freq;
+
+	/*
+	 * Set the recommend OPP this will enable and configure the regulator
+	 * if any and will avoid a switch off by regulator_late_cleanup()
+	 */
+	ret = dev_pm_opp_set_opp(dev, opp);
+	if (ret) {
+		DRM_DEV_ERROR(dev, "Couldn't set recommended OPP\n");
+		return ret;
+	}
+
 	dev_pm_opp_put(opp);
 
 	/*
-- 
2.35.1

