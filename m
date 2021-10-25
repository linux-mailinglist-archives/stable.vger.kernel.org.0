Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8245943A837
	for <lists+stable@lfdr.de>; Tue, 26 Oct 2021 01:35:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234986AbhJYXhc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 19:37:32 -0400
Received: from smtprelay-out1.synopsys.com ([149.117.87.133]:60952 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234994AbhJYXhc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Oct 2021 19:37:32 -0400
Received: from mailhost.synopsys.com (sv1-mailhost2.synopsys.com [10.205.2.132])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client CN "mailhost.synopsys.com", Issuer "SNPSica2" (verified OK))
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 9F75CC1D0D;
        Mon, 25 Oct 2021 23:35:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1635204909; bh=GMSmwluaspmoSpkki6v6uO3ZkU2BxA37ZooHsaSFYoA=;
        h=Date:From:Subject:To:Cc:From;
        b=G8X+/PActgyxmrbFRErFuwhNaIHxepHv4iF5Y+a0D8KuLcFpTUjZFGThl8lSamRLU
         bCMmQxeiEcOWHgtqfgGcLX6NXYuMlIwE8KzA2fzUMm3uTkE/likhVLJPc5+dCc5ynS
         36OPQ5+pywrReHJkr4JRMDTRIuEw/SxusHV1UO790lo6M+o3HvRfaVlr6DHZJWu7AB
         pJrk5WVGWsBxzdSD9czomxTrkoF22bFI010HNFR5mSruH8d8YnxUycc6rapqdy1TNT
         7RcZi2BRjRFmMswLqb323UC1vC83icLs2EZRaNTm+VepUUMh/ZBKlewYL8/nspb84L
         is2R+zRc7e+cA==
Received: from te-lab16-v2 (nanobot.internal.synopsys.com [10.204.48.11])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (Client did not present a certificate)
        by mailhost.synopsys.com (Postfix) with ESMTPSA id 51523A0070;
        Mon, 25 Oct 2021 23:35:06 +0000 (UTC)
Received: by te-lab16-v2 (sSMTP sendmail emulation); Mon, 25 Oct 2021 16:35:06 -0700
Date:   Mon, 25 Oct 2021 16:35:06 -0700
Message-Id: <05b4a5fbfbd0863fc9b1d7af934a366219e3d0b4.1635204761.git.Thinh.Nguyen@synopsys.com>
X-SNPS-Relay: synopsys.com
From:   Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH] usb: dwc3: gadget: Check for L1/L2/U3 for Start Transfer
To:     Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org
Cc:     John Youn <John.Youn@synopsys.com>,
        Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        <stable@vger.kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The programming guide noted that the driver needs to verify if the link
state is in U0 before executing the Start Transfer command. If it's not
in U0, the driver needs to perform remote wakeup. This is not accurate.
If the link state is in U1/U2, then the controller will not respond to
link recovery request from DCTL.ULSTCHNGREQ. The Start Transfer command
will trigger a link recovery if it is in U1/U2. A clarification will be
added to the programming guide for all controller versions.

The current implementation shouldn't cause any functional issue. It may
occasionally report an invalid time out warning from failed link
recovery request. The driver will still go ahead with the Start Transfer
command if the remote wakeup fails. The new change only initiates remote
wakeup where it is needed, which is when the link state is in L1/L2/U3.

Cc: <stable@vger.kernel.org>
Fixes: c36d8e947a56 ("usb: dwc3: gadget: put link to U0 before Start Transfer")
Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
---
 drivers/usb/dwc3/gadget.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index 23de2a5a40d6..e259198aa241 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -310,13 +310,24 @@ int dwc3_send_gadget_ep_cmd(struct dwc3_ep *dep, unsigned int cmd,
 	if (DWC3_DEPCMD_CMD(cmd) == DWC3_DEPCMD_STARTTRANSFER) {
 		int link_state;
 
+		/*
+		 * Initiate remote wakeup if the link state is in U3 when
+		 * operating in SS/SSP or L1/L2 when operating in HS/FS. If the
+		 * link state is in U1/U2, no remote wakeup is needed. The Start
+		 * Transfer command will initiate the link recovery.
+		 */
 		link_state = dwc3_gadget_get_link_state(dwc);
-		if (link_state == DWC3_LINK_STATE_U1 ||
-		    link_state == DWC3_LINK_STATE_U2 ||
-		    link_state == DWC3_LINK_STATE_U3) {
+		switch (link_state) {
+		case DWC3_LINK_STATE_U2:
+			if (dwc->gadget->speed >= USB_SPEED_SUPER)
+				break;
+
+			fallthrough;
+		case DWC3_LINK_STATE_U3:
 			ret = __dwc3_gadget_wakeup(dwc);
 			dev_WARN_ONCE(dwc->dev, ret, "wakeup failed --> %d\n",
 					ret);
+			break;
 		}
 	}
 

base-commit: e8d6336d9d7198013a7b307107908242a7a53b23
-- 
2.28.0

