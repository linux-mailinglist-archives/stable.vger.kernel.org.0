Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E158F1188A7
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 13:43:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727431AbfLJMnh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 07:43:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:53456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727242AbfLJMng (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Dec 2019 07:43:36 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7532C2073B;
        Tue, 10 Dec 2019 12:43:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575981815;
        bh=mtsJ8dlJFeBA4x/SocQNHL6FVDwrZmAusF4hldDzwsw=;
        h=Subject:To:From:Date:From;
        b=yHWQHsN+eJEaf1NZJRUWdAVsRFvTKxJr2Dyy28thcsUXi35mUjki+cR2mIOcYo8kR
         WjLoKbv7IPeDNwnuCdFv6O+daaL1FqHoCWfoo4MPaPKYLF6SxFCxydMocVp/qNAbLv
         xKKU7pgjQwO5uqYGFLToeKBzo6W7RC6kHqwBS9WA=
Subject: patch "staging: rtl8188eu: fix interface sanity check" added to staging-linus
To:     johan@kernel.org, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 10 Dec 2019 13:43:33 +0100
Message-ID: <157598181320822@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    staging: rtl8188eu: fix interface sanity check

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 74ca34118a0e05793935d804ccffcedd6eb56596 Mon Sep 17 00:00:00 2001
From: Johan Hovold <johan@kernel.org>
Date: Tue, 10 Dec 2019 12:47:50 +0100
Subject: staging: rtl8188eu: fix interface sanity check

Make sure to use the current alternate setting when verifying the
interface descriptors to avoid binding to an invalid interface.

Failing to do so could cause the driver to misbehave or trigger a WARN()
in usb_submit_urb() that kernels with panic_on_warn set would choke on.

Fixes: c2478d39076b ("staging: r8188eu: Add files for new driver - part 20")
Cc: stable <stable@vger.kernel.org>     # 3.12
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://lore.kernel.org/r/20191210114751.5119-2-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/rtl8188eu/os_dep/usb_intf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/rtl8188eu/os_dep/usb_intf.c b/drivers/staging/rtl8188eu/os_dep/usb_intf.c
index 4fac9dca798e..a7cac0719b8b 100644
--- a/drivers/staging/rtl8188eu/os_dep/usb_intf.c
+++ b/drivers/staging/rtl8188eu/os_dep/usb_intf.c
@@ -70,7 +70,7 @@ static struct dvobj_priv *usb_dvobj_init(struct usb_interface *usb_intf)
 	phost_conf = pusbd->actconfig;
 	pconf_desc = &phost_conf->desc;
 
-	phost_iface = &usb_intf->altsetting[0];
+	phost_iface = usb_intf->cur_altsetting;
 	piface_desc = &phost_iface->desc;
 
 	pdvobjpriv->NumInterfaces = pconf_desc->bNumInterfaces;
-- 
2.24.0


