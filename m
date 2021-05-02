Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1002370C3B
	for <lists+stable@lfdr.de>; Sun,  2 May 2021 16:05:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232701AbhEBOFi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 2 May 2021 10:05:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:50872 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232631AbhEBOFY (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 2 May 2021 10:05:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2A178613BB;
        Sun,  2 May 2021 14:04:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619964272;
        bh=zBrj9N0+ZJrHc7wY1+NswB6PUK+mR6562Gb1iQFBVVE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Fy6X5QM+QhxDvb+OKPvOt3UXOIelW7pGXBTunQkm2Y7S6Isr1jYGpTfX/KjMwzj03
         eaSBEfc2qEw4HD8jIkyAdjzJW3QkT+MD3LUUFSnWUwbszUqSZslzks5Uxi/FRj8g+z
         T4XKXrEzk5JlFQ9qPddM+MpOKQd+SO5ouUPeNGfYVIjH4ZWetbvDsWVkig2Dsd7e77
         QFQlIKq1/P+/lvWtMmfXRxmfs3iJ/6i7YPklwxS+AGiN5Rpvg4YKPZh4T+1KJUQQPw
         UAHGxroTXp7YkajPofQa6BqtVtFm40o96T/CTBMy41i5ohIqPCsQMaX5ocUnjxo//7
         wkvRCCX7KCyYA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 17/66] usb: xhci: Fix port minor revision
Date:   Sun,  2 May 2021 10:03:22 -0400
Message-Id: <20210502140411.2719301-17-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210502140411.2719301-1-sashal@kernel.org>
References: <20210502140411.2719301-1-sashal@kernel.org>
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
index 138ba4528dd3..1ad0ac8c8209 100644
--- a/drivers/usb/host/xhci-mem.c
+++ b/drivers/usb/host/xhci-mem.c
@@ -2143,6 +2143,15 @@ static void xhci_add_in_port(struct xhci_hcd *xhci, unsigned int num_ports,
 
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

