Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBE23405252
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 14:47:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350679AbhIIMm6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 08:42:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:48338 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1354383AbhIIMi7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 08:38:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7258E61BAA;
        Thu,  9 Sep 2021 11:54:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188475;
        bh=fIXSzeBeU3dLvLblzJEo+/rW3xAPrg7LD3uCRPt4XWY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HinJO7mOcSxoXu3krUUlN8IVwoHTsvDzZkn/FbL1iiJ9STqM8xb32k5fR5dUm3dhi
         BrJ/kpp8L1+ht54uUCv00eSwmNABoICRyX1Z9YbwZFCJwYaqiNoXhCDJxgxNwsTKex
         HmItjOH5RUBpEQNDuxEw7cO2iCIfqgbWCsaHhBEN8ZHP/ZV96zXhO4g1Erv7TTLWHT
         V0iSyWUOBZVQtblFXf9atLIMYbFMY0Td+6ZjHGKi1oJnIBp2F6j63zvZiNcqw2GyVx
         IPa2A7kEj2NK7slOb1dv4IGUz5vJJ961l3TZxiaY73aVNaHS6bzwr9UGGRSPOvq09Q
         epZd6R0WUmYsQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mathias Nyman <mathias.nyman@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 152/176] Revert "USB: xhci: fix U1/U2 handling for hardware with XHCI_INTEL_HOST quirk set"
Date:   Thu,  9 Sep 2021 07:50:54 -0400
Message-Id: <20210909115118.146181-152-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909115118.146181-1-sashal@kernel.org>
References: <20210909115118.146181-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mathias Nyman <mathias.nyman@linux.intel.com>

[ Upstream commit 2847c46c61486fd8bca9136a6e27177212e78c69 ]

This reverts commit 5d5323a6f3625f101dbfa94ba3ef7706cce38760.

That commit effectively disabled Intel host initiated U1/U2 lpm for devices
with periodic endpoints.

Before that commit we disabled host initiated U1/U2 lpm if the exit latency
was larger than any periodic endpoint service interval, this is according
to xhci spec xhci 1.1 specification section 4.23.5.2

After that commit we incorrectly checked that service interval was smaller
than U1/U2 inactivity timeout. This is not relevant, and can't happen for
Intel hosts as previously set U1/U2 timeout = 105% * service interval.

Patch claimed it solved cases where devices can't be enumerated because of
bandwidth issues. This might be true but it's a side effect of accidentally
turning off lpm.

exit latency calculations have been revised since then

Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20210820123503.2605901-5-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/xhci.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index a8d97e23f601..c51391b45207 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -4666,19 +4666,19 @@ static u16 xhci_calculate_u1_timeout(struct xhci_hcd *xhci,
 {
 	unsigned long long timeout_ns;
 
-	if (xhci->quirks & XHCI_INTEL_HOST)
-		timeout_ns = xhci_calculate_intel_u1_timeout(udev, desc);
-	else
-		timeout_ns = udev->u1_params.sel;
-
 	/* Prevent U1 if service interval is shorter than U1 exit latency */
 	if (usb_endpoint_xfer_int(desc) || usb_endpoint_xfer_isoc(desc)) {
-		if (xhci_service_interval_to_ns(desc) <= timeout_ns) {
+		if (xhci_service_interval_to_ns(desc) <= udev->u1_params.mel) {
 			dev_dbg(&udev->dev, "Disable U1, ESIT shorter than exit latency\n");
 			return USB3_LPM_DISABLED;
 		}
 	}
 
+	if (xhci->quirks & XHCI_INTEL_HOST)
+		timeout_ns = xhci_calculate_intel_u1_timeout(udev, desc);
+	else
+		timeout_ns = udev->u1_params.sel;
+
 	/* The U1 timeout is encoded in 1us intervals.
 	 * Don't return a timeout of zero, because that's USB3_LPM_DISABLED.
 	 */
@@ -4730,19 +4730,19 @@ static u16 xhci_calculate_u2_timeout(struct xhci_hcd *xhci,
 {
 	unsigned long long timeout_ns;
 
-	if (xhci->quirks & XHCI_INTEL_HOST)
-		timeout_ns = xhci_calculate_intel_u2_timeout(udev, desc);
-	else
-		timeout_ns = udev->u2_params.sel;
-
 	/* Prevent U2 if service interval is shorter than U2 exit latency */
 	if (usb_endpoint_xfer_int(desc) || usb_endpoint_xfer_isoc(desc)) {
-		if (xhci_service_interval_to_ns(desc) <= timeout_ns) {
+		if (xhci_service_interval_to_ns(desc) <= udev->u2_params.mel) {
 			dev_dbg(&udev->dev, "Disable U2, ESIT shorter than exit latency\n");
 			return USB3_LPM_DISABLED;
 		}
 	}
 
+	if (xhci->quirks & XHCI_INTEL_HOST)
+		timeout_ns = xhci_calculate_intel_u2_timeout(udev, desc);
+	else
+		timeout_ns = udev->u2_params.sel;
+
 	/* The U2 timeout is encoded in 256us intervals */
 	timeout_ns = DIV_ROUND_UP_ULL(timeout_ns, 256 * 1000);
 	/* If the necessary timeout value is bigger than what we can set in the
-- 
2.30.2

