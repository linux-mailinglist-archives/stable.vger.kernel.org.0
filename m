Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 619501CB1CE
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 16:28:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728000AbgEHO2Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 10:28:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726937AbgEHO2X (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 8 May 2020 10:28:23 -0400
Received: from mo6-p01-ob.smtp.rzone.de (mo6-p01-ob.smtp.rzone.de [IPv6:2a01:238:20a:202:5301::4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FD4BC05BD43
        for <stable@vger.kernel.org>; Fri,  8 May 2020 07:28:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1588948101;
        s=strato-dkim-0002; d=goldelico.com;
        h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=LpO9CZWTeUZskyiR1MzGWr/RjAwDvytIyHeUpak8yl4=;
        b=ODg0NYlVfPOG8lUAgBUXd6CvTF3elw8pfY6vkAbv8YvZ/1w5Y+mOuS3ztQL1+1FtPy
        OYo9iqXAzAUsJBD4q1ebTVIbFZxRHdC0yYE9fjoQq5lcZMKDQMiDKbJpRhQl0xVh+t/G
        gMYIkLD+ikHL8pfDaXa4/u5pauxG+OuZd63aPu/hom6Qpejiwa8dxbinZSCu+H0TbR51
        HEvMGuNkuC0n6xrYt1en5qrMoWxWVertyCj1X6KbklhxeiQ0NeYj3llYtVZ7NUV+xGhi
        s2p08VAZufUZegEqjgs5AoapdT7YMj8yJroSND/3VW/z6opeNNEYbyzBQcDKhpvkt7Gv
        42jA==
X-RZG-AUTH: ":JGIXVUS7cutRB/49FwqZ7WcJeFKiMhflhwDubTJ9o1mfYzBGHXH6HVy/jE8="
X-RZG-CLASS-ID: mo00
Received: from iMac.fritz.box
        by smtp.strato.de (RZmta 46.6.2 DYNA|AUTH)
        with ESMTPSA id R0acebw48ESL4Mj
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Fri, 8 May 2020 16:28:21 +0200 (CEST)
From:   "H. Nikolaus Schaller" <hns@goldelico.com>
To:     letux-kernel@openphoenux.org
Cc:     "H. Nikolaus Schaller" <hns@goldelico.com>, stable@vger.kernel.org
Subject: [PATCH 1/5] w1: omap-hdq: cleanup to add missing newline for some dev_dbg
Date:   Fri,  8 May 2020 16:28:16 +0200
Message-Id: <8adf53c9ec9900404df7e1e76088b7e85b35074e.1588948099.git.hns@goldelico.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <cover.1588948099.git.hns@goldelico.com>
References: <cover.1588948099.git.hns@goldelico.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

or it will corrupt the console log during debugging.

Fixes: 7b5362a603a1 ("w1: omap_hdq: Fix some error/debug handling.")
Cc: stable@vger.kernel.org
Signed-off-by: H. Nikolaus Schaller <hns@goldelico.com>
---
 drivers/w1/masters/omap_hdq.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/w1/masters/omap_hdq.c b/drivers/w1/masters/omap_hdq.c
index aa09f85277767..d363e2a89fdfc 100644
--- a/drivers/w1/masters/omap_hdq.c
+++ b/drivers/w1/masters/omap_hdq.c
@@ -155,7 +155,7 @@ static int hdq_write_byte(struct hdq_data *hdq_data, u8 val, u8 *status)
 	/* check irqstatus */
 	if (!(*status & OMAP_HDQ_INT_STATUS_TXCOMPLETE)) {
 		dev_dbg(hdq_data->dev, "timeout waiting for"
-			" TXCOMPLETE/RXCOMPLETE, %x", *status);
+			" TXCOMPLETE/RXCOMPLETE, %x\n", *status);
 		ret = -ETIMEDOUT;
 		goto out;
 	}
@@ -166,7 +166,7 @@ static int hdq_write_byte(struct hdq_data *hdq_data, u8 val, u8 *status)
 			OMAP_HDQ_FLAG_CLEAR, &tmp_status);
 	if (ret) {
 		dev_dbg(hdq_data->dev, "timeout waiting GO bit"
-			" return to zero, %x", tmp_status);
+			" return to zero, %x\n", tmp_status);
 	}
 
 out:
@@ -183,7 +183,7 @@ static irqreturn_t hdq_isr(int irq, void *_hdq)
 	spin_lock_irqsave(&hdq_data->hdq_spinlock, irqflags);
 	hdq_data->hdq_irqstatus = hdq_reg_in(hdq_data, OMAP_HDQ_INT_STATUS);
 	spin_unlock_irqrestore(&hdq_data->hdq_spinlock, irqflags);
-	dev_dbg(hdq_data->dev, "hdq_isr: %x", hdq_data->hdq_irqstatus);
+	dev_dbg(hdq_data->dev, "hdq_isr: %x\n", hdq_data->hdq_irqstatus);
 
 	if (hdq_data->hdq_irqstatus &
 		(OMAP_HDQ_INT_STATUS_TXCOMPLETE | OMAP_HDQ_INT_STATUS_RXCOMPLETE
@@ -248,7 +248,7 @@ static int omap_hdq_break(struct hdq_data *hdq_data)
 	tmp_status = hdq_data->hdq_irqstatus;
 	/* check irqstatus */
 	if (!(tmp_status & OMAP_HDQ_INT_STATUS_TIMEOUT)) {
-		dev_dbg(hdq_data->dev, "timeout waiting for TIMEOUT, %x",
+		dev_dbg(hdq_data->dev, "timeout waiting for TIMEOUT, %x\n",
 				tmp_status);
 		ret = -ETIMEDOUT;
 		goto out;
@@ -275,7 +275,7 @@ static int omap_hdq_break(struct hdq_data *hdq_data)
 			&tmp_status);
 	if (ret)
 		dev_dbg(hdq_data->dev, "timeout waiting INIT&GO bits"
-			" return to zero, %x", tmp_status);
+			" return to zero, %x\n", tmp_status);
 
 out:
 	hdq_reset_irqstatus(hdq_data);
-- 
2.26.2

