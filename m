Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A54DF7BCA
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 19:40:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728735AbfKKSjx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 13:39:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:58954 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729177AbfKKSjw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 13:39:52 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E5BA221655;
        Mon, 11 Nov 2019 18:39:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573497591;
        bh=3NBsUnB2jvtB3ZFBdUQ15Z1mIQDFnP6GAfPPNfWIal0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tFoIqR9/ybsxV08AGJiml/SD6JjQly0Ob2Roce1gIRir+bN+ntVoSclwgKlG7IgLP
         H1/JAADdCKvNXr0IyLCjRJ+w6YfQJplt4+YWzu6bvnmk99rgRg4NA/ZYtCjUYSGljS
         c6DGeXqqabPtyjpRRn98O1Q8NViSBVXC4/JN6gYk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yinbo Zhu <yinbo.zhu@nxp.com>,
        Felipe Balbi <felipe.balbi@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 086/105] usb: dwc3: remove the call trace of USBx_GFLADJ
Date:   Mon, 11 Nov 2019 19:28:56 +0100
Message-Id: <20191111181447.430945033@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191111181421.390326245@linuxfoundation.org>
References: <20191111181421.390326245@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yinbo Zhu <yinbo.zhu@nxp.com>

[ Upstream commit a7d9874c6f3fbc8d25cd9ceba35b6822612c4ebf ]

layerscape board sometimes reported some usb call trace, that is due to
kernel sent LPM tokerns automatically when it has no pending transfers
and think that the link is idle enough to enter L1, which procedure will
ask usb register has a recovery,then kernel will compare USBx_GFLADJ and
set GFLADJ_30MHZ, GFLADJ_30MHZ_REG until GFLADJ_30MHZ is equal 0x20, if
the conditions were met then issue occur, but whatever the conditions
whether were met that usb is all need keep GFLADJ_30MHZ of value is 0x20
(xhci spec ask use GFLADJ_30MHZ to adjust any offset from clock source
that generates the clock that drives the SOF counter, 0x20 is default
value of it)That is normal logic, so need remove the call trace.

Signed-off-by: Yinbo Zhu <yinbo.zhu@nxp.com>
Signed-off-by: Felipe Balbi <felipe.balbi@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/dwc3/core.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/usb/dwc3/core.c b/drivers/usb/dwc3/core.c
index 9b093978bd24d..48755c501201d 100644
--- a/drivers/usb/dwc3/core.c
+++ b/drivers/usb/dwc3/core.c
@@ -282,8 +282,7 @@ static void dwc3_frame_length_adjustment(struct dwc3 *dwc)
 
 	reg = dwc3_readl(dwc->regs, DWC3_GFLADJ);
 	dft = reg & DWC3_GFLADJ_30MHZ_MASK;
-	if (!dev_WARN_ONCE(dwc->dev, dft == dwc->fladj,
-	    "request value same as default, ignoring\n")) {
+	if (dft != dwc->fladj) {
 		reg &= ~DWC3_GFLADJ_30MHZ_MASK;
 		reg |= DWC3_GFLADJ_30MHZ_SDBND_SEL | dwc->fladj;
 		dwc3_writel(dwc->regs, DWC3_GFLADJ, reg);
-- 
2.20.1



