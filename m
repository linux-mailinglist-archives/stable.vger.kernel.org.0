Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2FFB3118617
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 12:21:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727326AbfLJLVc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 06:21:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:49860 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726915AbfLJLVc (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Dec 2019 06:21:32 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 82D1220726;
        Tue, 10 Dec 2019 11:21:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575976892;
        bh=R93f0HThzk+z1jf4EmyWx3j3bqjhK4XY+FGo2hrzy70=;
        h=Subject:To:From:Date:From;
        b=FlMW+Qn7E9Txaq+W5fQP1m+WFBxfQho7XeWzWxdu32joWJYU8aKDDF+Chsha6llZg
         KeyjjNRk2umiUXTg0duLXYRk7ttAyaCudhLivRh1XWik2/FII875tgWliaUn20BLz3
         rcz2FrlPM2AWcScuTMuCvSmMPYpSKQ0c5lAbl0Pw=
Subject: patch "usb: typec: fix use after free in typec_register_port()" added to usb-linus
To:     wenyang@linux.alibaba.com, gregkh@linuxfoundation.org,
        heikki.krogerus@linux.intel.com, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 10 Dec 2019 12:21:21 +0100
Message-ID: <157597688118044@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: typec: fix use after free in typec_register_port()

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 5c388abefda0d92355714010c0199055c57ab6c7 Mon Sep 17 00:00:00 2001
From: Wen Yang <wenyang@linux.alibaba.com>
Date: Tue, 26 Nov 2019 22:04:52 +0800
Subject: usb: typec: fix use after free in typec_register_port()
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

We can't use "port->sw" and/or "port->mux" after it has been freed.

Fixes: 23481121c81d ("usb: typec: class: Don't use port parent for getting mux handles")
Signed-off-by: Wen Yang <wenyang@linux.alibaba.com>
Cc: stable <stable@vger.kernel.org>
Cc: linux-usb@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Acked-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://lore.kernel.org/r/20191126140452.14048-1-wenyang@linux.alibaba.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/class.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/typec/class.c b/drivers/usb/typec/class.c
index 7ece6ca6e690..91d62276b56f 100644
--- a/drivers/usb/typec/class.c
+++ b/drivers/usb/typec/class.c
@@ -1612,14 +1612,16 @@ struct typec_port *typec_register_port(struct device *parent,
 
 	port->sw = typec_switch_get(&port->dev);
 	if (IS_ERR(port->sw)) {
+		ret = PTR_ERR(port->sw);
 		put_device(&port->dev);
-		return ERR_CAST(port->sw);
+		return ERR_PTR(ret);
 	}
 
 	port->mux = typec_mux_get(&port->dev, NULL);
 	if (IS_ERR(port->mux)) {
+		ret = PTR_ERR(port->mux);
 		put_device(&port->dev);
-		return ERR_CAST(port->mux);
+		return ERR_PTR(ret);
 	}
 
 	ret = device_add(&port->dev);
-- 
2.24.0


