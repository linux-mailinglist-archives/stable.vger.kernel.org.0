Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D56883785EB
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:30:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234189AbhEJLC1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:02:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:53030 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234753AbhEJK5A (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 06:57:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 850CA61941;
        Mon, 10 May 2021 10:48:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620643727;
        bh=Rle3zqVfWoW/uBThzNa9pZMyBFOzlSHimqohDy15prY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ktbDsfIWy9wy+ZlomdSHy6MufDkvEU4U2ux9j0rhfe/wPJixpS6wKDUWrMU+HbBHq
         Gh1EFMczl8LMUC/bOFW4tJl6dRylfcljuVczRqUohO5v24IKSVQmXSKKk7Ii/nIncj
         FDFTAi0xGpLiue4PgfA+lChdDDZeFx+Nf5Fdtrto=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 098/342] xhci: check port array allocation was successful before dereferencing it
Date:   Mon, 10 May 2021 12:18:08 +0200
Message-Id: <20210510102013.336539647@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102010.096403571@linuxfoundation.org>
References: <20210510102010.096403571@linuxfoundation.org>
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
index 412a83f8055f..1df123db5ef8 100644
--- a/drivers/usb/host/xhci-mem.c
+++ b/drivers/usb/host/xhci-mem.c
@@ -2262,6 +2262,9 @@ static void xhci_create_rhub_port_array(struct xhci_hcd *xhci,
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



