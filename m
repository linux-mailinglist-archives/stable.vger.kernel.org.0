Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B41D1393231
	for <lists+stable@lfdr.de>; Thu, 27 May 2021 17:14:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237145AbhE0PQF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 May 2021 11:16:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:44318 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237103AbhE0PPY (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 May 2021 11:15:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 449B0613D8;
        Thu, 27 May 2021 15:13:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622128431;
        bh=TR9vGiWJQI7ifGZDSg2mVN/XhyP3rPp0dNlLw1qTPME=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hj1uHVsf4ddCvaNlmfewoNqQirrUdSOSAb6GbpIZhD0A6Mc63e/5E/wqCmjP/mxEy
         6MiuERoaw3+wOw0sL+4hZbK2DvM1V8v17WOmbDgmXNx2d7iW+lSgzHyeiXk2mKHbQQ
         LcZMb1DDPKDqcmGfPqRjJoPoC9ZBaYSU0r1h2Mso=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+19bcfc64a8df1318d1c3@syzkaller.appspotmail.com,
        Dongliang Mu <mudongliangabcd@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.12 7/7] NFC: nci: fix memory leak in nci_allocate_device
Date:   Thu, 27 May 2021 17:13:08 +0200
Message-Id: <20210527151139.479147283@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210527151139.241267495@linuxfoundation.org>
References: <20210527151139.241267495@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dongliang Mu <mudongliangabcd@gmail.com>

commit e0652f8bb44d6294eeeac06d703185357f25d50b upstream.

nfcmrvl_disconnect fails to free the hci_dev field in struct nci_dev.
Fix this by freeing hci_dev in nci_free_device.

BUG: memory leak
unreferenced object 0xffff888111ea6800 (size 1024):
  comm "kworker/1:0", pid 19, jiffies 4294942308 (age 13.580s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 60 fd 0c 81 88 ff ff  .........`......
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<000000004bc25d43>] kmalloc include/linux/slab.h:552 [inline]
    [<000000004bc25d43>] kzalloc include/linux/slab.h:682 [inline]
    [<000000004bc25d43>] nci_hci_allocate+0x21/0xd0 net/nfc/nci/hci.c:784
    [<00000000c59cff92>] nci_allocate_device net/nfc/nci/core.c:1170 [inline]
    [<00000000c59cff92>] nci_allocate_device+0x10b/0x160 net/nfc/nci/core.c:1132
    [<00000000006e0a8e>] nfcmrvl_nci_register_dev+0x10a/0x1c0 drivers/nfc/nfcmrvl/main.c:153
    [<000000004da1b57e>] nfcmrvl_probe+0x223/0x290 drivers/nfc/nfcmrvl/usb.c:345
    [<00000000d506aed9>] usb_probe_interface+0x177/0x370 drivers/usb/core/driver.c:396
    [<00000000bc632c92>] really_probe+0x159/0x4a0 drivers/base/dd.c:554
    [<00000000f5009125>] driver_probe_device+0x84/0x100 drivers/base/dd.c:740
    [<000000000ce658ca>] __device_attach_driver+0xee/0x110 drivers/base/dd.c:846
    [<000000007067d05f>] bus_for_each_drv+0xb7/0x100 drivers/base/bus.c:431
    [<00000000f8e13372>] __device_attach+0x122/0x250 drivers/base/dd.c:914
    [<000000009cf68860>] bus_probe_device+0xc6/0xe0 drivers/base/bus.c:491
    [<00000000359c965a>] device_add+0x5be/0xc30 drivers/base/core.c:3109
    [<00000000086e4bd3>] usb_set_configuration+0x9d9/0xb90 drivers/usb/core/message.c:2164
    [<00000000ca036872>] usb_generic_driver_probe+0x8c/0xc0 drivers/usb/core/generic.c:238
    [<00000000d40d36f6>] usb_probe_device+0x5c/0x140 drivers/usb/core/driver.c:293
    [<00000000bc632c92>] really_probe+0x159/0x4a0 drivers/base/dd.c:554

Reported-by: syzbot+19bcfc64a8df1318d1c3@syzkaller.appspotmail.com
Fixes: 11f54f228643 ("NFC: nci: Add HCI over NCI protocol support")
Signed-off-by: Dongliang Mu <mudongliangabcd@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/nfc/nci_core.h |    1 +
 net/nfc/nci/core.c         |    1 +
 net/nfc/nci/hci.c          |    5 +++++
 3 files changed, 7 insertions(+)

--- a/include/net/nfc/nci_core.h
+++ b/include/net/nfc/nci_core.h
@@ -298,6 +298,7 @@ int nci_nfcc_loopback(struct nci_dev *nd
 		      struct sk_buff **resp);
 
 struct nci_hci_dev *nci_hci_allocate(struct nci_dev *ndev);
+void nci_hci_deallocate(struct nci_dev *ndev);
 int nci_hci_send_event(struct nci_dev *ndev, u8 gate, u8 event,
 		       const u8 *param, size_t param_len);
 int nci_hci_send_cmd(struct nci_dev *ndev, u8 gate,
--- a/net/nfc/nci/core.c
+++ b/net/nfc/nci/core.c
@@ -1191,6 +1191,7 @@ EXPORT_SYMBOL(nci_allocate_device);
 void nci_free_device(struct nci_dev *ndev)
 {
 	nfc_free_device(ndev->nfc_dev);
+	nci_hci_deallocate(ndev);
 	kfree(ndev);
 }
 EXPORT_SYMBOL(nci_free_device);
--- a/net/nfc/nci/hci.c
+++ b/net/nfc/nci/hci.c
@@ -792,3 +792,8 @@ struct nci_hci_dev *nci_hci_allocate(str
 
 	return hdev;
 }
+
+void nci_hci_deallocate(struct nci_dev *ndev)
+{
+	kfree(ndev->hci_dev);
+}


