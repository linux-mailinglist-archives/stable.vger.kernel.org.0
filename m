Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB6E9370BDB
	for <lists+stable@lfdr.de>; Sun,  2 May 2021 16:03:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232425AbhEBOEk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 2 May 2021 10:04:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:49374 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232346AbhEBOEe (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 2 May 2021 10:04:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 16198613AA;
        Sun,  2 May 2021 14:03:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619964222;
        bh=yjv83xeYuwyma2z/uwMdnT0GY8PGJ9xn6q6JHn+3dtk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=spSdrOUOV/sdjefbNIRiH39iGNVdgA+yeowdzHKWXvwUxfQ8NvbrttMvrFuVDcogJ
         nAfl8EdloNdhnnF0U/ypp7ZpDebEGv5PawfMGZCiPv78hHN674bP3PHXS+tcUAbkfC
         ZGe9upaddj9k4AyaLalCct9VzuE6q6yoFpIHhnyE3/4OoiX+nGtMksvggEWLC3NTNy
         CvvNnnstl2v3lIyId42BWZWgUZCQTGbcYzHUNZuIhhi411CD6NRMf/KJSddubofCh2
         Vh9TXGyhqj9hB4H/v6rqAauaTQov5b0ZjhKnGqTn/tKHr0J3R9I7HJjoF+K64Y2vqV
         9GUGcyDibGCNA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 20/79] usb: xhci: Fix port minor revision
Date:   Sun,  2 May 2021 10:02:17 -0400
Message-Id: <20210502140316.2718705-20-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210502140316.2718705-1-sashal@kernel.org>
References: <20210502140316.2718705-1-sashal@kernel.org>
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
index f2c4ee7c4786..3708432f5f69 100644
--- a/drivers/usb/host/xhci-mem.c
+++ b/drivers/usb/host/xhci-mem.c
@@ -2129,6 +2129,15 @@ static void xhci_add_in_port(struct xhci_hcd *xhci, unsigned int num_ports,
 
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

