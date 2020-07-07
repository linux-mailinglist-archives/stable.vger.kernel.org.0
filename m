Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AC69217209
	for <lists+stable@lfdr.de>; Tue,  7 Jul 2020 17:43:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728982AbgGGP2A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jul 2020 11:28:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:40896 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728891AbgGGP0f (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jul 2020 11:26:35 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 839DA2082E;
        Tue,  7 Jul 2020 15:26:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594135595;
        bh=0cZEtpLDgDWLJJYDX5oYDaxVIe3w12K+915qYrRErDg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XAT8fH1QdCgXmUaFii5mDwv5BZeTCITjgTskm/FloVPAgY1OD18kda/TERHrSjv3D
         bP5IFfdFgWDkCRsph9jSw25AFRqZ3W4XLVwIzf7whafiap45mxzc+BHURjTFFSaLq5
         2AibV75B4zqdMSruXtZkbcyLemHSfiUchXvC4HgM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ivan Mironov <mironov.ivan@gmail.com>,
        Bjorn Nostvold <bjorn.nostvold@gmail.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.7 103/112] drm/amd/powerplay: Fix NULL dereference in lock_bus() on Vega20 w/o RAS
Date:   Tue,  7 Jul 2020 17:17:48 +0200
Message-Id: <20200707145805.877030566@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200707145800.925304888@linuxfoundation.org>
References: <20200707145800.925304888@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ivan Mironov <mironov.ivan@gmail.com>

commit 7e89e4aaa9ae83107d059c186955484b3aa6eb23 upstream.

I updated my system with Radeon VII from kernel 5.6 to kernel 5.7, and
following started to happen on each boot:

	...
	BUG: kernel NULL pointer dereference, address: 0000000000000128
	...
	CPU: 9 PID: 1940 Comm: modprobe Tainted: G            E     5.7.2-200.im0.fc32.x86_64 #1
	Hardware name: System manufacturer System Product Name/PRIME X570-P, BIOS 1407 04/02/2020
	RIP: 0010:lock_bus+0x42/0x60 [amdgpu]
	...
	Call Trace:
	 i2c_smbus_xfer+0x3d/0xf0
	 i2c_default_probe+0xf3/0x130
	 i2c_detect.isra.0+0xfe/0x2b0
	 ? kfree+0xa3/0x200
	 ? kobject_uevent_env+0x11f/0x6a0
	 ? i2c_detect.isra.0+0x2b0/0x2b0
	 __process_new_driver+0x1b/0x20
	 bus_for_each_dev+0x64/0x90
	 ? 0xffffffffc0f34000
	 i2c_register_driver+0x73/0xc0
	 do_one_initcall+0x46/0x200
	 ? _cond_resched+0x16/0x40
	 ? kmem_cache_alloc_trace+0x167/0x220
	 ? do_init_module+0x23/0x260
	 do_init_module+0x5c/0x260
	 __do_sys_init_module+0x14f/0x170
	 do_syscall_64+0x5b/0xf0
	 entry_SYSCALL_64_after_hwframe+0x44/0xa9
	...

Error appears when some i2c device driver tries to probe for devices
using adapter registered by `smu_v11_0_i2c_eeprom_control_init()`.
Code supporting this adapter requires `adev->psp.ras.ras` to be not
NULL, which is true only when `amdgpu_ras_init()` detects HW support by
calling `amdgpu_ras_check_supported()`.

Before 9015d60c9ee1, adapter was registered by

	-> amdgpu_device_ip_init()
	  -> amdgpu_ras_recovery_init()
	    -> amdgpu_ras_eeprom_init()
	      -> smu_v11_0_i2c_eeprom_control_init()

after verifying that `adev->psp.ras.ras` is not NULL in
`amdgpu_ras_recovery_init()`. Currently it is registered
unconditionally by

	-> amdgpu_device_ip_init()
	  -> pp_sw_init()
	    -> hwmgr_sw_init()
	      -> vega20_smu_init()
	        -> smu_v11_0_i2c_eeprom_control_init()

Fix simply adds HW support check (ras == NULL => no support) before
calling `smu_v11_0_i2c_eeprom_control_{init,fini}()`.

Please note that there is a chance that similar fix is also required for
CHIP_ARCTURUS. I do not know whether any actual Arcturus hardware without
RAS exist, and whether calling `smu_i2c_eeprom_init()` makes any sense
when there is no HW support.

Cc: stable@vger.kernel.org
Fixes: 9015d60c9ee1 ("drm/amdgpu: Move EEPROM I2C adapter to amdgpu_device")
Signed-off-by: Ivan Mironov <mironov.ivan@gmail.com>
Tested-by: Bjorn Nostvold <bjorn.nostvold@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/amd/powerplay/smumgr/vega20_smumgr.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/amd/powerplay/smumgr/vega20_smumgr.c
+++ b/drivers/gpu/drm/amd/powerplay/smumgr/vega20_smumgr.c
@@ -508,9 +508,11 @@ static int vega20_smu_init(struct pp_hwm
 	priv->smu_tables.entry[TABLE_ACTIVITY_MONITOR_COEFF].version = 0x01;
 	priv->smu_tables.entry[TABLE_ACTIVITY_MONITOR_COEFF].size = sizeof(DpmActivityMonitorCoeffInt_t);
 
-	ret = smu_v11_0_i2c_eeprom_control_init(&adev->pm.smu_i2c);
-	if (ret)
-		goto err4;
+	if (adev->psp.ras.ras) {
+		ret = smu_v11_0_i2c_eeprom_control_init(&adev->pm.smu_i2c);
+		if (ret)
+			goto err4;
+	}
 
 	return 0;
 
@@ -546,7 +548,8 @@ static int vega20_smu_fini(struct pp_hwm
 			(struct vega20_smumgr *)(hwmgr->smu_backend);
 	struct amdgpu_device *adev = hwmgr->adev;
 
-	smu_v11_0_i2c_eeprom_control_fini(&adev->pm.smu_i2c);
+	if (adev->psp.ras.ras)
+		smu_v11_0_i2c_eeprom_control_fini(&adev->pm.smu_i2c);
 
 	if (priv) {
 		amdgpu_bo_free_kernel(&priv->smu_tables.entry[TABLE_PPTABLE].handle,


