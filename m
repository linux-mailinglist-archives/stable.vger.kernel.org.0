Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 03AC9CAB08
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 19:27:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388999AbfJCQQ2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:16:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:41460 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388994AbfJCQQ1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:16:27 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A10D220865;
        Thu,  3 Oct 2019 16:16:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570119387;
        bh=A7bB2lRTeqg19DskxmH6x0oHCi3rj0FsE/t+ZNh3yVU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rK94rNr2XlRZYWRTIEyywnJQiDe32gxmuqN/oVynTcHeP8Vtr6Esocx8NcKJvn5DQ
         6/RZWCu+sxlxNw1sxKSEBjwXOpBDKy5Wv2DpU2znaoMeNOn6jmvXQvQpeXezIeeLpQ
         fRTtds5E5C6PreQZSkI7peL3IZ9Yhbg9O2/vBg7c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+01a77b82edaa374068e1@syzkaller.appspotmail.com,
        Oliver Neukum <oneukum@suse.com>, Sean Young <sean@mess.org>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 047/211] media: iguanair: add sanity checks
Date:   Thu,  3 Oct 2019 17:51:53 +0200
Message-Id: <20191003154458.734574947@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154447.010950442@linuxfoundation.org>
References: <20191003154447.010950442@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oliver Neukum <oneukum@suse.com>

[ Upstream commit ab1cbdf159beba7395a13ab70bc71180929ca064 ]

The driver needs to check the endpoint types, too, as opposed
to the number of endpoints. This also requires moving the check earlier.

Reported-by: syzbot+01a77b82edaa374068e1@syzkaller.appspotmail.com
Signed-off-by: Oliver Neukum <oneukum@suse.com>
Signed-off-by: Sean Young <sean@mess.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/rc/iguanair.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/media/rc/iguanair.c b/drivers/media/rc/iguanair.c
index 7daac8bab83b0..6f3030b2054d0 100644
--- a/drivers/media/rc/iguanair.c
+++ b/drivers/media/rc/iguanair.c
@@ -424,6 +424,10 @@ static int iguanair_probe(struct usb_interface *intf,
 	int ret, pipein, pipeout;
 	struct usb_host_interface *idesc;
 
+	idesc = intf->altsetting;
+	if (idesc->desc.bNumEndpoints < 2)
+		return -ENODEV;
+
 	ir = kzalloc(sizeof(*ir), GFP_KERNEL);
 	rc = rc_allocate_device(RC_DRIVER_IR_RAW);
 	if (!ir || !rc) {
@@ -438,18 +442,13 @@ static int iguanair_probe(struct usb_interface *intf,
 	ir->urb_in = usb_alloc_urb(0, GFP_KERNEL);
 	ir->urb_out = usb_alloc_urb(0, GFP_KERNEL);
 
-	if (!ir->buf_in || !ir->packet || !ir->urb_in || !ir->urb_out) {
+	if (!ir->buf_in || !ir->packet || !ir->urb_in || !ir->urb_out ||
+	    !usb_endpoint_is_int_in(&idesc->endpoint[0].desc) ||
+	    !usb_endpoint_is_int_out(&idesc->endpoint[1].desc)) {
 		ret = -ENOMEM;
 		goto out;
 	}
 
-	idesc = intf->altsetting;
-
-	if (idesc->desc.bNumEndpoints < 2) {
-		ret = -ENODEV;
-		goto out;
-	}
-
 	ir->rc = rc;
 	ir->dev = &intf->dev;
 	ir->udev = udev;
-- 
2.20.1



