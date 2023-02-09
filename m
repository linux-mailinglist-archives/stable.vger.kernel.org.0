Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6926C6906C4
	for <lists+stable@lfdr.de>; Thu,  9 Feb 2023 12:20:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230427AbjBILU1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Feb 2023 06:20:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230379AbjBILTk (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Feb 2023 06:19:40 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0D4F5D1EC;
        Thu,  9 Feb 2023 03:17:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0718661A1B;
        Thu,  9 Feb 2023 11:17:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4185BC433D2;
        Thu,  9 Feb 2023 11:17:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675941440;
        bh=+vhK7e6XhuIH/Br9csMJjJgtHpt33A6BtnHyMAY8D0s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eWkbWtyBUtkbbyltFY6fTa7MMqZClr8rWL5FCPTKYqXgOKsXCsUJhN3mjYWk1LLB0
         8dgvV4btpYbq2GPqSI6nSejxxlsrPDN25ZbPTRXRKzmzBusfLPzlN4rBObM87dH2yJ
         D8xhlhwp+de9drlIX+7Wrnr+kOvl076BZUueCxsXVPJ1kXGbH/eu92cniZU/7hKB1B
         6E9kHO1DwJMEfAuo0KMlxxaXg/Q6WoRfFeIxCZwimyelhi9estBgAMgM2VHGxUmwUo
         KwWSUf4ICs5eeOqmiWhxFX7y+4amFYm8qZgXSApWBXXqyaO+jRnFhIxui+tnANyYLD
         GZrmD1bvf4sIg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yiqing Yao <yiqing.yao@amd.com>,
        Hawking Zhang <Hawking.Zhang@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, evan.quan@amd.com,
        christian.koenig@amd.com, Xinhui.Pan@amd.com, airlied@gmail.com,
        daniel@ffwll.ch, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 6.1 34/38] drm/amdgpu: Enable vclk dclk node for gc11.0.3
Date:   Thu,  9 Feb 2023 06:14:53 -0500
Message-Id: <20230209111459.1891941-34-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230209111459.1891941-1-sashal@kernel.org>
References: <20230209111459.1891941-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 236657eece477..a9170360d7e85 100644
--- a/drivers/gpu/drm/amd/pm/amdgpu_pm.c
+++ b/drivers/gpu/drm/amd/pm/amdgpu_pm.c
@@ -2007,14 +2007,16 @@ static int default_attr_update(struct amdgpu_device *adev, struct amdgpu_device_
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

