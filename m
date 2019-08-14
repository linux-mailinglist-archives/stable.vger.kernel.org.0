Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E63228C7DF
	for <lists+stable@lfdr.de>; Wed, 14 Aug 2019 04:28:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730244AbfHNC0S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Aug 2019 22:26:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:54370 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729471AbfHNC0R (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 13 Aug 2019 22:26:17 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8DEA120679;
        Wed, 14 Aug 2019 02:26:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565749576;
        bh=3XWtZEdk/jCI6CjF04iO/UxmbvT/Ken4lpg30kwtLSc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hHTZpVnjLE97x9NbqV5RqujDPkiHT5Ip0GLh7tn9fgi97qsljVF6LnzVSaVC7R5RG
         XKgIbi9V5MuEJWNmJnZqMS5Ll30hY1fAQa1kv0E3KcFckGmcONQRVNKSn3bySDGntB
         zo4Cu+D6x/d1mCKw3GldkCuQP/OxyP0ovcG46hk0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Oliver Neukum <oneukum@suse.com>,
        syzbot+c7df50363aaff50aa363@syzkaller.appspotmail.com,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sasha Levin <sashal@kernel.org>, linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 14/28] Input: kbtab - sanity check for endpoint type
Date:   Tue, 13 Aug 2019 22:25:36 -0400
Message-Id: <20190814022550.17463-14-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190814022550.17463-1-sashal@kernel.org>
References: <20190814022550.17463-1-sashal@kernel.org>
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
index 2812f9236b7d0..0ccc120a0f145 100644
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
@@ -164,8 +168,6 @@ static int kbtab_probe(struct usb_interface *intf, const struct usb_device_id *i
 	input_set_abs_params(input_dev, ABS_Y, 0, 0x1750, 4, 0);
 	input_set_abs_params(input_dev, ABS_PRESSURE, 0, 0xff, 0, 0);
 
-	endpoint = &intf->cur_altsetting->endpoint[0].desc;
-
 	usb_fill_int_urb(kbtab->irq, dev,
 			 usb_rcvintpipe(dev, endpoint->bEndpointAddress),
 			 kbtab->data, 8,
-- 
2.20.1

