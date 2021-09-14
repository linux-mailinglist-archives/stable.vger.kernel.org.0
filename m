Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0675F40A95D
	for <lists+stable@lfdr.de>; Tue, 14 Sep 2021 10:35:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230273AbhINIgo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Sep 2021 04:36:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:43180 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231300AbhINIgk (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Sep 2021 04:36:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B2CD2610A6;
        Tue, 14 Sep 2021 08:35:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631608523;
        bh=wT5nalsEI9azZtjcrOfBuIoeRcuimIemK/6YUJd4jgE=;
        h=Subject:To:From:Date:From;
        b=aMHVvO3sWu8xa0mzD8vqJdheh18VgGLVRil/kcOh14GxJEu+/kVb95zOjkEwoODlw
         MvRqOtVMvhyVPybJiOJdBMKonr12QDzLcvWa5aqVHHwe2AVKZLTybqk9N2z55k/ydB
         P+MiUig5iUz2yEutw0/WDDxXa0ofloSbDaWZI30I=
Subject: patch "usb: gadget: r8a66597: fix a loop in set_feature()" added to usb-linus
To:     dan.carpenter@oracle.com, balbi@kernel.org,
        gregkh@linuxfoundation.org, stable@vger.kernel.org,
        yoshihiro.shimoda.uh@renesas.com
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 14 Sep 2021 10:35:18 +0200
Message-ID: <1631608518254143@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: gadget: r8a66597: fix a loop in set_feature()

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 17956b53ebff6a490baf580a836cbd3eae94892b Mon Sep 17 00:00:00 2001
From: Dan Carpenter <dan.carpenter@oracle.com>
Date: Mon, 6 Sep 2021 12:42:21 +0300
Subject: usb: gadget: r8a66597: fix a loop in set_feature()

This loop is supposed to loop until if reads something other than
CS_IDST or until it times out after 30,000 attempts.  But because of
the || vs && bug, it will never time out and instead it will loop a
minimum of 30,000 times.

This bug is quite old but the code is only used in USB_DEVICE_TEST_MODE
so it probably doesn't affect regular usage.

Fixes: 96fe53ef5498 ("usb: gadget: r8a66597-udc: add support for TEST_MODE")
Cc: stable <stable@vger.kernel.org>
Reviewed-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Acked-by: Felipe Balbi <balbi@kernel.org>
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Link: https://lore.kernel.org/r/20210906094221.GA10957@kili
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/udc/r8a66597-udc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/gadget/udc/r8a66597-udc.c b/drivers/usb/gadget/udc/r8a66597-udc.c
index 65cae4883454..38e4d6b505a0 100644
--- a/drivers/usb/gadget/udc/r8a66597-udc.c
+++ b/drivers/usb/gadget/udc/r8a66597-udc.c
@@ -1250,7 +1250,7 @@ static void set_feature(struct r8a66597 *r8a66597, struct usb_ctrlrequest *ctrl)
 			do {
 				tmp = r8a66597_read(r8a66597, INTSTS0) & CTSQ;
 				udelay(1);
-			} while (tmp != CS_IDST || timeout-- > 0);
+			} while (tmp != CS_IDST && timeout-- > 0);
 
 			if (tmp == CS_IDST)
 				r8a66597_bset(r8a66597,
-- 
2.33.0


