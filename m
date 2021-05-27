Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A53323931FB
	for <lists+stable@lfdr.de>; Thu, 27 May 2021 17:13:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236747AbhE0POn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 May 2021 11:14:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:43170 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236899AbhE0POk (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 May 2021 11:14:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D1EAE61358;
        Thu, 27 May 2021 15:13:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622128385;
        bh=PGSDWSy5zTruX9mD8xCw9OZ6XVWP6IV6zXvmckvGE9Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NTnJUVGDcj3JOesxhRlt2vrNmgnvZBjIcj9DVjnQMRFkdYoTrURHqE0Q+wV+z+sr7
         jT6KkslFTdEZx5h7FCKmy0aGfc8p+8vDJ300Wm8U0Sp/zejRoyIiGoqbDYWUTlHuYI
         DqrQcJDxA3oTRKfnloZd7nG3wwZ7ZBZ7L6+c5/kk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Felipe Balbi <balbi@kernel.org>,
        Jack Pham <jackp@codeaurora.org>
Subject: [PATCH 5.4 4/7] usb: dwc3: gadget: Enable suspend events
Date:   Thu, 27 May 2021 17:12:46 +0200
Message-Id: <20210527151139.361919991@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210527151139.224619013@linuxfoundation.org>
References: <20210527151139.224619013@linuxfoundation.org>
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
@@ -2022,6 +2022,10 @@ static void dwc3_gadget_enable_irq(struc
 	if (dwc->revision < DWC3_REVISION_250A)
 		reg |= DWC3_DEVTEN_ULSTCNGEN;
 
+	/* On 2.30a and above this bit enables U3/L2-L1 Suspend Events */
+	if (dwc->revision >= DWC3_REVISION_230A)
+		reg |= DWC3_DEVTEN_EOPFEN;
+
 	dwc3_writel(dwc->regs, DWC3_DEVTEN, reg);
 }
 


