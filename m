Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 201AA69CE70
	for <lists+stable@lfdr.de>; Mon, 20 Feb 2023 14:59:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232713AbjBTN7S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Feb 2023 08:59:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232741AbjBTN7J (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Feb 2023 08:59:09 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5D741E9F6
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 05:58:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E6DF560EA9
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 13:58:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C38A3C433D2;
        Mon, 20 Feb 2023 13:58:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676901528;
        bh=azmU+k7UJ/E/AQqp94kZ+3zJYdz7y8e/T458A9QYbOI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2U2y+z4+NyWOGp/RogJe7PYOIIFweVdGLpZ1GGQMX3q82/49olLZnciqZNAEWWqbb
         p7vNGCIXobKCkpeQ55Y/Spq6IPL13KLDJwwZ7VfCK5BiWXQFNOcPGJp/u2Bsc+7Ud4
         kfpzSu0ELLYJ6gLSIdwiGXORCd4ntNDIHMJpTScE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, jfalempe@redhat.com,
        Jack Xiao <Jack.Xiao@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Feifei Xu <Feifei.Xu@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Evan Quan <evan.quan@amd.com>
Subject: [PATCH 6.1 051/118] drm/amd/amdgpu: fix warning during suspend
Date:   Mon, 20 Feb 2023 14:36:07 +0100
Message-Id: <20230220133602.499529823@linuxfoundation.org>
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

From: Jack Xiao <Jack.Xiao@amd.com>

commit 8f32378986218812083b127da5ba42d48297d7c4 upstream.

Freeing memory was warned during suspend.
Move the self test out of suspend.

Link: https://bugzilla.redhat.com/show_bug.cgi?id=2151825
Cc: jfalempe@redhat.com
Signed-off-by: Jack Xiao <Jack.Xiao@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Reviewed-by: Feifei Xu <Feifei.Xu@amd.com>
Reviewed-and-tested-by: Evan Quan <evan.quan@amd.com>
Tested-by: Jocelyn Falempe <jfalempe@redhat.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org # 6.1.x
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c |    3 +++
 drivers/gpu/drm/amd/amdgpu/mes_v11_0.c     |    2 +-
 2 files changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -4248,6 +4248,9 @@ int amdgpu_device_resume(struct drm_devi
 #endif
 	adev->in_suspend = false;
 
+	if (adev->enable_mes)
+		amdgpu_mes_self_test(adev);
+
 	if (amdgpu_acpi_smart_shift_update(dev, AMDGPU_SS_DEV_D0))
 		DRM_WARN("smart shift update failed\n");
 
--- a/drivers/gpu/drm/amd/amdgpu/mes_v11_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/mes_v11_0.c
@@ -1339,7 +1339,7 @@ static int mes_v11_0_late_init(void *han
 	struct amdgpu_device *adev = (struct amdgpu_device *)handle;
 
 	/* it's only intended for use in mes_self_test case, not for s0ix and reset */
-	if (!amdgpu_in_reset(adev) && !adev->in_s0ix &&
+	if (!amdgpu_in_reset(adev) && !adev->in_s0ix && !adev->in_suspend &&
 	    (adev->ip_versions[GC_HWIP][0] != IP_VERSION(11, 0, 3)))
 		amdgpu_mes_self_test(adev);
 


