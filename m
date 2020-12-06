Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DDDC2D0463
	for <lists+stable@lfdr.de>; Sun,  6 Dec 2020 12:52:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729473AbgLFLpT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Dec 2020 06:45:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:44440 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729464AbgLFLpO (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 6 Dec 2020 06:45:14 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Matti Vuorela <matti.vuorela@bitfactor.fi>,
        Yves-Alexis Perez <corsac@corsac.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.9 12/46] usbnet: ipheth: fix connectivity with iOS 14
Date:   Sun,  6 Dec 2020 12:17:20 +0100
Message-Id: <20201206111557.053456428@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201206111556.455533723@linuxfoundation.org>
References: <20201206111556.455533723@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yves-Alexis Perez <corsac@corsac.net>

[ Upstream commit f33d9e2b48a34e1558b67a473a1fc1d6e793f93c ]

Starting with iOS 14 released in September 2020, connectivity using the
personal hotspot USB tethering function of iOS devices is broken.

Communication between the host and the device (for example ICMP traffic
or DNS resolution using the DNS service running in the device itself)
works fine, but communication to endpoints further away doesn't work.

Investigation on the matter shows that no UDP and ICMP traffic from the
tethered host is reaching the Internet at all. For TCP traffic there are
exchanges between tethered host and server but packets are modified in
transit leading to impossible communication.

After some trials Matti Vuorela discovered that reducing the URB buffer
size by two bytes restored the previous behavior. While a better
solution might exist to fix the issue, since the protocol is not
publicly documented and considering the small size of the fix, let's do
that.

Tested-by: Matti Vuorela <matti.vuorela@bitfactor.fi>
Signed-off-by: Yves-Alexis Perez <corsac@corsac.net>
Link: https://lore.kernel.org/linux-usb/CAAn0qaXmysJ9vx3ZEMkViv_B19ju-_ExN8Yn_uSefxpjS6g4Lw@mail.gmail.com/
Link: https://github.com/libimobiledevice/libimobiledevice/issues/1038
Link: https://lore.kernel.org/r/20201119172439.94988-1-corsac@corsac.net
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/usb/ipheth.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/usb/ipheth.c
+++ b/drivers/net/usb/ipheth.c
@@ -59,7 +59,7 @@
 #define IPHETH_USBINTF_SUBCLASS 253
 #define IPHETH_USBINTF_PROTO    1
 
-#define IPHETH_BUF_SIZE         1516
+#define IPHETH_BUF_SIZE         1514
 #define IPHETH_IP_ALIGN		2	/* padding at front of URB */
 #define IPHETH_TX_TIMEOUT       (5 * HZ)
 


