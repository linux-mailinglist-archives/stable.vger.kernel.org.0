Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D7A4912C596
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 18:42:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729576AbfL2Rhq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:37:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:39616 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729516AbfL2RfU (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:35:20 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 434C9206DB;
        Sun, 29 Dec 2019 17:35:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577640919;
        bh=Z4NeLnHfinDf0dGZbvxosTXYvPNpnBpXnEzp2QUg3tM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qQGrjiBRZijkkrzl7Ss3U9jl4ey/3hjFnxmC8/1AX79fX24cCj8gDNMq6rBN0JbPQ
         0eGISxKz/LmIqoDmL5lg6QyNphofF7SEp33xE9l0zT/RSdnVgCVFjM/K5OzU2Sc+EH
         QTUoWfEvZTx4uRIbupu0PVFBAZiLsekRYNXSZdU8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Henry Lin <henryl@nvidia.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 193/219] usb: xhci: Fix build warning seen with CONFIG_PM=n
Date:   Sun, 29 Dec 2019 18:19:55 +0100
Message-Id: <20191229162538.879138816@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229162508.458551679@linuxfoundation.org>
References: <20191229162508.458551679@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guenter Roeck <linux@roeck-us.net>

[ Upstream commit 6056a0f8ede27b296d10ef46f7f677cc9d715371 ]

The following build warning is seen if CONFIG_PM is disabled.

drivers/usb/host/xhci-pci.c:498:13: warning:
	unused function 'xhci_pci_shutdown'

Fixes: f2c710f7dca8 ("usb: xhci: only set D3hot for pci device")
Cc: Henry Lin <henryl@nvidia.com>
Cc: stable@vger.kernel.org	# all stable releases with f2c710f7dca8
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Acked-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20191218011911.6907-1-linux@roeck-us.net
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/xhci-pci.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/host/xhci-pci.c b/drivers/usb/host/xhci-pci.c
index 74aeaa61f5c6..075c49cfe60f 100644
--- a/drivers/usb/host/xhci-pci.c
+++ b/drivers/usb/host/xhci-pci.c
@@ -493,7 +493,6 @@ static int xhci_pci_resume(struct usb_hcd *hcd, bool hibernated)
 	retval = xhci_resume(xhci, hibernated);
 	return retval;
 }
-#endif /* CONFIG_PM */
 
 static void xhci_pci_shutdown(struct usb_hcd *hcd)
 {
@@ -506,6 +505,7 @@ static void xhci_pci_shutdown(struct usb_hcd *hcd)
 	if (xhci->quirks & XHCI_SPURIOUS_WAKEUP)
 		pci_set_power_state(pdev, PCI_D3hot);
 }
+#endif /* CONFIG_PM */
 
 /*-------------------------------------------------------------------------*/
 
-- 
2.20.1



