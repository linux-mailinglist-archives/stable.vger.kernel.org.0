Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DD96247696
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 21:39:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730046AbgHQTj0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 15:39:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:35216 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729813AbgHQP0c (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:26:32 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6B95323718;
        Mon, 17 Aug 2020 15:26:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597677991;
        bh=7zefk5AnHsO0CJkvNYQwHaA5V3ogPlSFdGnb5lfCmhM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XzyjD7sABwZ7QHGRH7dzBHIP3AZyz2o+X2lHpFg4Y9e9+YwMQ1JarmWfx4sWJWlPR
         qeorOi5mjT+ESLkbMuvSvac+j7hWC7euNxQ24QNWEHmuw4b2ZAUBH14mR5Lt0VIaqb
         GnbdYO+ZYZNVdbY6RnOJU0Ef09EgRggTcI9pPc9A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Matthias Kaehlcke <mka@chromium.org>,
        Abhishek Pandit-Subedi <abhishekpandit@chromium.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 154/464] Bluetooth: hci_qca: Only remove TX clock vote after TX is completed
Date:   Mon, 17 Aug 2020 17:11:47 +0200
Message-Id: <20200817143841.189648230@linuxfoundation.org>
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

From: Matthias Kaehlcke <mka@chromium.org>

[ Upstream commit eff981f6579d5797d68d27afc0eede529ac8778a ]

qca_suspend() removes the vote for the UART TX clock after
writing an IBS sleep request to the serial buffer. This is
not a good idea since there is no guarantee that the request
has been sent at this point. Instead remove the vote after
successfully entering IBS sleep. This also fixes the issue
of the vote being removed in case of an aborted suspend due
to a failure of entering IBS sleep.

Fixes: 41d5b25fed0a0 ("Bluetooth: hci_qca: add PM support")
Signed-off-by: Matthias Kaehlcke <mka@chromium.org>
Reviewed-by: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/hci_qca.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/bluetooth/hci_qca.c b/drivers/bluetooth/hci_qca.c
index 25659b8b0c0c8..328919b79f7b9 100644
--- a/drivers/bluetooth/hci_qca.c
+++ b/drivers/bluetooth/hci_qca.c
@@ -2115,8 +2115,6 @@ static int __maybe_unused qca_suspend(struct device *dev)
 
 		qca->tx_ibs_state = HCI_IBS_TX_ASLEEP;
 		qca->ibs_sent_slps++;
-
-		qca_wq_serial_tx_clock_vote_off(&qca->ws_tx_vote_off);
 		break;
 
 	case HCI_IBS_TX_ASLEEP:
@@ -2144,8 +2142,10 @@ static int __maybe_unused qca_suspend(struct device *dev)
 			qca->rx_ibs_state == HCI_IBS_RX_ASLEEP,
 			msecs_to_jiffies(IBS_BTSOC_TX_IDLE_TIMEOUT_MS));
 
-	if (ret > 0)
+	if (ret > 0) {
+		qca_wq_serial_tx_clock_vote_off(&qca->ws_tx_vote_off);
 		return 0;
+	}
 
 	if (ret == 0)
 		ret = -ETIMEDOUT;
-- 
2.25.1



