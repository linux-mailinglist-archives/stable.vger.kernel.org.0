Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C6068C30F9
	for <lists+stable@lfdr.de>; Tue,  1 Oct 2019 12:10:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726138AbfJAKKh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Oct 2019 06:10:37 -0400
Received: from relmlor1.renesas.com ([210.160.252.171]:61186 "EHLO
        relmlie5.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730222AbfJAKKg (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Oct 2019 06:10:36 -0400
X-IronPort-AV: E=Sophos;i="5.64,570,1559487600"; 
   d="scan'208";a="28007373"
Received: from unknown (HELO relmlir6.idc.renesas.com) ([10.200.68.152])
  by relmlie5.idc.renesas.com with ESMTP; 01 Oct 2019 19:10:34 +0900
Received: from localhost.localdomain (unknown [10.166.17.210])
        by relmlir6.idc.renesas.com (Postfix) with ESMTP id 06EA341F2F81;
        Tue,  1 Oct 2019 19:10:34 +0900 (JST)
From:   Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
To:     balbi@kernel.org
Cc:     gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, stable@vger.kernel.org,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Subject: [PATCH 1/2] usb: renesas_usbhs: gadget: Do not discard queues in usb_ep_set_{halt,wedge}()
Date:   Tue,  1 Oct 2019 19:10:32 +0900
Message-Id: <1569924633-322-2-git-send-email-yoshihiro.shimoda.uh@renesas.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1569924633-322-1-git-send-email-yoshihiro.shimoda.uh@renesas.com>
References: <1569924633-322-1-git-send-email-yoshihiro.shimoda.uh@renesas.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The commit 97664a207bc2 ("usb: renesas_usbhs: shrink spin lock area")
had added a usbhsg_pipe_disable() calling into
__usbhsg_ep_set_halt_wedge() accidentally. But, this driver should
not call the usbhsg_pipe_disable() because the function discards
all queues. So, this patch removes it.

Fixes: 97664a207bc2 ("usb: renesas_usbhs: shrink spin lock area")
Cc: <stable@vger.kernel.org> # v3.1+
Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
---
 drivers/usb/renesas_usbhs/mod_gadget.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/usb/renesas_usbhs/mod_gadget.c b/drivers/usb/renesas_usbhs/mod_gadget.c
index 4d571a5..2c7523a 100644
--- a/drivers/usb/renesas_usbhs/mod_gadget.c
+++ b/drivers/usb/renesas_usbhs/mod_gadget.c
@@ -723,8 +723,6 @@ static int __usbhsg_ep_set_halt_wedge(struct usb_ep *ep, int halt, int wedge)
 	struct device *dev = usbhsg_gpriv_to_dev(gpriv);
 	unsigned long flags;
 
-	usbhsg_pipe_disable(uep);
-
 	dev_dbg(dev, "set halt %d (pipe %d)\n",
 		halt, usbhs_pipe_number(pipe));
 
-- 
2.7.4

