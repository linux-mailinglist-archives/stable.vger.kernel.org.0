Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59D67378806
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:41:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238898AbhEJLUX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:20:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:44218 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236472AbhEJLIN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 07:08:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E9B3D619B7;
        Mon, 10 May 2021 11:01:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620644491;
        bh=Hryb9EaU8CgLAEfMSXOv1F6UHB9Xx/U2+Y/8wmP8DtE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p5qfPCFoIycb1OyrKSej2Xsuqn3keygwHQ/OqrvXQ6NRhB1LXSTBK0hwWie4j4e8K
         EeFFdCRHDkbtcj+pdwmh1iqg4Dk+rm1zgkiAtRSuCzlloOYHBsJolnRV+Jfbc2IlZw
         EnPjHw8dPc3Pv8Ah7Ifn/Vjmenocrt0EOrkcQnQg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 103/384] xhci: check port array allocation was successful before dereferencing it
Date:   Mon, 10 May 2021 12:18:12 +0200
Message-Id: <20210510102018.277705080@linuxfoundation.org>
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

From: Mathias Nyman <mathias.nyman@linux.intel.com>

[ Upstream commit 8a157d2ff104d2849c58226a1fd02365d7d60150 ]

return if rhub->ports is null after rhub->ports = kcalloc_node()
Klockwork reported issue

Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20210406070208.3406266-2-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/xhci-mem.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/usb/host/xhci-mem.c b/drivers/usb/host/xhci-mem.c
index 3708432f5f69..717c122f9449 100644
--- a/drivers/usb/host/xhci-mem.c
+++ b/drivers/usb/host/xhci-mem.c
@@ -2249,6 +2249,9 @@ static void xhci_create_rhub_port_array(struct xhci_hcd *xhci,
 		return;
 	rhub->ports = kcalloc_node(rhub->num_ports, sizeof(*rhub->ports),
 			flags, dev_to_node(dev));
+	if (!rhub->ports)
+		return;
+
 	for (i = 0; i < HCS_MAX_PORTS(xhci->hcs_params1); i++) {
 		if (xhci->hw_ports[i].rhub != rhub ||
 		    xhci->hw_ports[i].hcd_portnum == DUPLICATE_ENTRY)
-- 
2.30.2



