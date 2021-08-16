Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 918A23ED51E
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 15:08:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237978AbhHPNI0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 09:08:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:58138 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236858AbhHPNGv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Aug 2021 09:06:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AA164610E8;
        Mon, 16 Aug 2021 13:06:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1629119176;
        bh=WbJqhSrA2ocgaRSNEopU1L/xoP4jtG1yFh5JF1j/a7k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z1SUEoYmvPXj0pIn9geloQW7+a5aSljj9GsIeUEbQ6Gnoza+nFqL2V0B1yDz4Twrm
         xwZ7ZjIUaifd3UHRSNWUWAKaXZaFc933Ir50W75596jWgPQXu3qxe8us6zHexUfWrm
         tlJOQDtux29IUMNVF1xgCGtw6WrLM5L020VAURdY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Evan Quan <evan.quan@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.10 21/96] drm/amdgpu: dont enable baco on boco platforms in runpm
Date:   Mon, 16 Aug 2021 15:01:31 +0200
Message-Id: <20210816125435.634469297@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210816125434.948010115@linuxfoundation.org>
References: <20210816125434.948010115@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Deucher <alexander.deucher@amd.com>

commit 202ead5a3c589b0594a75cb99f080174f6851fed upstream.

If the platform uses BOCO, don't use BACO in runtime suspend.
We could end up executing the BACO path if the platform supports
both.

Bug: https://gitlab.freedesktop.org/drm/amd/-/issues/1669
Reviewed-by: Evan Quan <evan.quan@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
@@ -1344,6 +1344,8 @@ static int amdgpu_pmops_runtime_suspend(
 			pci_set_power_state(pdev, PCI_D3cold);
 		}
 		drm_dev->switch_power_state = DRM_SWITCH_POWER_DYNAMIC_OFF;
+	} else if (amdgpu_device_supports_boco(drm_dev)) {
+		/* nothing to do */
 	} else if (amdgpu_device_supports_baco(drm_dev)) {
 		amdgpu_device_baco_enter(drm_dev);
 	}


