Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 717B537876C
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:38:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237552AbhEJLPa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:15:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:45870 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236391AbhEJLH6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 07:07:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A8AAD61990;
        Mon, 10 May 2021 11:00:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620644440;
        bh=yjv83xeYuwyma2z/uwMdnT0GY8PGJ9xn6q6JHn+3dtk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jT8o2+tNE+9p0klmmH5xgxlx6z6kNo5TmV9pKB/eIpTpNC2y/pUbWOgUXID/MxxrY
         s85dWwCYWGmFoKxvKJIYugpWAxwBjYGYSes3FJFws0UEdeYhWSQO4XQv6fvt87Ls3C
         HdDVUipYtZAmW4PvghMPhJss+TqtLopefLLLdL+8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 084/384] usb: xhci: Fix port minor revision
Date:   Mon, 10 May 2021 12:17:53 +0200
Message-Id: <20210510102017.659845757@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102014.849075526@linuxfoundation.org>
References: <20210510102014.849075526@linuxfoundation.org>
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



