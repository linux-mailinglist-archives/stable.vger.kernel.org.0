Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 194A61DF9A3
	for <lists+stable@lfdr.de>; Sat, 23 May 2020 19:33:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388123AbgEWRdN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 23 May 2020 13:33:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728044AbgEWRdM (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 23 May 2020 13:33:12 -0400
Received: from mo6-p01-ob.smtp.rzone.de (mo6-p01-ob.smtp.rzone.de [IPv6:2a01:238:20a:202:5301::4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E74E1C061A0E;
        Sat, 23 May 2020 10:33:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1590255189;
        s=strato-dkim-0002; d=goldelico.com;
        h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=YSIrxjOw32Ako2eh+MgWxJf5VvDsicctHOxFg58objU=;
        b=Pc2G0Qrqpy0kr7QWSTzBLetDls162oCE6AbESF31m3ibrPm2aW6ZH8FYJBBF1bJRLj
        /0FjCuvXlzOSzu86Kl8yM1Tu5quI9x3yBYL02VHWbySe0in2ObJIfWdG6Fe/SB6640u1
        m38BJzeakYWnRVyHx055icQZ6pjbLvNXF4DK3ILsb6UNBq0kLp0vZRJ14svTGiW0AV19
        yZDzIGC6UDE84X2PUlGd3S2uTEAP7EgqXcEOo1sj5CHixYr34sZ9sa26SgUbMMyDSrAR
        3PVyTsuxo82UcK3FNRv8PdWASEHI+XeogUheKURcVfJKIex5sOpCaM/xEq0pvzp0i7GH
        BFPA==
X-RZG-AUTH: ":JGIXVUS7cutRB/49FwqZ7WcJeFKiMhflhwDubTJ9o19MtK65S+//9m1YB9g="
X-RZG-CLASS-ID: mo00
Received: from iMac.fritz.box
        by smtp.strato.de (RZmta 46.7.0 AUTH)
        with ESMTPSA id D0a7c0w4NHX0Fab
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Sat, 23 May 2020 19:33:00 +0200 (CEST)
From:   "H. Nikolaus Schaller" <hns@goldelico.com>
To:     Evgeniy Polyakov <zbr@ioremap.net>,
        "H. Nikolaus Schaller" <hns@goldelico.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        YueHaibing <yuehaibing@huawei.com>,
        Tony Lindgren <tony@atomide.com>
Cc:     linux-kernel@vger.kernel.org, kernel@pyra-handheld.com,
        letux-kernel@openphoenux.org, linux-omap@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH 1/4] w1: omap-hdq: cleanup to add missing newline for some dev_dbg
Date:   Sat, 23 May 2020 19:32:54 +0200
Message-Id: <cd0d55749a091214106575f6e1d363c6db56622f.1590255176.git.hns@goldelico.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <cover.1590255176.git.hns@goldelico.com>
References: <cover.1590255176.git.hns@goldelico.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Otherwise it will corrupt the console log during debugging.

Fixes: 7b5362a603a1 ("w1: omap_hdq: Fix some error/debug handling.")
Cc: stable@vger.kernel.org
Signed-off-by: H. Nikolaus Schaller <hns@goldelico.com>
---
 drivers/w1/masters/omap_hdq.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/w1/masters/omap_hdq.c b/drivers/w1/masters/omap_hdq.c
index aa09f85277767a..d363e2a89fdfc4 100644
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

