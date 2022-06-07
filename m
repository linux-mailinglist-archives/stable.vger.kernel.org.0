Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 656CC540B7B
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 20:29:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350499AbiFGS3R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 14:29:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351365AbiFGSXO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 14:23:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45D79C686D;
        Tue,  7 Jun 2022 10:54:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CE6CC617FE;
        Tue,  7 Jun 2022 17:54:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAB40C3411F;
        Tue,  7 Jun 2022 17:54:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654624454;
        bh=O81XcMlN/TnTWCUyaNqzBZdDsQkHdCrUlFjxtCxOq20=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YUvXzRlm4JrW4ZjYKZrOdAQqW8CcniYxD7+oi5L5mPvTaJhFOo5fR0Rq3gfLO2jCX
         Gs2ej6axUmkhf8J2seWADi9YCtvBxRGBu51kqbMOpBwZD5sC7OUPSuecpxSZ8BNaPJ
         nVm1o4GqmRJslhNXhHP+zIFlP0XhbCKBrMzuaWaLPvfJj8DarGgOBZGsvupU3N7ksh
         5roKXyLXIlkBEDcBnEQTPR9aQ3OJkOFSSDIugDmkwh/nRyvD+ImDYsyLPPCDFp/DTm
         Bc5H/wM3MTr6NdgfDU4XxJj7l/5gWjPJpcvqqyeWKYDHf6dmo80pK+ves+0KIE5Waw
         NINFLa5+etpNw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wang Cheng <wanngchenng@gmail.com>,
        syzbot+6f5ecd144854c0d8580b@syzkaller.appspotmail.com,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, Larry.Finger@lwfinger.net,
        florian.c.schilhabel@googlemail.com, paskripkin@gmail.com,
        skumark1902@gmail.com, kuba@kernel.org, xkernel.wang@foxmail.com,
        linux-staging@lists.linux.dev
Subject: [PATCH AUTOSEL 5.17 27/60] staging: rtl8712: fix uninit-value in r871xu_drv_init()
Date:   Tue,  7 Jun 2022 13:52:24 -0400
Message-Id: <20220607175259.478835-27-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220607175259.478835-1-sashal@kernel.org>
References: <20220607175259.478835-1-sashal@kernel.org>
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
index 56450ede9f23..1ff3e2658e77 100644
--- a/drivers/staging/rtl8712/usb_intf.c
+++ b/drivers/staging/rtl8712/usb_intf.c
@@ -536,13 +536,13 @@ static int r871xu_drv_init(struct usb_interface *pusb_intf,
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

