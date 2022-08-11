Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39F1859003B
	for <lists+stable@lfdr.de>; Thu, 11 Aug 2022 17:40:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236305AbiHKPjf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Aug 2022 11:39:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236306AbiHKPjG (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Aug 2022 11:39:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 438E885AB2;
        Thu, 11 Aug 2022 08:34:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CF162615FB;
        Thu, 11 Aug 2022 15:34:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62493C433D7;
        Thu, 11 Aug 2022 15:34:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660232071;
        bh=C9M4r8tfAO7KFB5rS+Rx6lS06rRTzLkaPWrFYj/U2yA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FLbFyt3ndpRr9NdKtdy4VXq5pUrspvi9Yd8zQJHDokjG00rCVzkpiwE5375EjCMu3
         oif9ojcIYkm6zzU5ZmiHdU8CoNW4alGBH18octwaA2yR2zeVeqJdeCDC1aW6pWiCvj
         UZSyyvQdrvLhbo1k4W/HPa5IO5FA20iZZjj7U9gqaWWNmaJK7McGNrYhM0h84Z9O5a
         06zx2iylp+isfIP381sKc5ptzbnfkM9QJul6L12D+4as4oWQw4o8f3LieCIWoXPN/u
         qVPvC/7tmwy0WCVOozP3JN5AkcRFRDSj8ns3v/p/EnsBSQAYd3U/SFYoDmRCGIfmiV
         TQF6jHcvYgPeg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Stanley.Yang" <Stanley.Yang@amd.com>,
        Hawking Zhang <Hawking.Zhang@amd.com>,
        Tao Zhou <tao.zhou1@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, christian.koenig@amd.com,
        Xinhui.Pan@amd.com, airlied@linux.ie, daniel@ffwll.ch,
        YiPeng.Chai@amd.com, john.clements@amd.com, candice.li@amd.com,
        mukul.joshi@amd.com, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.19 057/105] drm/amdgpu: skip whole ras bad page framework on sriov
Date:   Thu, 11 Aug 2022 11:27:41 -0400
Message-Id: <20220811152851.1520029-57-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220811152851.1520029-1-sashal@kernel.org>
References: <20220811152851.1520029-1-sashal@kernel.org>
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

From: "Stanley.Yang" <Stanley.Yang@amd.com>

[ Upstream commit e0e146d5567317d6ba7d0169bed55d1d9ea05a61 ]

It should not init whole ras bad page framework on sriov guest side
due to it is handled on host side.

Signed-off-by: Stanley.Yang <Stanley.Yang@amd.com>
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Reviewed-by: Tao Zhou <tao.zhou1@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c
index dac202ae864d..465e7921bba1 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c
@@ -2148,7 +2148,7 @@ int amdgpu_ras_recovery_init(struct amdgpu_device *adev)
 	bool exc_err_limit = false;
 	int ret;
 
-	if (!con)
+	if (!con || amdgpu_sriov_vf(adev))
 		return 0;
 
 	/* Allow access to RAS EEPROM via debugfs, when the ASIC
-- 
2.35.1

