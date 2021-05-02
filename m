Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48053370CAB
	for <lists+stable@lfdr.de>; Sun,  2 May 2021 16:06:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233439AbhEBOHK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 2 May 2021 10:07:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:51596 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233430AbhEBOGZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 2 May 2021 10:06:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 68DEA61476;
        Sun,  2 May 2021 14:05:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619964327;
        bh=rBY/7Bk1Sr8TdKUOYXS2eSOAZqHHk1x1bDMTDS6FW18=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pjvgmQvQq2YliPXChebgbuPJ3aGs8/HsFfJCLfAgsJnh/Xo0IlfSEZbaHMl2tPMA/
         tbPSuuLD3KpPAhWjxTXZFCtv9uI0m/YjK5sQuKOgQAXy2pvl5UXgeYupnD35p3WnQn
         Z+Px1ZUxasAVF09tLdwvIJGV4D7FA9gI8ZdBsIZmTCrnaP4blILRBGuuN9djqyS6Xd
         VKJgj8cOQVvyrWnnL+hKxvAz8hMX0ObFuhmIqEjMRoWuFxOgn3maIi/wvtJlLdWDXg
         ren0rDIDisLvDSzxeEDdmB0erYasPVJhYyLELuWnEkCtF+/RvWIwa2qQOE3NHTT4pM
         wFNUIYCzcthng==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 07/21] usb: xhci: Fix port minor revision
Date:   Sun,  2 May 2021 10:05:03 -0400
Message-Id: <20210502140517.2719912-7-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210502140517.2719912-1-sashal@kernel.org>
References: <20210502140517.2719912-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thinh Nguyen <Thinh.Nguyen@synopsys.com>

[ Upstream commit 64364bc912c01b33bba6c22e3ccb849bfca96398 ]

Some hosts incorrectly use sub-minor version for minor version (i.e.
0x02 instead of 0x20 for bcdUSB 0x320 and 0x01 for bcdUSB 0x310).
Currently the xHCI driver works around this by just checking for minor
revision > 0x01 for USB 3.1 everywhere. With the addition of USB 3.2,
checking this gets a bit cumbersome. Since there is no USB release with
bcdUSB 0x301 to 0x309, we can assume that sub-minor version 01 to 09 is
incorrect. Let's try to fix this and use the minor revision that matches
with the USB/xHCI spec to help with the version checking within the
driver.

Acked-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Link: https://lore.kernel.org/r/ed330e95a19dc367819c5b4d78bf7a541c35aa0a.1615432770.git.Thinh.Nguyen@synopsys.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/xhci-mem.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/usb/host/xhci-mem.c b/drivers/usb/host/xhci-mem.c
index 9e87c282a743..2461be2a8748 100644
--- a/drivers/usb/host/xhci-mem.c
+++ b/drivers/usb/host/xhci-mem.c
@@ -2134,6 +2134,15 @@ static void xhci_add_in_port(struct xhci_hcd *xhci, unsigned int num_ports,
 
 	if (major_revision == 0x03) {
 		rhub = &xhci->usb3_rhub;
+		/*
+		 * Some hosts incorrectly use sub-minor version for minor
+		 * version (i.e. 0x02 instead of 0x20 for bcdUSB 0x320 and 0x01
+		 * for bcdUSB 0x310). Since there is no USB release with sub
+		 * minor version 0x301 to 0x309, we can assume that they are
+		 * incorrect and fix it here.
+		 */
+		if (minor_revision > 0x00 && minor_revision < 0x10)
+			minor_revision <<= 4;
 	} else if (major_revision <= 0x02) {
 		rhub = &xhci->usb2_rhub;
 	} else {
-- 
2.30.2

