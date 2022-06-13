Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A751548618
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 17:55:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347764AbiFMK5o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 06:57:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346293AbiFMKzO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 06:55:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BAA225296;
        Mon, 13 Jun 2022 03:32:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F18BBB80EAA;
        Mon, 13 Jun 2022 10:32:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57724C34114;
        Mon, 13 Jun 2022 10:32:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655116320;
        bh=XSCQaA6YXgw2zEPO29dmb2VLCfRXEk74fjBZeIAnomY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YC6LiUj5BjdytYBYN+v0HhNuP8ibaHJLT2i3jl5V7sOrL/HGnqrpxrMha2AHfzX/D
         jLY/rPHMZXjwEF8zXP2myFgQXnKBeLfX0xM0jxKVhoS1D6A/XR/voQVeV7YBuqCBRe
         +4rM6su9IpWYJYB/1jHVVbZBfRQRp3qYUB68EpgY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Brian Norris <briannorris@chromium.org>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 065/411] PM / devfreq: rk3399_dmc: Disable edev on remove()
Date:   Mon, 13 Jun 2022 12:05:38 +0200
Message-Id: <20220613094930.466573957@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094928.482772422@linuxfoundation.org>
References: <20220613094928.482772422@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Brian Norris <briannorris@chromium.org>

[ Upstream commit 2fccf9e6050e0e3b8b4cd275d41daf7f7fa22804 ]

Otherwise we hit an unablanced enable-count when unbinding the DFI
device:

[ 1279.659119] ------------[ cut here ]------------
[ 1279.659179] WARNING: CPU: 2 PID: 5638 at drivers/devfreq/devfreq-event.c:360 devfreq_event_remove_edev+0x84/0x8c
...
[ 1279.659352] Hardware name: Google Kevin (DT)
[ 1279.659363] pstate: 80400005 (Nzcv daif +PAN -UAO -TCO BTYPE=--)
[ 1279.659371] pc : devfreq_event_remove_edev+0x84/0x8c
[ 1279.659380] lr : devm_devfreq_event_release+0x1c/0x28
...
[ 1279.659571] Call trace:
[ 1279.659582]  devfreq_event_remove_edev+0x84/0x8c
[ 1279.659590]  devm_devfreq_event_release+0x1c/0x28
[ 1279.659602]  release_nodes+0x1cc/0x244
[ 1279.659611]  devres_release_all+0x44/0x60
[ 1279.659621]  device_release_driver_internal+0x11c/0x1ac
[ 1279.659629]  device_driver_detach+0x20/0x2c
[ 1279.659641]  unbind_store+0x7c/0xb0
[ 1279.659650]  drv_attr_store+0x2c/0x40
[ 1279.659663]  sysfs_kf_write+0x44/0x58
[ 1279.659672]  kernfs_fop_write_iter+0xf4/0x190
[ 1279.659684]  vfs_write+0x2b0/0x2e4
[ 1279.659693]  ksys_write+0x80/0xec
[ 1279.659701]  __arm64_sys_write+0x24/0x30
[ 1279.659714]  el0_svc_common+0xf0/0x1d8
[ 1279.659724]  do_el0_svc_compat+0x28/0x3c
[ 1279.659738]  el0_svc_compat+0x10/0x1c
[ 1279.659746]  el0_sync_compat_handler+0xa8/0xcc
[ 1279.659758]  el0_sync_compat+0x188/0x1c0
[ 1279.659768] ---[ end trace cec200e5094155b4 ]---

Signed-off-by: Brian Norris <briannorris@chromium.org>
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/devfreq/rk3399_dmc.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/devfreq/rk3399_dmc.c b/drivers/devfreq/rk3399_dmc.c
index 027769e39f9b..a491dcfa1dd0 100644
--- a/drivers/devfreq/rk3399_dmc.c
+++ b/drivers/devfreq/rk3399_dmc.c
@@ -485,6 +485,8 @@ static int rk3399_dmcfreq_remove(struct platform_device *pdev)
 {
 	struct rk3399_dmcfreq *dmcfreq = dev_get_drvdata(&pdev->dev);
 
+	devfreq_event_disable_edev(dmcfreq->edev);
+
 	/*
 	 * Before remove the opp table we need to unregister the opp notifier.
 	 */
-- 
2.35.1



