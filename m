Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA3F96157FA
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 03:42:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230308AbiKBCml (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 22:42:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230307AbiKBCml (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 22:42:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 964DC20BCE
        for <stable@vger.kernel.org>; Tue,  1 Nov 2022 19:42:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4B062B82073
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 02:42:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A511C433D6;
        Wed,  2 Nov 2022 02:42:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667356958;
        bh=ulIENH84dpY7yhoEl1hGG0yEwxV6h8w5IMjtdNAv3E4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jTkmIyZWgtUMlkJZwmZTIfo8UFxRYNe921MZHwocSZr7EOeFoBnUv9HkZ0xJRkUzg
         j/Bt3DRGiszo72ihqPokfh0IjGiazP4RdxVwOGTrZCQXzATN7Y/HGLr0Fx0X0h7f1C
         /dOahcSOcoryIMoIP+7NyAdGqVdde0E4uTaG0hxI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Prike Liang <Prike.Liang@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.0 062/240] drm/amdgpu: disallow gfxoff until GC IP blocks complete s2idle resume
Date:   Wed,  2 Nov 2022 03:30:37 +0100
Message-Id: <20221102022112.803438027@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022111.398283374@linuxfoundation.org>
References: <20221102022111.398283374@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Prike Liang <Prike.Liang@amd.com>

commit d61e1d1d5225a9baeb995bcbdb904f66f70ed87e upstream.

In the S2idle suspend/resume phase the gfxoff is keeping functional so
some IP blocks will be likely to reinitialize at gfxoff entry and that
will result in failing to program GC registers.Therefore, let disallow
gfxoff until AMDGPU IPs reinitialized completely.

Signed-off-by: Prike Liang <Prike.Liang@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org # 5.15.x
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -3208,6 +3208,15 @@ static int amdgpu_device_ip_resume_phase
 			return r;
 		}
 		adev->ip_blocks[i].status.hw = true;
+
+		if (adev->in_s0ix && adev->ip_blocks[i].version->type == AMD_IP_BLOCK_TYPE_SMC) {
+			/* disable gfxoff for IP resume. The gfxoff will be re-enabled in
+			 * amdgpu_device_resume() after IP resume.
+			 */
+			amdgpu_gfx_off_ctrl(adev, false);
+			DRM_DEBUG("will disable gfxoff for re-initializing other blocks\n");
+		}
+
 	}
 
 	return 0;
@@ -4180,6 +4189,13 @@ int amdgpu_device_resume(struct drm_devi
 	/* Make sure IB tests flushed */
 	flush_delayed_work(&adev->delayed_init_work);
 
+	if (adev->in_s0ix) {
+		/* re-enable gfxoff after IP resume. This re-enables gfxoff after
+		 * it was disabled for IP resume in amdgpu_device_ip_resume_phase2().
+		 */
+		amdgpu_gfx_off_ctrl(adev, true);
+		DRM_DEBUG("will enable gfxoff for the mission mode\n");
+	}
 	if (fbcon)
 		drm_fb_helper_set_suspend_unlocked(adev_to_drm(adev)->fb_helper, false);
 


