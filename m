Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 597ED62186
	for <lists+stable@lfdr.de>; Mon,  8 Jul 2019 17:17:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732730AbfGHPRD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jul 2019 11:17:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:40230 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732710AbfGHPRD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jul 2019 11:17:03 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BA47221537;
        Mon,  8 Jul 2019 15:17:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562599022;
        bh=9HGfosyz4rMqfLNB/CN21fCDu1xqGpNd+21+lEo5jJ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DnGoOK3+0vRh5fI9uxqTfajPzwwIjSmRYwlDJNz58Ru62oVja6q7qO+L3gC1PBQiz
         ZghOXpVSUoeRs0PbixlqHAyJM01CCjmTSejNeLx2tOVMUFySKf1PddBaEQRed1+67s
         y+7MD6kbIyHzmukavvVIrDzu34SMuKs/t9taqi4s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Young Xiao <92siuyang@gmail.com>,
        Felipe Balbi <felipe.balbi@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 52/73] usb: gadget: fusb300_udc: Fix memory leak of fusb300->ep[i]
Date:   Mon,  8 Jul 2019 17:13:02 +0200
Message-Id: <20190708150524.105871798@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190708150513.136580595@linuxfoundation.org>
References: <20190708150513.136580595@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 62fd0e0a24abeebe2c19fce49dd5716d9b62042d ]

There is no deallocation of fusb300->ep[i] elements, allocated at
fusb300_probe.

The patch adds deallocation of fusb300->ep array elements.

Signed-off-by: Young Xiao <92siuyang@gmail.com>
Signed-off-by: Felipe Balbi <felipe.balbi@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/udc/fusb300_udc.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/usb/gadget/udc/fusb300_udc.c b/drivers/usb/gadget/udc/fusb300_udc.c
index 948845c90e47..351012c498c5 100644
--- a/drivers/usb/gadget/udc/fusb300_udc.c
+++ b/drivers/usb/gadget/udc/fusb300_udc.c
@@ -1345,12 +1345,15 @@ static const struct usb_gadget_ops fusb300_gadget_ops = {
 static int fusb300_remove(struct platform_device *pdev)
 {
 	struct fusb300 *fusb300 = platform_get_drvdata(pdev);
+	int i;
 
 	usb_del_gadget_udc(&fusb300->gadget);
 	iounmap(fusb300->reg);
 	free_irq(platform_get_irq(pdev, 0), fusb300);
 
 	fusb300_free_request(&fusb300->ep[0]->ep, fusb300->ep0_req);
+	for (i = 0; i < FUSB300_MAX_NUM_EP; i++)
+		kfree(fusb300->ep[i]);
 	kfree(fusb300);
 
 	return 0;
@@ -1494,6 +1497,8 @@ clean_up:
 		if (fusb300->ep0_req)
 			fusb300_free_request(&fusb300->ep[0]->ep,
 				fusb300->ep0_req);
+		for (i = 0; i < FUSB300_MAX_NUM_EP; i++)
+			kfree(fusb300->ep[i]);
 		kfree(fusb300);
 	}
 	if (reg)
-- 
2.20.1



