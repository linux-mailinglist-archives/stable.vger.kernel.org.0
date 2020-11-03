Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B8612A529D
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 21:51:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731951AbgKCUvc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 15:51:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:46670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731971AbgKCUv2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:51:28 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7953620719;
        Tue,  3 Nov 2020 20:51:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604436688;
        bh=wVLLopMnkUunpVigXiTm5cdhAoAq2FHLPwHRt6HrWNA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a+dS2TxD/ow9madbE4zZeDbvhishV/a/WWnuOOFCfErOJUIy9tgaPyzpt32p8tXYq
         JKNjfiTF6tOYDRlivc63NcxC5vW1hB30lklzUaltOCgY5dxbawFbEsL8MBhss5qqVU
         hgPbe/JNVcsggccO6mkPBwOa/7OkjQb8vcB2lw1g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andrey Grodzovsky <andrey.grodzovsky@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.9 360/391] drm/amd/psp: Fix sysfs: cannot create duplicate filename
Date:   Tue,  3 Nov 2020 21:36:51 +0100
Message-Id: <20201103203411.429637272@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203348.153465465@linuxfoundation.org>
References: <20201103203348.153465465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrey Grodzovsky <andrey.grodzovsky@amd.com>

commit f1bcddffe46b349a82445a8d9efd5f5fcb72557f upstream.

psp sysfs not cleaned up on driver unload for sienna_cichlid

Fixes: ce87c98db428e7 ("drm/amdgpu: Include sienna_cichlid in USBC PD FW support.")
Signed-off-by: Andrey Grodzovsky <andrey.grodzovsky@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org # 5.9.x
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>


---
 drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
@@ -206,7 +206,8 @@ static int psp_sw_fini(void *handle)
 		adev->psp.ta_fw = NULL;
 	}
 
-	if (adev->asic_type == CHIP_NAVI10)
+	if (adev->asic_type == CHIP_NAVI10 ||
+	    adev->asic_type == CHIP_SIENNA_CICHLID)
 		psp_sysfs_fini(adev);
 
 	return 0;


