Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C7563C4736
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:26:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236052AbhGLGbq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:31:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:53376 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237410AbhGLGbC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:31:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7B1D360238;
        Mon, 12 Jul 2021 06:28:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626071294;
        bh=h1cRvg9IIqmLu4uS94dNYOwG1oOwn29DAly0n27sg+s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Gjso1XfLAuusRPRhnc6oz1cVRdnUj8lTkeHt85IjLn4452geUaAvjhxWRnGOnYsai
         uPT1sdqgsaMx7nlnLdJxPrQNNNoCMK/k3k4HK7BUAn7RqP2v+aOj7Olxb8wmcyn6Hf
         s24t6nN9gHY2GSKpPQlbcGrpDbx8YLSvNQpWgaL0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rocky Liao <rjliao@codeaurora.org>,
        Pavel Skripkin <paskripkin@gmail.com>,
        Johan Hovold <johan@kernel.org>,
        Marcel Holtmann <marcel@holtmann.org>
Subject: [PATCH 5.10 001/593] Bluetooth: hci_qca: fix potential GPF
Date:   Mon, 12 Jul 2021 08:02:41 +0200
Message-Id: <20210712060843.337899580@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060843.180606720@linuxfoundation.org>
References: <20210712060843.180606720@linuxfoundation.org>
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
@@ -1809,8 +1809,6 @@ static void qca_power_shutdown(struct hc
 	unsigned long flags;
 	enum qca_btsoc_type soc_type = qca_soc_type(hu);
 
-	qcadev = serdev_device_get_drvdata(hu->serdev);
-
 	/* From this point we go into power off state. But serial port is
 	 * still open, stop queueing the IBS data and flush all the buffered
 	 * data in skb's.
@@ -1826,6 +1824,8 @@ static void qca_power_shutdown(struct hc
 	if (!hu->serdev)
 		return;
 
+	qcadev = serdev_device_get_drvdata(hu->serdev);
+
 	if (qca_is_wcn399x(soc_type)) {
 		host_set_baudrate(hu, 2400);
 		qca_send_power_pulse(hu, false);


