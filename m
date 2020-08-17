Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A230F2469BF
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 17:25:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729725AbgHQPZe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 11:25:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:59728 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729438AbgHQPZa (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:25:30 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4A7BF23110;
        Mon, 17 Aug 2020 15:25:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597677929;
        bh=xPQ55l8TgbrNEJVWJSK3Tk8/hsvVC1iKAIUrDRUITfo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xkeEoLC98/PnLMGfWuddQHllXAWfWux2IhjCdv4LtFIOkO49Ln8t5GtwAzFrzISPL
         uJmdr+/F1sP0Ki6rHsGueo14YS4+k84/qZYbbfIwoRQ+CbXOGhENyFZcB5Th0oBEqu
         9G+ZXfTMx0A+pnRkWCNNpKxiaP7xnNg/+gQtyMtc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 152/464] Bluetooth: hci_qca: Fix an error pointer dereference
Date:   Mon, 17 Aug 2020 17:11:45 +0200
Message-Id: <20200817143841.092975291@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143833.737102804@linuxfoundation.org>
References: <20200817143833.737102804@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 4c07a5d7aeb39f559b29aa58ec9a8a5ab4282cb0 ]

When a function like devm_clk_get_optional() function returns both error
pointers on error and NULL then the NULL return means that the optional
feature is deliberately disabled.  It is a special sort of success and
should not trigger an error message.  The surrounding code should be
written to check for NULL and not crash.

On the other hand, if we encounter an error, then the probe from should
clean up and return a failure.

In this code, if devm_clk_get_optional() returns an error pointer then
the kernel will crash inside the call to:

	clk_set_rate(qcadev->susclk, SUSCLK_RATE_32KHZ);

The error handling must be updated to prevent that.

Fixes: 77131dfec6af ("Bluetooth: hci_qca: Replace devm_gpiod_get() with devm_gpiod_get_optional()")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/hci_qca.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/bluetooth/hci_qca.c b/drivers/bluetooth/hci_qca.c
index 3788ec7a4ad6b..25659b8b0c0c8 100644
--- a/drivers/bluetooth/hci_qca.c
+++ b/drivers/bluetooth/hci_qca.c
@@ -1994,17 +1994,17 @@ static int qca_serdev_probe(struct serdev_device *serdev)
 		}
 
 		qcadev->susclk = devm_clk_get_optional(&serdev->dev, NULL);
-		if (!qcadev->susclk) {
+		if (IS_ERR(qcadev->susclk)) {
 			dev_warn(&serdev->dev, "failed to acquire clk\n");
-		} else {
-			err = clk_set_rate(qcadev->susclk, SUSCLK_RATE_32KHZ);
-			if (err)
-				return err;
-
-			err = clk_prepare_enable(qcadev->susclk);
-			if (err)
-				return err;
+			return PTR_ERR(qcadev->susclk);
 		}
+		err = clk_set_rate(qcadev->susclk, SUSCLK_RATE_32KHZ);
+		if (err)
+			return err;
+
+		err = clk_prepare_enable(qcadev->susclk);
+		if (err)
+			return err;
 
 		err = hci_uart_register_device(&qcadev->serdev_hu, &qca_proto);
 		if (err) {
-- 
2.25.1



