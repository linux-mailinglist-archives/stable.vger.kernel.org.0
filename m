Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9891629C37E
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 18:47:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1822092AbgJ0Rqy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 13:46:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:53096 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2901809AbgJ0O1E (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:27:04 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DA99B20790;
        Tue, 27 Oct 2020 14:27:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603808823;
        bh=SySYuPaU2EKoYhRLPpJ4Wa5bYuGDlO0eSs56k1kPA18=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wmA5M3+O/SlyiqLuRlP+lOHxi19v+1RBDOV9SDT6AtSABIFjjf03IxidDQokVsrZ2
         REwQ/6isN/14rYpOrBTyH0vA/I2UKbfr7hOfKhabXR6/rXzZN2r7zdnCgBLweKpokZ
         TLQwj0JWJRzK2FqwDCku4HlTbI2xScxNQkEGGluc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Felipe Balbi <balbi@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 237/264] usb: dwc3: simple: add support for Hikey 970
Date:   Tue, 27 Oct 2020 14:54:55 +0100
Message-Id: <20201027135441.782362183@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135430.632029009@linuxfoundation.org>
References: <20201027135430.632029009@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

[ Upstream commit b68d9251561f33661e53dd618f1cafe7ec9ec3c2 ]

This binding driver is needed for Hikey 970 to work,
as otherwise a Serror is produced:

    [    1.837458] SError Interrupt on CPU0, code 0xbf000002 -- SError
    [    1.837462] CPU: 0 PID: 74 Comm: kworker/0:1 Not tainted 5.8.0+ #205
    [    1.837463] Hardware name: HiKey970 (DT)
    [    1.837465] Workqueue: events deferred_probe_work_func
    [    1.837467] pstate: 20000005 (nzCv daif -PAN -UAO BTYPE=--)
    [    1.837468] pc : _raw_spin_unlock_irqrestore+0x18/0x50
    [    1.837469] lr : regmap_unlock_spinlock+0x14/0x20
    [    1.837470] sp : ffff8000124dba60
    [    1.837471] x29: ffff8000124dba60 x28: 0000000000000000
    [    1.837474] x27: ffff0001b7e854c8 x26: ffff80001204ea18
    [    1.837476] x25: 0000000000000005 x24: ffff800011f918f8
    [    1.837479] x23: ffff800011fbb588 x22: ffff0001b7e40e00
    [    1.837481] x21: 0000000000000100 x20: 0000000000000000
    [    1.837483] x19: ffff0001b767ec00 x18: 00000000ff10c000
    [    1.837485] x17: 0000000000000002 x16: 0000b0740fdb9950
    [    1.837488] x15: ffff8000116c1198 x14: ffffffffffffffff
    [    1.837490] x13: 0000000000000030 x12: 0101010101010101
    [    1.837493] x11: 0000000000000020 x10: ffff0001bf17d130
    [    1.837495] x9 : 0000000000000000 x8 : ffff0001b6938080
    [    1.837497] x7 : 0000000000000000 x6 : 000000000000003f
    [    1.837500] x5 : 0000000000000000 x4 : 0000000000000000
    [    1.837502] x3 : ffff80001096a880 x2 : 0000000000000000
    [    1.837505] x1 : ffff0001b7e40e00 x0 : 0000000100000001
    [    1.837507] Kernel panic - not syncing: Asynchronous SError Interrupt
    [    1.837509] CPU: 0 PID: 74 Comm: kworker/0:1 Not tainted 5.8.0+ #205
    [    1.837510] Hardware name: HiKey970 (DT)
    [    1.837511] Workqueue: events deferred_probe_work_func
    [    1.837513] Call trace:
    [    1.837514]  dump_backtrace+0x0/0x1e0
    [    1.837515]  show_stack+0x18/0x24
    [    1.837516]  dump_stack+0xc0/0x11c
    [    1.837517]  panic+0x15c/0x324
    [    1.837518]  nmi_panic+0x8c/0x90
    [    1.837519]  arm64_serror_panic+0x78/0x84
    [    1.837520]  do_serror+0x158/0x15c
    [    1.837521]  el1_error+0x84/0x100
    [    1.837522]  _raw_spin_unlock_irqrestore+0x18/0x50
    [    1.837523]  regmap_write+0x58/0x80
    [    1.837524]  hi3660_reset_deassert+0x28/0x34
    [    1.837526]  reset_control_deassert+0x50/0x260
    [    1.837527]  reset_control_deassert+0xf4/0x260
    [    1.837528]  dwc3_probe+0x5dc/0xe6c
    [    1.837529]  platform_drv_probe+0x54/0xb0
    [    1.837530]  really_probe+0xe0/0x490
    [    1.837531]  driver_probe_device+0xf4/0x160
    [    1.837532]  __device_attach_driver+0x8c/0x114
    [    1.837533]  bus_for_each_drv+0x78/0xcc
    [    1.837534]  __device_attach+0x108/0x1a0
    [    1.837535]  device_initial_probe+0x14/0x20
    [    1.837537]  bus_probe_device+0x98/0xa0
    [    1.837538]  deferred_probe_work_func+0x88/0xe0
    [    1.837539]  process_one_work+0x1cc/0x350
    [    1.837540]  worker_thread+0x2c0/0x470
    [    1.837541]  kthread+0x154/0x160
    [    1.837542]  ret_from_fork+0x10/0x30
    [    1.837569] SMP: stopping secondary CPUs
    [    1.837570] Kernel Offset: 0x1d0000 from 0xffff800010000000
    [    1.837571] PHYS_OFFSET: 0x0
    [    1.837572] CPU features: 0x240002,20882004
    [    1.837573] Memory Limit: none

Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Felipe Balbi <balbi@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/dwc3/dwc3-of-simple.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/dwc3/dwc3-of-simple.c b/drivers/usb/dwc3/dwc3-of-simple.c
index 4c2771c5e7276..1ef89a4317c87 100644
--- a/drivers/usb/dwc3/dwc3-of-simple.c
+++ b/drivers/usb/dwc3/dwc3-of-simple.c
@@ -243,6 +243,7 @@ static const struct of_device_id of_dwc3_simple_match[] = {
 	{ .compatible = "amlogic,meson-axg-dwc3" },
 	{ .compatible = "amlogic,meson-gxl-dwc3" },
 	{ .compatible = "allwinner,sun50i-h6-dwc3" },
+	{ .compatible = "hisilicon,hi3670-dwc3" },
 	{ /* Sentinel */ }
 };
 MODULE_DEVICE_TABLE(of, of_dwc3_simple_match);
-- 
2.25.1



