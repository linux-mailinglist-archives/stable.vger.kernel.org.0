Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5610911AB02
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 13:34:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729132AbfLKMer (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 07:34:47 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:7217 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729131AbfLKMer (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 07:34:47 -0500
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 57E5FB965D7FD45D06AF;
        Wed, 11 Dec 2019 20:34:42 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS412-HUB.china.huawei.com (10.3.19.212) with Microsoft SMTP Server id
 14.3.439.0; Wed, 11 Dec 2019 20:34:36 +0800
From:   Mao Wenan <maowenan@huawei.com>
To:     <kernel.openeuler@huawei.com>
CC:     Johan Hovold <johan@kernel.org>, stable <stable@vger.kernel.org>,
        <syzbot+863724e7128e14b26732@syzkaller.appspotmail.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Mao Wenan <maowenan@huawei.com>
Subject: [PATCH rh7.3 02/11] can: peak_usb: fix slab info leak
Date:   Wed, 11 Dec 2019 20:31:45 +0800
Message-ID: <20191211123154.141040-3-maowenan@huawei.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191211123154.141040-1-maowenan@huawei.com>
References: <20191211123154.141040-1-maowenan@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.113.25]
X-CFilter-Loop: Reflected
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

mainline inclusion
from mainline-5.4
commit f7a1337f0d29b98733c8824e165fca3371d7d4fd
category: bugfix
bugzilla: NA
DTS: NA
CVE: CVE-2019-19534

-------------------------------------------------

Fix a small slab info leak due to a failure to clear the command buffer
at allocation.

The first 16 bytes of the command buffer are always sent to the device
in pcan_usb_send_cmd() even though only the first two may have been
initialised in case no argument payload is provided (e.g. when waiting
for a response).

Fixes: bb4785551f64 ("can: usb: PEAK-System Technik USB adapters driver core")
Cc: stable <stable@vger.kernel.org>     # 3.4
Reported-by: syzbot+863724e7128e14b26732@syzkaller.appspotmail.com
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Mao Wenan <maowenan@huawei.com>
---
 drivers/net/can/usb/peak_usb/pcan_usb_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/can/usb/peak_usb/pcan_usb_core.c b/drivers/net/can/usb/peak_usb/pcan_usb_core.c
index b9df329577a7..8320937a9fd1 100644
--- a/drivers/net/can/usb/peak_usb/pcan_usb_core.c
+++ b/drivers/net/can/usb/peak_usb/pcan_usb_core.c
@@ -731,7 +731,7 @@ static int peak_usb_create_dev(struct peak_usb_adapter *peak_usb_adapter,
 	dev = netdev_priv(netdev);
 
 	/* allocate a buffer large enough to send commands */
-	dev->cmd_buf = kmalloc(PCAN_USB_MAX_CMD_LEN, GFP_KERNEL);
+	dev->cmd_buf = kzalloc(PCAN_USB_MAX_CMD_LEN, GFP_KERNEL);
 	if (!dev->cmd_buf) {
 		err = -ENOMEM;
 		goto lbl_free_candev;
-- 
2.20.1

