Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7CCD811B5A6
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 16:56:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730579AbfLKPQR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:16:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:43246 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729260AbfLKPQQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:16:16 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AA69824654;
        Wed, 11 Dec 2019 15:16:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077376;
        bh=7eOKCjZ0cR1AnFiTqy5GIYb61+R5OBdQSidlgyrGhpk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MQZHFADnTH6XEp17BXZfJkYM/N8HXmahMop5m1UHPhCntJCEhcQn7gdARRNhfJbCY
         qBEtmvzT0F4WTR6WzcgtPbbQIwgqVOX4mGm1FxFB6Ulw1KXDYQxISQaEg1WS6dOIRF
         yK8eVwQGjvEK01aehuPOHLqHPT/0bcyziKlUsBf8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stephan Gerhold <stephan@gerhold.net>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 016/243] NFC: nxp-nci: Fix NULL pointer dereference after I2C communication error
Date:   Wed, 11 Dec 2019 16:02:58 +0100
Message-Id: <20191211150340.131305469@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191211150339.185439726@linuxfoundation.org>
References: <20191211150339.185439726@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stephan Gerhold <stephan@gerhold.net>

[ Upstream commit a71a29f50de1ef97ab55c151a1598eb12dde379d ]

I2C communication errors (-EREMOTEIO) during the IRQ handler of nxp-nci
result in a NULL pointer dereference at the moment:

    BUG: kernel NULL pointer dereference, address: 0000000000000000
    Oops: 0002 [#1] PREEMPT SMP NOPTI
    CPU: 1 PID: 355 Comm: irq/137-nxp-nci Not tainted 5.4.0-rc6 #1
    RIP: 0010:skb_queue_tail+0x25/0x50
    Call Trace:
     nci_recv_frame+0x36/0x90 [nci]
     nxp_nci_i2c_irq_thread_fn+0xd1/0x285 [nxp_nci_i2c]
     ? preempt_count_add+0x68/0xa0
     ? irq_forced_thread_fn+0x80/0x80
     irq_thread_fn+0x20/0x60
     irq_thread+0xee/0x180
     ? wake_threads_waitq+0x30/0x30
     kthread+0xfb/0x130
     ? irq_thread_check_affinity+0xd0/0xd0
     ? kthread_park+0x90/0x90
     ret_from_fork+0x1f/0x40

Afterward the kernel must be rebooted to work properly again.

This happens because it attempts to call nci_recv_frame() with skb == NULL.
However, unlike nxp_nci_fw_recv_frame(), nci_recv_frame() does not have any
NULL checks for skb, causing the NULL pointer dereference.

Change the code to call only nxp_nci_fw_recv_frame() in case of an error.
Make sure to log it so it is obvious that a communication error occurred.
The error above then becomes:

    nxp-nci_i2c i2c-NXP1001:00: NFC: Read failed with error -121
    nci: __nci_request: wait_for_completion_interruptible_timeout failed 0
    nxp-nci_i2c i2c-NXP1001:00: NFC: Read failed with error -121

Fixes: 6be88670fc59 ("NFC: nxp-nci_i2c: Add I2C support to NXP NCI driver")
Signed-off-by: Stephan Gerhold <stephan@gerhold.net>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nfc/nxp-nci/i2c.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/nfc/nxp-nci/i2c.c b/drivers/nfc/nxp-nci/i2c.c
index ba695e392c3b7..0df745cad601a 100644
--- a/drivers/nfc/nxp-nci/i2c.c
+++ b/drivers/nfc/nxp-nci/i2c.c
@@ -236,8 +236,10 @@ static irqreturn_t nxp_nci_i2c_irq_thread_fn(int irq, void *phy_id)
 
 	if (r == -EREMOTEIO) {
 		phy->hard_fault = r;
-		skb = NULL;
-	} else if (r < 0) {
+		if (info->mode == NXP_NCI_MODE_FW)
+			nxp_nci_fw_recv_frame(phy->ndev, NULL);
+	}
+	if (r < 0) {
 		nfc_err(&client->dev, "Read failed with error %d\n", r);
 		goto exit_irq_handled;
 	}
-- 
2.20.1



