Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82E046648D3
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 19:15:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234677AbjAJSPj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 13:15:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239151AbjAJSPD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 13:15:03 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7572A1571D
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 10:13:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 11FE6617EC
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 18:13:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19448C433F0;
        Tue, 10 Jan 2023 18:13:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673374381;
        bh=AkGcjnLk+Y3qQw+Y3CRBlivILlXfV2KR4KZINAIIhMU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xcG1qiwHwTDRpf+UiDT3fO9D+FgGJ7lDSwyIvL0wHz1h9VqjUCFezUt1Wh2gvVVK/
         OePfCgTbAglwnothVUQPwMv1y2Z76RWsfIZv4kntHNKqg2GR2Wn1PQX7EC3q3Cf8tz
         yUI3NKZ5Yipmy8Yh1pfeS7bguu6uFYAadFFp4fUs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Mukul Joshi <mukul.joshi@amd.com>,
        Felix Kuehling <Felix.Kuehling@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.0 137/148] drm/amdkfd: Fix kernel warning during topology setup
Date:   Tue, 10 Jan 2023 19:04:01 +0100
Message-Id: <20230110180021.519678102@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180017.145591678@linuxfoundation.org>
References: <20230110180017.145591678@linuxfoundation.org>
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

From: Mukul Joshi <mukul.joshi@amd.com>

commit cf97eb7e47d4671084c7e114c5d88a3d0540ecbd upstream.

This patch fixes the following kernel warning seen during
driver load by correctly initializing the p2plink attr before
creating the sysfs file:

[  +0.002865] ------------[ cut here ]------------
[  +0.002327] kobject: '(null)' (0000000056260cfb): is not initialized, yet kobject_put() is being called.
[  +0.004780] WARNING: CPU: 32 PID: 1006 at lib/kobject.c:718 kobject_put+0xaa/0x1c0
[  +0.001361] Call Trace:
[  +0.001234]  <TASK>
[  +0.001067]  kfd_remove_sysfs_node_entry+0x24a/0x2d0 [amdgpu]
[  +0.003147]  kfd_topology_update_sysfs+0x3d/0x750 [amdgpu]
[  +0.002890]  kfd_topology_add_device+0xbd7/0xc70 [amdgpu]
[  +0.002844]  ? lock_release+0x13c/0x2e0
[  +0.001936]  ? smu_cmn_send_smc_msg_with_param+0x1e8/0x2d0 [amdgpu]
[  +0.003313]  ? amdgpu_dpm_get_mclk+0x54/0x60 [amdgpu]
[  +0.002703]  kgd2kfd_device_init.cold+0x39f/0x4ed [amdgpu]
[  +0.002930]  amdgpu_amdkfd_device_init+0x13d/0x1f0 [amdgpu]
[  +0.002944]  amdgpu_device_init.cold+0x1464/0x17b4 [amdgpu]
[  +0.002970]  ? pci_bus_read_config_word+0x43/0x80
[  +0.002380]  amdgpu_driver_load_kms+0x15/0x100 [amdgpu]
[  +0.002744]  amdgpu_pci_probe+0x147/0x370 [amdgpu]
[  +0.002522]  local_pci_probe+0x40/0x80
[  +0.001896]  work_for_cpu_fn+0x10/0x20
[  +0.001892]  process_one_work+0x26e/0x5a0
[  +0.002029]  worker_thread+0x1fd/0x3e0
[  +0.001890]  ? process_one_work+0x5a0/0x5a0
[  +0.002115]  kthread+0xea/0x110
[  +0.001618]  ? kthread_complete_and_exit+0x20/0x20
[  +0.002422]  ret_from_fork+0x1f/0x30
[  +0.001808]  </TASK>
[  +0.001103] irq event stamp: 59837
[  +0.001718] hardirqs last  enabled at (59849): [<ffffffffb30fab12>] __up_console_sem+0x52/0x60
[  +0.004414] hardirqs last disabled at (59860): [<ffffffffb30faaf7>] __up_console_sem+0x37/0x60
[  +0.004414] softirqs last  enabled at (59654): [<ffffffffb307d9c7>] irq_exit_rcu+0xd7/0x130
[  +0.004205] softirqs last disabled at (59649): [<ffffffffb307d9c7>] irq_exit_rcu+0xd7/0x130
[  +0.004203] ---[ end trace 0000000000000000 ]---

Fixes: 0f28cca87e9a ("drm/amdkfd: Extend KFD device topology to surface peer-to-peer links")
Signed-off-by: Mukul Joshi <mukul.joshi@amd.com>
Reviewed-by: Felix Kuehling <Felix.Kuehling@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_topology.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_topology.c b/drivers/gpu/drm/amd/amdkfd/kfd_topology.c
index bceb1a5b2518..3fdaba56be6f 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_topology.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_topology.c
@@ -801,7 +801,7 @@ static int kfd_build_sysfs_node_entry(struct kfd_topology_device *dev,
 
 		p2plink->attr.name = "properties";
 		p2plink->attr.mode = KFD_SYSFS_FILE_MODE;
-		sysfs_attr_init(&iolink->attr);
+		sysfs_attr_init(&p2plink->attr);
 		ret = sysfs_create_file(p2plink->kobj, &p2plink->attr);
 		if (ret < 0)
 			return ret;
-- 
2.39.0



