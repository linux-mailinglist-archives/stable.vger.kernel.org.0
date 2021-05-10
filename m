Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1D03378923
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:50:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238197AbhEJLZt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:25:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:55988 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238076AbhEJLRA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 07:17:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7DE5A60FEF;
        Mon, 10 May 2021 11:12:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620645144;
        bh=3Ufg7xo03ya1yrgPAz1RlfrVuRck0My3z2pCiLPXPmo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M0mrlsNjtvuZoGUY7OIHcTr1J4/V/a101wT4gGdvtkbrHNL7ODZbrZPDSehxIWH8M
         jUXjfyCOm78n082MCPkMur/ciW9Ykb5FOghAeoVzzB+QBayETG+42alhKvaR7Mhi+T
         GSRRfWbi2HLeRmz3d4t6D6oHVUARyLNVnFRm5YE8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Minas Harutyunyan <Minas.Harutyunyan@synopsys.com>,
        Artur Petrosyan <Arthur.Petrosyan@synopsys.com>
Subject: [PATCH 5.12 369/384] usb: dwc2: Fix session request interrupt handler
Date:   Mon, 10 May 2021 12:22:38 +0200
Message-Id: <20210510102026.933753736@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102014.849075526@linuxfoundation.org>
References: <20210510102014.849075526@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Artur Petrosyan <Arthur.Petrosyan@synopsys.com>

commit 42b32b164acecd850edef010915a02418345a033 upstream.

According to programming guide in host mode, port
power must be turned on in session request
interrupt handlers.

Fixes: 21795c826a45 ("usb: dwc2: exit hibernation on session request")
Cc: <stable@vger.kernel.org>
Acked-by: Minas Harutyunyan <Minas.Harutyunyan@synopsys.com>
Signed-off-by: Artur Petrosyan <Arthur.Petrosyan@synopsys.com>
Link: https://lore.kernel.org/r/20210408094550.75484A0094@mailhost.synopsys.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc2/core_intr.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/usb/dwc2/core_intr.c
+++ b/drivers/usb/dwc2/core_intr.c
@@ -307,6 +307,7 @@ static void dwc2_handle_conn_id_status_c
 static void dwc2_handle_session_req_intr(struct dwc2_hsotg *hsotg)
 {
 	int ret;
+	u32 hprt0;
 
 	/* Clear interrupt */
 	dwc2_writel(hsotg, GINTSTS_SESSREQINT, GINTSTS);
@@ -327,6 +328,13 @@ static void dwc2_handle_session_req_intr
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
 


