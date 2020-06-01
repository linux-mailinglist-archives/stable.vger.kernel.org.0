Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E2151EA8E4
	for <lists+stable@lfdr.de>; Mon,  1 Jun 2020 19:57:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728752AbgFAR4x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 13:56:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:37666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728739AbgFAR4w (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Jun 2020 13:56:52 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4A58C206E2;
        Mon,  1 Jun 2020 17:56:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591034211;
        bh=/5VkpIO2UD91rUp5qWHQOHYDOK8hTEv34OEZz29srVY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PJl8FZ/ErtOFQ4q8lsjLcnst55O8b5MKhh338Dq1j+MCJ/hwE+ROeK8A9mK6KxsMJ
         7sLfTY6l6nqBF+n9XAulhESqj05v58Y/xopmNLLBcaieVo1eeoRBpGW0w/lU9T5FU0
         rnmxFYzB5yK+tfp2CA119iNqY9VpxuqT4TfqYFfc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Kazuya Mizuguchi <kazuya.mizuguchi.ks@renesas.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Felipe Balbi <felipe.balbi@linux.intel.com>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 4.4 42/48] usb: renesas_usbhs: gadget: fix spin_lock_init() for &uep->lock
Date:   Mon,  1 Jun 2020 19:53:52 +0200
Message-Id: <20200601174003.939899118@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200601173952.175939894@linuxfoundation.org>
References: <20200601173952.175939894@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>

commit 14a8d4bfc2102f85ce097563d151370c91c1898a upstream.

This patch fixes an issue that the spin_lock_init() is not called
for almost all pipes. Otherwise, the lockdep output the following
message when we connect a usb cable using g_ncm:

 INFO: trying to register non-static key.
 the code is fine but needs lockdep annotation.
 turning off the locking correctness validator.

Reported-by: Kazuya Mizuguchi <kazuya.mizuguchi.ks@renesas.com>
Fixes: b8b9c974afee ("usb: renesas_usbhs: gadget: disable all eps when the driver stops")
Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Tested-by: Kazuya Mizuguchi <kazuya.mizuguchi.ks@renesas.com>
Signed-off-by: Felipe Balbi <felipe.balbi@linux.intel.com>
Cc: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/renesas_usbhs/mod_gadget.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/renesas_usbhs/mod_gadget.c
+++ b/drivers/usb/renesas_usbhs/mod_gadget.c
@@ -1103,7 +1103,6 @@ int usbhs_mod_gadget_probe(struct usbhs_
 		ret = -ENOMEM;
 		goto usbhs_mod_gadget_probe_err_gpriv;
 	}
-	spin_lock_init(&uep->lock);
 
 	gpriv->transceiver = usb_get_phy(USB_PHY_TYPE_UNDEFINED);
 	dev_info(dev, "%stransceiver found\n",
@@ -1151,6 +1150,7 @@ int usbhs_mod_gadget_probe(struct usbhs_
 		uep->ep.name		= uep->ep_name;
 		uep->ep.ops		= &usbhsg_ep_ops;
 		INIT_LIST_HEAD(&uep->ep.ep_list);
+		spin_lock_init(&uep->lock);
 
 		/* init DCP */
 		if (usbhsg_is_dcp(uep)) {


