Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B1422F5FB
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:53:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728233AbfE3DKs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 23:10:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:48586 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728229AbfE3DKs (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:10:48 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9287A244BE;
        Thu, 30 May 2019 03:10:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559185847;
        bh=nJOC11LG61CeMscW6+L6k4s9ntWti32k6Lq/HMaFMLs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Hs6rYYRQvClqij+JUxI16o5blaV5CGe8dQYERgK/b/tGd7GfIQsDqOaerAqK3Uj0j
         R5koHtDaizpMWI7nbknAsyTJEAvHzL1O1qRBfSpJf+80cbejp2tQUZLf9JXcXlLXq7
         vhxO5UawWmtmlNhENDuf1H67R7B4tHX8ODXZz3Xc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Balakrishna Godavarthi <bgodavar@codeaurora.org>,
        Rocky Liao <rjliao@codeaurora.org>,
        Matthias Kaehlcke <mka@chromium.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 142/405] Bluetooth: hci_qca: Fix crash with non-serdev devices
Date:   Wed, 29 May 2019 20:02:20 -0700
Message-Id: <20190530030548.309635745@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030540.291644921@linuxfoundation.org>
References: <20190530030540.291644921@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit ecf2b768bd11e2ff09ecbe621b387d0d58e970cf ]

qca_set_baudrate() calls serdev_device_wait_until_sent() assuming that
the HCI is always associated with a serdev device. This isn't true for
ROME controllers instantiated through ldisc, where the call causes a
crash due to a NULL pointer dereferentiation. Only call the function
when we have a serdev device. The timeout for ROME devices at the end
of qca_set_baudrate() is long enough to be reasonably sure that the
command was sent.

Fixes: fa9ad876b8e0 ("Bluetooth: hci_qca: Add support for Qualcomm Bluetooth chip wcn3990")
Reported-by: Balakrishna Godavarthi <bgodavar@codeaurora.org>
Reported-by: Rocky Liao <rjliao@codeaurora.org>
Signed-off-by: Matthias Kaehlcke <mka@chromium.org>
Reviewed-by: Rocky Liao <rjliao@codeaurora.org>
Tested-by: Rocky Liao <rjliao@codeaurora.org>
Reviewed-by: Balakrishna Godavarthi <bgodavar@codeaurora.org>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/hci_qca.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/bluetooth/hci_qca.c b/drivers/bluetooth/hci_qca.c
index 237aea34b69f1..340c3c750b180 100644
--- a/drivers/bluetooth/hci_qca.c
+++ b/drivers/bluetooth/hci_qca.c
@@ -992,7 +992,8 @@ static int qca_set_baudrate(struct hci_dev *hdev, uint8_t baudrate)
 	while (!skb_queue_empty(&qca->txq))
 		usleep_range(100, 200);
 
-	serdev_device_wait_until_sent(hu->serdev,
+	if (hu->serdev)
+		serdev_device_wait_until_sent(hu->serdev,
 		      msecs_to_jiffies(CMD_TRANS_TIMEOUT_MS));
 
 	/* Give the controller time to process the request */
-- 
2.20.1



