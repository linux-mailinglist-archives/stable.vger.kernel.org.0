Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFCD445BCC2
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 13:29:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243104AbhKXMcU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 07:32:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:36026 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243282AbhKXMUS (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 07:20:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 91D42610D2;
        Wed, 24 Nov 2021 12:12:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637755940;
        bh=zOXv2UtE57JKTq2KzF1uEVYdV6PH/qTwljCDXQtgrXU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vWJqnRgH1zCynVEhB+/lM1OTPiILAU14HCL6/5E5Pd0aoi2ckHJeQacgP+QwXpVR5
         ky3TDa9fb1GsQM6ek4WFtgkLtloTtPIRoHep2YWE5f0WTXl+qrRoxEMyRndkVJcffS
         Kn8TmqGQaeZrc30XvnYAsYevHOanRLgs26Oxwk2k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Wang Hai <wanghai38@huawei.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 113/207] libertas: Fix possible memory leak in probe and disconnect
Date:   Wed, 24 Nov 2021 12:56:24 +0100
Message-Id: <20211124115707.729712542@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115703.941380739@linuxfoundation.org>
References: <20211124115703.941380739@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wang Hai <wanghai38@huawei.com>

[ Upstream commit 9692151e2fe7a326bafe99836fd1f20a2cc3a049 ]

I got memory leak as follows when doing fault injection test:

unreferenced object 0xffff88812c7d7400 (size 512):
  comm "kworker/6:1", pid 176, jiffies 4295003332 (age 822.830s)
  hex dump (first 32 bytes):
    00 68 1e 04 81 88 ff ff 01 00 00 00 00 00 00 00  .h..............
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff8167939c>] slab_post_alloc_hook+0x9c/0x490
    [<ffffffff8167f627>] kmem_cache_alloc_trace+0x1f7/0x470
    [<ffffffffa02c9873>] if_usb_probe+0x63/0x446 [usb8xxx]
    [<ffffffffa022668a>] usb_probe_interface+0x1aa/0x3c0 [usbcore]
    [<ffffffff82b59630>] really_probe+0x190/0x480
    [<ffffffff82b59a19>] __driver_probe_device+0xf9/0x180
    [<ffffffff82b59af3>] driver_probe_device+0x53/0x130
    [<ffffffff82b5a075>] __device_attach_driver+0x105/0x130
    [<ffffffff82b55949>] bus_for_each_drv+0x129/0x190
    [<ffffffff82b593c9>] __device_attach+0x1c9/0x270
    [<ffffffff82b5a250>] device_initial_probe+0x20/0x30
    [<ffffffff82b579c2>] bus_probe_device+0x142/0x160
    [<ffffffff82b52e49>] device_add+0x829/0x1300
    [<ffffffffa02229b1>] usb_set_configuration+0xb01/0xcc0 [usbcore]
    [<ffffffffa0235c4e>] usb_generic_driver_probe+0x6e/0x90 [usbcore]
    [<ffffffffa022641f>] usb_probe_device+0x6f/0x130 [usbcore]

cardp is missing being freed in the error handling path of the probe
and the path of the disconnect, which will cause memory leak.

This patch adds the missing kfree().

Fixes: 876c9d3aeb98 ("[PATCH] Marvell Libertas 8388 802.11b/g USB driver")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wang Hai <wanghai38@huawei.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20211020120345.2016045-3-wanghai38@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/marvell/libertas/if_usb.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/marvell/libertas/if_usb.c b/drivers/net/wireless/marvell/libertas/if_usb.c
index 9d147b11ee516..9f19fd5c18d07 100644
--- a/drivers/net/wireless/marvell/libertas/if_usb.c
+++ b/drivers/net/wireless/marvell/libertas/if_usb.c
@@ -292,6 +292,7 @@ err_add_card:
 	if_usb_reset_device(cardp);
 dealloc:
 	if_usb_free(cardp);
+	kfree(cardp);
 
 error:
 	return r;
@@ -318,6 +319,7 @@ static void if_usb_disconnect(struct usb_interface *intf)
 
 	/* Unlink and free urb */
 	if_usb_free(cardp);
+	kfree(cardp);
 
 	usb_set_intfdata(intf, NULL);
 	usb_put_dev(interface_to_usbdev(intf));
-- 
2.33.0



