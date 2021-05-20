Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C22038A32E
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 11:49:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233999AbhETJuG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 05:50:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:47342 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233433AbhETJr6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 05:47:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A15EE613F9;
        Thu, 20 May 2021 09:34:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621503270;
        bh=3GvK6IdFfpr0M4VNNzbYiiMkr/Q/DR3Xvlrb7qN4ivE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t0jA5mEV97Wov3XfEvPpkAxhYnl3cWbErLCVtngO0jQKdsjeQkXlPOoxEbcx/iSJm
         o15yzSGhwq2oXIuHb4kNwZe/LtUJ3Ga+vo1IXCaFWbPoNhKrzqzpugqxjSwDJj0bP2
         N5OcQyTBbxhxxn4uOg5jenrqhtpS3m8ie4upV53c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Minas Harutyunyan <Minas.Harutyunyan@synopsys.com>,
        Artur Petrosyan <Arthur.Petrosyan@synopsys.com>
Subject: [PATCH 4.19 111/425] usb: dwc2: Fix session request interrupt handler
Date:   Thu, 20 May 2021 11:18:00 +0200
Message-Id: <20210520092135.097811695@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092131.308959589@linuxfoundation.org>
References: <20210520092131.308959589@linuxfoundation.org>
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
@@ -312,6 +312,7 @@ static void dwc2_handle_conn_id_status_c
 static void dwc2_handle_session_req_intr(struct dwc2_hsotg *hsotg)
 {
 	int ret;
+	u32 hprt0;
 
 	/* Clear interrupt */
 	dwc2_writel(hsotg, GINTSTS_SESSREQINT, GINTSTS);
@@ -332,6 +333,13 @@ static void dwc2_handle_session_req_intr
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
 


