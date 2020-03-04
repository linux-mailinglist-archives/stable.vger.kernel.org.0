Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B908178DE4
	for <lists+stable@lfdr.de>; Wed,  4 Mar 2020 10:58:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729126AbgCDJ6F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Mar 2020 04:58:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:50682 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727734AbgCDJ6F (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Mar 2020 04:58:05 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CE2AC20848;
        Wed,  4 Mar 2020 09:58:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583315884;
        bh=9ANdEwxsF1yGArHH8JLMuapabAm8FAJQw5jZ/GAJozo=;
        h=Subject:To:From:Date:From;
        b=TttUCAvGR0JX149X3acsWJbybzTaL3NReRTUkAScqq6RqIBjYjpLItuxc1R1q1flT
         pnf9iadBjRrlbw3UwuqsHZcquc+wFvkimwIjiu2tpULE5hDJyCnUybu9rTbkbd4OSk
         Vv9EehQCpufihjJn+J7Ys3E7v+YnnBAFljdm0tpE=
Subject: patch "usb: usb251xb: fix regulator probe and error handling" added to usb-linus
To:     m.felsch@pengutronix.de, gregkh@linuxfoundation.org,
        richard.leitner@skidata.com, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 04 Mar 2020 10:57:52 +0100
Message-ID: <15833158728239@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: usb251xb: fix regulator probe and error handling

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From f06947f275f1838586792c17b6ab70da82ed7b43 Mon Sep 17 00:00:00 2001
From: Marco Felsch <m.felsch@pengutronix.de>
Date: Wed, 26 Feb 2020 08:26:44 +0100
Subject: usb: usb251xb: fix regulator probe and error handling

Commit 4d7201cda226 ("usb: usb251xb: add vdd supply support") didn't
covered the non-DT use-case and so the regualtor_enable() call during
probe will fail on those platforms. Also the commit didn't handled the
error case correctly.

Move devm_regulator_get() out of usb251xb_get_ofdata() to address the
1st issue. This can be done without worries because devm_regulator_get()
handles the non-DT use-case too. Add devm_add_action_or_reset() to
address the 2nd bug.

Fixes: 4d7201cda226 ("usb: usb251xb: add vdd supply support")
Signed-off-by: Marco Felsch <m.felsch@pengutronix.de>
Cc: stable <stable@vger.kernel.org>
Acked-by: Richard Leitner <richard.leitner@skidata.com>
Link: https://lore.kernel.org/r/20200226072644.18490-1-m.felsch@pengutronix.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/misc/usb251xb.c | 20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/misc/usb251xb.c b/drivers/usb/misc/usb251xb.c
index 10c9e7f6273e..29fe5771c21b 100644
--- a/drivers/usb/misc/usb251xb.c
+++ b/drivers/usb/misc/usb251xb.c
@@ -424,10 +424,6 @@ static int usb251xb_get_ofdata(struct usb251xb *hub,
 		return err;
 	}
 
-	hub->vdd = devm_regulator_get(dev, "vdd");
-	if (IS_ERR(hub->vdd))
-		return PTR_ERR(hub->vdd);
-
 	if (of_property_read_u16_array(np, "vendor-id", &hub->vendor_id, 1))
 		hub->vendor_id = USB251XB_DEF_VENDOR_ID;
 
@@ -640,6 +636,13 @@ static int usb251xb_get_ofdata(struct usb251xb *hub,
 }
 #endif /* CONFIG_OF */
 
+static void usb251xb_regulator_disable_action(void *data)
+{
+	struct usb251xb *hub = data;
+
+	regulator_disable(hub->vdd);
+}
+
 static int usb251xb_probe(struct usb251xb *hub)
 {
 	struct device *dev = hub->dev;
@@ -676,10 +679,19 @@ static int usb251xb_probe(struct usb251xb *hub)
 	if (err)
 		return err;
 
+	hub->vdd = devm_regulator_get(dev, "vdd");
+	if (IS_ERR(hub->vdd))
+		return PTR_ERR(hub->vdd);
+
 	err = regulator_enable(hub->vdd);
 	if (err)
 		return err;
 
+	err = devm_add_action_or_reset(dev,
+				       usb251xb_regulator_disable_action, hub);
+	if (err)
+		return err;
+
 	err = usb251xb_connect(hub);
 	if (err) {
 		dev_err(dev, "Failed to connect hub (%d)\n", err);
-- 
2.25.1


