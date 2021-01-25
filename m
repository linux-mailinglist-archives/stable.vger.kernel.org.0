Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85B223033BB
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 06:05:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730780AbhAZFEX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Jan 2021 00:04:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:39874 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731194AbhAYSxF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Jan 2021 13:53:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CF1B2224D1;
        Mon, 25 Jan 2021 18:52:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611600744;
        bh=fgkYR3eZXan/liAaAqx8oy1KPKmgEInSuP5TaA0fjpc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LtnyHqdf8wOjuNHNnvS4kc8it8yxOKIPi87Ih4eGiQh/s7L9sl0VPtCkKlqBfirML
         CrlLvDY6umSQRS0OZoZmdCCzb/wy368GbttXDnPtnYUk7frUBTG8P8UpQBq8KFh6xw
         aNG/SjD2GGHnWfkmygCcU6ErIvnSBddzz4Y9I+cg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Felipe Balbi <balbi@kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 5.10 135/199] USB: gadget: dummy-hcd: Fix errors in port-reset handling
Date:   Mon, 25 Jan 2021 19:39:17 +0100
Message-Id: <20210125183221.918294406@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210125183216.245315437@linuxfoundation.org>
References: <20210125183216.245315437@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alan Stern <stern@rowland.harvard.edu>

commit 6e6aa61d81194c01283880950df563b1b9abec46 upstream.

Commit c318840fb2a4 ("USB: Gadget: dummy-hcd: Fix shift-out-of-bounds
bug") messed up the way dummy-hcd handles requests to turn on the
RESET port feature (I didn't notice that the original switch case
ended with a fallthrough).  The call to set_link_state() was
inadvertently removed, as was the code to set the USB_PORT_STAT_RESET
flag when the speed is USB2.

In addition, the original code never checked whether the port was
connected before handling the port-reset request.  There was a check
for the port being powered, but it was removed by that commit!  In
practice this doesn't matter much because the kernel doesn't try to
reset disconnected ports, but it's still bad form.

This patch fixes these problems by changing the fallthrough to break,
adding back in the missing set_link_state() call, setting the
port-reset status flag, adding a port-is-connected test, and removing
a redundant assignment statement.

Fixes: c318840fb2a4 ("USB: Gadget: dummy-hcd: Fix shift-out-of-bounds bug")
CC: <stable@vger.kernel.org>
Acked-by: Felipe Balbi <balbi@kernel.org>
Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Link: https://lore.kernel.org/r/20210113194510.GA1290698@rowland.harvard.edu
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/gadget/udc/dummy_hcd.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/drivers/usb/gadget/udc/dummy_hcd.c
+++ b/drivers/usb/gadget/udc/dummy_hcd.c
@@ -2266,17 +2266,20 @@ static int dummy_hub_control(
 			}
 			fallthrough;
 		case USB_PORT_FEAT_RESET:
+			if (!(dum_hcd->port_status & USB_PORT_STAT_CONNECTION))
+				break;
 			/* if it's already enabled, disable */
 			if (hcd->speed == HCD_USB3) {
-				dum_hcd->port_status = 0;
 				dum_hcd->port_status =
 					(USB_SS_PORT_STAT_POWER |
 					 USB_PORT_STAT_CONNECTION |
 					 USB_PORT_STAT_RESET);
-			} else
+			} else {
 				dum_hcd->port_status &= ~(USB_PORT_STAT_ENABLE
 					| USB_PORT_STAT_LOW_SPEED
 					| USB_PORT_STAT_HIGH_SPEED);
+				dum_hcd->port_status |= USB_PORT_STAT_RESET;
+			}
 			/*
 			 * We want to reset device status. All but the
 			 * Self powered feature
@@ -2288,7 +2291,8 @@ static int dummy_hub_control(
 			 * interval? Is it still 50msec as for HS?
 			 */
 			dum_hcd->re_timeout = jiffies + msecs_to_jiffies(50);
-			fallthrough;
+			set_link_state(dum_hcd);
+			break;
 		case USB_PORT_FEAT_C_CONNECTION:
 		case USB_PORT_FEAT_C_RESET:
 		case USB_PORT_FEAT_C_ENABLE:


