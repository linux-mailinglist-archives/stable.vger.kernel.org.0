Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE1A83783E1
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 12:47:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231213AbhEJKrz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 06:47:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:59424 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233314AbhEJKpg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 06:45:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 58FE96199B;
        Mon, 10 May 2021 10:35:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620642958;
        bh=HbZVkDM7Hz1dYdhcBMw/0LW2l3hciERE9GIKr0uqtH8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qwfgIpaqxgiKNGH4Xq5xo9wyAdJrfj7W+B24sTSGyUkvGCgbYnTobLjG6hqdLo9HK
         uuSjC3uuHGjFXfk0A/e4JHje3BfsNyvL9RayDiH0kbws0PNbqVl8vtbU/yxTTDB+mb
         RVgZ84L3LEw7LnGfhixpaGpLX7Bm/yGe0PQMyKXs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 085/299] xhci: check port array allocation was successful before dereferencing it
Date:   Mon, 10 May 2021 12:18:02 +0200
Message-Id: <20210510102007.747032385@linuxfoundation.org>
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
index 1ad0ac8c8209..8ce043e6ed87 100644
--- a/drivers/usb/host/xhci-mem.c
+++ b/drivers/usb/host/xhci-mem.c
@@ -2263,6 +2263,9 @@ static void xhci_create_rhub_port_array(struct xhci_hcd *xhci,
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



