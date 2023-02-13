Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7A056949AB
	for <lists+stable@lfdr.de>; Mon, 13 Feb 2023 16:00:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231214AbjBMPAr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Feb 2023 10:00:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231149AbjBMO7m (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Feb 2023 09:59:42 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 539FE1CAE9
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 06:59:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D442961167
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 14:59:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E86EFC433EF;
        Mon, 13 Feb 2023 14:59:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676300362;
        bh=UTiNo5Antlr8IhouoiYLDPulwfrEup9AcyMwlVRyLgk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JEzTDxo9F7lZKUSrFKLlmLRF4ZKzh/dnHWwrHlxtZXjiyum+r3MJtvoYdmyJX59ss
         J2SqhSS8XI/1GpKtiymtxS+ukhOoV43HGvJVj9mb7VB7rA7g2hZ9yH9mPBiVHXixBk
         B3hWleFa2K/Zxvv9y35m/enL7VSX0/tjd9/E8lV4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Alan Stern <stern@rowland.harvard.edu>,
        "David S. Miller" <davem@davemloft.net>,
        syzbot+2a0e7abd24f1eb90ce25@syzkaller.appspotmail.com
Subject: [PATCH 5.15 50/67] net: USB: Fix wrong-direction WARNING in plusb.c
Date:   Mon, 13 Feb 2023 15:49:31 +0100
Message-Id: <20230213144734.743524001@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230213144732.336342050@linuxfoundation.org>
References: <20230213144732.336342050@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alan Stern <stern@rowland.harvard.edu>

commit 811d581194f7412eda97acc03d17fc77824b561f upstream.

The syzbot fuzzer detected a bug in the plusb network driver: A
zero-length control-OUT transfer was treated as a read instead of a
write.  In modern kernels this error provokes a WARNING:

usb 1-1: BOGUS control dir, pipe 80000280 doesn't match bRequestType c0
WARNING: CPU: 0 PID: 4645 at drivers/usb/core/urb.c:411
usb_submit_urb+0x14a7/0x1880 drivers/usb/core/urb.c:411
Modules linked in:
CPU: 1 PID: 4645 Comm: dhcpcd Not tainted
6.2.0-rc6-syzkaller-00050-g9f266ccaa2f5 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google
01/12/2023
RIP: 0010:usb_submit_urb+0x14a7/0x1880 drivers/usb/core/urb.c:411
...
Call Trace:
 <TASK>
 usb_start_wait_urb+0x101/0x4b0 drivers/usb/core/message.c:58
 usb_internal_control_msg drivers/usb/core/message.c:102 [inline]
 usb_control_msg+0x320/0x4a0 drivers/usb/core/message.c:153
 __usbnet_read_cmd+0xb9/0x390 drivers/net/usb/usbnet.c:2010
 usbnet_read_cmd+0x96/0xf0 drivers/net/usb/usbnet.c:2068
 pl_vendor_req drivers/net/usb/plusb.c:60 [inline]
 pl_set_QuickLink_features drivers/net/usb/plusb.c:75 [inline]
 pl_reset+0x2f/0xf0 drivers/net/usb/plusb.c:85
 usbnet_open+0xcc/0x5d0 drivers/net/usb/usbnet.c:889
 __dev_open+0x297/0x4d0 net/core/dev.c:1417
 __dev_change_flags+0x587/0x750 net/core/dev.c:8530
 dev_change_flags+0x97/0x170 net/core/dev.c:8602
 devinet_ioctl+0x15a2/0x1d70 net/ipv4/devinet.c:1147
 inet_ioctl+0x33f/0x380 net/ipv4/af_inet.c:979
 sock_do_ioctl+0xcc/0x230 net/socket.c:1169
 sock_ioctl+0x1f8/0x680 net/socket.c:1286
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:870 [inline]
 __se_sys_ioctl fs/ioctl.c:856 [inline]
 __x64_sys_ioctl+0x197/0x210 fs/ioctl.c:856
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

The fix is to call usbnet_write_cmd() instead of usbnet_read_cmd() and
remove the USB_DIR_IN flag.

Reported-and-tested-by: syzbot+2a0e7abd24f1eb90ce25@syzkaller.appspotmail.com
Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Fixes: 090ffa9d0e90 ("[PATCH] USB: usbnet (9/9) module for pl2301/2302 cables")
CC: stable@vger.kernel.org
Link: https://lore.kernel.org/r/00000000000052099f05f3b3e298@google.com/
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/usb/plusb.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/drivers/net/usb/plusb.c
+++ b/drivers/net/usb/plusb.c
@@ -57,9 +57,7 @@
 static inline int
 pl_vendor_req(struct usbnet *dev, u8 req, u8 val, u8 index)
 {
-	return usbnet_read_cmd(dev, req,
-				USB_DIR_IN | USB_TYPE_VENDOR |
-				USB_RECIP_DEVICE,
+	return usbnet_write_cmd(dev, req, USB_TYPE_VENDOR | USB_RECIP_DEVICE,
 				val, index, NULL, 0);
 }
 


