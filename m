Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 45C80F7E69
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 20:03:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729816AbfKKSpM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 13:45:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:37152 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729782AbfKKSpL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 13:45:11 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E9BF8204FD;
        Mon, 11 Nov 2019 18:45:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573497910;
        bh=SgrOoM6A5+kz3s7SG/YnqFYB1nGb7q9cFugrwjUOeqM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HG7czOdlMPsAGtBk9vqWknGnvTLdyaYtciSGv5tPVm1T31MfzqJ+YBGnBbKlyCj07
         WX+bc4gemR9g+xDPVlj9KJCBn2wbicmlw6+wBROEjluY1q5VacQmyQGtcsog1aSeBi
         GBUml/P5B0NbffksG6p844YB5X9QDR9fZ+xfEaGQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yinbo Zhu <yinbo.zhu@nxp.com>,
        Felipe Balbi <felipe.balbi@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 094/125] usb: dwc3: remove the call trace of USBx_GFLADJ
Date:   Mon, 11 Nov 2019 19:28:53 +0100
Message-Id: <20191111181452.414812119@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191111181438.945353076@linuxfoundation.org>
References: <20191111181438.945353076@linuxfoundation.org>
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
index 05b9ccff7447a..aca7e7fa5e47d 100644
--- a/drivers/usb/dwc3/core.c
+++ b/drivers/usb/dwc3/core.c
@@ -299,8 +299,7 @@ static void dwc3_frame_length_adjustment(struct dwc3 *dwc)
 
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



