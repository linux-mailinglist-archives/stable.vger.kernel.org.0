Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 645F12018D9
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 19:02:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387663AbgFSQxk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 12:53:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:53834 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387623AbgFSOhC (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 10:37:02 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C32F021582;
        Fri, 19 Jun 2020 14:37:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592577422;
        bh=IWwugB8J0T2HwlfDvqTqvYRdo+b31C/P+vvrxhblFWk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fU4DzqB0vLuabe/Qz8mZb5nG3pfXSfkH7p1sT5QpB1mxBSfM8Dq+L7Rky5ZPprnmN
         etQJ8ypvIkDg8ReVYRRtWsXZidCiSdStMMMHMnHc0x4AZUe5uZKgWkJMd37nPZSzF4
         InnnjYVP5aQibMq91B4c3hGRNtyrAW+3CpsuJYr0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Xiaolong Huang <butterflyhuangxx@gmail.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 4.4 045/101] can: kvaser_usb: kvaser_usb_leaf: Fix some info-leaks to USB devices
Date:   Fri, 19 Jun 2020 16:32:34 +0200
Message-Id: <20200619141616.459095266@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141614.001544111@linuxfoundation.org>
References: <20200619141614.001544111@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiaolong Huang <butterflyhuangxx@gmail.com>

commit da2311a6385c3b499da2ed5d9be59ce331fa93e9 upstream.

Uninitialized Kernel memory can leak to USB devices.

Fix this by using kzalloc() instead of kmalloc().

Signed-off-by: Xiaolong Huang <butterflyhuangxx@gmail.com>
Fixes: 7259124eac7d ("can: kvaser_usb: Split driver into kvaser_usb_core.c and kvaser_usb_leaf.c")
Cc: linux-stable <stable@vger.kernel.org> # >= v4.19
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
[bwh: Backported to 4.9: adjust filename, context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/can/usb/kvaser_usb.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/net/can/usb/kvaser_usb.c
+++ b/drivers/net/can/usb/kvaser_usb.c
@@ -787,7 +787,7 @@ static int kvaser_usb_simple_msg_async(s
 		return -ENOMEM;
 	}
 
-	buf = kmalloc(sizeof(struct kvaser_msg), GFP_ATOMIC);
+	buf = kzalloc(sizeof(struct kvaser_msg), GFP_ATOMIC);
 	if (!buf) {
 		usb_free_urb(urb);
 		return -ENOMEM;
@@ -1457,7 +1457,7 @@ static int kvaser_usb_set_opt_mode(const
 	struct kvaser_msg *msg;
 	int rc;
 
-	msg = kmalloc(sizeof(*msg), GFP_KERNEL);
+	msg = kzalloc(sizeof(*msg), GFP_KERNEL);
 	if (!msg)
 		return -ENOMEM;
 
@@ -1590,7 +1590,7 @@ static int kvaser_usb_flush_queue(struct
 	struct kvaser_msg *msg;
 	int rc;
 
-	msg = kmalloc(sizeof(*msg), GFP_KERNEL);
+	msg = kzalloc(sizeof(*msg), GFP_KERNEL);
 	if (!msg)
 		return -ENOMEM;
 


