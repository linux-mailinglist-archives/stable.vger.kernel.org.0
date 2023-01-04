Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7430E65D808
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 17:10:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239839AbjADQK2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 11:10:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239871AbjADQJt (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 11:09:49 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 307BC395D3
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 08:09:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 105FF6179C
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 16:09:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 050CCC433EF;
        Wed,  4 Jan 2023 16:09:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672848575;
        bh=zsf9mfcBW2jDNFm+t6nq9xnuBvqTTIpZH0UOHWWwlkc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lqovXqN+46buJCbKR9FHhxqBTliOYtGA702N9T7skXl8MA/zmlpkNsAJ1q8MPIkN0
         HfUn64XThWD/2TNlKbXybgN2RPqJng6WexYY+kQ2y74InytxAlpC12J1HDCQAmNuLu
         RIc3HXvXGk3tET84eI97+mEdJKyLfq5/udsP2v9I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Tim Huang <tim.huang@amd.com>,
        Mario Limonciello <mario.limonciello@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.1 002/207] drm/amdgpu: skip mes self test after s0i3 resume for MES IP v11.0
Date:   Wed,  4 Jan 2023 17:04:20 +0100
Message-Id: <20230104160511.988152631@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230104160511.905925875@linuxfoundation.org>
References: <20230104160511.905925875@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tim Huang <tim.huang@amd.com>

commit 8660495a9c5b9afeec4cc006b3b75178f0fb2f10 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/mes_v11_0.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdgpu/mes_v11_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/mes_v11_0.c
@@ -1339,7 +1339,8 @@ static int mes_v11_0_late_init(void *han
 {
 	struct amdgpu_device *adev = (struct amdgpu_device *)handle;
 
-	if (!amdgpu_in_reset(adev) &&
+	/* it's only intended for use in mes_self_test case, not for s0ix and reset */
+	if (!amdgpu_in_reset(adev) && !adev->in_s0ix &&
 	    (adev->ip_versions[GC_HWIP][0] != IP_VERSION(11, 0, 3)))
 		amdgpu_mes_self_test(adev);
 


