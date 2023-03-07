Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F7906AEACF
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:37:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231812AbjCGRhh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:37:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231886AbjCGRhI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:37:08 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D1104C6D0
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:33:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A57086151D
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:33:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B3F8C4339B;
        Tue,  7 Mar 2023 17:33:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678210393;
        bh=rAfTvp/zOhvD7wyTYJAujxQudDl7HmMD/QhKJbxAtGg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ak5Pvv/98Wn87iatYg3Seg/HTgCYEdKM3zjoljFBeqQJOajsDhaW9rkyTT1u15f1o
         Sw6w46tj2MJEm/xmmG1bLndNp0M4nPmFSciiZv6uhigoylY9E9uNLGUwhQDkSH8pwl
         3OmHygjZNH44cdi45nqt1xof9Zdi5iiUn2rYvB4A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yang Yingliang <yangyingliang@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0495/1001] driver core: fix potential null-ptr-deref in device_add()
Date:   Tue,  7 Mar 2023 17:54:27 +0100
Message-Id: <20230307170042.860427575@linuxfoundation.org>
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
index a3e14143ec0cf..506289e6b04dd 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -3513,6 +3513,7 @@ int device_add(struct device *dev)
 	device_pm_remove(dev);
 	dpm_sysfs_remove(dev);
  DPMError:
+	dev->driver = NULL;
 	bus_remove_device(dev);
  BusError:
 	device_remove_attrs(dev);
-- 
2.39.2



