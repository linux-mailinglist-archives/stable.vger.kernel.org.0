Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 236E56CC4A4
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 17:06:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233878AbjC1PGu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 11:06:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233877AbjC1PGs (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 11:06:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF73BBDF2
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 08:05:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 054A06184A
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 15:04:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1713AC433D2;
        Tue, 28 Mar 2023 15:04:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680015866;
        bh=pngvrPoAZ5sQwovWrZ2Et43HlzAY7YmPaBid4d9jo+w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W0RQpqa55RirlQFbQjMcfuAl8tyQlXoJL1po4rClvCwRXLuVTxTPF/y4EZl8RBEW+
         gBWHN3rfRqxHBymTIyarWot3ubsnQaoj7soiDcpGBo0LmRcjjiS6DM6bwNNM3a/i7J
         93q4BW/Eof6sUJb0lhADC1at5PoJlL86ENQHcEfc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Tim Huang <tim.huang@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.1 204/224] drm/amdgpu: skip ASIC reset for APUs when go to S4
Date:   Tue, 28 Mar 2023 16:43:20 +0200
Message-Id: <20230328142625.861872541@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142617.205414124@linuxfoundation.org>
References: <20230328142617.205414124@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tim Huang <tim.huang@amd.com>

commit b589626674de94d977e81c99bf7905872b991197 upstream.

For GC IP v11.0.4/11, PSP TMR need to be reserved
for ASIC mode2 reset. But for S4, when psp suspend,
it will destroy the TMR that fails the ASIC reset.

[  96.006101] amdgpu 0000:62:00.0: amdgpu: MODE2 reset
[  100.409717] amdgpu 0000:62:00.0: amdgpu: SMU: I'm not done with your previous command: SMN_C2PMSG_66:0x00000011 SMN_C2PMSG_82:0x00000002
[  100.411593] amdgpu 0000:62:00.0: amdgpu: Mode2 reset failed!
[  100.412470] amdgpu 0000:62:00.0: PM: pci_pm_freeze(): amdgpu_pmops_freeze+0x0/0x50 [amdgpu] returns -62
[  100.414020] amdgpu 0000:62:00.0: PM: dpm_run_callback(): pci_pm_freeze+0x0/0xd0 returns -62
[  100.415311] amdgpu 0000:62:00.0: PM: pci_pm_freeze+0x0/0xd0 returned -62 after 4623202 usecs
[  100.416608] amdgpu 0000:62:00.0: PM: failed to freeze async: error -62

We can skip the reset on APUs, assuming we can resume them
properly. Verified on some GFX11, GFX10 and old GFX9 APUs.

Signed-off-by: Tim Huang <tim.huang@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org # 6.1.x
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
@@ -2447,7 +2447,10 @@ static int amdgpu_pmops_freeze(struct de
 	adev->in_s4 = false;
 	if (r)
 		return r;
-	return amdgpu_asic_reset(adev);
+
+	if (amdgpu_acpi_should_gpu_reset(adev))
+		return amdgpu_asic_reset(adev);
+	return 0;
 }
 
 static int amdgpu_pmops_thaw(struct device *dev)


