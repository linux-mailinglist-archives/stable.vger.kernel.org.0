Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D72D3EB8BC
	for <lists+stable@lfdr.de>; Fri, 13 Aug 2021 17:26:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242760AbhHMPQD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Aug 2021 11:16:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:55722 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242645AbhHMPOd (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Aug 2021 11:14:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BF825610FF;
        Fri, 13 Aug 2021 15:14:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628867642;
        bh=1wJ0zb7O8wyMT9RiAhV7Tt8m5ChXhbRXWIJiwTth6Rk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yqGCK1TVMOZuFxWa/RC/WUT+6u8ZL2KYe1t+LdD9j+pJdI5o4m8wWqSs1Tz9X4j9F
         ojyZGNpr1MNlHuARZ8XYWgLBa+xefqwH7EqPKRHCrYtBOK7kyKc1TPbtAdeVST+WLy
         QjLza4PScpUsC13N4M4jzg9R+y9Rq8rdwyo68ULg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "stable@vger.kernel.org, Wesley Cheng" <wcheng@codeaurora.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Wesley Cheng <wcheng@codeaurora.org>
Subject: [PATCH 5.4 09/27] usb: dwc3: gadget: Clear DEP flags after stop transfers in ep disable
Date:   Fri, 13 Aug 2021 17:07:07 +0200
Message-Id: <20210813150523.674268668@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210813150523.364549385@linuxfoundation.org>
References: <20210813150523.364549385@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wesley Cheng <wcheng@codeaurora.org>

[ Upstream commit 5aef629704ad4d983ecf5c8a25840f16e45b6d59 ]

Ensure that dep->flags are cleared until after stop active transfers
is completed.  Otherwise, the ENDXFER command will not be executed
during ep disable.

Fixes: f09ddcfcb8c5 ("usb: dwc3: gadget: Prevent EP queuing while stopping transfers")
Cc: stable <stable@vger.kernel.org>
Reported-and-tested-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Wesley Cheng <wcheng@codeaurora.org>
Link: https://lore.kernel.org/r/1616610664-16495-1-git-send-email-wcheng@codeaurora.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/gadget.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -754,10 +754,6 @@ static int __dwc3_gadget_ep_disable(stru
 	reg &= ~DWC3_DALEPENA_EP(dep->number);
 	dwc3_writel(dwc->regs, DWC3_DALEPENA, reg);
 
-	dep->stream_capable = false;
-	dep->type = 0;
-	dep->flags = 0;
-
 	/* Clear out the ep descriptors for non-ep0 */
 	if (dep->number > 1) {
 		dep->endpoint.comp_desc = NULL;
@@ -766,6 +762,10 @@ static int __dwc3_gadget_ep_disable(stru
 
 	dwc3_remove_requests(dwc, dep);
 
+	dep->stream_capable = false;
+	dep->type = 0;
+	dep->flags = 0;
+
 	return 0;
 }
 


