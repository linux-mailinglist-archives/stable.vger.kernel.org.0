Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE9E02F1456
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 14:24:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727984AbhAKNXX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 08:23:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:37076 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733124AbhAKNSd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Jan 2021 08:18:33 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BB79B2229C;
        Mon, 11 Jan 2021 13:17:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610371072;
        bh=b/rHpro2UBOvgR7pS8TtW4j9VgswjUFvu+g/vIdFfRI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GsuMrUuBsS51X1kxQhLJz5+vq8O2QQVmW29numGuN5gJZsTArg242v5Iu44USkE9I
         FNHfCnQZd43MYLt9fnUhOgsbZDEY9WpJGEqcvKXl7pZLI3fbJ4kB+hq/sDfGs2Rdkj
         cf3+AynY0XhI7AknY4zrCecFyR0R/LUT7Hm99nqY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
        syzbot+5925509f78293baa7331@syzkaller.appspotmail.com
Subject: [PATCH 5.10 099/145] USB: Gadget: dummy-hcd: Fix shift-out-of-bounds bug
Date:   Mon, 11 Jan 2021 14:02:03 +0100
Message-Id: <20210111130053.286876397@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210111130048.499958175@linuxfoundation.org>
References: <20210111130048.499958175@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alan Stern <stern@rowland.harvard.edu>

commit c318840fb2a42ce25febc95c4c19357acf1ae5ca upstream.

The dummy-hcd driver was written under the assumption that all the
parameters in URBs sent to its root hub would be valid.  With URBs
sent from userspace via usbfs, that assumption can be violated.

In particular, the driver doesn't fully check the port-feature values
stored in the wValue entry of Clear-Port-Feature and Set-Port-Feature
requests.  Values that are too large can cause the driver to perform
an invalid left shift of more than 32 bits.  Ironically, two of those
left shifts are unnecessary, because they implement Set-Port-Feature
requests that hubs are not required to support, according to section
11.24.2.13 of the USB-2.0 spec.

This patch adds the appropriate checks for the port feature selector
values and removes the unnecessary feature settings.  It also rejects
requests to set the TEST feature or to set or clear the INDICATOR and
C_OVERCURRENT features, as none of these are relevant to dummy-hcd's
root-hub emulation.

CC: <stable@vger.kernel.org>
Reported-and-tested-by: syzbot+5925509f78293baa7331@syzkaller.appspotmail.com
Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Link: https://lore.kernel.org/r/20201230162044.GA727759@rowland.harvard.edu
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/gadget/udc/dummy_hcd.c |   35 +++++++++++++++++++++++------------
 1 file changed, 23 insertions(+), 12 deletions(-)

--- a/drivers/usb/gadget/udc/dummy_hcd.c
+++ b/drivers/usb/gadget/udc/dummy_hcd.c
@@ -2114,9 +2114,21 @@ static int dummy_hub_control(
 				dum_hcd->port_status &= ~USB_PORT_STAT_POWER;
 			set_link_state(dum_hcd);
 			break;
-		default:
+		case USB_PORT_FEAT_ENABLE:
+		case USB_PORT_FEAT_C_ENABLE:
+		case USB_PORT_FEAT_C_SUSPEND:
+			/* Not allowed for USB-3 */
+			if (hcd->speed == HCD_USB3)
+				goto error;
+			fallthrough;
+		case USB_PORT_FEAT_C_CONNECTION:
+		case USB_PORT_FEAT_C_RESET:
 			dum_hcd->port_status &= ~(1 << wValue);
 			set_link_state(dum_hcd);
+			break;
+		default:
+		/* Disallow INDICATOR and C_OVER_CURRENT */
+			goto error;
 		}
 		break;
 	case GetHubDescriptor:
@@ -2277,18 +2289,17 @@ static int dummy_hub_control(
 			 */
 			dum_hcd->re_timeout = jiffies + msecs_to_jiffies(50);
 			fallthrough;
+		case USB_PORT_FEAT_C_CONNECTION:
+		case USB_PORT_FEAT_C_RESET:
+		case USB_PORT_FEAT_C_ENABLE:
+		case USB_PORT_FEAT_C_SUSPEND:
+			/* Not allowed for USB-3, and ignored for USB-2 */
+			if (hcd->speed == HCD_USB3)
+				goto error;
+			break;
 		default:
-			if (hcd->speed == HCD_USB3) {
-				if ((dum_hcd->port_status &
-				     USB_SS_PORT_STAT_POWER) != 0) {
-					dum_hcd->port_status |= (1 << wValue);
-				}
-			} else
-				if ((dum_hcd->port_status &
-				     USB_PORT_STAT_POWER) != 0) {
-					dum_hcd->port_status |= (1 << wValue);
-				}
-			set_link_state(dum_hcd);
+		/* Disallow TEST, INDICATOR, and C_OVER_CURRENT */
+			goto error;
 		}
 		break;
 	case GetPortErrorCount:


