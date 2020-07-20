Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB18E226694
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:04:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732627AbgGTQEY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 12:04:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:39212 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732834AbgGTQEX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 12:04:23 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4292A2064B;
        Mon, 20 Jul 2020 16:04:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595261062;
        bh=brtp9yHjy3ziQVxTsjjgYfS8uVlOTxN4qyMt/fPozVw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DOrIA4Z6uEULndJDGR7KYV+ajywV9gZUXslF3OMucS+5kzXyxVFrvFLX0rE+v7zvB
         GeuyIlp6u9I9FWCHB77V8em2M8Ih2EvwpfIpzcxV7+U6GFbIQIDFXmDvINATybiY8m
         OMrTybk/fvKFK9LCw3Cyb/lEqdl9nfHrzemluYSI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Krzysztof Kozlowski <krzk@kernel.org>,
        Robin Gong <yibin.gong@nxp.com>, Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 5.4 194/215] dmaengine: mcf-edma: Fix NULL pointer exception in mcf_edma_tx_handler
Date:   Mon, 20 Jul 2020 17:37:56 +0200
Message-Id: <20200720152829.412085710@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152820.122442056@linuxfoundation.org>
References: <20200720152820.122442056@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Krzysztof Kozlowski <krzk@kernel.org>

commit 8995aa3d164ddd9200e6abcf25c449cf5298c858 upstream.

On Toradex Colibri VF50 (Vybrid VF5xx) with fsl-edma driver NULL pointer
exception happens occasionally on serial output initiated by login
timeout.

This was reproduced only if kernel was built with significant debugging
options and EDMA driver is used with serial console.

Issue looks like a race condition between interrupt handler
fsl_edma_tx_handler() (called as a result of fsl_edma_xfer_desc()) and
terminating the transfer with fsl_edma_terminate_all().

The fsl_edma_tx_handler() handles interrupt for a transfer with already
freed edesc and idle==true.

The mcf-edma driver shares design and lot of code with fsl-edma.  It
looks like being affected by same problem.  Fix this pattern the same
way as fix for fsl-edma driver.

Fixes: e7a3ff92eaf1 ("dmaengine: fsl-edma: add ColdFire mcf5441x edma support")
Cc: <stable@vger.kernel.org>
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Reviewed-by: Robin Gong <yibin.gong@nxp.com>
Link: https://lore.kernel.org/r/1591881665-25592-1-git-send-email-krzk@kernel.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/dma/mcf-edma.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/dma/mcf-edma.c
+++ b/drivers/dma/mcf-edma.c
@@ -35,6 +35,13 @@ static irqreturn_t mcf_edma_tx_handler(i
 			mcf_chan = &mcf_edma->chans[ch];
 
 			spin_lock(&mcf_chan->vchan.lock);
+
+			if (!mcf_chan->edesc) {
+				/* terminate_all called before */
+				spin_unlock(&mcf_chan->vchan.lock);
+				continue;
+			}
+
 			if (!mcf_chan->edesc->iscyclic) {
 				list_del(&mcf_chan->edesc->vdesc.node);
 				vchan_cookie_complete(&mcf_chan->edesc->vdesc);


