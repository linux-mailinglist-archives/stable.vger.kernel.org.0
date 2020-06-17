Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F5D41FC2A7
	for <lists+stable@lfdr.de>; Wed, 17 Jun 2020 02:26:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726454AbgFQA0z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Jun 2020 20:26:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725894AbgFQA0z (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Jun 2020 20:26:55 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2FD6C061573;
        Tue, 16 Jun 2020 17:26:53 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id y11so681265ljm.9;
        Tue, 16 Jun 2020 17:26:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lEQf5F3W4qCJ4deQv/VzXA6SqhV/PIAqUDgAQqykNFY=;
        b=VSGXubUjoC6aZ/GL8vLA/sgMXbyYw4sEdfiq1ah7ZlhmgzlXVJxXOy+r/uJTl7g5f9
         /XTkUXXmPa0tuQ4HtcxIiYJbqHiZP1wm8qbefZaUr9+BNZvYHeqwBlnmrAlYEmYE6Sng
         m6tspP73JYarWyLVeqmgW9q17WSsL3ef/90c1pieee4kREP+HUw0ZbEb2JPpr9peXSII
         NU+2tXUS3bAvxXOl9bt9hB411bUtUIM1U/MNjj3WNVCcpknWg4xkTOI+JGKNKYk3bcNo
         jETlezpNJ8dvzk8gusFXZMNiDGt5ZhhdGZWZb2JK4UUsG2dUQ5O21YkXpg17c7lD6ZJQ
         SVbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lEQf5F3W4qCJ4deQv/VzXA6SqhV/PIAqUDgAQqykNFY=;
        b=BlZZL9NvxywCFgRz8fugijRIO15Vnb+v15+IjknT4/kZmG/jc9v8l7t/fEDvvM6cD+
         K5SBXV8dCayBjXpPxpLycOlO+XcMFvsW82DM8OjY6IlQ7Jp1Lj8aYrNPK2FXNU73SF6x
         gX7fwEdCE9K68ZqpXLq+a2FHMMITXH0Qkcw9Lof3XAWKi6dcMBlyv5T0CNDL62OMwR0c
         ePTfgjNlaHH/HMCZ3+fhUqNPt3oImfsf1XnaFKImjERZrXgsVZXdDo/3Qbycx7QkinLI
         mmEIXXY6WZ8YgsEi0VA/ShNuWjuvmK+9BiephiSixC4Qn07HDk/dRJBn4s/ZM48EzaPi
         w+/g==
X-Gm-Message-State: AOAM530s97ikKA6OUEnKP2Lud4lDnEoswwuAlbRDx+qG/y87KxYfdxrV
        cx8sWzQYYjvFPg/JKEa1Ljg=
X-Google-Smtp-Source: ABdhPJx/61Qe73HXhles5hdVAZmzzp3ui4DiMBM3iBrfiV/5FEpgE9dF+dD+BR8yXqCBrXAXQRL+RQ==
X-Received: by 2002:a2e:98d7:: with SMTP id s23mr2712729ljj.2.1592353612228;
        Tue, 16 Jun 2020 17:26:52 -0700 (PDT)
Received: from localhost (pool-109-191-188-200.is74.ru. [109.191.188.200])
        by smtp.gmail.com with ESMTPSA id v24sm427080lfo.4.2020.06.16.17.26.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Jun 2020 17:26:51 -0700 (PDT)
From:   Ivan Mironov <mironov.ivan@gmail.com>
To:     amd-gfx@lists.freedesktop.org
Cc:     dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Andrey Grodzovsky <andrey.grodzovsky@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Evan Quan <evan.quan@amd.com>,
        Ivan Mironov <mironov.ivan@gmail.com>, stable@vger.kernel.org
Subject: [PATCH] drm/amd/powerplay: Fix NULL dereference in lock_bus() on Vega20 w/o RAS
Date:   Wed, 17 Jun 2020 05:26:13 +0500
Message-Id: <20200617002613.67917-1-mironov.ivan@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
---
 drivers/gpu/drm/amd/powerplay/smumgr/vega20_smumgr.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/amd/powerplay/smumgr/vega20_smumgr.c b/drivers/gpu/drm/amd/powerplay/smumgr/vega20_smumgr.c
index 2fb97554134f..c2e0fbbccf56 100644
--- a/drivers/gpu/drm/amd/powerplay/smumgr/vega20_smumgr.c
+++ b/drivers/gpu/drm/amd/powerplay/smumgr/vega20_smumgr.c
@@ -522,9 +522,11 @@ static int vega20_smu_init(struct pp_hwmgr *hwmgr)
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
 
@@ -560,7 +562,8 @@ static int vega20_smu_fini(struct pp_hwmgr *hwmgr)
 			(struct vega20_smumgr *)(hwmgr->smu_backend);
 	struct amdgpu_device *adev = hwmgr->adev;
 
-	smu_v11_0_i2c_eeprom_control_fini(&adev->pm.smu_i2c);
+	if (adev->psp.ras.ras)
+		smu_v11_0_i2c_eeprom_control_fini(&adev->pm.smu_i2c);
 
 	if (priv) {
 		amdgpu_bo_free_kernel(&priv->smu_tables.entry[TABLE_PPTABLE].handle,
-- 
2.26.2

