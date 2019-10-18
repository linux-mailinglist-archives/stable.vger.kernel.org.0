Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 12C83DD3EC
	for <lists+stable@lfdr.de>; Sat, 19 Oct 2019 00:21:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731293AbfJRWGT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Oct 2019 18:06:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:38282 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731258AbfJRWGT (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 18 Oct 2019 18:06:19 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1481B222D4;
        Fri, 18 Oct 2019 22:06:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571436378;
        bh=uhPeJNd+u49dcc0yqvWhoBEO7i98kn3a/Loq3BHxCWo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C/14N7qqjKO36MlSTZgO8Br465pUasQT4ZsyL7a0yrZL7D6T8/90uBKtIld7cgwv/
         9aZMnwr7mJbnWTxY14ZVhvTQNkkBGI68sa+dSVN5I4fSG5i2R+enptJQRCjAmuHlem
         F92+wW8XJHl5Dzoqn32zm9xN8PkX74GgzMFcZnoY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Felipe Balbi <felipe.balbi@linux.intel.com>,
        Thinh Nguyen <thinhn@synopsys.com>,
        Sasha Levin <sashal@kernel.org>, linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 032/100] usb: dwc3: gadget: clear DWC3_EP_TRANSFER_STARTED on cmd complete
Date:   Fri, 18 Oct 2019 18:04:17 -0400
Message-Id: <20191018220525.9042-32-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191018220525.9042-1-sashal@kernel.org>
References: <20191018220525.9042-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

