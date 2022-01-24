Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4763498BFD
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:18:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243075AbiAXTSN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:18:13 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:45272 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242895AbiAXTQK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:16:10 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4BC9060B86;
        Mon, 24 Jan 2022 19:16:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B999C340E5;
        Mon, 24 Jan 2022 19:16:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643051766;
        bh=rNFNOaUveDWG3n5enoqmhQglyshTNpn0X82fcUAeWog=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lmlsi0iDp6eG0QK0B/5OVR72g8gx2+eZqz0ng62fFNsWvzoD6aDHDUoCHzUi6R5TJ
         FFdAx5sUK+cBabfX6zWnXLfKF/YEJ9b+7QF5+2HEA4gQGLVY3lMp0v0igsr4EqJSap
         QlM1SvYkc/7eKLiO18gcPp79bCgHUur6YY8wkli0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Wei Yongjun <weiyongjun1@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 081/239] usb: ftdi-elan: fix memory leak on device disconnect
Date:   Mon, 24 Jan 2022 19:41:59 +0100
Message-Id: <20220124183945.699408618@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183943.102762895@linuxfoundation.org>
References: <20220124183943.102762895@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wei Yongjun <weiyongjun1@huawei.com>

[ Upstream commit 1646566b5e0c556f779180a8514e521ac735de1e ]

'ftdi' is alloced when probe device, but not free on device disconnect,
this cause a memory leak as follows:

unreferenced object 0xffff88800d584000 (size 8400):
  comm "kworker/0:2", pid 3809, jiffies 4295453055 (age 13.784s)
  hex dump (first 32 bytes):
    00 40 58 0d 80 88 ff ff 00 40 58 0d 80 88 ff ff  .@X......@X.....
    00 00 00 00 00 00 00 00 00 00 00 00 ad 4e ad de  .............N..
  backtrace:
    [<000000000d47f947>] kmalloc_order_trace+0x19/0x110 mm/slab_common.c:960
    [<000000008548ac68>] ftdi_elan_probe+0x8c/0x880 drivers/usb/misc/ftdi-elan.c:2647
    [<000000007f73e422>] usb_probe_interface+0x31b/0x800 drivers/usb/core/driver.c:396
    [<00000000fe8d07fc>] really_probe+0x299/0xc30 drivers/base/dd.c:517
    [<0000000005da7d32>] __driver_probe_device+0x357/0x500 drivers/base/dd.c:751
    [<000000003c2c9579>] driver_probe_device+0x4e/0x140 drivers/base/dd.c:781

Fix it by freeing 'ftdi' after nobody use it.

Fixes: a5c66e4b2418 ("USB: ftdi-elan: client driver for ELAN Uxxx adapters")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
Link: https://lore.kernel.org/r/20211217083428.2441-1-weiyongjun1@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/misc/ftdi-elan.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/misc/ftdi-elan.c b/drivers/usb/misc/ftdi-elan.c
index 76c718ac8c78d..adc2a380be79f 100644
--- a/drivers/usb/misc/ftdi-elan.c
+++ b/drivers/usb/misc/ftdi-elan.c
@@ -202,6 +202,7 @@ static void ftdi_elan_delete(struct kref *kref)
 	mutex_unlock(&ftdi_module_lock);
 	kfree(ftdi->bulk_in_buffer);
 	ftdi->bulk_in_buffer = NULL;
+	kfree(ftdi);
 }
 
 static void ftdi_elan_put_kref(struct usb_ftdi *ftdi)
-- 
2.34.1



