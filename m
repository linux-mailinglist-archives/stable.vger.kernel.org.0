Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4A93378534
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:22:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233711AbhEJK7r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 06:59:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:52740 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233864AbhEJKzc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 06:55:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DDF006192D;
        Mon, 10 May 2021 10:42:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620643362;
        bh=cFchhMaHYH8bR5GvCJ3hR1rSWQ9RiBBN8mveFISbNds=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GuQZj0/MuJtg7nRbn34MGHhlDXPKvf+0Hd8Z2jxKgnzqUVcM6siZ3rSq3fyluaCIb
         UFTOwu3K1H17hndh/SJToxK3NMae21pqMeCwkyOwF09vB1GxJLtlatoHwhiaX0Gs7Z
         H8+mA+oH4HIlKF7fh+PyILkdBQf4qcwLQUeg/6jY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Felipe Balbi <balbi@kernel.org>,
        Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 5.10 285/299] usb: dwc3: gadget: Fix START_TRANSFER link state check
Date:   Mon, 10 May 2021 12:21:22 +0200
Message-Id: <20210510102014.335874319@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102004.821838356@linuxfoundation.org>
References: <20210510102004.821838356@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thinh Nguyen <Thinh.Nguyen@synopsys.com>

commit c560e76319a94a3b9285bc426c609903408e4826 upstream.

The START_TRANSFER command needs to be executed while in ON/U0 link
state (with an exception during register initialization). Don't use
dwc->link_state to check this since the driver only tracks the link
state when the link state change interrupt is enabled. Check the link
state from DSTS register instead.

Note that often the host already brings the device out of low power
before it sends/requests the next transfer. So, the user won't see any
issue when the device starts transfer then. This issue is more
noticeable in cases when the device delays starting transfer, which can
happen during delayed control status after the host put the device in
low power.

Fixes: 799e9dc82968 ("usb: dwc3: gadget: conditionally disable Link State change events")
Cc: <stable@vger.kernel.org>
Acked-by: Felipe Balbi <balbi@kernel.org>
Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Link: https://lore.kernel.org/r/bcefaa9ecbc3e1936858c0baa14de6612960e909.1618884221.git.Thinh.Nguyen@synopsys.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/gadget.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -308,13 +308,12 @@ int dwc3_send_gadget_ep_cmd(struct dwc3_
 	}
 
 	if (DWC3_DEPCMD_CMD(cmd) == DWC3_DEPCMD_STARTTRANSFER) {
-		int		needs_wakeup;
+		int link_state;
 
-		needs_wakeup = (dwc->link_state == DWC3_LINK_STATE_U1 ||
-				dwc->link_state == DWC3_LINK_STATE_U2 ||
-				dwc->link_state == DWC3_LINK_STATE_U3);
-
-		if (unlikely(needs_wakeup)) {
+		link_state = dwc3_gadget_get_link_state(dwc);
+		if (link_state == DWC3_LINK_STATE_U1 ||
+		    link_state == DWC3_LINK_STATE_U2 ||
+		    link_state == DWC3_LINK_STATE_U3) {
 			ret = __dwc3_gadget_wakeup(dwc);
 			dev_WARN_ONCE(dwc->dev, ret, "wakeup failed --> %d\n",
 					ret);
@@ -1975,6 +1974,8 @@ static int __dwc3_gadget_wakeup(struct d
 	case DWC3_LINK_STATE_RESET:
 	case DWC3_LINK_STATE_RX_DET:	/* in HS, means Early Suspend */
 	case DWC3_LINK_STATE_U3:	/* in HS, means SUSPEND */
+	case DWC3_LINK_STATE_U2:	/* in HS, means Sleep (L1) */
+	case DWC3_LINK_STATE_U1:
 	case DWC3_LINK_STATE_RESUME:
 		break;
 	default:


