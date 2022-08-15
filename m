Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7E5859352D
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 20:28:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239687AbiHOSU7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 14:20:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240182AbiHOSTM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 14:19:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 434532BB28;
        Mon, 15 Aug 2022 11:16:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 49DB8B8106C;
        Mon, 15 Aug 2022 18:16:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94C78C433C1;
        Mon, 15 Aug 2022 18:16:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660587383;
        bh=SH+pC6vT7iDgd9abhCEoZEDCVetOpDBa2PhqZvIrB6Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gdfa/E1TsaydFF6g8GWqIThyqT8hYj+Xyd4Gtft7jcUfFkXDRbREMM3ets+6jMM1e
         GyrvMavsMb6vV4FF8fw8eWkV1b//hHLMRmXB5CuU/cQUhDYCVVMIO5ZsSJd9OpTFqg
         mHsM9jMD3BmTpzh8UyJQB07ERvVxqYndgw/WlPso=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        hgoffin@amazon.com, Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.15 069/779] drm/amdgpu: fix check in fbdev init
Date:   Mon, 15 Aug 2022 19:55:13 +0200
Message-Id: <20220815180340.239813219@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
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

From: Alex Deucher <alexander.deucher@amd.com>

The new vkms virtual display code is atomic so there is
no need to call drm_helper_disable_unused_functions()
when it is enabled.  Doing so can result in a segfault.
When the driver switched from the old virtual display code
to the new atomic virtual display code, it was missed that
we enable virtual display unconditionally under SR-IOV
so the checks here missed that case.  Add the missing
check for SR-IOV.

There is no equivalent of this patch for Linus' tree
because the relevant code no longer exists.  This patch
is only relevant to kernels 5.15 and 5.16.

Fixes: 84ec374bd580 ("drm/amdgpu: create amdgpu_vkms (v4)")
Cc: stable@vger.kernel.org # 5.15.x
Cc: hgoffin@amazon.com
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_fb.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_fb.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_fb.c
@@ -341,7 +341,8 @@ int amdgpu_fbdev_init(struct amdgpu_devi
 	}
 
 	/* disable all the possible outputs/crtcs before entering KMS mode */
-	if (!amdgpu_device_has_dc_support(adev) && !amdgpu_virtual_display)
+	if (!amdgpu_device_has_dc_support(adev) && !amdgpu_virtual_display &&
+	    !amdgpu_sriov_vf(adev))
 		drm_helper_disable_unused_functions(adev_to_drm(adev));
 
 	drm_fb_helper_initial_config(&rfbdev->helper, bpp_sel);


