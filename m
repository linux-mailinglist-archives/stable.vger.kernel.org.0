Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35E903DD96C
	for <lists+stable@lfdr.de>; Mon,  2 Aug 2021 16:00:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237001AbhHBOAU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Aug 2021 10:00:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:43028 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234291AbhHBN6P (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Aug 2021 09:58:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 13CB5610CC;
        Mon,  2 Aug 2021 13:55:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627912511;
        bh=pS5jcD3S2fm+uMBqOrdXI3F1v1qyPMs0J1KWeXKdWvw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cMbGsPyydQePmxqfYaBwoe/bd8CsOKL3lfFORbPpLBsUA00GE6OmwJVIpQnaHYuwV
         WKOjCHgGpTERS/o8ixTOpj/ZgJC25ORfcBTjbpUj4SDHC+KBoqrxYQzA8OULxOV5Lx
         o03dc43GLPk9bdh0g0lBdiGrwW2DsxKX8vZ6FRWs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lijo Lazar <Lijo.Lazar@amd.com>,
        Pratik Vishwakarma <Pratik.Vishwakarma@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.13 026/104] drm/amdgpu: Check pmops for desired suspend state
Date:   Mon,  2 Aug 2021 15:44:23 +0200
Message-Id: <20210802134344.882224526@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210802134344.028226640@linuxfoundation.org>
References: <20210802134344.028226640@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pratik Vishwakarma <Pratik.Vishwakarma@amd.com>

commit 91e273712ab8dd8c31924ac7714b21e011137e98 upstream.

[Why]
User might change the suspend behaviour from OS.

[How]
Check with pm for target suspend state and set s0ix
flag only for s2idle state.

v2: User might change default suspend state, use target state
v3: squash in build fix

Suggested-by: Lijo Lazar <Lijo.Lazar@amd.com>
Signed-off-by: Pratik Vishwakarma <Pratik.Vishwakarma@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c
@@ -26,6 +26,7 @@
 #include <linux/slab.h>
 #include <linux/power_supply.h>
 #include <linux/pm_runtime.h>
+#include <linux/suspend.h>
 #include <acpi/video.h>
 #include <acpi/actbl.h>
 
@@ -906,7 +907,7 @@ bool amdgpu_acpi_is_s0ix_supported(struc
 #if defined(CONFIG_AMD_PMC) || defined(CONFIG_AMD_PMC_MODULE)
 	if (acpi_gbl_FADT.flags & ACPI_FADT_LOW_POWER_S0) {
 		if (adev->flags & AMD_IS_APU)
-			return true;
+			return pm_suspend_target_state == PM_SUSPEND_TO_IDLE;
 	}
 #endif
 	return false;


