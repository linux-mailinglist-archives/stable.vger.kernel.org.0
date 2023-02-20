Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3C7069CE8A
	for <lists+stable@lfdr.de>; Mon, 20 Feb 2023 15:00:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232717AbjBTOAG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Feb 2023 09:00:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232711AbjBTOAG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Feb 2023 09:00:06 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 367391EFD5
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 05:59:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5E40DB80D44
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 13:59:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAF30C433D2;
        Mon, 20 Feb 2023 13:59:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676901567;
        bh=lIhkI8m9T+DERshfUzGDlJgWYJOeAQuB6TTNFot7Eyk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dNkpthL4dMsLyE0Vv6GxEoVKPhZkHzNA6+t4inBSD6oOA6O+PCPWyJU9E6xmiSkCY
         0BkkM/RUqLaUEPzjlhOhlPkrSErQGcmfkXtk/tifKV1uy10clgFdQBwo4LY5rv7gzd
         XPIEoJ/jVeW0ewYEcq5CNL7mexvK1Sh2OT+JIvfM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yiqing Yao <yiqing.yao@amd.com>,
        Hawking Zhang <Hawking.Zhang@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 038/118] drm/amdgpu: Enable vclk dclk node for gc11.0.3
Date:   Mon, 20 Feb 2023 14:35:54 +0100
Message-Id: <20230220133601.972022619@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133600.368809650@linuxfoundation.org>
References: <20230220133600.368809650@linuxfoundation.org>
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

From: Yiqing Yao <yiqing.yao@amd.com>

[ Upstream commit ac7170082c0e140663f0853d3de733a5341ce7b0 ]

These sysfs nodes are tested supported, so enable them.

Signed-off-by: Yiqing Yao <yiqing.yao@amd.com>
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/pm/amdgpu_pm.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/pm/amdgpu_pm.c b/drivers/gpu/drm/amd/pm/amdgpu_pm.c
index 41635694e5216..2f3e239e623dc 100644
--- a/drivers/gpu/drm/amd/pm/amdgpu_pm.c
+++ b/drivers/gpu/drm/amd/pm/amdgpu_pm.c
@@ -2009,14 +2009,16 @@ static int default_attr_update(struct amdgpu_device *adev, struct amdgpu_device_
 		      gc_ver == IP_VERSION(10, 3, 0) ||
 		      gc_ver == IP_VERSION(10, 1, 2) ||
 		      gc_ver == IP_VERSION(11, 0, 0) ||
-		      gc_ver == IP_VERSION(11, 0, 2)))
+		      gc_ver == IP_VERSION(11, 0, 2) ||
+		      gc_ver == IP_VERSION(11, 0, 3)))
 			*states = ATTR_STATE_UNSUPPORTED;
 	} else if (DEVICE_ATTR_IS(pp_dpm_dclk)) {
 		if (!(gc_ver == IP_VERSION(10, 3, 1) ||
 		      gc_ver == IP_VERSION(10, 3, 0) ||
 		      gc_ver == IP_VERSION(10, 1, 2) ||
 		      gc_ver == IP_VERSION(11, 0, 0) ||
-		      gc_ver == IP_VERSION(11, 0, 2)))
+		      gc_ver == IP_VERSION(11, 0, 2) ||
+		      gc_ver == IP_VERSION(11, 0, 3)))
 			*states = ATTR_STATE_UNSUPPORTED;
 	} else if (DEVICE_ATTR_IS(pp_power_profile_mode)) {
 		if (amdgpu_dpm_get_power_profile_mode(adev, NULL) == -EOPNOTSUPP)
-- 
2.39.0



