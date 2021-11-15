Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E288450EF6
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 19:22:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241569AbhKOSWz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 13:22:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:58650 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241314AbhKOSTZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:19:25 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2335F63263;
        Mon, 15 Nov 2021 17:51:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636998691;
        bh=VHv/jATYzon7aBwA0JSFUaRtQnEp0JWl/hUXN5QxjFM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1Z9EWcB6eBgjRqP+CTKpQtPyI6Q48IjL0rzFfdJ+bEXjqBUehcNoM3oTFOrNrqVFS
         nFucL/TUpGgtddiIwFpNPWUFiZDTVet2WQiVvK4DQ3skbNYLHNaYJO6t+aOjYvZrpU
         5m9nEN2LQdJpKsdY+R6Xl48Tc3VOMY4qSndst2zU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bryan Pass <bryan.pass@gmail.com>,
        Sean Young <sean@mess.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 5.14 025/849] media: ite-cir: IR receiver stop working after receive overflow
Date:   Mon, 15 Nov 2021 17:51:48 +0100
Message-Id: <20211115165420.846613229@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
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
@@ -242,7 +242,7 @@ static irqreturn_t ite_cir_isr(int irq,
 	}
 
 	/* check for the receive interrupt */
-	if (iflags & ITE_IRQ_RX_FIFO) {
+	if (iflags & (ITE_IRQ_RX_FIFO | ITE_IRQ_RX_FIFO_OVERRUN)) {
 		/* read the FIFO bytes */
 		rx_bytes = dev->params->get_rx_bytes(dev, rx_buf,
 						    ITE_RX_FIFO_LEN);


