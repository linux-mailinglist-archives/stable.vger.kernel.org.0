Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 913692FA91B
	for <lists+stable@lfdr.de>; Mon, 18 Jan 2021 19:43:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390688AbhARSmQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jan 2021 13:42:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:36204 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390647AbhARLk6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Jan 2021 06:40:58 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 692DB22D3E;
        Mon, 18 Jan 2021 11:40:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610970037;
        bh=OULd1rchyaJ3lu1ChmDbrGYh+3FoJzh29lklPIqjMyw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ln68LC25m0sry6JPfgm7aj3q1HBr8rEdl0Pw9DUL46A0Yw1kxh5we25EE/95S1W27
         DnrQkovflPNiDbPeDEkoietj2hegPKWJjfTPcNtgGm5ws5yVPk+dCYzxvgxLhvd7hI
         HETpyganBsqz0RAAPpZLrJ5ZsU/hUbLlKVb/ojO4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, mengwang <mengbing.wang@amd.com>,
        Huang Rui <ray.huang@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.10 011/152] drm/amdgpu: add new device id for Renior
Date:   Mon, 18 Jan 2021 12:33:06 +0100
Message-Id: <20210118113353.303089308@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210118113352.764293297@linuxfoundation.org>
References: <20210118113352.764293297@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: mengwang <mengbing.wang@amd.com>

commit 53f1e7f6a1720f8299b5283857eedc8f07d29533 upstream.

add DID 0x164C into pciidlist under CHIP_RENOIR family.

Signed-off-by: mengwang <mengbing.wang@amd.com>
Reviewed-by: Huang Rui <ray.huang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org # 5.10.x
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c |    1 +
 drivers/gpu/drm/amd/amdgpu/soc15.c      |    3 ++-
 2 files changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
@@ -1077,6 +1077,7 @@ static const struct pci_device_id pciidl
 	/* Renoir */
 	{0x1002, 0x1636, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_RENOIR|AMD_IS_APU},
 	{0x1002, 0x1638, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_RENOIR|AMD_IS_APU},
+	{0x1002, 0x164C, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_RENOIR|AMD_IS_APU},
 
 	/* Navi12 */
 	{0x1002, 0x7360, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_NAVI12},
--- a/drivers/gpu/drm/amd/amdgpu/soc15.c
+++ b/drivers/gpu/drm/amd/amdgpu/soc15.c
@@ -1242,7 +1242,8 @@ static int soc15_common_early_init(void
 		break;
 	case CHIP_RENOIR:
 		adev->asic_funcs = &soc15_asic_funcs;
-		if (adev->pdev->device == 0x1636)
+		if ((adev->pdev->device == 0x1636) ||
+		    (adev->pdev->device == 0x164c))
 			adev->apu_flags |= AMD_APU_IS_RENOIR;
 		else
 			adev->apu_flags |= AMD_APU_IS_GREEN_SARDINE;


