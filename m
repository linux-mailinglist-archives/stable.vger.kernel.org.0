Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A30B10BED6
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:39:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728436AbfK0Uop (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 15:44:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:54546 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729639AbfK0Uoo (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 15:44:44 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0712C2158A;
        Wed, 27 Nov 2019 20:44:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574887484;
        bh=IZD60WKOoIIwQZ0XlG9VB+VgoMwu1UzQuNA7TjHizyw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JidVmYXWpmebyPjgY1bOUPMsBWY1+On84oGceVIS0JTC+sHAdygNn/t4jajhxmF7K
         7ZKLJEuTHdNwrKR7EiRh3z8yJ17S+8uVvib7SHp4mReTo48LCTzlswwfNVTiP62yH2
         E7QS0iSVw9zmSOi2MoD0tIjro6MWDAoGhzFYt1Xc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+d93dff37e6a89431c158@syzkaller.appspotmail.com,
        Oliver Neukum <oneukum@suse.com>, Sean Young <sean@mess.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH 4.9 129/151] media: b2c2-flexcop-usb: add sanity checking
Date:   Wed, 27 Nov 2019 21:31:52 +0100
Message-Id: <20191127203046.084865383@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127203000.773542911@linuxfoundation.org>
References: <20191127203000.773542911@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oliver Neukum <oneukum@suse.com>

commit 1b976fc6d684e3282914cdbe7a8d68fdce19095c upstream.

The driver needs an isochronous endpoint to be present. It will
oops in its absence. Add checking for it.

Reported-by: syzbot+d93dff37e6a89431c158@syzkaller.appspotmail.com
Signed-off-by: Oliver Neukum <oneukum@suse.com>
Signed-off-by: Sean Young <sean@mess.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/usb/b2c2/flexcop-usb.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/media/usb/b2c2/flexcop-usb.c
+++ b/drivers/media/usb/b2c2/flexcop-usb.c
@@ -538,6 +538,9 @@ static int flexcop_usb_probe(struct usb_
 	struct flexcop_device *fc = NULL;
 	int ret;
 
+	if (intf->cur_altsetting->desc.bNumEndpoints < 1)
+		return -ENODEV;
+
 	if ((fc = flexcop_device_kmalloc(sizeof(struct flexcop_usb))) == NULL) {
 		err("out of memory\n");
 		return -ENOMEM;


