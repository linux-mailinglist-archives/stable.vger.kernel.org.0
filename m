Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F2BB6AEEDB
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:17:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232599AbjCGSR2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:17:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232005AbjCGSRH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:17:07 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 305802A16A
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:11:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4418AB819C7
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:11:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85C58C433EF;
        Tue,  7 Mar 2023 18:11:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678212705;
        bh=5crKRGoGjs7OvnBbceoKVHiUFKx5kaljmaFN01e52PI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wsYto6E0zEM4chpyjrZBUbcq/exdmQpkbYxdV2jxjtz2pWsTz1ojDN5cYDgPcu308
         1VwMrdN7IwbCze+6W62BIa6t66z1z7elGk27nmCc5K4dTl9Ra7k9rsTF2wGTukOWDK
         6yf03b9S59/9BDq4QofJVVTNdHcoep7UnTdypY2g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yuan Can <yuancan@huawei.com>,
        Melissa Wen <mwen@igalia.com>,
        Melissa Wen <melissa.srw@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 270/885] drm/vkms: Fix null-ptr-deref in vkms_release()
Date:   Tue,  7 Mar 2023 17:53:24 +0100
Message-Id: <20230307170013.745153292@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yuan Can <yuancan@huawei.com>

[ Upstream commit 2fe2a8f40c21161ffe7653cc234e7934db5b7cc5 ]

A null-ptr-deref is triggered when it tries to destroy the workqueue in
vkms->output.composer_workq in vkms_release().

 KASAN: null-ptr-deref in range [0x0000000000000118-0x000000000000011f]
 CPU: 5 PID: 17193 Comm: modprobe Not tainted 6.0.0-11331-gd465bff130bf #24
 RIP: 0010:destroy_workqueue+0x2f/0x710
 ...
 Call Trace:
  <TASK>
  ? vkms_config_debugfs_init+0x50/0x50 [vkms]
  __devm_drm_dev_alloc+0x15a/0x1c0 [drm]
  vkms_init+0x245/0x1000 [vkms]
  do_one_initcall+0xd0/0x4f0
  do_init_module+0x1a4/0x680
  load_module+0x6249/0x7110
  __do_sys_finit_module+0x140/0x200
  do_syscall_64+0x35/0x80
  entry_SYSCALL_64_after_hwframe+0x46/0xb0

The reason is that an OOM happened which triggers the destroy of the
workqueue, however, the workqueue is alloced in the later process,
thus a null-ptr-deref happened. A simple call graph is shown as below:

 vkms_init()
  vkms_create()
    devm_drm_dev_alloc()
      __devm_drm_dev_alloc()
        devm_drm_dev_init()
          devm_add_action_or_reset()
            devm_add_action() # an error happened
            devm_drm_dev_init_release()
              drm_dev_put()
                kref_put()
                  drm_dev_release()
                    vkms_release()
                      destroy_workqueue() # null-ptr-deref happened
    vkms_modeset_init()
      vkms_output_init()
        vkms_crtc_init() # where the workqueue get allocated

Fix this by checking if composer_workq is NULL before passing it to
the destroy_workqueue() in vkms_release().

Fixes: 6c234fe37c57 ("drm/vkms: Implement CRC debugfs API")
Signed-off-by: Yuan Can <yuancan@huawei.com>
Reviewed-by: Melissa Wen <mwen@igalia.com>
Signed-off-by: Melissa Wen <melissa.srw@gmail.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20221101065156.41584-3-yuancan@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vkms/vkms_drv.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/vkms/vkms_drv.c b/drivers/gpu/drm/vkms/vkms_drv.c
index dfe983eaa07ff..f716c5796f5fc 100644
--- a/drivers/gpu/drm/vkms/vkms_drv.c
+++ b/drivers/gpu/drm/vkms/vkms_drv.c
@@ -57,7 +57,8 @@ static void vkms_release(struct drm_device *dev)
 {
 	struct vkms_device *vkms = drm_device_to_vkms_device(dev);
 
-	destroy_workqueue(vkms->output.composer_workq);
+	if (vkms->output.composer_workq)
+		destroy_workqueue(vkms->output.composer_workq);
 }
 
 static void vkms_atomic_commit_tail(struct drm_atomic_state *old_state)
-- 
2.39.2



