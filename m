Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8220E3781C9
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 12:28:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231560AbhEJK3v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 06:29:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:60020 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231699AbhEJK20 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 06:28:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0AC49613C5;
        Mon, 10 May 2021 10:26:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620642415;
        bh=nqwsTI4z0ueqDsideuLlT3/SIcz+IHv/RFA1CRkZxmw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ssvAvo5h752pHTZHDPbDy7PXv4ijnJYzopcsjygQUvFECY9F/ttb5G1bTDGDi2xoV
         hGm43mR2PxJ9f0/4fziBOPNQINkCuLd4/u1THpzEYsSUDnOvRukSxtAkwQmfDppCQH
         Efa6EjjKRUpWqkjA5BNEq6euJmLioEisN2XdmytQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 050/184] usb: xhci: Fix port minor revision
Date:   Mon, 10 May 2021 12:19:04 +0200
Message-Id: <20210510101951.857220190@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510101950.200777181@linuxfoundation.org>
References: <20210510101950.200777181@linuxfoundation.org>
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
index 9764122c9cdf..7f9f302a73cd 100644
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



