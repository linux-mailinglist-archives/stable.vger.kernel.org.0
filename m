Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 292FC357FB7
	for <lists+stable@lfdr.de>; Thu,  8 Apr 2021 11:46:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231509AbhDHJqF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Apr 2021 05:46:05 -0400
Received: from smtprelay-out1.synopsys.com ([149.117.87.133]:36630 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231500AbhDHJqF (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 8 Apr 2021 05:46:05 -0400
Received: from mailhost.synopsys.com (mdc-mailhost2.synopsys.com [10.225.0.210])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 1ADDAC09B1;
        Thu,  8 Apr 2021 09:45:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1617875154; bh=xhxpjgTpa9pFuo9pJIVEGylg0epbNh6oZH7CA1L2gdc=;
        h=Date:In-Reply-To:References:From:Subject:To:Cc:From;
        b=XwhmdZ+cHK82HfuPZpbrVajJB7gaG6sEgI5MkcbfqwFCEGwcoWENtex6/3WTza2bL
         zGXWzWm3Z/e+z1+iLCP9YIsxGhL0RjIRyLqxRZFOzL+q5kvgTEdRPsatidjBv51Gj9
         /stm0yw6iBRoAY8BqjW7yiBOsQu6YwfL4HTXndPXIm7cZhRzKhV6zXNexkb9EIgl9G
         TQYoVQFWUnmlR4Rg/91qqkkfvf0qhL/7I4tJn+slSTZDZxRKGobOa0xgzj6dzKMNyz
         HjTkHdJhHcwCrnBG/QS7Urv4L8nqvk2gTUyx5GZDCSzhu/8u2dA/jmvRkW/RtbsnXY
         icPLptyHBDV3w==
Received: from razpc-HP (razpc-hp.internal.synopsys.com [10.116.126.207])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPSA id 75484A0094;
        Thu,  8 Apr 2021 09:45:50 +0000 (UTC)
Received: by razpc-HP (sSMTP sendmail emulation); Thu, 08 Apr 2021 13:45:49 +0400
Date:   Thu, 08 Apr 2021 13:45:49 +0400
In-Reply-To: <cover.1617782102.git.Arthur.Petrosyan@synopsys.com>
References: <cover.1617782102.git.Arthur.Petrosyan@synopsys.com>
X-SNPS-Relay: synopsys.com
From:   Artur Petrosyan <Arthur.Petrosyan@synopsys.com>
Subject: [PATCH v3 11/14] usb: dwc2: Fix session request interrupt handler
To:     John Youn <John.Youn@synopsys.com>,
        Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Minas Harutyunyan <Minas.Harutyunyan@synopsys.com>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mian Yousaf Kaukab <yousaf.kaukab@intel.com>,
        Gregory Herrero <gregory.herrero@intel.com>
Cc:     Artur Petrosyan <Arthur.Petrosyan@synopsys.com>,
        Minas Harutyunyan <Minas.Harutyunyan@synopsys.com>,
        <stable@vger.kernel.org>, Robert Baldyga <r.baldyga@samsung.com>
Message-Id: <20210408094550.75484A0094@mailhost.synopsys.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

According to programming guide in host mode, port
power must be turned on in session request
interrupt handlers.

Cc: <stable@vger.kernel.org>
Fixes: 21795c826a45 ("usb: dwc2: exit hibernation on session request")
Signed-off-by: Artur Petrosyan <Arthur.Petrosyan@synopsys.com>
Acked-by: Minas Harutyunyan <Minas.Harutyunyan@synopsys.com>
---
 drivers/usb/dwc2/core_intr.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/usb/dwc2/core_intr.c b/drivers/usb/dwc2/core_intr.c
index 0a7f9330907f..8c0152b514be 100644
--- a/drivers/usb/dwc2/core_intr.c
+++ b/drivers/usb/dwc2/core_intr.c
@@ -307,6 +307,7 @@ static void dwc2_handle_conn_id_status_change_intr(struct dwc2_hsotg *hsotg)
 static void dwc2_handle_session_req_intr(struct dwc2_hsotg *hsotg)
 {
 	int ret;
+	u32 hprt0;
 
 	/* Clear interrupt */
 	dwc2_writel(hsotg, GINTSTS_SESSREQINT, GINTSTS);
@@ -328,6 +329,13 @@ static void dwc2_handle_session_req_intr(struct dwc2_hsotg *hsotg)
 		 * established
 		 */
 		dwc2_hsotg_disconnect(hsotg);
+	} else {
+		/* Turn on the port power bit. */
+		hprt0 = dwc2_read_hprt0(hsotg);
+		hprt0 |= HPRT0_PWR;
+		dwc2_writel(hsotg, hprt0, HPRT0);
+		/* Connect hcd after port power is set. */
+		dwc2_hcd_connect(hsotg);
 	}
 }
 
-- 
2.25.1

