Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AA9338A6AB
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 12:28:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235814AbhETK3p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 06:29:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:55676 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236724AbhETK1k (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 06:27:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 19F13613AC;
        Thu, 20 May 2021 09:50:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621504237;
        bh=kDGiedMBDc8If3gZIPwzG/k6SJ8Q5Rpp8/C+ken0mUM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T4NLTugy0ThrYLSLSQxpZ2s1+8wN15PC1jMF76FZQCc72wnKkb1lsvvIQ8YwiEibR
         SAAZALglyyTGcmoADEF7j8zIvkZ/0mss80ZGhE3CDR5P8faCLHwjB4TFcXK0aHSN80
         STrE+jnrglCPkPA13ATeRyl7Fht3luHLmZQTXA0k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Fabian Vogt <fabian@ritter-vogt.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 154/323] fotg210-udc: Mask GRP2 interrupts we dont handle
Date:   Thu, 20 May 2021 11:20:46 +0200
Message-Id: <20210520092125.382397382@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092120.115153432@linuxfoundation.org>
References: <20210520092120.115153432@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fabian Vogt <fabian@ritter-vogt.de>

[ Upstream commit 9aee3a23d6455200702f3a57e731fa11e8408667 ]

Currently it leaves unhandled interrupts unmasked, but those are never
acked. In the case of a "device idle" interrupt, this leads to an
effectively frozen system until plugging it in.

Fixes: b84a8dee23fd ("usb: gadget: add Faraday fotg210_udc driver")
Signed-off-by: Fabian Vogt <fabian@ritter-vogt.de>
Link: https://lore.kernel.org/r/20210324141115.9384-5-fabian@ritter-vogt.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/udc/fotg210-udc.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/usb/gadget/udc/fotg210-udc.c b/drivers/usb/gadget/udc/fotg210-udc.c
index dcdf92415064..d25cf5d44121 100644
--- a/drivers/usb/gadget/udc/fotg210-udc.c
+++ b/drivers/usb/gadget/udc/fotg210-udc.c
@@ -1033,6 +1033,12 @@ static void fotg210_init(struct fotg210_udc *fotg210)
 	value &= ~DMCR_GLINT_EN;
 	iowrite32(value, fotg210->reg + FOTG210_DMCR);
 
+	/* enable only grp2 irqs we handle */
+	iowrite32(~(DISGR2_DMA_ERROR | DISGR2_RX0BYTE_INT | DISGR2_TX0BYTE_INT
+		    | DISGR2_ISO_SEQ_ABORT_INT | DISGR2_ISO_SEQ_ERR_INT
+		    | DISGR2_RESM_INT | DISGR2_SUSP_INT | DISGR2_USBRST_INT),
+		  fotg210->reg + FOTG210_DMISGR2);
+
 	/* disable all fifo interrupt */
 	iowrite32(~(u32)0, fotg210->reg + FOTG210_DMISGR1);
 
-- 
2.30.2



