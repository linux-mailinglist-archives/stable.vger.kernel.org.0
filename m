Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 571403783A1
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 12:47:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232513AbhEJKqv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 06:46:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:57348 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232803AbhEJKoi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 06:44:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F37D46198A;
        Mon, 10 May 2021 10:33:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620642824;
        bh=zBrj9N0+ZJrHc7wY1+NswB6PUK+mR6562Gb1iQFBVVE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kp9iPAdGKZm32i27iPJdouU2oFEMhZJaqMbhqsTqQljXjruZERZr1Nwr8GS0qOU1D
         IGD7kSH/mIJ5ymMCAuTz/ThqjLme/JDC4koU7GDL+ePXI7ydb7qjKmoblsAmm9sgsy
         I2x26QBwtYYSYoM3KoTypcpzd4sefANyMAXBVyjI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 066/299] usb: xhci: Fix port minor revision
Date:   Mon, 10 May 2021 12:17:43 +0200
Message-Id: <20210510102007.080219629@linuxfoundation.org>
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



