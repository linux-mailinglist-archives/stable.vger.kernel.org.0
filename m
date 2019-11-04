Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D52DAEEF52
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 23:21:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388513AbfKDWU0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 17:20:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:56854 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388271AbfKDV7g (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Nov 2019 16:59:36 -0500
Received: from localhost (6.204-14-84.ripe.coltfrance.com [84.14.204.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 09E3620650;
        Mon,  4 Nov 2019 21:59:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572904775;
        bh=uhPeJNd+u49dcc0yqvWhoBEO7i98kn3a/Loq3BHxCWo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0WhniwCqQYvJ1cq3XS/0KzL1RoYDtLZcC2aZrEJgW9D/HsrzL3/SDdg3USGqeFPWN
         f5YD97z5v+hvhM+TS72zCW9YLdWC/bguToUjvzxhiSs4aHCEkAlTE5BC5YbSGq12bs
         iovA2oU2mrZbhniQ3pq4BpUX0kcUlfTbkFsGaGAU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thinh Nguyen <thinhn@synopsys.com>,
        Felipe Balbi <felipe.balbi@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 039/149] usb: dwc3: gadget: clear DWC3_EP_TRANSFER_STARTED on cmd complete
Date:   Mon,  4 Nov 2019 22:43:52 +0100
Message-Id: <20191104212138.540612440@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191104212126.090054740@linuxfoundation.org>
References: <20191104212126.090054740@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Felipe Balbi <felipe.balbi@linux.intel.com>

[ Upstream commit acbfa6c26f21a18830ee064b588c92334305b6af ]

We must wait until End Transfer completes in order to clear
DWC3_EP_TRANSFER_STARTED, otherwise we may confuse the driver.

This patch is in preparation to fix a rare race condition that happens
upon Disconnect Interrupt.

Tested-by: Thinh Nguyen <thinhn@synopsys.com>
Signed-off-by: Felipe Balbi <felipe.balbi@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/dwc3/gadget.c | 19 +++++--------------
 1 file changed, 5 insertions(+), 14 deletions(-)

diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index 7b0957c530485..54de732550648 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -375,19 +375,9 @@ int dwc3_send_gadget_ep_cmd(struct dwc3_ep *dep, unsigned cmd,
 
 	trace_dwc3_gadget_ep_cmd(dep, cmd, params, cmd_status);
 
-	if (ret == 0) {
-		switch (DWC3_DEPCMD_CMD(cmd)) {
-		case DWC3_DEPCMD_STARTTRANSFER:
-			dep->flags |= DWC3_EP_TRANSFER_STARTED;
-			dwc3_gadget_ep_get_transfer_index(dep);
-			break;
-		case DWC3_DEPCMD_ENDTRANSFER:
-			dep->flags &= ~DWC3_EP_TRANSFER_STARTED;
-			break;
-		default:
-			/* nothing */
-			break;
-		}
+	if (ret == 0 && DWC3_DEPCMD_CMD(cmd) == DWC3_DEPCMD_STARTTRANSFER) {
+		dep->flags |= DWC3_EP_TRANSFER_STARTED;
+		dwc3_gadget_ep_get_transfer_index(dep);
 	}
 
 	if (unlikely(susphy)) {
@@ -2417,7 +2407,8 @@ static void dwc3_endpoint_interrupt(struct dwc3 *dwc,
 		cmd = DEPEVT_PARAMETER_CMD(event->parameters);
 
 		if (cmd == DWC3_DEPCMD_ENDTRANSFER) {
-			dep->flags &= ~DWC3_EP_END_TRANSFER_PENDING;
+			dep->flags &= ~(DWC3_EP_END_TRANSFER_PENDING |
+					DWC3_EP_TRANSFER_STARTED);
 			dwc3_gadget_ep_cleanup_cancelled_requests(dep);
 		}
 		break;
-- 
2.20.1



