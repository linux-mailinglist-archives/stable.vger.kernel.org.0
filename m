Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAC78383256
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 16:49:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241136AbhEQOrE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 10:47:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:54268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240230AbhEQOlU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 10:41:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D6BA261221;
        Mon, 17 May 2021 14:19:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621261148;
        bh=0vrsYNOIc8zESrOuuzbh1miucDaaw9MeoIfhsBJVRTU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W3vK8vqryfNsKVmizM48/MbCctN5qRLOAuBV2r+cXNRY0JbFFWha8bYgsf/i2sMm/
         wlFlGEdhraM37pWMOJlUEtJD/YdcRzs1kA6NugcuqAXIAhJfNFuH8r1fjqiKz9gZed
         FsUo4gQUkoacN/bF4gJoZjCkrzLO5aDO1RzAMj0A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Felipe Balbi <balbi@kernel.org>,
        Jack Pham <jackp@codeaurora.org>
Subject: [PATCH 5.12 314/363] usb: dwc3: gadget: Enable suspend events
Date:   Mon, 17 May 2021 16:03:00 +0200
Message-Id: <20210517140313.227715572@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140302.508966430@linuxfoundation.org>
References: <20210517140302.508966430@linuxfoundation.org>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/gadget.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -2302,6 +2302,10 @@ static void dwc3_gadget_enable_irq(struc
 	if (DWC3_VER_IS_PRIOR(DWC3, 250A))
 		reg |= DWC3_DEVTEN_ULSTCNGEN;
 
+	/* On 2.30a and above this bit enables U3/L2-L1 Suspend Events */
+	if (!DWC3_VER_IS_PRIOR(DWC3, 230A))
+		reg |= DWC3_DEVTEN_EOPFEN;
+
 	dwc3_writel(dwc->regs, DWC3_DEVTEN, reg);
 }
 


