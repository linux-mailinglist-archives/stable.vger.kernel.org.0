Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1361065D175
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 12:32:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230249AbjADLct (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 06:32:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239068AbjADLck (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 06:32:40 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFE051CB38
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 03:32:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A7CC2B80E65
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 11:32:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4E23C433D2;
        Wed,  4 Jan 2023 11:32:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672831956;
        bh=ob1z/B+InO4/4TnOajI8W6zjEbskR8YdYIwc4q7flS8=;
        h=Subject:To:Cc:From:Date:From;
        b=pzvyg2XFSeWpM6qwiuvMESq3bOo9+6Au+xELEShT/RI4O+KUPedP6IqADRJKfSToi
         R72MQgnWcpdsoGEux52F3nsRUbN4bxiLbTG6850iUSSsW22FWnwtzeo8vUM686ppxl
         XPFgJEGhvoSuh4ErENUb741fnpZMnqcRFJjMkhSk=
Subject: FAILED: patch "[PATCH] drm/amdgpu: skip mes self test after s0i3 resume for MES IP" failed to apply to 6.0-stable tree
To:     tim.huang@amd.com, alexander.deucher@amd.com,
        mario.limonciello@amd.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 04 Jan 2023 12:32:33 +0100
Message-ID: <16728319532129@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 6.0-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

8660495a9c5b ("drm/amdgpu: skip mes self test after s0i3 resume for MES IP v11.0")
bbce8cdb8390 ("drm/amdgpu: skip mes self test for gc 11.0.3")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 8660495a9c5b9afeec4cc006b3b75178f0fb2f10 Mon Sep 17 00:00:00 2001
From: Tim Huang <tim.huang@amd.com>
Date: Mon, 19 Dec 2022 18:32:32 +0800
Subject: [PATCH] drm/amdgpu: skip mes self test after s0i3 resume for MES IP
 v11.0

MES is part of gfxoff and MES suspend and resume are skipped for S0i3.
But the mes_self_test call path is still in the amdgpu_device_ip_late_init.
it's should also be skipped for s0ix as no hardware re-initialization
happened.

Besides, mes_self_test will free the BO that triggers a lot of warning
messages while in the suspend state.

[   81.656085] WARNING: CPU: 2 PID: 1550 at drivers/gpu/drm/amd/amdgpu/amdgpu_object.c:425 amdgpu_bo_free_kernel+0xfc/0x110 [amdgpu]
[   81.679435] Call Trace:
[   81.679726]  <TASK>
[   81.679981]  amdgpu_mes_remove_hw_queue+0x17a/0x230 [amdgpu]
[   81.680857]  amdgpu_mes_self_test+0x390/0x430 [amdgpu]
[   81.681665]  mes_v11_0_late_init+0x37/0x50 [amdgpu]
[   81.682423]  amdgpu_device_ip_late_init+0x53/0x280 [amdgpu]
[   81.683257]  amdgpu_device_resume+0xae/0x2a0 [amdgpu]
[   81.684043]  amdgpu_pmops_resume+0x37/0x70 [amdgpu]
[   81.684818]  pci_pm_resume+0x5c/0xa0
[   81.685247]  ? pci_pm_thaw+0x90/0x90
[   81.685658]  dpm_run_callback+0x4e/0x160
[   81.686110]  device_resume+0xad/0x210
[   81.686529]  async_resume+0x1e/0x40
[   81.686931]  async_run_entry_fn+0x33/0x120
[   81.687405]  process_one_work+0x21d/0x3f0
[   81.687869]  worker_thread+0x4a/0x3c0
[   81.688293]  ? process_one_work+0x3f0/0x3f0
[   81.688777]  kthread+0xff/0x130
[   81.689157]  ? kthread_complete_and_exit+0x20/0x20
[   81.689707]  ret_from_fork+0x22/0x30
[   81.690118]  </TASK>
[   81.690380] ---[ end trace 0000000000000000 ]---

v2: make the comment clean and use adev->in_s0ix instead of
adev->suspend

Signed-off-by: Tim Huang <tim.huang@amd.com>
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org # 6.0, 6.1

diff --git a/drivers/gpu/drm/amd/amdgpu/mes_v11_0.c b/drivers/gpu/drm/amd/amdgpu/mes_v11_0.c
index 5459366f49ff..970b066b37bb 100644
--- a/drivers/gpu/drm/amd/amdgpu/mes_v11_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/mes_v11_0.c
@@ -1342,7 +1342,8 @@ static int mes_v11_0_late_init(void *handle)
 {
 	struct amdgpu_device *adev = (struct amdgpu_device *)handle;
 
-	if (!amdgpu_in_reset(adev) &&
+	/* it's only intended for use in mes_self_test case, not for s0ix and reset */
+	if (!amdgpu_in_reset(adev) && !adev->in_s0ix &&
 	    (adev->ip_versions[GC_HWIP][0] != IP_VERSION(11, 0, 3)))
 		amdgpu_mes_self_test(adev);
 

