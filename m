Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A60EEF088
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 23:28:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730023AbfKDVs1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 16:48:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:38856 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729968AbfKDVs0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Nov 2019 16:48:26 -0500
Received: from localhost (6.204-14-84.ripe.coltfrance.com [84.14.204.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B2DE520B7C;
        Mon,  4 Nov 2019 21:48:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572904106;
        bh=5YfsL84lW/rNJVkUOyhps8l0wKXGrBYJqxZNQ+RK7Qw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ObRKM8K8ql9X8RhzfGvcsoMdJhWnsNugbsbZYyQkPoilyqhK5gIZwevDZ7gZyGoZS
         YEQzZcVyX62XAgVvUZ7yQ3pzCRiEmlmEBL4nfjawRGrc781xmUNwWEEhaxpembh9nb
         kYPAVEgkS58hwPpgyOdc+2Ogy21bybSTOGBGKN2Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hui Peng <benquike@gmail.com>,
        Mathias Payer <mathias.payer@nebelwelt.net>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 24/46] ath6kl: fix a NULL-ptr-deref bug in ath6kl_usb_alloc_urb_from_pipe()
Date:   Mon,  4 Nov 2019 22:44:55 +0100
Message-Id: <20191104211855.943825731@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191104211830.912265604@linuxfoundation.org>
References: <20191104211830.912265604@linuxfoundation.org>
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
 drivers/net/wireless/ath/ath6kl/usb.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/net/wireless/ath/ath6kl/usb.c
+++ b/drivers/net/wireless/ath/ath6kl/usb.c
@@ -132,6 +132,10 @@ ath6kl_usb_alloc_urb_from_pipe(struct at
 	struct ath6kl_urb_context *urb_context = NULL;
 	unsigned long flags;
 
+	/* bail if this pipe is not initialized */
+	if (!pipe->ar_usb)
+		return NULL;
+
 	spin_lock_irqsave(&pipe->ar_usb->cs_lock, flags);
 	if (!list_empty(&pipe->urb_list_head)) {
 		urb_context =
@@ -150,6 +154,10 @@ static void ath6kl_usb_free_urb_to_pipe(
 {
 	unsigned long flags;
 
+	/* bail if this pipe is not initialized */
+	if (!pipe->ar_usb)
+		return;
+
 	spin_lock_irqsave(&pipe->ar_usb->cs_lock, flags);
 	pipe->urb_cnt++;
 


