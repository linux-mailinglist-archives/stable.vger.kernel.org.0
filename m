Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 96FBE118616
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 12:21:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727227AbfLJLVY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 06:21:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:49814 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726915AbfLJLVY (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Dec 2019 06:21:24 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 06E8620726;
        Tue, 10 Dec 2019 11:21:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575976883;
        bh=b0FuCV76uYXGlnMSChA7vvZmGBfBgeSve4rqbfm61p0=;
        h=Subject:To:From:Date:From;
        b=xYBf7FWhIFvCTRz2UYPRgf9YFG7z0WoY7rVJrkR3pMgznUCiRxF/ppsHd4m2x+L5M
         xMdW5cnBT6QCy0PJG3kZ1nPkSSDSRlLOPWL1uada/BsNbIKGHmTVvgWbCB2vx+joPe
         8dGFuhzVYoIqrJwMjsRlMn1FJZZRTJCCsCU0hre4=
Subject: patch "usb: roles: fix a potential use after free" added to usb-linus
To:     wenyang@linux.alibaba.com, chunfeng.yun@mediatek.com,
        gregkh@linuxfoundation.org, hdegoede@redhat.com,
        heikki.krogerus@linux.intel.com, peter.chen@nxp.com,
        stable@vger.kernel.org, suzuki.poulose@arm.com
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 10 Dec 2019 12:21:21 +0100
Message-ID: <157597688191171@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: roles: fix a potential use after free

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 1848a543191ae32e558bb0a5974ae7c38ebd86fc Mon Sep 17 00:00:00 2001
From: Wen Yang <wenyang@linux.alibaba.com>
Date: Sun, 24 Nov 2019 22:22:36 +0800
Subject: usb: roles: fix a potential use after free

Free the sw structure only after we are done using it.
This patch just moves the put_device() down a bit to avoid the
use after free.

Fixes: 5c54fcac9a9d ("usb: roles: Take care of driver module reference counting")
Signed-off-by: Wen Yang <wenyang@linux.alibaba.com>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Reviewed-by: Peter Chen <peter.chen@nxp.com>
Cc: stable <stable@vger.kernel.org>
Cc: Hans de Goede <hdegoede@redhat.com>
Cc: Chunfeng Yun <chunfeng.yun@mediatek.com>
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: linux-usb@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Link: https://lore.kernel.org/r/20191124142236.25671-1-wenyang@linux.alibaba.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/roles/class.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/roles/class.c b/drivers/usb/roles/class.c
index 8273126ffdf4..63a00ff26655 100644
--- a/drivers/usb/roles/class.c
+++ b/drivers/usb/roles/class.c
@@ -169,8 +169,8 @@ EXPORT_SYMBOL_GPL(fwnode_usb_role_switch_get);
 void usb_role_switch_put(struct usb_role_switch *sw)
 {
 	if (!IS_ERR_OR_NULL(sw)) {
-		put_device(&sw->dev);
 		module_put(sw->dev.parent->driver->owner);
+		put_device(&sw->dev);
 	}
 }
 EXPORT_SYMBOL_GPL(usb_role_switch_put);
-- 
2.24.0


