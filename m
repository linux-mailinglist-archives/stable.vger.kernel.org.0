Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED931798F9
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 22:12:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729313AbfG2UL7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 16:11:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:46104 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729269AbfG2Tcd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jul 2019 15:32:33 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 389D1217D4;
        Mon, 29 Jul 2019 19:32:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564428752;
        bh=HFU/DbYWq2H2LL/Ks3RT4dJnz4zgG/Hmhvvi2tRXXQg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wjkDVj0bESS8Quf1mHX5+0jQ2oYc6bjzzVmrzvbTV3LSlAk9qL+Qm0R4I8YUiEfY3
         a5NWWNqQ4Q2fGeh49vkMtRh/RVOeIeDE1OBv+I9/uanu5edisSBP15zBQvXgsIE3++
         Sr2u+S2amZczkQwctO7PqnQzFCrpiiOvuiJZEi+0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Lee, Chiasheng" <chiasheng.lee@intel.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Lee@vger.kernel.org
Subject: [PATCH 4.14 174/293] usb: Handle USB3 remote wakeup for LPM enabled devices correctly
Date:   Mon, 29 Jul 2019 21:21:05 +0200
Message-Id: <20190729190837.847991420@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190729190820.321094988@linuxfoundation.org>
References: <20190729190820.321094988@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lee, Chiasheng <chiasheng.lee@intel.com>

commit e244c4699f859cf7149b0781b1894c7996a8a1df upstream.

With Link Power Management (LPM) enabled USB3 links transition to low
power U1/U2 link states from U0 state automatically.

Current hub code detects USB3 remote wakeups by checking if the software
state still shows suspended, but the link has transitioned from suspended
U3 to enabled U0 state.

As it takes some time before the hub thread reads the port link state
after a USB3 wake notification, the link may have transitioned from U0
to U1/U2, and wake is not detected by hub code.

Fix this by handling U1/U2 states in the same way as U0 in USB3 wakeup
handling

This patch should be added to stable kernels since 4.13 where LPM was
kept enabled during suspend/resume

Cc: <stable@vger.kernel.org> # v4.13+
Signed-off-by: Lee, Chiasheng <chiasheng.lee@intel.com>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/core/hub.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -3532,6 +3532,7 @@ static int hub_handle_remote_wakeup(stru
 	struct usb_device *hdev;
 	struct usb_device *udev;
 	int connect_change = 0;
+	u16 link_state;
 	int ret;
 
 	hdev = hub->hdev;
@@ -3541,9 +3542,11 @@ static int hub_handle_remote_wakeup(stru
 			return 0;
 		usb_clear_port_feature(hdev, port, USB_PORT_FEAT_C_SUSPEND);
 	} else {
+		link_state = portstatus & USB_PORT_STAT_LINK_STATE;
 		if (!udev || udev->state != USB_STATE_SUSPENDED ||
-				 (portstatus & USB_PORT_STAT_LINK_STATE) !=
-				 USB_SS_PORT_LS_U0)
+				(link_state != USB_SS_PORT_LS_U0 &&
+				 link_state != USB_SS_PORT_LS_U1 &&
+				 link_state != USB_SS_PORT_LS_U2))
 			return 0;
 	}
 


