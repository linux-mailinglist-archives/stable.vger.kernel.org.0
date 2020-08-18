Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB883248255
	for <lists+stable@lfdr.de>; Tue, 18 Aug 2020 11:55:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726435AbgHRJz0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Aug 2020 05:55:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:49604 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726374AbgHRJz0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 18 Aug 2020 05:55:26 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 275C7206DA;
        Tue, 18 Aug 2020 09:55:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597744525;
        bh=FlXzDjB3dtEictI2KObAfXP8wlj0GaTL9AVigeajRQY=;
        h=Subject:To:From:Date:From;
        b=xuqxDa/31Y5JRVt2dceulGDm4fZmF07oJabSzFPWrMY5cEObGSwt4kmroeJ1wq9vM
         SKXgp/XODpNNr41X2VjBadaP2IYiky627oIxklyhs8tX5fhiF0NCN6+culUu8ibVHd
         8j5X8AXxPHpwlO1bdITvdgRH4AegG/kzy398JWik=
Subject: patch "USB: lvtest: return proper error code in probe" added to usb-linus
To:     novikov@ispras.ru, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 18 Aug 2020 11:55:43 +0200
Message-ID: <15977445439880@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    USB: lvtest: return proper error code in probe

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 531412492ce93ea29b9ca3b4eb5e3ed771f851dd Mon Sep 17 00:00:00 2001
From: Evgeny Novikov <novikov@ispras.ru>
Date: Wed, 5 Aug 2020 12:06:43 +0300
Subject: USB: lvtest: return proper error code in probe

lvs_rh_probe() can return some nonnegative value from usb_control_msg()
when it is less than "USB_DT_HUB_NONVAR_SIZE + 2" that is considered as
a failure. Make lvs_rh_probe() return -EINVAL in this case.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Evgeny Novikov <novikov@ispras.ru>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200805090643.3432-1-novikov@ispras.ru
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/misc/lvstest.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/misc/lvstest.c b/drivers/usb/misc/lvstest.c
index 407fe7570f3b..f8686139d6f3 100644
--- a/drivers/usb/misc/lvstest.c
+++ b/drivers/usb/misc/lvstest.c
@@ -426,7 +426,7 @@ static int lvs_rh_probe(struct usb_interface *intf,
 			USB_DT_SS_HUB_SIZE, USB_CTRL_GET_TIMEOUT);
 	if (ret < (USB_DT_HUB_NONVAR_SIZE + 2)) {
 		dev_err(&hdev->dev, "wrong root hub descriptor read %d\n", ret);
-		return ret;
+		return ret < 0 ? ret : -EINVAL;
 	}
 
 	/* submit urb to poll interrupt endpoint */
-- 
2.28.0


