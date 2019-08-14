Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B6178C7AB
	for <lists+stable@lfdr.de>; Wed, 14 Aug 2019 04:25:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728390AbfHNCZp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Aug 2019 22:25:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:52802 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729971AbfHNCXv (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 13 Aug 2019 22:23:51 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 56ADA20679;
        Wed, 14 Aug 2019 02:23:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565749431;
        bh=5OM0KKqgmvpI3Ob3ZcIFnfVf47X5AKUtdvCUgHxSCWg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uOi1dXl9RdbOpCpXK2GWkmoTg2zNTwoOJq9/wGxWF+DDiAfjpzbQzTwj8QWExFlSG
         5ugqdCSFH8t87QwRNtFh/TC8ledMAiY6n66zwy2BeXIKXw1krVOiIv0glgoC/kWCWv
         BHbDCtBaer218a02ed6NjuXb/dPSBo1BFNdOWGFA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Oliver Neukum <oneukum@suse.com>,
        syzbot+c7df50363aaff50aa363@syzkaller.appspotmail.com,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sasha Levin <sashal@kernel.org>, linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 15/33] Input: kbtab - sanity check for endpoint type
Date:   Tue, 13 Aug 2019 22:23:05 -0400
Message-Id: <20190814022323.17111-15-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190814022323.17111-1-sashal@kernel.org>
References: <20190814022323.17111-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oliver Neukum <oneukum@suse.com>

[ Upstream commit c88090dfc84254fa149174eb3e6a8458de1912c4 ]

The driver should check whether the endpoint it uses has the correct
type.

Reported-by: syzbot+c7df50363aaff50aa363@syzkaller.appspotmail.com
Signed-off-by: Oliver Neukum <oneukum@suse.com>
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/tablet/kbtab.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/input/tablet/kbtab.c b/drivers/input/tablet/kbtab.c
index 4d9d64908b595..b7ea64ec1205e 100644
--- a/drivers/input/tablet/kbtab.c
+++ b/drivers/input/tablet/kbtab.c
@@ -125,6 +125,10 @@ static int kbtab_probe(struct usb_interface *intf, const struct usb_device_id *i
 	if (intf->cur_altsetting->desc.bNumEndpoints < 1)
 		return -ENODEV;
 
+	endpoint = &intf->cur_altsetting->endpoint[0].desc;
+	if (!usb_endpoint_is_int_in(endpoint))
+		return -ENODEV;
+
 	kbtab = kzalloc(sizeof(struct kbtab), GFP_KERNEL);
 	input_dev = input_allocate_device();
 	if (!kbtab || !input_dev)
@@ -163,8 +167,6 @@ static int kbtab_probe(struct usb_interface *intf, const struct usb_device_id *i
 	input_set_abs_params(input_dev, ABS_Y, 0, 0x1750, 4, 0);
 	input_set_abs_params(input_dev, ABS_PRESSURE, 0, 0xff, 0, 0);
 
-	endpoint = &intf->cur_altsetting->endpoint[0].desc;
-
 	usb_fill_int_urb(kbtab->irq, dev,
 			 usb_rcvintpipe(dev, endpoint->bEndpointAddress),
 			 kbtab->data, 8,
-- 
2.20.1

