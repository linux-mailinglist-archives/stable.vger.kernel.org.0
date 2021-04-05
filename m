Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E24B353F5C
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 12:35:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238972AbhDEJLv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 05:11:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:58708 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238546AbhDEJLt (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Apr 2021 05:11:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8D33A61393;
        Mon,  5 Apr 2021 09:11:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617613893;
        bh=JurLy8cBkPqWxyUaJ/ITh8W4P04f2WYbLfYuj6QDTHE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=naHhgLKpie3YL4l3Bvq4ZfOqrEkdw43de4f60Pd8ybdiESOWr3qWXEpYExphqOj9J
         YNesQE7jciJsl8fEya6VgBVj7Xs2WSfA8MJ2G9UwJl/PcozXV2bevi9fObN9dyTpvA
         /GSbZvkkAWFLTZbj5Uk6ckqSysf0fu47ktkB5b/M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Wesley Cheng <wcheng@codeaurora.org>,
        Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: [PATCH 5.10 118/126] usb: dwc3: gadget: Clear DEP flags after stop transfers in ep disable
Date:   Mon,  5 Apr 2021 10:54:40 +0200
Message-Id: <20210405085034.943960818@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210405085031.040238881@linuxfoundation.org>
References: <20210405085031.040238881@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wesley Cheng <wcheng@codeaurora.org>

commit 5aef629704ad4d983ecf5c8a25840f16e45b6d59 upstream.

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
@@ -791,10 +791,6 @@ static int __dwc3_gadget_ep_disable(stru
 	reg &= ~DWC3_DALEPENA_EP(dep->number);
 	dwc3_writel(dwc->regs, DWC3_DALEPENA, reg);
 
-	dep->stream_capable = false;
-	dep->type = 0;
-	dep->flags = 0;
-
 	/* Clear out the ep descriptors for non-ep0 */
 	if (dep->number > 1) {
 		dep->endpoint.comp_desc = NULL;
@@ -803,6 +799,10 @@ static int __dwc3_gadget_ep_disable(stru
 
 	dwc3_remove_requests(dwc, dep);
 
+	dep->stream_capable = false;
+	dep->type = 0;
+	dep->flags = 0;
+
 	return 0;
 }
 


