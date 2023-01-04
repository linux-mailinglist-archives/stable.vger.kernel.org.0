Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D707365D988
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 17:26:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239880AbjADQ0L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 11:26:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240019AbjADQZV (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 11:25:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 046E433D4D
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 08:25:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A1B6CB817B8
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 16:25:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCD5BC433D2;
        Wed,  4 Jan 2023 16:25:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672849510;
        bh=b8b29d6uUF5uatIFA5lMUaZBJaLCG3x6XpgDZhqgjbI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=akTPVpA3XdGLA+2TNJQ1zMPj764wDmzMh4OBQ4eWLkwkq0rOxnU+VrTl7lwR/7Y7+
         VsPn2vieJAarf4t90XAaSVfClUr3Q7FUyHlSzg7rpgMr8aSqbbNyichKT2ZbiqktCi
         hZKGaK2o4tBeCcGvnHryWyRZa8oGWE2/9hiW6xKk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Luben Tuikov <luben.tuikov@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.1 200/207] drm/amdgpu: handle polaris10/11 overlap asics (v2)
Date:   Wed,  4 Jan 2023 17:07:38 +0100
Message-Id: <20230104160518.258001076@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230104160511.905925875@linuxfoundation.org>
References: <20230104160511.905925875@linuxfoundation.org>
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
@@ -2040,6 +2040,15 @@ static int amdgpu_pci_probe(struct pci_d
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
@@ -2109,12 +2118,12 @@ static int amdgpu_pci_probe(struct pci_d
 
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


