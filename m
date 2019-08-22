Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 909DD99AEA
	for <lists+stable@lfdr.de>; Thu, 22 Aug 2019 19:17:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728964AbfHVRRP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Aug 2019 13:17:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:58088 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390350AbfHVRI3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Aug 2019 13:08:29 -0400
Received: from sasha-vm.mshome.net (wsip-184-188-36-2.sd.sd.cox.net [184.188.36.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DA2D823405;
        Thu, 22 Aug 2019 17:08:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566493709;
        bh=NC7ztbCd7aVI48pb50ZBHxNerlptjjT/MMMS582ur3I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=de1DPJS1kaxByP25xauYMsMFJNQPdz5PrZ3JVbFAx31xfY/Wkla7c8m7ssxU6LgBP
         uFfU8gKtq0AS8BP7jvzZPagPLBJIAQrhjLIXXpqBMD0ENB+RWGfjN85Ak2iBmyfvY9
         khOKNLi5ghonq1JZN50QPaklW9657GWPeOxHjnCQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Oliver Neukum <oneukum@suse.com>,
        syzbot+c7df50363aaff50aa363@syzkaller.appspotmail.com,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 5.2 027/135] Input: kbtab - sanity check for endpoint type
Date:   Thu, 22 Aug 2019 13:06:23 -0400
Message-Id: <20190822170811.13303-28-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190822170811.13303-1-sashal@kernel.org>
References: <20190822170811.13303-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.2.10-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.2.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.2.10-rc1
X-KernelTest-Deadline: 2019-08-24T17:07+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oliver Neukum <oneukum@suse.com>

commit c88090dfc84254fa149174eb3e6a8458de1912c4 upstream.

The driver should check whether the endpoint it uses has the correct
type.

Reported-by: syzbot+c7df50363aaff50aa363@syzkaller.appspotmail.com
Signed-off-by: Oliver Neukum <oneukum@suse.com>
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/tablet/kbtab.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/input/tablet/kbtab.c b/drivers/input/tablet/kbtab.c
index 04b85571f41e3..aa577898e952b 100644
--- a/drivers/input/tablet/kbtab.c
+++ b/drivers/input/tablet/kbtab.c
@@ -117,6 +117,10 @@ static int kbtab_probe(struct usb_interface *intf, const struct usb_device_id *i
 	if (intf->cur_altsetting->desc.bNumEndpoints < 1)
 		return -ENODEV;
 
+	endpoint = &intf->cur_altsetting->endpoint[0].desc;
+	if (!usb_endpoint_is_int_in(endpoint))
+		return -ENODEV;
+
 	kbtab = kzalloc(sizeof(struct kbtab), GFP_KERNEL);
 	input_dev = input_allocate_device();
 	if (!kbtab || !input_dev)
@@ -155,8 +159,6 @@ static int kbtab_probe(struct usb_interface *intf, const struct usb_device_id *i
 	input_set_abs_params(input_dev, ABS_Y, 0, 0x1750, 4, 0);
 	input_set_abs_params(input_dev, ABS_PRESSURE, 0, 0xff, 0, 0);
 
-	endpoint = &intf->cur_altsetting->endpoint[0].desc;
-
 	usb_fill_int_urb(kbtab->irq, dev,
 			 usb_rcvintpipe(dev, endpoint->bEndpointAddress),
 			 kbtab->data, 8,
-- 
2.20.1

