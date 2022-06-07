Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8132540EE6
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 20:59:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352416AbiFGS6E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 14:58:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353354AbiFGSx7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 14:53:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BBDDAE47B;
        Tue,  7 Jun 2022 11:03:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C0DF7616B6;
        Tue,  7 Jun 2022 18:03:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3C01C34119;
        Tue,  7 Jun 2022 18:03:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654625027;
        bh=sXA8eHrhDiaMO3chv+YN3qGZ4+qj4uRNBHrPjyUh5X0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nU4/wa8VCeld53oE5Wsqg2E3hCH+sIcC0pCoe76hR/y+cVU+fDnT8jYLMOPWSA516
         EXgKxLMgpBZayFp6k/rPS6fZQYQT0kR6iow0F7SShIwsVnG3x0BaMsS2y6RklAkua3
         bQGp413ScPF3H+yJyo3pbpCW9Ggigux0AWAc87ImGR6o/E14TK/Bmn+xQCPNtHsn28
         W4n4clVHuXHbEkqmoro39XhenMMloCaOx+mTjLSPEgyB8kVnjhaGraHyrOFYbvpg04
         xu+1alIJZxUHnFIYi9sZrGQve1Y3ilHyvwVMQtEVOkJHQ5OA9CB/xr+ctBYS+4sqiM
         C+z+kAh3paRhQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wang Cheng <wanngchenng@gmail.com>,
        syzbot+6f5ecd144854c0d8580b@syzkaller.appspotmail.com,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, Larry.Finger@lwfinger.net,
        florian.c.schilhabel@googlemail.com, paskripkin@gmail.com,
        kuba@kernel.org, skumark1902@gmail.com, xkernel.wang@foxmail.com,
        linux-staging@lists.linux.dev
Subject: [PATCH AUTOSEL 4.9 13/19] staging: rtl8712: fix uninit-value in r871xu_drv_init()
Date:   Tue,  7 Jun 2022 14:03:08 -0400
Message-Id: <20220607180317.482354-13-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220607180317.482354-1-sashal@kernel.org>
References: <20220607180317.482354-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

From: Wang Cheng <wanngchenng@gmail.com>

[ Upstream commit 0458e5428e5e959d201a40ffe71d762a79ecedc4 ]

When 'tmpU1b' returns from r8712_read8(padapter, EE_9346CR) is 0,
'mac[6]' will not be initialized.

BUG: KMSAN: uninit-value in r871xu_drv_init+0x2d54/0x3070 drivers/staging/rtl8712/usb_intf.c:541
 r871xu_drv_init+0x2d54/0x3070 drivers/staging/rtl8712/usb_intf.c:541
 usb_probe_interface+0xf19/0x1600 drivers/usb/core/driver.c:396
 really_probe+0x653/0x14b0 drivers/base/dd.c:596
 __driver_probe_device+0x3e9/0x530 drivers/base/dd.c:752
 driver_probe_device drivers/base/dd.c:782 [inline]
 __device_attach_driver+0x79f/0x1120 drivers/base/dd.c:899
 bus_for_each_drv+0x2d6/0x3f0 drivers/base/bus.c:427
 __device_attach+0x593/0x8e0 drivers/base/dd.c:970
 device_initial_probe+0x4a/0x60 drivers/base/dd.c:1017
 bus_probe_device+0x17b/0x3e0 drivers/base/bus.c:487
 device_add+0x1fff/0x26e0 drivers/base/core.c:3405
 usb_set_configuration+0x37e9/0x3ed0 drivers/usb/core/message.c:2170
 usb_generic_driver_probe+0x13c/0x300 drivers/usb/core/generic.c:238
 usb_probe_device+0x309/0x570 drivers/usb/core/driver.c:293
 really_probe+0x653/0x14b0 drivers/base/dd.c:596
 __driver_probe_device+0x3e9/0x530 drivers/base/dd.c:752
 driver_probe_device drivers/base/dd.c:782 [inline]
 __device_attach_driver+0x79f/0x1120 drivers/base/dd.c:899
 bus_for_each_drv+0x2d6/0x3f0 drivers/base/bus.c:427
 __device_attach+0x593/0x8e0 drivers/base/dd.c:970
 device_initial_probe+0x4a/0x60 drivers/base/dd.c:1017
 bus_probe_device+0x17b/0x3e0 drivers/base/bus.c:487
 device_add+0x1fff/0x26e0 drivers/base/core.c:3405
 usb_new_device+0x1b8e/0x2950 drivers/usb/core/hub.c:2566
 hub_port_connect drivers/usb/core/hub.c:5358 [inline]
 hub_port_connect_change drivers/usb/core/hub.c:5502 [inline]
 port_event drivers/usb/core/hub.c:5660 [inline]
 hub_event+0x58e3/0x89e0 drivers/usb/core/hub.c:5742
 process_one_work+0xdb6/0x1820 kernel/workqueue.c:2307
 worker_thread+0x10b3/0x21e0 kernel/workqueue.c:2454
 kthread+0x3c7/0x500 kernel/kthread.c:377
 ret_from_fork+0x1f/0x30

Local variable mac created at:
 r871xu_drv_init+0x1771/0x3070 drivers/staging/rtl8712/usb_intf.c:394
 usb_probe_interface+0xf19/0x1600 drivers/usb/core/driver.c:396

KMSAN: uninit-value in r871xu_drv_init
https://syzkaller.appspot.com/bug?id=3cd92b1d85428b128503bfa7a250294c9ae00bd8

Reported-by: <syzbot+6f5ecd144854c0d8580b@syzkaller.appspotmail.com>
Tested-by: <syzbot+6f5ecd144854c0d8580b@syzkaller.appspotmail.com>
Reviewed-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Wang Cheng <wanngchenng@gmail.com>
Link: https://lore.kernel.org/r/14c3886173dfa4597f0704547c414cfdbcd11d16.1652618244.git.wanngchenng@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/rtl8712/usb_intf.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/rtl8712/usb_intf.c b/drivers/staging/rtl8712/usb_intf.c
index d0ba42dfafeb..7b7cb2a7db60 100644
--- a/drivers/staging/rtl8712/usb_intf.c
+++ b/drivers/staging/rtl8712/usb_intf.c
@@ -569,13 +569,13 @@ static int r871xu_drv_init(struct usb_interface *pusb_intf,
 		} else {
 			AutoloadFail = false;
 		}
-		if (((mac[0] == 0xff) && (mac[1] == 0xff) &&
+		if ((!AutoloadFail) ||
+		    ((mac[0] == 0xff) && (mac[1] == 0xff) &&
 		     (mac[2] == 0xff) && (mac[3] == 0xff) &&
 		     (mac[4] == 0xff) && (mac[5] == 0xff)) ||
 		    ((mac[0] == 0x00) && (mac[1] == 0x00) &&
 		     (mac[2] == 0x00) && (mac[3] == 0x00) &&
-		     (mac[4] == 0x00) && (mac[5] == 0x00)) ||
-		     (!AutoloadFail)) {
+		     (mac[4] == 0x00) && (mac[5] == 0x00))) {
 			mac[0] = 0x00;
 			mac[1] = 0xe0;
 			mac[2] = 0x4c;
-- 
2.35.1

