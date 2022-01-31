Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1A184A47CF
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 14:11:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378104AbiAaNLi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 08:11:38 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:47262 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348565AbiAaNLh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 08:11:37 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B990AB82ABD
        for <stable@vger.kernel.org>; Mon, 31 Jan 2022 13:11:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04CD5C340EE;
        Mon, 31 Jan 2022 13:11:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643634695;
        bh=Zms5C9Fa7Xm3Di/rX0k+nki1ucD9xHHdTY1cOCXkzV8=;
        h=Subject:To:From:Date:From;
        b=W+BAnVjORRGb20iN/oEVUsUbJWbFyXOsUsjlY4s3qwmPTk9bC+0+oZsX8U5r/TrQm
         oLzhcyPha6e98s2yC8XshXKfpYl8g18MWbpul018KwX/IoKYQjUnXcitHjT5ilLGjr
         I4s0oR1IF5sIcvvXKjiJatmWUCO0rBC9EU9CS21U=
Subject: patch "usb: ulpi: Move of_node_put to ulpi_dev_release" added to usb-linus
To:     sean.anderson@seco.com, gregkh@linuxfoundation.org,
        heikki.krogerus@linux.intel.com, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 31 Jan 2022 14:11:32 +0100
Message-ID: <16436346922226@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: ulpi: Move of_node_put to ulpi_dev_release

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 092f45b13e51666fe8ecbf2d6cd247aa7e6c1f74 Mon Sep 17 00:00:00 2001
From: Sean Anderson <sean.anderson@seco.com>
Date: Thu, 27 Jan 2022 14:00:02 -0500
Subject: usb: ulpi: Move of_node_put to ulpi_dev_release

Drivers are not unbound from the device when ulpi_unregister_interface
is called. Move of_node-freeing code to ulpi_dev_release which is called
only after all users are gone.

Fixes: ef6a7bcfb01c ("usb: ulpi: Support device discovery via DT")
Cc: stable <stable@vger.kernel.org>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Signed-off-by: Sean Anderson <sean.anderson@seco.com>
Link: https://lore.kernel.org/r/20220127190004.1446909-2-sean.anderson@seco.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/common/ulpi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/common/ulpi.c b/drivers/usb/common/ulpi.c
index 8f8405b0d608..09ad569a1a35 100644
--- a/drivers/usb/common/ulpi.c
+++ b/drivers/usb/common/ulpi.c
@@ -130,6 +130,7 @@ static const struct attribute_group *ulpi_dev_attr_groups[] = {
 
 static void ulpi_dev_release(struct device *dev)
 {
+	of_node_put(dev->of_node);
 	kfree(to_ulpi_dev(dev));
 }
 
@@ -299,7 +300,6 @@ EXPORT_SYMBOL_GPL(ulpi_register_interface);
  */
 void ulpi_unregister_interface(struct ulpi *ulpi)
 {
-	of_node_put(ulpi->dev.of_node);
 	device_unregister(&ulpi->dev);
 }
 EXPORT_SYMBOL_GPL(ulpi_unregister_interface);
-- 
2.35.1


