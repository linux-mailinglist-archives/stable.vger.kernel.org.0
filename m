Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 432403916B
	for <lists+stable@lfdr.de>; Fri,  7 Jun 2019 17:59:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730286AbfFGPlV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Jun 2019 11:41:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:51148 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729325AbfFGPlV (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 7 Jun 2019 11:41:21 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E0C0B212F5;
        Fri,  7 Jun 2019 15:41:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559922080;
        bh=TwpQH5IEGVm1BfQanqjx4j2oQNl5Cm9iB/CvJp+FJHQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iA099m467p3siyG/5phXQWhdHQN4pObatnXxiOE3v5y4tKhpBs4k1EkKZmvU/8tRn
         0xp0k5tVVtf4tVj8Oh3QSYs441B8diVlWm4bFON8fR7WfBSY23M4awoZb5qKjQE3U7
         rso5ZDJ8hgYjjV7fhC96Z4ejO+7Obuj9Grh20pzU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
        syzbot+71f1e64501a309fcc012@syzkaller.appspotmail.com
Subject: [PATCH 4.14 29/69] USB: Fix slab-out-of-bounds write in usb_get_bos_descriptor
Date:   Fri,  7 Jun 2019 17:39:10 +0200
Message-Id: <20190607153851.981453928@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190607153848.271562617@linuxfoundation.org>
References: <20190607153848.271562617@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alan Stern <stern@rowland.harvard.edu>

commit a03ff54460817c76105f81f3aa8ef655759ccc9a upstream.

The syzkaller USB fuzzer found a slab-out-of-bounds write bug in the
USB core, caused by a failure to check the actual size of a BOS
descriptor.  This patch adds a check to make sure the descriptor is at
least as large as it is supposed to be, so that the code doesn't
inadvertently access memory beyond the end of the allocated region
when assigning to dev->bos->desc->bNumDeviceCaps later on.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Reported-and-tested-by: syzbot+71f1e64501a309fcc012@syzkaller.appspotmail.com
CC: <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/core/config.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/usb/core/config.c
+++ b/drivers/usb/core/config.c
@@ -936,8 +936,8 @@ int usb_get_bos_descriptor(struct usb_de
 
 	/* Get BOS descriptor */
 	ret = usb_get_descriptor(dev, USB_DT_BOS, 0, bos, USB_DT_BOS_SIZE);
-	if (ret < USB_DT_BOS_SIZE) {
-		dev_err(ddev, "unable to get BOS descriptor\n");
+	if (ret < USB_DT_BOS_SIZE || bos->bLength < USB_DT_BOS_SIZE) {
+		dev_err(ddev, "unable to get BOS descriptor or descriptor too short\n");
 		if (ret >= 0)
 			ret = -ENOMSG;
 		kfree(bos);


