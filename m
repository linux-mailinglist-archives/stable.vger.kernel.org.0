Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F3376AE9FE
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:30:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229981AbjCGR37 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:29:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230076AbjCGR3W (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:29:22 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B62759B9BB
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:24:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4BFB0614D0
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:24:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39DF9C433EF;
        Tue,  7 Mar 2023 17:24:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678209868;
        bh=2F43DLcAKIE3oAeFmtMXiwi+DBXdP8RR9TeKb2Jol/c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O978UbWInEnE0TN0rRLUCSp6kCTscmsQoyPYquyDl0spGu0xx2006BFctRnQpswFl
         gXJ1GlEDQosNKON52GatpRVxSa0xjad3OK4LnUoHPvkERUbgDYrcbufRAIY+NLZVCD
         FCYHG21QJn3btLmUesN4NwXDTRtx2lE06MGBlU8w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Shang XiaoJing <shangxiaojing@huawei.com>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0327/1001] drm: Fix potential null-ptr-deref due to drmm_mode_config_init()
Date:   Tue,  7 Mar 2023 17:51:39 +0100
Message-Id: <20230307170035.699493918@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
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

From: Shang XiaoJing <shangxiaojing@huawei.com>

[ Upstream commit 834c23e4f798dcdc8af251b3c428ceef94741991 ]

drmm_mode_config_init() will call drm_mode_create_standard_properties()
and won't check the ret value. When drm_mode_create_standard_properties()
failed due to alloc, property will be a NULL pointer and may causes the
null-ptr-deref. Fix the null-ptr-deref by adding the ret value check.

Found null-ptr-deref while testing insert module bochs:
general protection fault, probably for non-canonical address
    0xdffffc000000000c: 0000 [#1] SMP KASAN PTI
KASAN: null-ptr-deref in range [0x0000000000000060-0x0000000000000067]
CPU: 3 PID: 249 Comm: modprobe Not tainted 6.1.0-rc1+ #364
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
rel-1.15.0-0-g2dd4b9b3f840-prebuilt.qemu.org 04/01/2014
RIP: 0010:drm_object_attach_property+0x73/0x3c0 [drm]
Call Trace:
 <TASK>
 __drm_connector_init+0xb6c/0x1100 [drm]
 bochs_pci_probe.cold.11+0x4cb/0x7fe [bochs]
 pci_device_probe+0x17d/0x340
 really_probe+0x1db/0x5d0
 __driver_probe_device+0x1e7/0x250
 driver_probe_device+0x4a/0x120
 __driver_attach+0xcd/0x2c0
 bus_for_each_dev+0x11a/0x1b0
 bus_add_driver+0x3d7/0x500
 driver_register+0x18e/0x320
 do_one_initcall+0xc4/0x3e0
 do_init_module+0x1b4/0x630
 load_module+0x5dca/0x7230
 __do_sys_finit_module+0x100/0x170
 do_syscall_64+0x3f/0x90
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7ff65af9f839

Fixes: 6b4959f43a04 ("drm/atomic: atomic plane properties")
Signed-off-by: Shang XiaoJing <shangxiaojing@huawei.com>
Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Link: https://patchwork.freedesktop.org/patch/msgid/20221118021651.2460-1-shangxiaojing@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_mode_config.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/drm_mode_config.c b/drivers/gpu/drm/drm_mode_config.c
index 688c8afe0bf17..8525ef8515406 100644
--- a/drivers/gpu/drm/drm_mode_config.c
+++ b/drivers/gpu/drm/drm_mode_config.c
@@ -399,6 +399,8 @@ static void drm_mode_config_init_release(struct drm_device *dev, void *ptr)
  */
 int drmm_mode_config_init(struct drm_device *dev)
 {
+	int ret;
+
 	mutex_init(&dev->mode_config.mutex);
 	drm_modeset_lock_init(&dev->mode_config.connection_mutex);
 	mutex_init(&dev->mode_config.idr_mutex);
@@ -420,7 +422,11 @@ int drmm_mode_config_init(struct drm_device *dev)
 	init_llist_head(&dev->mode_config.connector_free_list);
 	INIT_WORK(&dev->mode_config.connector_free_work, drm_connector_free_work_fn);
 
-	drm_mode_create_standard_properties(dev);
+	ret = drm_mode_create_standard_properties(dev);
+	if (ret) {
+		drm_mode_config_cleanup(dev);
+		return ret;
+	}
 
 	/* Just to be sure */
 	dev->mode_config.num_fb = 0;
-- 
2.39.2



