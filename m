Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE82766C50E
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:01:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231805AbjAPQBF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:01:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231470AbjAPQBD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:01:03 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77DC0193DD
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:01:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 32678B8105F
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:01:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95CB8C433D2;
        Mon, 16 Jan 2023 16:00:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673884858;
        bh=CAENawXkmGIikTgQaoNQNaa2aMRkxqXC9VP92b9laqY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FyBTBwADKLm0ZLxzI8mza8t/ChFA4RmBCirPUy3V6uvd0t4a4IGm7sO9sFTC7KQBa
         wYA3cHHzS+t6AF/7uz3Ej930SV71TAb5atshJ5zKZlJzFeBbPw+jL8YEyE9e6UQMVI
         4blYPzlQxt9eMoQ9k9jGxx58s1LPwDu4cY6etyZk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Alex Deucher <Alexander.Deucher@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        AMD Graphics <amd-gfx@lists.freedesktop.org>,
        Dan Carpenter <error27@gmail.com>,
        kernel test robot <lkp@intel.com>,
        Luben Tuikov <luben.tuikov@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 138/183] drm/amdgpu: Fix potential NULL dereference
Date:   Mon, 16 Jan 2023 16:51:01 +0100
Message-Id: <20230116154809.201264284@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154803.321528435@linuxfoundation.org>
References: <20230116154803.321528435@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Luben Tuikov <luben.tuikov@amd.com>

[ Upstream commit 0be7ed8e7eb15282b5d0f6fdfea884db594ea9bf ]

Fix potential NULL dereference, in the case when "man", the resource manager
might be NULL, when/if we print debug information.

Cc: Alex Deucher <Alexander.Deucher@amd.com>
Cc: Christian König <christian.koenig@amd.com>
Cc: AMD Graphics <amd-gfx@lists.freedesktop.org>
Cc: Dan Carpenter <error27@gmail.com>
Cc: kernel test robot <lkp@intel.com>
Fixes: 7554886daa31ea ("drm/amdgpu: Fix size validation for non-exclusive domains (v4)")
Signed-off-by: Luben Tuikov <luben.tuikov@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_object.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_object.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_object.c
index 3be3cba3a16d..cfd78c4a45ba 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_object.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_object.c
@@ -468,8 +468,9 @@ static bool amdgpu_bo_validate_size(struct amdgpu_device *adev,
 	return true;
 
 fail:
-	DRM_DEBUG("BO size %lu > total memory in domain: %llu\n", size,
-		  man->size);
+	if (man)
+		DRM_DEBUG("BO size %lu > total memory in domain: %llu\n", size,
+			  man->size);
 	return false;
 }
 
-- 
2.35.1



