Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C11034CA0B
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:40:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234150AbhC2Ien (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:34:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:53538 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234733AbhC2Ide (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:33:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E3625614A7;
        Mon, 29 Mar 2021 08:33:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617006792;
        bh=1Q+B8OuN6vikby9De953jGy6Gtier1pII5MZSdQFi6Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0oMu+l+95tulx3vmZYHmQ4rsFf7JIrNrqbwbCHdB66b7a81txiihsgPXMEB5hoGYK
         gXD1OQ57kjIRIoAGPK2o+Jyv3uo3oL9BcO3kh6aVGU2tmL6abJ2s2VeDjjr/sZeNCs
         AGaD8Q2/+qfKmk5apflIEJN5tJ14lYFws6alfOGs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Prike Liang <Prike.Liang@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Huang Rui <ray.huang@amd.com>
Subject: [PATCH 5.11 099/254] drm/amdgpu: fix the hibernation suspend with s0ix
Date:   Mon, 29 Mar 2021 09:56:55 +0200
Message-Id: <20210329075636.449973882@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075633.135869143@linuxfoundation.org>
References: <20210329075633.135869143@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Prike Liang <Prike.Liang@amd.com>

commit 9aa26019c1a60013ea866d460de6392acb1712ee upstream.

During system hibernation suspend still need un-gate gfx CG/PG firstly to handle HW
status check before HW resource destory.

Signed-off-by: Prike Liang <Prike.Liang@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Acked-by: Huang Rui <ray.huang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -2666,7 +2666,7 @@ static int amdgpu_device_ip_suspend_phas
 {
 	int i, r;
 
-	if (adev->in_poweroff_reboot_com ||
+	if (adev->in_poweroff_reboot_com || adev->in_hibernate ||
 	    !amdgpu_acpi_is_s0ix_supported(adev) || amdgpu_in_reset(adev)) {
 		amdgpu_device_set_pg_state(adev, AMD_PG_STATE_UNGATE);
 		amdgpu_device_set_cg_state(adev, AMD_CG_STATE_UNGATE);
@@ -3727,7 +3727,11 @@ int amdgpu_device_suspend(struct drm_dev
 
 	amdgpu_fence_driver_suspend(adev);
 
-	if (adev->in_poweroff_reboot_com ||
+	/*
+	 * TODO: Need figure out the each GNB IP idle off dependency and then
+	 * improve the AMDGPU suspend/resume sequence for system-wide Sx entry/exit.
+	 */
+	if (adev->in_poweroff_reboot_com || adev->in_hibernate ||
 	    !amdgpu_acpi_is_s0ix_supported(adev) || amdgpu_in_reset(adev))
 		r = amdgpu_device_ip_suspend_phase2(adev);
 	else


