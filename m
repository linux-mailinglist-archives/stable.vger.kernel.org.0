Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59EBD450C6F
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 18:35:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238212AbhKORir (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 12:38:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:50930 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237926AbhKORhP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 12:37:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2CA37632D5;
        Mon, 15 Nov 2021 17:24:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636997094;
        bh=gbFNswM4XxDHV0nCtFOABSphPr8MmghwTuyMXuO7gUQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aLspxObvEFyUhGXNsYW74Dnkp8v4FHRv2uSom9WGPL2ojlSmyRLiJLAthXwTzcViu
         nF28uUIiC0wHHh0CRejvDP26jRFtlqeObst1lPFxojQPoBUNBY+fafg8ottFrvVKn6
         n387fDEsUBU47FXoZYfu7E9zpsM2LYxAerxY8B+I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bryan Pass <bryan.pass@gmail.com>,
        Sean Young <sean@mess.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 5.10 023/575] media: ite-cir: IR receiver stop working after receive overflow
Date:   Mon, 15 Nov 2021 17:55:48 +0100
Message-Id: <20211115165344.419074774@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165343.579890274@linuxfoundation.org>
References: <20211115165343.579890274@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Young <sean@mess.org>

commit fdc881783099c6343921ff017450831c8766d12a upstream.

On an Intel NUC6iSYK, no IR is reported after a receive overflow.

When a receiver overflow occurs, this condition is only cleared by
reading the fifo. Make sure we read anything in the fifo.

Fixes: 28c7afb07ccf ("media: ite-cir: check for receive overflow")
Suggested-by: Bryan Pass <bryan.pass@gmail.com>
Tested-by: Bryan Pass <bryan.pass@gmail.com>
Cc: stable@vger.kernel.org>
Signed-off-by: Sean Young <sean@mess.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/rc/ite-cir.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/media/rc/ite-cir.c
+++ b/drivers/media/rc/ite-cir.c
@@ -283,7 +283,7 @@ static irqreturn_t ite_cir_isr(int irq,
 	}
 
 	/* check for the receive interrupt */
-	if (iflags & ITE_IRQ_RX_FIFO) {
+	if (iflags & (ITE_IRQ_RX_FIFO | ITE_IRQ_RX_FIFO_OVERRUN)) {
 		/* read the FIFO bytes */
 		rx_bytes =
 			dev->params.get_rx_bytes(dev, rx_buf,


