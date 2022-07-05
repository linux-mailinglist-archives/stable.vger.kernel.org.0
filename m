Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A26EE566D03
	for <lists+stable@lfdr.de>; Tue,  5 Jul 2022 14:21:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231658AbiGEMUn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jul 2022 08:20:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237518AbiGEMTS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jul 2022 08:19:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDF7C1D0FF;
        Tue,  5 Jul 2022 05:14:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 87745B817AC;
        Tue,  5 Jul 2022 12:14:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE92AC341C7;
        Tue,  5 Jul 2022 12:14:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657023294;
        bh=OTmZADZLWKyTXoVEvZlu6VSqwHjC1HlNN1ln2kDxW2A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dQHCelNNeEIyW5z7mfWY8gp6o+eYNWJ3DkLlpQlb//hsbLf8pC4yKhw6w8vCtk6Ra
         0Ix2clyh59wtzcgKkHtSiWJBz4bjsU9Kgdc7yPL6r8nUuGF0JCT2LqioEYTEzm3sB2
         tuPzekqm+vx1cFiBrd6drGsizJr+NzojgkDfsIF4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guchun Chen <guchun.chen@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.18 001/102] drm/amdgpu: fix adev variable used in amdgpu_device_gpu_recover()
Date:   Tue,  5 Jul 2022 13:57:27 +0200
Message-Id: <20220705115618.454736735@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220705115618.410217782@linuxfoundation.org>
References: <20220705115618.410217782@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Deucher <alexander.deucher@amd.com>

commit bbba251577b27422ebe173e1bd006424d6a8cfb3 upstream.

Use the correct adev variable for the drm_fb_helper in
amdgpu_device_gpu_recover().  Noticed by inspection.

Fixes: 087451f372bf ("drm/amdgpu: use generic fb helpers instead of setting up AMD own's.")
Reviewed-by: Guchun Chen <guchun.chen@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -5140,7 +5140,7 @@ int amdgpu_device_gpu_recover_imp(struct
 		 */
 		amdgpu_unregister_gpu_instance(tmp_adev);
 
-		drm_fb_helper_set_suspend_unlocked(adev_to_drm(adev)->fb_helper, true);
+		drm_fb_helper_set_suspend_unlocked(adev_to_drm(tmp_adev)->fb_helper, true);
 
 		/* disable ras on ALL IPs */
 		if (!need_emergency_restart &&


