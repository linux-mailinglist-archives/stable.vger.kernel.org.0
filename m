Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 426F465D9BB
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 17:28:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239813AbjADQ2F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 11:28:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240024AbjADQ1e (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 11:27:34 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C2F83F136
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 08:27:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 22240617A8
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 16:27:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FE68C433EF;
        Wed,  4 Jan 2023 16:27:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672849641;
        bh=otsHJIKptbLaNqeWlZec4N1QzHhuNXO9Kpw73I26GBg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ggscFnEWtMvWVYxt1kr8yngC/g7oGqeqDp4leiOErsdnL2RDBuFXeWa2uE4cliur8
         Kg57Kot2d7UarMx4tW7temHinykPIjZuB4YccYaA9ES9/L7IlPs1TIGvbIfXGSo5Bi
         YPRUN0HeVKHWBdy4W29Bcl4GJ16cPeeMAdjB3zJU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Luben Tuikov <luben.tuikov@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.0 170/177] drm/amdgpu: handle polaris10/11 overlap asics (v2)
Date:   Wed,  4 Jan 2023 17:07:41 +0100
Message-Id: <20230104160512.828442508@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230104160507.635888536@linuxfoundation.org>
References: <20230104160507.635888536@linuxfoundation.org>
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

From: Alex Deucher <alexander.deucher@amd.com>

commit 1d4624cd72b912b2680c08d0be48338a1629a858 upstream.

Some special polaris 10 chips overlap with the polaris11
DID range.  Handle this properly in the driver.

v2: use local flags for other function calls.

Acked-by: Luben Tuikov <luben.tuikov@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
@@ -2025,6 +2025,15 @@ static int amdgpu_pci_probe(struct pci_d
 			 "See modparam exp_hw_support\n");
 		return -ENODEV;
 	}
+	/* differentiate between P10 and P11 asics with the same DID */
+	if (pdev->device == 0x67FF &&
+	    (pdev->revision == 0xE3 ||
+	     pdev->revision == 0xE7 ||
+	     pdev->revision == 0xF3 ||
+	     pdev->revision == 0xF7)) {
+		flags &= ~AMD_ASIC_MASK;
+		flags |= CHIP_POLARIS10;
+	}
 
 	/* Due to hardware bugs, S/G Display on raven requires a 1:1 IOMMU mapping,
 	 * however, SME requires an indirect IOMMU mapping because the encryption
@@ -2094,12 +2103,12 @@ static int amdgpu_pci_probe(struct pci_d
 
 	pci_set_drvdata(pdev, ddev);
 
-	ret = amdgpu_driver_load_kms(adev, ent->driver_data);
+	ret = amdgpu_driver_load_kms(adev, flags);
 	if (ret)
 		goto err_pci;
 
 retry_init:
-	ret = drm_dev_register(ddev, ent->driver_data);
+	ret = drm_dev_register(ddev, flags);
 	if (ret == -EAGAIN && ++retry <= 3) {
 		DRM_INFO("retry init %d\n", retry);
 		/* Don't request EX mode too frequently which is attacking */


