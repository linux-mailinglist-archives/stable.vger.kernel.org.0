Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E796520E770
	for <lists+stable@lfdr.de>; Tue, 30 Jun 2020 00:11:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731597AbgF2V5W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 17:57:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:56782 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726507AbgF2Sfa (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 14:35:30 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5C05D24681;
        Mon, 29 Jun 2020 15:19:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593443976;
        bh=1xv6yYBqZwbWzKf+MAaWuSrnLwTqcr4DmRgoY8PZRCM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HMENSB8c7+B5relgx2fhDnJduQlAwGDtN1JQ7yaV9/j0xdwtRdpvU6WxcJbTPQAsN
         xoiEJxrhB8sgfVdOQ5md1ZyG50knGREOKdp7LXWNvUx37VasvIzC5p5LUpZuiaPiM2
         rXc7ATop//HoUyX9q9szAVtj4JhDbYQS8pgDdZ1g=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Peter Chen <peter.chen@nxp.com>,
        Pawel Laszczak <pawell@cadence.com>,
        Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 5.7 080/265] usb: cdns3: ep0: add spinlock for cdns3_check_new_setup
Date:   Mon, 29 Jun 2020 11:15:13 -0400
Message-Id: <20200629151818.2493727-81-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629151818.2493727-1-sashal@kernel.org>
References: <20200629151818.2493727-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.7.7-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.7.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.7.7-rc1
X-KernelTest-Deadline: 2020-07-01T15:14+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Chen <peter.chen@nxp.com>

commit 2587a029fa2a877d0a8dda955ef1b24c94b4bd0e upstream.

The other thread may access other endpoints when the cdns3_check_new_setup
is handling, add spinlock to protect it.

Cc: <stable@vger.kernel.org>
Fixes: 7733f6c32e36 ("usb: cdns3: Add Cadence USB3 DRD Driver")
Reviewed-by: Pawel Laszczak <pawell@cadence.com>
Signed-off-by: Peter Chen <peter.chen@nxp.com>
Signed-off-by: Felipe Balbi <balbi@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/cdns3/ep0.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/cdns3/ep0.c b/drivers/usb/cdns3/ep0.c
index f785ce84aba62..da4c5eb03d7ee 100644
--- a/drivers/usb/cdns3/ep0.c
+++ b/drivers/usb/cdns3/ep0.c
@@ -712,15 +712,17 @@ static int cdns3_gadget_ep0_queue(struct usb_ep *ep,
 	int ret = 0;
 	u8 zlp = 0;
 
+	spin_lock_irqsave(&priv_dev->lock, flags);
 	trace_cdns3_ep0_queue(priv_dev, request);
 
 	/* cancel the request if controller receive new SETUP packet. */
-	if (cdns3_check_new_setup(priv_dev))
+	if (cdns3_check_new_setup(priv_dev)) {
+		spin_unlock_irqrestore(&priv_dev->lock, flags);
 		return -ECONNRESET;
+	}
 
 	/* send STATUS stage. Should be called only for SET_CONFIGURATION */
 	if (priv_dev->ep0_stage == CDNS3_STATUS_STAGE) {
-		spin_lock_irqsave(&priv_dev->lock, flags);
 		cdns3_select_ep(priv_dev, 0x00);
 
 		erdy_sent = !priv_dev->hw_configured_flag;
@@ -745,7 +747,6 @@ static int cdns3_gadget_ep0_queue(struct usb_ep *ep,
 		return 0;
 	}
 
-	spin_lock_irqsave(&priv_dev->lock, flags);
 	if (!list_empty(&priv_ep->pending_req_list)) {
 		dev_err(priv_dev->dev,
 			"can't handle multiple requests for ep0\n");
-- 
2.25.1

