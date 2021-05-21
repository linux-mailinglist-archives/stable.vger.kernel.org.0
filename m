Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04AF638C67E
	for <lists+stable@lfdr.de>; Fri, 21 May 2021 14:28:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233186AbhEUM37 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 May 2021 08:29:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:55566 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229457AbhEUM3w (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 May 2021 08:29:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9304C613B6;
        Fri, 21 May 2021 12:28:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621600110;
        bh=mU3UzTVIV0qfdUyKOwz8Mu+EmACfUxtF45IQtyNYiRU=;
        h=Subject:To:From:Date:From;
        b=AVn9ljNT5X5hL5VC0RzC2lWbTmHqZDDaWSe/2d+JosF7vyGXxh3WSIcb/jiA1fUvc
         fbMk8hbnyg7MapF+BfhXhaAjLDVNvWRWCx36ly6Gw3n60rOfGeFSiklwv6hI3Lo2VF
         +sQHF26bzFHL/eMHzOFQUgAkKpxFPTAl/69PM+h8=
Subject: patch "usb: typec: tcpm: Use LE to CPU conversion when accessing msg->header" added to usb-linus
To:     andriy.shevchenko@linux.intel.com,
        Adam.Thomson.Opensource@diasemi.com, gregkh@linuxfoundation.org,
        heikki.krogerus@linux.intel.com, linux@roeck-us.net,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 21 May 2021 14:28:18 +0200
Message-ID: <162160009810686@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: typec: tcpm: Use LE to CPU conversion when accessing msg->header

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From c58bbe3477f75deb7883983e6cf428404a107555 Mon Sep 17 00:00:00 2001
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Date: Wed, 19 May 2021 13:03:58 +0300
Subject: usb: typec: tcpm: Use LE to CPU conversion when accessing msg->header

Sparse is not happy about strict type handling:
  .../typec/tcpm/tcpm.c:2720:27: warning: restricted __le16 degrades to integer
  .../typec/tcpm/tcpm.c:2814:32: warning: restricted __le16 degrades to integer

Fix this by converting LE to CPU before use.

Fixes: ae8a2ca8a221 ("usb: typec: Group all TCPCI/TCPM code together")
Fixes: 64f7c494a3c0 ("typec: tcpm: Add support for sink PPS related messages")
Cc: stable <stable@vger.kernel.org>
Cc: Adam Thomson <Adam.Thomson.Opensource@diasemi.com>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Reviewed-by: Adam Thomson <Adam.Thomson.Opensource@diasemi.com>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20210519100358.64018-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/tcpm/tcpm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/typec/tcpm/tcpm.c b/drivers/usb/typec/tcpm/tcpm.c
index 64133e586c64..8fdfd7f65ad7 100644
--- a/drivers/usb/typec/tcpm/tcpm.c
+++ b/drivers/usb/typec/tcpm/tcpm.c
@@ -2717,7 +2717,7 @@ static void tcpm_pd_ext_msg_request(struct tcpm_port *port,
 	enum pd_ext_msg_type type = pd_header_type_le(msg->header);
 	unsigned int data_size = pd_ext_header_data_size_le(msg->ext_msg.header);
 
-	if (!(msg->ext_msg.header & PD_EXT_HDR_CHUNKED)) {
+	if (!(le16_to_cpu(msg->ext_msg.header) & PD_EXT_HDR_CHUNKED)) {
 		tcpm_pd_handle_msg(port, PD_MSG_CTRL_NOT_SUPP, NONE_AMS);
 		tcpm_log(port, "Unchunked extended messages unsupported");
 		return;
@@ -2811,7 +2811,7 @@ static void tcpm_pd_rx_handler(struct kthread_work *work)
 				 "Data role mismatch, initiating error recovery");
 			tcpm_set_state(port, ERROR_RECOVERY, 0);
 		} else {
-			if (msg->header & PD_HEADER_EXT_HDR)
+			if (le16_to_cpu(msg->header) & PD_HEADER_EXT_HDR)
 				tcpm_pd_ext_msg_request(port, msg);
 			else if (cnt)
 				tcpm_pd_data_request(port, msg);
-- 
2.31.1


