Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 45104A8DFD
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 21:32:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732627AbfIDRz2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 13:55:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:60494 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732620AbfIDRz1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Sep 2019 13:55:27 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7CBCC208E4;
        Wed,  4 Sep 2019 17:55:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567619727;
        bh=uun2tIggxofMoBfrIBSPSFtfiMuhO/XgwscPuae6WE0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fVmOpUyCWnbgC4SepagDUISzB0VsDsMzrpnjsUjRH8ARWP9j4b1RQBt4lDxYrbFAP
         cQ/JtCVAxdnh1eVdjxjGwGkCkBKePGXyMwd605ySqs97vNpKAMurBGEnmmK8vYYeOE
         bwUFpQrBZtAgxH0m5qOsMdgGD7yI5J+qIJ7IS3NM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Juliana Rodrigueiro <juliana.rodrigueiro@intra2net.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 12/77] isdn: hfcsusb: Fix mISDN driver crash caused by transfer buffer on the stack
Date:   Wed,  4 Sep 2019 19:52:59 +0200
Message-Id: <20190904175304.773817812@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190904175303.317468926@linuxfoundation.org>
References: <20190904175303.317468926@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit d8a1de3d5bb881507602bc02e004904828f88711 ]

Since linux 4.9 it is not possible to use buffers on the stack for DMA transfers.

During usb probe the driver crashes with "transfer buffer is on stack" message.

This fix k-allocates a buffer to be used on "read_reg_atomic", which is a macro
that calls "usb_control_msg" under the hood.

Kernel 4.19 backtrace:

usb_hcd_submit_urb+0x3e5/0x900
? sched_clock+0x9/0x10
? log_store+0x203/0x270
? get_random_u32+0x6f/0x90
? cache_alloc_refill+0x784/0x8a0
usb_submit_urb+0x3b4/0x550
usb_start_wait_urb+0x4e/0xd0
usb_control_msg+0xb8/0x120
hfcsusb_probe+0x6bc/0xb40 [hfcsusb]
usb_probe_interface+0xc2/0x260
really_probe+0x176/0x280
driver_probe_device+0x49/0x130
__driver_attach+0xa9/0xb0
? driver_probe_device+0x130/0x130
bus_for_each_dev+0x5a/0x90
driver_attach+0x14/0x20
? driver_probe_device+0x130/0x130
bus_add_driver+0x157/0x1e0
driver_register+0x51/0xe0
usb_register_driver+0x5d/0x120
? 0xf81ed000
hfcsusb_drv_init+0x17/0x1000 [hfcsusb]
do_one_initcall+0x44/0x190
? free_unref_page_commit+0x6a/0xd0
do_init_module+0x46/0x1c0
load_module+0x1dc1/0x2400
sys_init_module+0xed/0x120
do_fast_syscall_32+0x7a/0x200
entry_SYSENTER_32+0x6b/0xbe

Signed-off-by: Juliana Rodrigueiro <juliana.rodrigueiro@intra2net.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/isdn/hardware/mISDN/hfcsusb.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/isdn/hardware/mISDN/hfcsusb.c b/drivers/isdn/hardware/mISDN/hfcsusb.c
index 6f19530ba2a93..726fba452f5f6 100644
--- a/drivers/isdn/hardware/mISDN/hfcsusb.c
+++ b/drivers/isdn/hardware/mISDN/hfcsusb.c
@@ -1701,13 +1701,23 @@ hfcsusb_stop_endpoint(struct hfcsusb *hw, int channel)
 static int
 setup_hfcsusb(struct hfcsusb *hw)
 {
+	void *dmabuf = kmalloc(sizeof(u_char), GFP_KERNEL);
 	u_char b;
+	int ret;
 
 	if (debug & DBG_HFC_CALL_TRACE)
 		printk(KERN_DEBUG "%s: %s\n", hw->name, __func__);
 
+	if (!dmabuf)
+		return -ENOMEM;
+
+	ret = read_reg_atomic(hw, HFCUSB_CHIP_ID, dmabuf);
+
+	memcpy(&b, dmabuf, sizeof(u_char));
+	kfree(dmabuf);
+
 	/* check the chip id */
-	if (read_reg_atomic(hw, HFCUSB_CHIP_ID, &b) != 1) {
+	if (ret != 1) {
 		printk(KERN_DEBUG "%s: %s: cannot read chip id\n",
 		       hw->name, __func__);
 		return 1;
-- 
2.20.1



