Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D76A3837FE
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 17:47:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244559AbhEQPsN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 11:48:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:35078 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344957AbhEQPqJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 11:46:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B41D061428;
        Mon, 17 May 2021 14:44:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621262648;
        bh=j10Tu3XCs6O+GEPElE0P5RSfy4Ez9e4IVLaC2L3GgCI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DdkgSUdQHcHZo1BXq6A5BDKEupAyguMErH5jn7APSviDzz61FgEcfjO08sTdkGaVG
         HAaRrOS+pFJ4CBNfy/h5CVjpf4lsgKuTsn0hWQJDfIp1pQUtSNfL3RhbaQaXkmLRBO
         aWNICzVCzsnxakW1VA1rh9Bw2/ycExzrPLU6GQOI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Felipe Balbi <balbi@kernel.org>,
        Jack Pham <jackp@codeaurora.org>
Subject: [PATCH 5.10 245/289] usb: dwc3: gadget: Enable suspend events
Date:   Mon, 17 May 2021 16:02:50 +0200
Message-Id: <20210517140313.397506831@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140305.140529752@linuxfoundation.org>
References: <20210517140305.140529752@linuxfoundation.org>
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
@@ -2206,6 +2206,10 @@ static void dwc3_gadget_enable_irq(struc
 	if (DWC3_VER_IS_PRIOR(DWC3, 250A))
 		reg |= DWC3_DEVTEN_ULSTCNGEN;
 
+	/* On 2.30a and above this bit enables U3/L2-L1 Suspend Events */
+	if (!DWC3_VER_IS_PRIOR(DWC3, 230A))
+		reg |= DWC3_DEVTEN_EOPFEN;
+
 	dwc3_writel(dwc->regs, DWC3_DEVTEN, reg);
 }
 


