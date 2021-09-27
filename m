Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AC8A419ABA
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 19:10:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235839AbhI0RLt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 13:11:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:46362 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236198AbhI0RJu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Sep 2021 13:09:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 02E4660F46;
        Mon, 27 Sep 2021 17:07:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632762456;
        bh=xfECexUdKNbdFGlTds2HVqNsA8qj7QcE2q8SsBxctLk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jP9ERfoOm8g76kA0QSKGFnkywdURkwXFneY2SS7iFh43GNSnO9/+3/a/BxE/UH3D8
         l3bOPx0lXOjALFesSEN50xhthCt/Y7ClrxU0y42fdqeJVG8w/UdDSMb0YODJLBtGlu
         irjsjd3iyfrQr8F8MGJxEu+iB/KPbnF3FSXhFdSA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lijo Lazar <lijo.lazar@amd.com>,
        Hawking Zhang <Hawking.Zhang@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.10 030/103] drm/amd/pm: Update intermediate power state for SI
Date:   Mon, 27 Sep 2021 19:02:02 +0200
Message-Id: <20210927170226.785342122@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210927170225.702078779@linuxfoundation.org>
References: <20210927170225.702078779@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lijo Lazar <lijo.lazar@amd.com>

commit ab39d3cef526ba09c4c6923b4cd7e6ec1c5d4faa upstream.

Update the current state as boot state during dpm initialization.
During the subsequent initialization, set_power_state gets called to
transition to the final power state. set_power_state refers to values
from the current state and without current state populated, it could
result in NULL pointer dereference.

For ex: on platforms where PCI speed change is supported through ACPI
ATCS method, the link speed of current state needs to be queried before
deciding on changing to final power state's link speed. The logic to query
ATCS-support was broken on certain platforms. The issue became visible
when broken ATCS-support logic got fixed with commit
f9b7f3703ff9 ("drm/amdgpu/acpi: make ATPX/ATCS structures global (v2)").

Bug: https://gitlab.freedesktop.org/drm/amd/-/issues/1698

Signed-off-by: Lijo Lazar <lijo.lazar@amd.com>
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/pm/powerplay/si_dpm.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/gpu/drm/amd/pm/powerplay/si_dpm.c
+++ b/drivers/gpu/drm/amd/pm/powerplay/si_dpm.c
@@ -6870,6 +6870,8 @@ static int si_dpm_enable(struct amdgpu_d
 	si_enable_auto_throttle_source(adev, AMDGPU_DPM_AUTO_THROTTLE_SRC_THERMAL, true);
 	si_thermal_start_thermal_controller(adev);
 
+	ni_update_current_ps(adev, boot_ps);
+
 	return 0;
 }
 


