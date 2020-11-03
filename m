Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1DD12A55AD
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 22:21:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730304AbgKCVV0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 16:21:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:45030 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388119AbgKCVGL (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 16:06:11 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 802FA205ED;
        Tue,  3 Nov 2020 21:06:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604437571;
        bh=RGRplAmYxujE5GLwdQEMcv7jg6rmi59tS7wxg0AjfJ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bK/DQ33RHmbXq/eS7zBTQdZVU5LO3BAOYqL/Vy2rgmgnnj9Ed2UggOuUPyepFIDyt
         1ZpeJtTqG4DQTvjK7+hiXPewVFM9ySB7/FlFzO9QDer94+6ySaJAVUrdUdNSeWagGT
         31IrGVORy+1p16qqFK5mtKK5cTcMe7mv9hy3XHGE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jun Li <jun.li@nxp.com>,
        Peter Chen <peter.chen@nxp.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 085/191] usb: xhci: omit duplicate actions when suspending a runtime suspended host.
Date:   Tue,  3 Nov 2020 21:36:17 +0100
Message-Id: <20201103203242.052499066@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203232.656475008@linuxfoundation.org>
References: <20201103203232.656475008@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Chen <peter.chen@nxp.com>

[ Upstream commit 18a367e8947d72dd91b6fc401e88a2952c6363f7 ]

If the xhci-plat.c is the platform driver, after the runtime pm is
enabled, the xhci_suspend is called if nothing is connected on
the port. When the system goes to suspend, it will call xhci_suspend again
if USB wakeup is enabled.

Since the runtime suspend wakeup setting is not always the same as
system suspend wakeup setting, eg, at runtime suspend we always need
wakeup if the controller is in low power mode; but at system suspend,
we may not need wakeup. So, we move the judgement after changing
wakeup setting.

[commit message rewording -Mathias]

Reviewed-by: Jun Li <jun.li@nxp.com>
Signed-off-by: Peter Chen <peter.chen@nxp.com>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20200918131752.16488-8-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/xhci.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index 6f976c4cccdae..0348ea899d062 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -972,12 +972,15 @@ int xhci_suspend(struct xhci_hcd *xhci, bool do_wakeup)
 			xhci->shared_hcd->state != HC_STATE_SUSPENDED)
 		return -EINVAL;
 
-	xhci_dbc_suspend(xhci);
-
 	/* Clear root port wake on bits if wakeup not allowed. */
 	if (!do_wakeup)
 		xhci_disable_port_wake_on_bits(xhci);
 
+	if (!HCD_HW_ACCESSIBLE(hcd))
+		return 0;
+
+	xhci_dbc_suspend(xhci);
+
 	/* Don't poll the roothubs on bus suspend. */
 	xhci_dbg(xhci, "%s: stopping port polling.\n", __func__);
 	clear_bit(HCD_FLAG_POLL_RH, &hcd->flags);
-- 
2.27.0



