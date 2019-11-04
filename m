Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D1811EF049
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 23:27:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387831AbfKDW1H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 17:27:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:43002 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387755AbfKDVuj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Nov 2019 16:50:39 -0500
Received: from localhost (6.204-14-84.ripe.coltfrance.com [84.14.204.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A3E7721744;
        Mon,  4 Nov 2019 21:50:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572904238;
        bh=QTCPxfOHcDMqsT3sNLrtpzZwxWq4ArbqZGS79lePllI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=imnYyeUthywFw1iPOXp2euVQIkP6xuUAEuLlPF36/H+k7zxjkM7ccMJYHC8Uw1Q9V
         pdwryFVCsMs5EBESPhJu6elyZhKOkd17ijpaCZu5ejkrhNPJbr9Qjo1sw82+93yRSI
         4XUvP1xHh7yWT2N9mfxfcU8XKMlR4RJ9qE5tgPFs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hui Peng <benquike@gmail.com>,
        Mathias Payer <mathias.payer@nebelwelt.net>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 33/62] ath6kl: fix a NULL-ptr-deref bug in ath6kl_usb_alloc_urb_from_pipe()
Date:   Mon,  4 Nov 2019 22:44:55 +0100
Message-Id: <20191104211933.014977706@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191104211901.387893698@linuxfoundation.org>
References: <20191104211901.387893698@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hui Peng <benquike@gmail.com>

[ Upstream commit 39d170b3cb62ba98567f5c4f40c27b5864b304e5 ]

The `ar_usb` field of `ath6kl_usb_pipe_usb_pipe` objects
are initialized to point to the containing `ath6kl_usb` object
according to endpoint descriptors read from the device side, as shown
below in `ath6kl_usb_setup_pipe_resources`:

for (i = 0; i < iface_desc->desc.bNumEndpoints; ++i) {
	endpoint = &iface_desc->endpoint[i].desc;

	// get the address from endpoint descriptor
	pipe_num = ath6kl_usb_get_logical_pipe_num(ar_usb,
						endpoint->bEndpointAddress,
						&urbcount);
	......
	// select the pipe object
	pipe = &ar_usb->pipes[pipe_num];

	// initialize the ar_usb field
	pipe->ar_usb = ar_usb;
}

The driver assumes that the addresses reported in endpoint
descriptors from device side  to be complete. If a device is
malicious and does not report complete addresses, it may trigger
NULL-ptr-deref `ath6kl_usb_alloc_urb_from_pipe` and
`ath6kl_usb_free_urb_to_pipe`.

This patch fixes the bug by preventing potential NULL-ptr-deref
(CVE-2019-15098).

Signed-off-by: Hui Peng <benquike@gmail.com>
Reported-by: Hui Peng <benquike@gmail.com>
Reported-by: Mathias Payer <mathias.payer@nebelwelt.net>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath6kl/usb.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/wireless/ath/ath6kl/usb.c b/drivers/net/wireless/ath/ath6kl/usb.c
index 9da3594fd010d..fc22c5f479276 100644
--- a/drivers/net/wireless/ath/ath6kl/usb.c
+++ b/drivers/net/wireless/ath/ath6kl/usb.c
@@ -132,6 +132,10 @@ ath6kl_usb_alloc_urb_from_pipe(struct ath6kl_usb_pipe *pipe)
 	struct ath6kl_urb_context *urb_context = NULL;
 	unsigned long flags;
 
+	/* bail if this pipe is not initialized */
+	if (!pipe->ar_usb)
+		return NULL;
+
 	spin_lock_irqsave(&pipe->ar_usb->cs_lock, flags);
 	if (!list_empty(&pipe->urb_list_head)) {
 		urb_context =
@@ -150,6 +154,10 @@ static void ath6kl_usb_free_urb_to_pipe(struct ath6kl_usb_pipe *pipe,
 {
 	unsigned long flags;
 
+	/* bail if this pipe is not initialized */
+	if (!pipe->ar_usb)
+		return;
+
 	spin_lock_irqsave(&pipe->ar_usb->cs_lock, flags);
 	pipe->urb_cnt++;
 
-- 
2.20.1



