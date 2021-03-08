Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75764330E1F
	for <lists+stable@lfdr.de>; Mon,  8 Mar 2021 13:36:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231924AbhCHMfU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Mar 2021 07:35:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:44200 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231981AbhCHMfH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Mar 2021 07:35:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 90A95651C9;
        Mon,  8 Mar 2021 12:35:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615206907;
        bh=LzbW4j5Qgv6KG8N46KH0GEZepSQlTDjEDLa1GjY9YKQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cPaPgIIzgS+pY58SFAUcLbSM4M8WaLw7+n1B12CCqElM/SOqf7C8y8CGA1g/wAmFj
         YZXgrfumel8SFN/41cHFGrqneJs6eFmv+1Q5wL1OIqwrEUJwJyVqe/hwdmAZ3iXrUM
         QWZW7shHpaqVeL2RXF6zskxZLQxXsbMhiVo8SyRM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guchun Chen <guchun.chen@amd.com>,
        "Asher.Song" <Asher.Song@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.10 21/42] drm/amdgpu:disable VCN for Navi12 SKU
Date:   Mon,  8 Mar 2021 13:30:47 +0100
Message-Id: <20210308122719.171442111@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210308122718.120213856@linuxfoundation.org>
References: <20210308122718.120213856@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Asher.Song <Asher.Song@amd.com>

commit 0c61ac8134ffc851681ce5d4bd60d97c3d5aed27 upstream.

Navi12 0x7360/C7 SKU has no video support, so remove it.

Reviewed-by: Guchun Chen <guchun.chen@amd.com>
Signed-off-by: Asher.Song <Asher.Song@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/nv.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/nv.c
+++ b/drivers/gpu/drm/amd/amdgpu/nv.c
@@ -459,7 +459,8 @@ static bool nv_is_headless_sku(struct pc
 {
 	if ((pdev->device == 0x731E &&
 	    (pdev->revision == 0xC6 || pdev->revision == 0xC7)) ||
-	    (pdev->device == 0x7340 && pdev->revision == 0xC9))
+	    (pdev->device == 0x7340 && pdev->revision == 0xC9)  ||
+	    (pdev->device == 0x7360 && pdev->revision == 0xC7))
 		return true;
 	return false;
 }
@@ -524,7 +525,8 @@ int nv_set_ip_blocks(struct amdgpu_devic
 		if (adev->firmware.load_type == AMDGPU_FW_LOAD_DIRECT &&
 		    !amdgpu_sriov_vf(adev))
 			amdgpu_device_ip_block_add(adev, &smu_v11_0_ip_block);
-		amdgpu_device_ip_block_add(adev, &vcn_v2_0_ip_block);
+		if (!nv_is_headless_sku(adev->pdev))
+		        amdgpu_device_ip_block_add(adev, &vcn_v2_0_ip_block);
 		if (!amdgpu_sriov_vf(adev))
 			amdgpu_device_ip_block_add(adev, &jpeg_v2_0_ip_block);
 		break;


