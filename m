Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB07E6AEFE5
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:28:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232994AbjCGS1j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:27:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232913AbjCGS0F (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:26:05 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26714ACE0C
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:20:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B994461550
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:20:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36690C433EF;
        Tue,  7 Mar 2023 18:20:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678213236;
        bh=XQEX1iSzhdbbReeM0GnqVIUhim+Vd5CUKYWqEBIosKY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F7g53ludVyKpoSx/0Z4Lm6h5NRFFNkNKTlMlmzSyagRk1GG1cCzZxKN6uHVDWY32+
         Ww84heLen8Oj0I6z5gCqCfwG9hFQ15zxzAFWl2BcM1FcsApvxy7LVP7PmoKrav8XQS
         gMKjMhn2r3ZV1fPr/K4vNg5a6/Rc3UjqQRShEN4A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yang Yingliang <yangyingliang@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 412/885] driver core: fix potential null-ptr-deref in device_add()
Date:   Tue,  7 Mar 2023 17:55:46 +0100
Message-Id: <20230307170020.334089398@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit f6837f34a34973ef6600c08195ed300e24e97317 ]

I got the following null-ptr-deref report while doing fault injection test:

BUG: kernel NULL pointer dereference, address: 0000000000000058
CPU: 2 PID: 278 Comm: 37-i2c-ds2482 Tainted: G    B   W        N 6.1.0-rc3+
RIP: 0010:klist_put+0x2d/0xd0
Call Trace:
 <TASK>
 klist_remove+0xf1/0x1c0
 device_release_driver_internal+0x196/0x210
 bus_remove_device+0x1bd/0x240
 device_add+0xd3d/0x1100
 w1_add_master_device+0x476/0x490 [wire]
 ds2482_probe+0x303/0x3e0 [ds2482]

This is how it happened:

w1_alloc_dev()
  // The dev->driver is set to w1_master_driver.
  memcpy(&dev->dev, device, sizeof(struct device));
  device_add()
    bus_add_device()
    dpm_sysfs_add() // It fails, calls bus_remove_device.

    // error path
    bus_remove_device()
      // The dev->driver is not null, but driver is not bound.
      __device_release_driver()
        klist_remove(&dev->p->knode_driver) <-- It causes null-ptr-deref.

    // normal path
    bus_probe_device() // It's not called yet.
      device_bind_driver()

If dev->driver is set, in the error path after calling bus_add_device()
in device_add(), bus_remove_device() is called, then the device will be
detached from driver. But device_bind_driver() is not called yet, so it
causes null-ptr-deref while access the 'knode_driver'. To fix this, set
dev->driver to null in the error path before calling bus_remove_device().

Fixes: 57eee3d23e88 ("Driver core: Call device_pm_add() after bus_add_device() in device_add()")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Link: https://lore.kernel.org/r/20221205034904.2077765-1-yangyingliang@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index d02501933467d..e5c15061070b7 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -3551,6 +3551,7 @@ int device_add(struct device *dev)
 	device_pm_remove(dev);
 	dpm_sysfs_remove(dev);
  DPMError:
+	dev->driver = NULL;
 	bus_remove_device(dev);
  BusError:
 	device_remove_attrs(dev);
-- 
2.39.2



