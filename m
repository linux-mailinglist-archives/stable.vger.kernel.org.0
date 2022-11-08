Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 696D36215DF
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 15:16:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235357AbiKHOQX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 09:16:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235354AbiKHOQW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 09:16:22 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA5E669DF2
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 06:16:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 22921CE1B98
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 14:16:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C288EC433C1;
        Tue,  8 Nov 2022 14:16:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667916978;
        bh=P/6WlaGvkIeJbrdeqXJRfGQ73dOtRH/GBt3yzBJBpZI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YSSy2SMRTnPp4mR8vChXfWAz8JbGDF3UxW7KDVMibvCllLM0sUA2syZIo+KxN2Kc6
         PLKEK5D7fIvQJ2bSJSmZBkhu94ixbBAFkci09DlN7gJqnlfiRKD7g2bue9sAfpEor+
         sMs0fb9GNk6w7+hxcv+yJx33J7NXgSV7DrSXh5oY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Graham Sider <Graham.Sider@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Harish Kasiviswanathan <Harish.Kasiviswanathan@amd.com>
Subject: [PATCH 6.0 192/197] drm/amdgpu: disable GFXOFF during compute for GFX11
Date:   Tue,  8 Nov 2022 14:40:30 +0100
Message-Id: <20221108133403.580396388@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133354.787209461@linuxfoundation.org>
References: <20221108133354.787209461@linuxfoundation.org>
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

From: Graham Sider <Graham.Sider@amd.com>

commit a3e5ce56f3d260f2ec8e5242c33f57e60ae9eba7 upstream.

Temporary workaround to fix issues observed in some compute applications
when GFXOFF is enabled on GFX11.

Signed-off-by: Graham Sider <Graham.Sider@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Harish Kasiviswanathan <Harish.Kasiviswanathan@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org # 6.0.x
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.c
@@ -703,6 +703,13 @@ err:
 
 void amdgpu_amdkfd_set_compute_idle(struct amdgpu_device *adev, bool idle)
 {
+	/* Temporary workaround to fix issues observed in some
+	 * compute applications when GFXOFF is enabled on GFX11.
+	 */
+	if (IP_VERSION_MAJ(adev->ip_versions[GC_HWIP][0]) == 11) {
+		pr_debug("GFXOFF is %s\n", idle ? "enabled" : "disabled");
+		amdgpu_gfx_off_ctrl(adev, idle);
+	}
 	amdgpu_dpm_switch_power_profile(adev,
 					PP_SMC_POWER_PROFILE_COMPUTE,
 					!idle);


