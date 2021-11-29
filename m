Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78382461E30
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 19:30:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377849AbhK2Sdn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 13:33:43 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:50790 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350491AbhK2Sbj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 13:31:39 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id CAC84CE13F9;
        Mon, 29 Nov 2021 18:28:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75629C53FAD;
        Mon, 29 Nov 2021 18:28:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638210498;
        bh=CctDmUDtPYBvIs6XJg3akBXJ5RnL5ij5joMJudApFq4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T1MTC9afLte7DPd9M+LZLdV4iMtc5baNEY86f21bQfrpVHqhm24SHTvIl3OJQ7jP+
         VJXtUhLx6ifFnyWDJi2+lOfJhkU+Ola3tMgWfthWGcx1CTUtKzN3fxKUgwVin7RTvb
         HOSF+xKksGJzAfN+a/UAK0GMNSLwosSsoCSOryF4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 5.10 008/121] usb: dwc3: gadget: Check for L1/L2/U3 for Start Transfer
Date:   Mon, 29 Nov 2021 19:17:19 +0100
Message-Id: <20211129181711.922740074@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181711.642046348@linuxfoundation.org>
References: <20211129181711.642046348@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thinh Nguyen <Thinh.Nguyen@synopsys.com>

commit 63c4c320ccf77074ffe9019ac596603133c1b517 upstream.

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

Fixes: c36d8e947a56 ("usb: dwc3: gadget: put link to U0 before Start Transfer")
Cc: <stable@vger.kernel.org>
Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Link: https://lore.kernel.org/r/05b4a5fbfbd0863fc9b1d7af934a366219e3d0b4.1635204761.git.Thinh.Nguyen@synopsys.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/gadget.c |   17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -310,13 +310,24 @@ int dwc3_send_gadget_ep_cmd(struct dwc3_
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
 


