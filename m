Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5707C40DAAA
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 15:06:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239810AbhIPNHy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 09:07:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:57502 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239495AbhIPNHy (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 09:07:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A1027606A5;
        Thu, 16 Sep 2021 13:06:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631797594;
        bh=JCg5ueJr29Z+ir+uvZo/6FS7DRMnZxGvUMpTLFR6BN4=;
        h=Subject:To:Cc:From:Date:From;
        b=x/oqxqT6Hx5d0xZ4naCrdtaM34JSpkc0J16b4lCA0/TeB2x2P++ENoYFd/nu8c8wE
         5XNc0mHa6SDQORExhLnr/BLSPkiLzIObwQwFs+qzJLV5kc4klNCKFWXdCKU3v+scTt
         W4JvQF4bqb06+jIRecDQNwPk9diWI3noscjqkDkw=
Subject: FAILED: patch "[PATCH] drm/amdgpu: Fix build with missing pm_suspend_target_state" failed to apply to 5.14-stable tree
To:     bp@suse.de, alexander.deucher@amd.com, lijo.lazar@amd.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 16 Sep 2021 15:06:31 +0200
Message-ID: <163179759115270@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From a47f6a5806da4f24fbb66148a1519bf72fe060db Mon Sep 17 00:00:00 2001
From: Borislav Petkov <bp@suse.de>
Date: Tue, 24 Aug 2021 11:42:47 +0200
Subject: [PATCH] drm/amdgpu: Fix build with missing pm_suspend_target_state
 module export

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

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c
index 260ba01d303e..4811b0faafd9 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c
@@ -1040,7 +1040,7 @@ void amdgpu_acpi_detect(void)
  */
 bool amdgpu_acpi_is_s0ix_active(struct amdgpu_device *adev)
 {
-#if IS_ENABLED(CONFIG_AMD_PMC) && IS_ENABLED(CONFIG_PM_SLEEP)
+#if IS_ENABLED(CONFIG_AMD_PMC) && IS_ENABLED(CONFIG_SUSPEND)
 	if (acpi_gbl_FADT.flags & ACPI_FADT_LOW_POWER_S0) {
 		if (adev->flags & AMD_IS_APU)
 			return pm_suspend_target_state == PM_SUSPEND_TO_IDLE;

