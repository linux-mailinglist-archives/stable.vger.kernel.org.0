Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2498A2A5936
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 23:06:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730502AbgKCWFu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 17:05:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:54398 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730459AbgKCUmQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:42:16 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 53711223AC;
        Tue,  3 Nov 2020 20:42:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604436135;
        bh=XGsbqvd62qY1W8D7D05w1F7bqDnJdi/VHCcbnNG8Ces=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1LMsSnTQQF+6SHWf3DTD35xb2dfye2+mecu/aeap3XxU2OJzwZ6vkyTzy5LIfXGLf
         nxNNKYQoVlyYEHG72dSfqy6pYqE0K9X08jwF2LZs4yaBn7p8Ny1Gym7hXpjQxZ6Dqg
         ryQ5z+MxF55dliu9HLZmAobouS8iK9BcudVQ+pIc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jun Li <jun.li@nxp.com>,
        Peter Chen <peter.chen@nxp.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 118/391] usb: xhci: omit duplicate actions when suspending a runtime suspended host.
Date:   Tue,  3 Nov 2020 21:32:49 +0100
Message-Id: <20201103203354.785713773@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203348.153465465@linuxfoundation.org>
References: <20201103203348.153465465@linuxfoundation.org>
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
index e534f524b7f87..e88f4f9539955 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -982,12 +982,15 @@ int xhci_suspend(struct xhci_hcd *xhci, bool do_wakeup)
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



