Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B74793A32A7
	for <lists+stable@lfdr.de>; Thu, 10 Jun 2021 20:02:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230130AbhFJSEi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Jun 2021 14:04:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:42368 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229823AbhFJSEh (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Jun 2021 14:04:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D4CE0613CA;
        Thu, 10 Jun 2021 18:02:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623348145;
        bh=EhiZiYQ3p32kI8CqMXr9uyytvHHFD095oAEvjguYRxo=;
        h=Subject:To:From:Date:From;
        b=eDNF+y0Yo0EZwtAyBQFx7RSLtUn/ZZiXtdMW4GHO8ZZAwrfh2QHNkjT8vJwiXiZnl
         kxydMZD4zQBTL5SbXR8vHW2W+a4qgx2kl5i3cfsc6ntGjwTN1M63GhyFb6vZdbNljk
         MxgSjNj54uNmd8BbBF8/TrDlvWyjO4j9N/fjgwJ4=
Subject: patch "usb: typec: wcove: Use LE to CPU conversion when accessing" added to usb-linus
To:     andriy.shevchenko@linux.intel.com, gregkh@linuxfoundation.org,
        heikki.krogerus@linux.intel.com, linux@roeck-us.net, lkp@intel.com,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 10 Jun 2021 20:02:23 +0200
Message-ID: <1623348143180129@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: typec: wcove: Use LE to CPU conversion when accessing

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From d5ab95da2a41567440097c277c5771ad13928dad Mon Sep 17 00:00:00 2001
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Date: Wed, 9 Jun 2021 20:22:02 +0300
Subject: usb: typec: wcove: Use LE to CPU conversion when accessing
 msg->header

As LKP noticed the Sparse is not happy about strict type handling:
   .../typec/tcpm/wcove.c:380:50: sparse:     expected unsigned short [usertype] header
   .../typec/tcpm/wcove.c:380:50: sparse:     got restricted __le16 const [usertype] header

Fix this by switching to use pd_header_cnt_le() instead of pd_header_cnt()
in the affected code.

Fixes: ae8a2ca8a221 ("usb: typec: Group all TCPCI/TCPM code together")
Fixes: 3c4fb9f16921 ("usb: typec: wcove: start using tcpm for USB PD support")
Reported-by: kernel test robot <lkp@intel.com>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20210609172202.83377-1-andriy.shevchenko@linux.intel.com
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/tcpm/wcove.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/typec/tcpm/wcove.c b/drivers/usb/typec/tcpm/wcove.c
index 79ae63950050..5d125339687a 100644
--- a/drivers/usb/typec/tcpm/wcove.c
+++ b/drivers/usb/typec/tcpm/wcove.c
@@ -378,7 +378,7 @@ static int wcove_pd_transmit(struct tcpc_dev *tcpc,
 		const u8 *data = (void *)msg;
 		int i;
 
-		for (i = 0; i < pd_header_cnt(msg->header) * 4 + 2; i++) {
+		for (i = 0; i < pd_header_cnt_le(msg->header) * 4 + 2; i++) {
 			ret = regmap_write(wcove->regmap, USBC_TX_DATA + i,
 					   data[i]);
 			if (ret)
-- 
2.32.0


