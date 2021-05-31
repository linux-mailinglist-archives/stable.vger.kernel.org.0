Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D537B395D3C
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 15:41:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232132AbhEaNnQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 09:43:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:44088 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232624AbhEaNlJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 09:41:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8EA6661460;
        Mon, 31 May 2021 13:27:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622467675;
        bh=k5A3H3REnK5KkvSyWYlgxwEuPJD3vdtkKgliojMJyjY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H3byL2bpDOC8Z/QWwFGohYVhswz1FhmfM56+wYn4vga8X1/rb7P0VQSExyI56DpkL
         E/AIUoPWCnvmVKcOUPDCBZyZD3BFQVApiP5fOqpiBmlPqTp7+Cg0u7agb2y1YsOPO9
         dn0DLPHoIRj5tnFut6q5u2NxZkHOHy3gYZViDZjg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Felipe Balbi <balbi@kernel.org>,
        Jack Pham <jackp@codeaurora.org>
Subject: [PATCH 4.14 04/79] usb: dwc3: gadget: Enable suspend events
Date:   Mon, 31 May 2021 15:13:49 +0200
Message-Id: <20210531130636.143877931@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130636.002722319@linuxfoundation.org>
References: <20210531130636.002722319@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jack Pham <jackp@codeaurora.org>

commit d1d90dd27254c44d087ad3f8b5b3e4fff0571f45 upstream.

commit 72704f876f50 ("dwc3: gadget: Implement the suspend entry event
handler") introduced (nearly 5 years ago!) an interrupt handler for
U3/L1-L2 suspend events.  The problem is that these events aren't
currently enabled in the DEVTEN register so the handler is never
even invoked.  Fix this simply by enabling the corresponding bit
in dwc3_gadget_enable_irq() using the same revision check as found
in the handler.

Fixes: 72704f876f50 ("dwc3: gadget: Implement the suspend entry event handler")
Acked-by: Felipe Balbi <balbi@kernel.org>
Signed-off-by: Jack Pham <jackp@codeaurora.org>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210428090111.3370-1-jackp@codeaurora.org
[jackp@codeaurora.org: backport to pre-5.7 by replacing
 DWC3_IS_VER_PRIOR check with direct comparison of dwc->revision]
Signed-off-by: Jack Pham <jackp@codeaurora.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/gadget.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -1829,6 +1829,10 @@ static void dwc3_gadget_enable_irq(struc
 	if (dwc->revision < DWC3_REVISION_250A)
 		reg |= DWC3_DEVTEN_ULSTCNGEN;
 
+	/* On 2.30a and above this bit enables U3/L2-L1 Suspend Events */
+	if (dwc->revision >= DWC3_REVISION_230A)
+		reg |= DWC3_DEVTEN_EOPFEN;
+
 	dwc3_writel(dwc->regs, DWC3_DEVTEN, reg);
 }
 


