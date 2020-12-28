Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D33F92E696B
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 17:50:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727823AbgL1Mwu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 07:52:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:49778 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727802AbgL1Mwt (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 07:52:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 47CC322582;
        Mon, 28 Dec 2020 12:51:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609159908;
        bh=U5RPrhEFmD/L9Jfx6SCO/Rla942PhiWX9M1apAZ4L0o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wJM1GkMh77VaOGcOa3BfHxuBPG5eZuImM15VI52kbIb8mh5NO4cMOyZ/74hoq397t
         eWhOVy3RpNmhZ6qqV7CrVCHq8vlU1SY3O8trGb4X2V2kbP8qARAOpTrCgSH9v86Jta
         0HC1Wx/1SR+BqW2z2CR/+XaNWklGwU9yt+6s8b+8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Li Jun <jun.li@nxp.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 4.4 017/132] xhci: Give USB2 ports time to enter U3 in bus suspend
Date:   Mon, 28 Dec 2020 13:48:21 +0100
Message-Id: <20201228124847.241563012@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124846.409999325@linuxfoundation.org>
References: <20201228124846.409999325@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Li Jun <jun.li@nxp.com>

commit c1373f10479b624fb6dba0805d673e860f1b421d upstream.

If a USB2 device wakeup is not enabled/supported the link state may
still be in U0 in xhci_bus_suspend(), where it's then manually put
to suspended U3 state.

Just as with selective suspend the device needs time to enter U3
suspend before continuing with further suspend operations
(e.g. system suspend), otherwise we may enter system suspend with link
state in U0.

[commit message rewording -Mathias]

Cc: <stable@vger.kernel.org>
Signed-off-by: Li Jun <jun.li@nxp.com>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20201208092912.1773650-6-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/host/xhci-hub.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/usb/host/xhci-hub.c
+++ b/drivers/usb/host/xhci-hub.c
@@ -1400,6 +1400,10 @@ int xhci_bus_suspend(struct usb_hcd *hcd
 	hcd->state = HC_STATE_SUSPENDED;
 	bus_state->next_statechange = jiffies + msecs_to_jiffies(10);
 	spin_unlock_irqrestore(&xhci->lock, flags);
+
+	if (bus_state->bus_suspended)
+		usleep_range(5000, 10000);
+
 	return 0;
 }
 


