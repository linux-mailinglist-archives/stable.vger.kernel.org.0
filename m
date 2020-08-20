Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAE1E24B49D
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 12:09:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730810AbgHTKJf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 06:09:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:43870 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730790AbgHTKJb (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 06:09:31 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5CA1D20738;
        Thu, 20 Aug 2020 10:09:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597918170;
        bh=O9Hex2PI3iQ6/NXORTRno+6ERGMI/L7zK73tXL6N1SE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CQuXXR5nIQ4gHJ8fdCS2z2qPmwkdzBVgS/BfDBt6kDRoeTigEXPPtAH79ctAi5aE1
         iykb3yl9CQvW/cgC97Gc3Wotq+CfQgs5GWYOvdyhJ2Ar8Qe7H6pFzrbPu9tYIrvrbX
         2XE6x4BPG79qgJr/LcrVGTr8ibdQanoMSBeU8nf4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Danesh Petigara <danesh.petigara@broadcom.com>,
        Al Cooper <alcooperx@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Felipe Balbi <balbi@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 077/228] usb: bdc: Halt controller on suspend
Date:   Thu, 20 Aug 2020 11:20:52 +0200
Message-Id: <20200820091611.452811488@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091607.532711107@linuxfoundation.org>
References: <20200820091607.532711107@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Danesh Petigara <danesh.petigara@broadcom.com>

[ Upstream commit 5fc453d7de3d0c345812453823a3a56783c5f82c ]

GISB bus error kernel panics have been observed during S2 transition
tests on the 7271t platform. The errors are a result of the BDC
interrupt handler trying to access BDC register space after the
system's suspend callbacks have completed.

Adding a suspend hook to the BDC driver that halts the controller before
S2 entry thus preventing unwanted access to the BDC register space during
this transition.

Signed-off-by: Danesh Petigara <danesh.petigara@broadcom.com>
Signed-off-by: Al Cooper <alcooperx@gmail.com>
Acked-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Felipe Balbi <balbi@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/udc/bdc/bdc_core.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/gadget/udc/bdc/bdc_core.c b/drivers/usb/gadget/udc/bdc/bdc_core.c
index 2660cc2e42a08..58ba04d858bab 100644
--- a/drivers/usb/gadget/udc/bdc/bdc_core.c
+++ b/drivers/usb/gadget/udc/bdc/bdc_core.c
@@ -613,9 +613,14 @@ static int bdc_remove(struct platform_device *pdev)
 static int bdc_suspend(struct device *dev)
 {
 	struct bdc *bdc = dev_get_drvdata(dev);
+	int ret;
 
-	clk_disable_unprepare(bdc->clk);
-	return 0;
+	/* Halt the controller */
+	ret = bdc_stop(bdc);
+	if (!ret)
+		clk_disable_unprepare(bdc->clk);
+
+	return ret;
 }
 
 static int bdc_resume(struct device *dev)
-- 
2.25.1



