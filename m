Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 907CB73E47
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 22:23:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388668AbfGXTmU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 15:42:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:43960 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390344AbfGXTmT (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 15:42:19 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BF14B217D4;
        Wed, 24 Jul 2019 19:42:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563997339;
        bh=k7HusJDUgJunaBFNuyzKP/8EUR1t/9moYa77Naaiwrs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LvEl3mxsIA2ow4EKXtSLXr2TKxX4HoqqSkjGF2qKQMzrXIAZoTfQAvn0yH7/13f3p
         J+LLeyMohRecP/flB3DqFqI2CAMt4pGHOVukuGm70doOkjrfIP8mIhEvHocj659Uvr
         hnoPiCkKm9uvZSgs/iKygyNUxvYYdDAFe1gbDlCI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Lee, Chiasheng" <chiasheng.lee@intel.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Lee@vger.kernel.org
Subject: [PATCH 5.2 403/413] usb: Handle USB3 remote wakeup for LPM enabled devices correctly
Date:   Wed, 24 Jul 2019 21:21:34 +0200
Message-Id: <20190724191803.571898108@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191735.096702571@linuxfoundation.org>
References: <20190724191735.096702571@linuxfoundation.org>
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
@@ -3617,6 +3617,7 @@ static int hub_handle_remote_wakeup(stru
 	struct usb_device *hdev;
 	struct usb_device *udev;
 	int connect_change = 0;
+	u16 link_state;
 	int ret;
 
 	hdev = hub->hdev;
@@ -3626,9 +3627,11 @@ static int hub_handle_remote_wakeup(stru
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
 


