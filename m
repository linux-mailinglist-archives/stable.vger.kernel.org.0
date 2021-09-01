Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B91F03FDC3D
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 15:18:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345136AbhIAMsN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 08:48:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:49846 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346005AbhIAMqL (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Sep 2021 08:46:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0CDC8610A1;
        Wed,  1 Sep 2021 12:39:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630499972;
        bh=dkmQky7MqGdCrJ2LkA6T01hj9azqS7CDCxRUQm6Gpd0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=adV1gsNaFE7rify3E97aAT5vyhnKKK60Ea53HuuXHPcrtiYkwYKcuWPSnNz3kXvhN
         Vcw/V7FHkuSVXP3BRjDmvO3CVl6EAhwva7nQ6K3nUtyMdmslS6wDb/59/DdJQp9rNf
         nUi0Qqs5616zKqga8ak55w/gt8fk28cUHDKaICFc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lijo Lazar <lijo.lazar@amd.com>,
        Borislav Petkov <bp@suse.de>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.13 027/113] drm/amdgpu: Fix build with missing pm_suspend_target_state module export
Date:   Wed,  1 Sep 2021 14:27:42 +0200
Message-Id: <20210901122302.904408427@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210901122301.984263453@linuxfoundation.org>
References: <20210901122301.984263453@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

commit c41a4e877a185241d8e83501453326fb98f67354 upstream.

Building a randconfig here triggered:

  ERROR: modpost: "pm_suspend_target_state" [drivers/gpu/drm/amd/amdgpu/amdgpu.ko] undefined!

because the module export of that symbol happens in
kernel/power/suspend.c which is enabled with CONFIG_SUSPEND.

The ifdef guards in amdgpu_acpi_is_s0ix_supported(), however, test for
CONFIG_PM_SLEEP which is defined like this:

  config PM_SLEEP
          def_bool y
          depends on SUSPEND || HIBERNATE_CALLBACKS

and that randconfig has:

  # CONFIG_SUSPEND is not set
  CONFIG_HIBERNATE_CALLBACKS=y

leading to the module export missing.

Change the ifdeffery to depend directly on CONFIG_SUSPEND.

Fixes: 5706cb3c910c ("drm/amdgpu: fix checking pmops when PM_SLEEP is not enabled")
Reviewed-by: Lijo Lazar <lijo.lazar@amd.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Link: https://lkml.kernel.org/r/YSP6Lv53QV0cOAsd@zn.tnic
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
-#if IS_ENABLED(CONFIG_AMD_PMC) && IS_ENABLED(CONFIG_PM_SLEEP)
+#if IS_ENABLED(CONFIG_AMD_PMC) && IS_ENABLED(CONFIG_SUSPEND)
 	if (acpi_gbl_FADT.flags & ACPI_FADT_LOW_POWER_S0) {
 		if (adev->flags & AMD_IS_APU)
 			return pm_suspend_target_state == PM_SUSPEND_TO_IDLE;


