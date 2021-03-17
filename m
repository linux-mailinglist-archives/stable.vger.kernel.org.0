Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98AD033F9F8
	for <lists+stable@lfdr.de>; Wed, 17 Mar 2021 21:32:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233271AbhCQUbf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Mar 2021 16:31:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:34384 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233383AbhCQUbO (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Mar 2021 16:31:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5335264F30;
        Wed, 17 Mar 2021 20:31:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616013073;
        bh=9slJgJq+eCF57wYm8vJAHToWWQ+IvGXJnnk2llvW/V0=;
        h=Subject:To:From:Date:From;
        b=pxzjHQk/1c9ggeJ3uPyb2eqAwOHKc58LXahj1JlJQnjxs72Na16howPm/OAm1E1V5
         1kPw5MqYtoHA/wPH9RXli/RNopXMab9T5lMZ77gKmiFYaaKlQ4rAxsueUw21+78FcW
         vQe0bcoG5S8NL7AOcMsCSt5FN4eISl6fpT4ra6+k=
Subject: patch "usb: typec: Remove vdo[3] part of tps6598x_rx_identity_reg struct" added to usb-linus
To:     mail@eliasrudberg.se, agx@sigxcpu.org, gregkh@linuxfoundation.org,
        heikki.krogerus@linux.intel.com, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 17 Mar 2021 21:31:02 +0100
Message-ID: <1616013062135133@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: typec: Remove vdo[3] part of tps6598x_rx_identity_reg struct

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 3cac9104bea41099cf622091f0c0538bcb19050d Mon Sep 17 00:00:00 2001
From: Elias Rudberg <mail@eliasrudberg.se>
Date: Thu, 11 Mar 2021 13:47:10 +0100
Subject: usb: typec: Remove vdo[3] part of tps6598x_rx_identity_reg struct
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Remove the unused "u32 vdo[3]" part in the tps6598x_rx_identity_reg
struct. This helps avoid "failed to register partner" errors which
happen when tps6598x_read_partner_identity() fails because the
amount of data read is 12 bytes smaller than the struct size.
Note that vdo[3] is already in usb_pd_identity and hence
shouldn't be added to tps6598x_rx_identity_reg as well.

Fixes: f6c56ca91b92 ("usb: typec: Add the Product Type VDOs to struct usb_pd_identity")
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Reviewed-by: Guido Günther <agx@sigxcpu.org>
Signed-off-by: Elias Rudberg <mail@eliasrudberg.se>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210311124710.6563-1-mail@eliasrudberg.se
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/tps6598x.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/usb/typec/tps6598x.c b/drivers/usb/typec/tps6598x.c
index 6e6ef6317523..29bd1c5a283c 100644
--- a/drivers/usb/typec/tps6598x.c
+++ b/drivers/usb/typec/tps6598x.c
@@ -64,7 +64,6 @@ enum {
 struct tps6598x_rx_identity_reg {
 	u8 status;
 	struct usb_pd_identity identity;
-	u32 vdo[3];
 } __packed;
 
 /* Standard Task return codes */
-- 
2.30.2


