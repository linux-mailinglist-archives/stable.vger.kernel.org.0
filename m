Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E2E077F3AB
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 12:00:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406135AbfHBJzO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 05:55:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:33588 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406485AbfHBJzK (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 2 Aug 2019 05:55:10 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AE2CC206A2;
        Fri,  2 Aug 2019 09:55:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564739710;
        bh=ctxtzsTqbKx85BXupl4d4d0HHrp90z4CQv0kcxHld48=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GRrKBZEN74bgKZgc5TD+f4sVQ3ifQCDHiX7Gp/+wInEkoMfPX6YAHuh7MDaweS8+Y
         uK+xZRESbAnt01aefCQsqECR8mC4yW6VIC+TACWMZpirIzRHgwS6yS/ltg1YT/Vzc7
         /Gz2ZhgtlRRjAmj7xq0MIhxR31nsjduNRSVO2TAs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Abhishek Sahu <absahu@codeaurora.org>,
        Sricharan R <sricharan@codeaurora.org>,
        Austin Christ <austinwc@codeaurora.org>,
        Andy Gross <andy.gross@linaro.org>,
        Wolfram Sang <wsa@the-dreams.de>,
        Amit Pundir <amit.pundir@linaro.org>
Subject: [PATCH 4.14 07/25] i2c: qup: fixed releasing dma without flush operation completion
Date:   Fri,  2 Aug 2019 11:39:39 +0200
Message-Id: <20190802092100.708534648@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190802092058.428079740@linuxfoundation.org>
References: <20190802092058.428079740@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Abhishek Sahu <absahu@codeaurora.org>

commit 7239872fb3400b21a8f5547257f9f86455867bd6 upstream.

The QUP BSLP BAM generates the following error sometimes if the
current I2C DMA transfer fails and the flush operation has been
scheduled

    “bam-dma-engine 7884000.dma: Cannot free busy channel”

If any I2C error comes during BAM DMA transfer, then the QUP I2C
interrupt will be generated and the flush operation will be
carried out to make I2C consume all scheduled DMA transfer.
Currently, the same completion structure is being used for BAM
transfer which has already completed without reinit. It will make
flush operation wait_for_completion_timeout completed immediately
and will proceed for freeing the DMA resources where the
descriptors are still in process.

Signed-off-by: Abhishek Sahu <absahu@codeaurora.org>
Acked-by: Sricharan R <sricharan@codeaurora.org>
Reviewed-by: Austin Christ <austinwc@codeaurora.org>
Reviewed-by: Andy Gross <andy.gross@linaro.org>
Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
Signed-off-by: Amit Pundir <amit.pundir@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/i2c/busses/i2c-qup.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/i2c/busses/i2c-qup.c
+++ b/drivers/i2c/busses/i2c-qup.c
@@ -844,6 +844,8 @@ static int qup_i2c_bam_do_xfer(struct qu
 	}
 
 	if (ret || qup->bus_err || qup->qup_err) {
+		reinit_completion(&qup->xfer);
+
 		if (qup_i2c_change_state(qup, QUP_RUN_STATE)) {
 			dev_err(qup->dev, "change to run state timed out");
 			goto desc_err;


