Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B165200F97
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 17:23:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392574AbgFSPTn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 11:19:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:46814 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403913AbgFSPQS (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:16:18 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6FFA5206DB;
        Fri, 19 Jun 2020 15:16:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592579778;
        bh=2HALglx0FG3o8HOaRDw3kpLZKN5CEh0HYtvhNQ4yCBU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fA6hOBMLe6pdpHlHKRfN07OQbx5IAhMXMXVFzCQE1Owr9nadaggpc5j1KzXTt3+uG
         NBZO9Wc+ueDzy8UHxy44N+1nAPp42GuH8OAz+85oyUGRAm8CwoWyIaprU8lkDsMc3D
         NRgPjqfLqUVKUDr0ubZsaGKO2Gu9XIlx8T3tzXrc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tony Lindgren <tony@atomide.com>,
        "H. Nikolaus Schaller" <hns@goldelico.com>
Subject: [PATCH 5.4 255/261] w1: omap-hdq: cleanup to add missing newline for some dev_dbg
Date:   Fri, 19 Jun 2020 16:34:26 +0200
Message-Id: <20200619141702.086136691@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141649.878808811@linuxfoundation.org>
References: <20200619141649.878808811@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: H. Nikolaus Schaller <hns@goldelico.com>

commit 5e02f3b31704e24537697bce54f8156bdb72b7a6 upstream.

Otherwise it will corrupt the console log during debugging.

Fixes: 7b5362a603a1 ("w1: omap_hdq: Fix some error/debug handling.")
Cc: stable@vger.kernel.org
Acked-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: H. Nikolaus Schaller <hns@goldelico.com>
Link: https://lore.kernel.org/r/cd0d55749a091214106575f6e1d363c6db56622f.1590255176.git.hns@goldelico.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/w1/masters/omap_hdq.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/drivers/w1/masters/omap_hdq.c
+++ b/drivers/w1/masters/omap_hdq.c
@@ -176,7 +176,7 @@ static int hdq_write_byte(struct hdq_dat
 	/* check irqstatus */
 	if (!(*status & OMAP_HDQ_INT_STATUS_TXCOMPLETE)) {
 		dev_dbg(hdq_data->dev, "timeout waiting for"
-			" TXCOMPLETE/RXCOMPLETE, %x", *status);
+			" TXCOMPLETE/RXCOMPLETE, %x\n", *status);
 		ret = -ETIMEDOUT;
 		goto out;
 	}
@@ -187,7 +187,7 @@ static int hdq_write_byte(struct hdq_dat
 			OMAP_HDQ_FLAG_CLEAR, &tmp_status);
 	if (ret) {
 		dev_dbg(hdq_data->dev, "timeout waiting GO bit"
-			" return to zero, %x", tmp_status);
+			" return to zero, %x\n", tmp_status);
 	}
 
 out:
@@ -203,7 +203,7 @@ static irqreturn_t hdq_isr(int irq, void
 	spin_lock_irqsave(&hdq_data->hdq_spinlock, irqflags);
 	hdq_data->hdq_irqstatus = hdq_reg_in(hdq_data, OMAP_HDQ_INT_STATUS);
 	spin_unlock_irqrestore(&hdq_data->hdq_spinlock, irqflags);
-	dev_dbg(hdq_data->dev, "hdq_isr: %x", hdq_data->hdq_irqstatus);
+	dev_dbg(hdq_data->dev, "hdq_isr: %x\n", hdq_data->hdq_irqstatus);
 
 	if (hdq_data->hdq_irqstatus &
 		(OMAP_HDQ_INT_STATUS_TXCOMPLETE | OMAP_HDQ_INT_STATUS_RXCOMPLETE
@@ -311,7 +311,7 @@ static int omap_hdq_break(struct hdq_dat
 	tmp_status = hdq_data->hdq_irqstatus;
 	/* check irqstatus */
 	if (!(tmp_status & OMAP_HDQ_INT_STATUS_TIMEOUT)) {
-		dev_dbg(hdq_data->dev, "timeout waiting for TIMEOUT, %x",
+		dev_dbg(hdq_data->dev, "timeout waiting for TIMEOUT, %x\n",
 				tmp_status);
 		ret = -ETIMEDOUT;
 		goto out;
@@ -338,7 +338,7 @@ static int omap_hdq_break(struct hdq_dat
 			&tmp_status);
 	if (ret)
 		dev_dbg(hdq_data->dev, "timeout waiting INIT&GO bits"
-			" return to zero, %x", tmp_status);
+			" return to zero, %x\n", tmp_status);
 
 out:
 	mutex_unlock(&hdq_data->hdq_mutex);


