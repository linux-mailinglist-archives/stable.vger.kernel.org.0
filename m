Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16ED91F2D87
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 02:36:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730378AbgFIAeG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 20:34:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:35140 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729880AbgFHXOl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jun 2020 19:14:41 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5B66A20C09;
        Mon,  8 Jun 2020 23:14:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591658081;
        bh=L9dEFwmMPW+AV5IScBr/9bkG1sG4655gjTPtCJQfpNQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pPebJoRTz80DttDZht1dD/QIJLb09QDq93cfmhBXv4COFr/VWNDW5pcc1DX3iK5PF
         xHBY2Gg20y4lF6gv0Md4IJAzpgW6VyLaUM/hD0t4y5tqUJUi0zEUZy/fSmKa/smxu5
         LCZyint2nxhsNmVUEVuhRmi9kuAu4x0ILpng/j6E=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alan Stern <stern@rowland.harvard.edu>,
        syzbot+db339689b2101f6f6071@syzkaller.appspotmail.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 125/606] USB: core: Fix misleading driver bug report
Date:   Mon,  8 Jun 2020 19:04:10 -0400
Message-Id: <20200608231211.3363633-125-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608231211.3363633-1-sashal@kernel.org>
References: <20200608231211.3363633-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alan Stern <stern@rowland.harvard.edu>

[ Upstream commit ac854131d9844f79e2fdcef67a7707227538d78a ]

The syzbot fuzzer found a race between URB submission to endpoint 0
and device reset.  Namely, during the reset we call usb_ep0_reinit()
because the characteristics of ep0 may have changed (if the reset
follows a firmware update, for example).  While usb_ep0_reinit() is
running there is a brief period during which the pointers stored in
udev->ep_in[0] and udev->ep_out[0] are set to NULL, and if an URB is
submitted to ep0 during that period, usb_urb_ep_type_check() will
report it as a driver bug.  In the absence of those pointers, the
routine thinks that the endpoint doesn't exist.  The log message looks
like this:

------------[ cut here ]------------
usb 2-1: BOGUS urb xfer, pipe 2 != type 2
WARNING: CPU: 0 PID: 9241 at drivers/usb/core/urb.c:478
usb_submit_urb+0x1188/0x1460 drivers/usb/core/urb.c:478

Now, although submitting an URB while the device is being reset is a
questionable thing to do, it shouldn't count as a driver bug as severe
as submitting an URB for an endpoint that doesn't exist.  Indeed,
endpoint 0 always exists, even while the device is in its unconfigured
state.

To prevent these misleading driver bug reports, this patch updates
usb_disable_endpoint() to avoid clearing the ep_in[] and ep_out[]
pointers when the endpoint being disabled is ep0.  There's no danger
of leaving a stale pointer in place, because the usb_host_endpoint
structure being pointed to is stored permanently in udev->ep0; it
doesn't get deallocated until the entire usb_device structure does.

Reported-and-tested-by: syzbot+db339689b2101f6f6071@syzkaller.appspotmail.com
Signed-off-by: Alan Stern <stern@rowland.harvard.edu>

Link: https://lore.kernel.org/r/Pine.LNX.4.44L0.2005011558590.903-100000@netrider.rowland.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/core/message.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/core/message.c b/drivers/usb/core/message.c
index 02eaac7e1e34..a1ac2f0723b0 100644
--- a/drivers/usb/core/message.c
+++ b/drivers/usb/core/message.c
@@ -1143,11 +1143,11 @@ void usb_disable_endpoint(struct usb_device *dev, unsigned int epaddr,
 
 	if (usb_endpoint_out(epaddr)) {
 		ep = dev->ep_out[epnum];
-		if (reset_hardware)
+		if (reset_hardware && epnum != 0)
 			dev->ep_out[epnum] = NULL;
 	} else {
 		ep = dev->ep_in[epnum];
-		if (reset_hardware)
+		if (reset_hardware && epnum != 0)
 			dev->ep_in[epnum] = NULL;
 	}
 	if (ep) {
-- 
2.25.1

