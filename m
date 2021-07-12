Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF81C3C50CE
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:46:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245380AbhGLHfU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:35:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:49570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347015AbhGLHbZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:31:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A90916052B;
        Mon, 12 Jul 2021 07:28:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626074916;
        bh=qPRuWdfF0zru4a0Jn/Yv/kXqJxzpZugb6RKDhEzNdAE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oYinCXSkWxXdnxjzBNwxXRE+0RiB4y/7/JW/zf9IPUK7HvsXbM+/YyChfX/NnZDOJ
         SHd8mBc4An7WN8T85ZV6TDkTSZayWnmcl1y3OefiklFItse9AaEvNfPETm1sz8Hbbh
         YQDuGhAUIZCsQaXjkhthPDaZLMiZ4DGe0S3o+PHM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rocky Liao <rjliao@codeaurora.org>,
        Pavel Skripkin <paskripkin@gmail.com>,
        Johan Hovold <johan@kernel.org>,
        Marcel Holtmann <marcel@holtmann.org>
Subject: [PATCH 5.13 001/800] Bluetooth: hci_qca: fix potential GPF
Date:   Mon, 12 Jul 2021 08:00:24 +0200
Message-Id: <20210712060913.184271719@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Skripkin <paskripkin@gmail.com>

commit 59f90f1351282ea2dbd0c59098fd9bb2634e920e upstream.

In qca_power_shutdown() qcadev local variable is
initialized by hu->serdev.dev private data, but
hu->serdev can be NULL and there is a check for it.

Since, qcadev is not used before

	if (!hu->serdev)
		return;

we can move its initialization after this "if" to
prevent GPF.

Fixes: 5559904ccc08 ("Bluetooth: hci_qca: Add QCA Rome power off support to the qca_power_shutdown()")
Cc: stable@vger.kernel.org # v5.6+
Cc: Rocky Liao <rjliao@codeaurora.org>
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
Reviewed-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/bluetooth/hci_qca.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/bluetooth/hci_qca.c
+++ b/drivers/bluetooth/hci_qca.c
@@ -1835,8 +1835,6 @@ static void qca_power_shutdown(struct hc
 	unsigned long flags;
 	enum qca_btsoc_type soc_type = qca_soc_type(hu);
 
-	qcadev = serdev_device_get_drvdata(hu->serdev);
-
 	/* From this point we go into power off state. But serial port is
 	 * still open, stop queueing the IBS data and flush all the buffered
 	 * data in skb's.
@@ -1852,6 +1850,8 @@ static void qca_power_shutdown(struct hc
 	if (!hu->serdev)
 		return;
 
+	qcadev = serdev_device_get_drvdata(hu->serdev);
+
 	if (qca_is_wcn399x(soc_type)) {
 		host_set_baudrate(hu, 2400);
 		qca_send_power_pulse(hu, false);


