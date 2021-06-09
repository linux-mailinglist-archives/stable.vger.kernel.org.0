Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48A573A0EC9
	for <lists+stable@lfdr.de>; Wed,  9 Jun 2021 10:34:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237297AbhFIIgj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Jun 2021 04:36:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:38898 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232333AbhFIIgj (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 9 Jun 2021 04:36:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7CD6F61359;
        Wed,  9 Jun 2021 08:34:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623227669;
        bh=h+QWNCgFYP0MqhH835VLLXIGpC2/HHDLngRDILPkhi4=;
        h=Subject:To:From:Date:From;
        b=HpsRsD61L/gvHczu3Q35z/2KSW3sBwceh9xboPq5+8w5zMrIrI3VheZEP8BkYJuNy
         YfdnVeC3UgzeP48odd+4OCyOSlwT8VF1dheRpkfsYBpWd6JE5X24Rvrsxp6hKwkiEj
         WRoNActEVoVZCpNYqbOvmtkxoEM8LE/3cR9V4uM8=
Subject: patch "USB: f_ncm: ncm_bitrate (speed) is unsigned" added to usb-linus
To:     maze@google.com, balbi@kernel.org, brookebasile@gmail.com,
        bryan.odonoghue@linaro.org, gregkh@linuxfoundation.org,
        linux-usb@vger.kernel.org, lorenzo@google.com,
        stable@vger.kernel.org, yauheni.kaliuta@nokia.com
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 09 Jun 2021 10:34:27 +0200
Message-ID: <162322766714319@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    USB: f_ncm: ncm_bitrate (speed) is unsigned

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 3370139745853f7826895293e8ac3aec1430508e Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>
Date: Mon, 7 Jun 2021 17:53:44 -0700
Subject: USB: f_ncm: ncm_bitrate (speed) is unsigned
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

[  190.544755] configfs-gadget gadget: notify speed -44967296

This is because 4250000000 - 2**32 is -44967296.

Fixes: 9f6ce4240a2b ("usb: gadget: f_ncm.c added")
Cc: Brooke Basile <brookebasile@gmail.com>
Cc: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Cc: Felipe Balbi <balbi@kernel.org>
Cc: Lorenzo Colitti <lorenzo@google.com>
Cc: Yauheni Kaliuta <yauheni.kaliuta@nokia.com>
Cc: Linux USB Mailing List <linux-usb@vger.kernel.org>
Acked-By: Lorenzo Colitti <lorenzo@google.com>
Signed-off-by: Maciej Żenczykowski <maze@google.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210608005344.3762668-1-zenczykowski@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/f_ncm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/gadget/function/f_ncm.c b/drivers/usb/gadget/function/f_ncm.c
index 019bea8e09cc..0d23c6c11a13 100644
--- a/drivers/usb/gadget/function/f_ncm.c
+++ b/drivers/usb/gadget/function/f_ncm.c
@@ -583,7 +583,7 @@ static void ncm_do_notify(struct f_ncm *ncm)
 		data[0] = cpu_to_le32(ncm_bitrate(cdev->gadget));
 		data[1] = data[0];
 
-		DBG(cdev, "notify speed %d\n", ncm_bitrate(cdev->gadget));
+		DBG(cdev, "notify speed %u\n", ncm_bitrate(cdev->gadget));
 		ncm->notify_state = NCM_NOTIFY_CONNECT;
 		break;
 	}
-- 
2.32.0


