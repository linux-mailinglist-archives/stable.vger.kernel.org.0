Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F54720A35B
	for <lists+stable@lfdr.de>; Thu, 25 Jun 2020 18:51:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391017AbgFYQvU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Jun 2020 12:51:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390939AbgFYQvT (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Jun 2020 12:51:19 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A182C08C5C1;
        Thu, 25 Jun 2020 09:51:19 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id n24so7266479lji.10;
        Thu, 25 Jun 2020 09:51:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/UdLMEbsDOCR1U9pQ5KV9lzE5YZFu5bOJN7OeGkQDNQ=;
        b=ppexb1fEv8Sukf5p8oW35AQ2df2siKDT8RUubIHYQJDlyShZhvd04ibfyDJSBICwdu
         cqhBwt37T+fJ1T3WNXcxsG/70YEbQ2qK8UfAT3zkHBerQy5oCSwkHGYyK1BJlij2ij0x
         nXWdva+EENVDDUPUM+Ev5/VBwJR1IvXMrsciLTXU9GtqtMGyyYSg47ke13MD939Z3zfB
         lUlm/jM9Kpt+y9EnZQMPbtP9PyN6J+noskAdEQek45b9KT051oNZBIqakk14NLin+OU7
         eDoWPsSPv1j3iHF9NAlFp7h28mgDTeX3ZCgNSwrh56r2oaJJhLrgQTHzc++cf6031HCI
         dScQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/UdLMEbsDOCR1U9pQ5KV9lzE5YZFu5bOJN7OeGkQDNQ=;
        b=R4JeKoH2lkyfuu8qQw5/tXrvMD7t5qWu0e0OLImTDqNp2kJDCEHzI7+AYQCDi+IHNW
         zY5COPGfk5Ek4zN67g40LunyL5HfyO+fMUP5yrQwphmz53QJ+5QnMFdRxSmXK8OhpzdU
         D4h/2iiwPfYtpFzAo3Mt2GM1uvDnCm98DO/c1LAz+4XZ9Urj3TKDAMeV3NWu7324lQJt
         JsO3+8/1iAEKt+9uCmqZks384feo8klQIhu616Y7uYCi9FlXLCuDmbCSfWzpZTVTmKNR
         3SGokpPXwhET8KtyYL8AnVJmGV1Sdzki2EaZ8z4b5G5lpj/b310HZnZ3iduKJ1CpDPr8
         YYYA==
X-Gm-Message-State: AOAM532nejmAVcnIkvgT/nGLSu+KMcRML1huMk56vFN/SWTNTqhfvns+
        XdiWeY3//4vGz0kZReUQxEXf75rz+Tc=
X-Google-Smtp-Source: ABdhPJy+x+R/cxt2yvhXQOTLvfn7L5Omua0+PZfhzHADRJgLB5AIxhxHpzbxCSfoANT7Tedy5cE+GA==
X-Received: by 2002:a2e:8e8d:: with SMTP id z13mr5268182ljk.215.1593103877478;
        Thu, 25 Jun 2020 09:51:17 -0700 (PDT)
Received: from localhost (pool-109-191-188-200.is74.ru. [109.191.188.200])
        by smtp.gmail.com with ESMTPSA id n1sm4914636ljg.131.2020.06.25.09.51.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Jun 2020 09:51:16 -0700 (PDT)
From:   Ivan Mironov <mironov.ivan@gmail.com>
To:     amd-gfx@lists.freedesktop.org
Cc:     dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Andrey Grodzovsky <andrey.grodzovsky@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Evan Quan <evan.quan@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Ivan Mironov <mironov.ivan@gmail.com>, stable@vger.kernel.org,
        Bjorn Nostvold <bjorn.nostvold@gmail.com>
Subject: [PATCH v1] drm/amd/powerplay: Fix NULL dereference in lock_bus() on Vega20 w/o RAS
Date:   Thu, 25 Jun 2020 21:50:42 +0500
Message-Id: <20200625165042.13708-1-mironov.ivan@gmail.com>
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
Tested-by: Bjorn Nostvold <bjorn.nostvold@gmail.com>
---
Changelog:

v1:
  - Added "Tested-by" for another user who used this patch to fix the
    same issue.

v0:
  - Patch introduced.
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

