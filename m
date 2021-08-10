Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18C423E8189
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 20:01:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237088AbhHJSAP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 14:00:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:57246 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236861AbhHJRzs (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 13:55:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1492D6101E;
        Tue, 10 Aug 2021 17:44:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628617489;
        bh=U87jz2yLDcnwlfFLRwK6RNCPjxBmNIr2x/Ym20ZB4+4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hpdBici9wKHC7aK6LzQAvZvq/fRvh5KmuQVR6ngcRgsjKj6jsIADV909tVrAaOd/o
         EksA77uf0V3RAlw1/hp0pk19PZ9K7qbS4YBaJ7xbMn/KDVb/wd103q0bw179MeO6he
         gXr6T4VTGP9HV1n26ojLuQksuAYakHwG9YoI59cU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        Alex Deucher <alexander.deucher@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        "Pan, Xinhui" <Xinhui.Pan@amd.com>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, linux-next@vger.kernel.org
Subject: [PATCH 5.13 081/175] drm/amdgpu: fix checking pmops when PM_SLEEP is not enabled
Date:   Tue, 10 Aug 2021 19:29:49 +0200
Message-Id: <20210810173003.613302353@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210810173000.928681411@linuxfoundation.org>
References: <20210810173000.928681411@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

commit 5706cb3c910cc8283f344bc37a889a8d523a2c6d upstream.

'pm_suspend_target_state' is only available when CONFIG_PM_SLEEP
is set/enabled. OTOH, when both SUSPEND and HIBERNATION are not set,
PM_SLEEP is not set, so this variable cannot be used.

../drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c: In function ‘amdgpu_acpi_is_s0ix_active’:
../drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c:1046:11: error: ‘pm_suspend_target_state’ undeclared (first use in this function); did you mean ‘__KSYM_pm_suspend_target_state’?
    return pm_suspend_target_state == PM_SUSPEND_TO_IDLE;
           ^~~~~~~~~~~~~~~~~~~~~~~
           __KSYM_pm_suspend_target_state

Also use shorter IS_ENABLED(CONFIG_foo) notation for checking the
2 config symbols.

Fixes: 91e273712ab8dd ("drm/amdgpu: Check pmops for desired suspend state")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: Christian König <christian.koenig@amd.com>
Cc: "Pan, Xinhui" <Xinhui.Pan@amd.com>
Cc: amd-gfx@lists.freedesktop.org
Cc: dri-devel@lists.freedesktop.org
Cc: linux-next@vger.kernel.org
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c
@@ -904,7 +904,7 @@ void amdgpu_acpi_fini(struct amdgpu_devi
  */
 bool amdgpu_acpi_is_s0ix_supported(struct amdgpu_device *adev)
 {
-#if defined(CONFIG_AMD_PMC) || defined(CONFIG_AMD_PMC_MODULE)
+#if IS_ENABLED(CONFIG_AMD_PMC) && IS_ENABLED(CONFIG_PM_SLEEP)
 	if (acpi_gbl_FADT.flags & ACPI_FADT_LOW_POWER_S0) {
 		if (adev->flags & AMD_IS_APU)
 			return pm_suspend_target_state == PM_SUSPEND_TO_IDLE;


