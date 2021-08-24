Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D97C3F5DD0
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 14:20:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237175AbhHXMUy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 08:20:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:55152 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236676AbhHXMUx (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 08:20:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9B40361265;
        Tue, 24 Aug 2021 12:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629807609;
        bh=8oQhuq/DGjyESiByy7PbgYQ4KR5PoguBI5CPoD3IxB0=;
        h=From:To:Cc:Subject:Date:From;
        b=QQlKZSpGKshJiJAAPzp3Puebaq5BpAp4b7N57nJKY0RuiaOKb6I8p25CUH5dsmDsf
         wdDgQySDQzQa3g8jGBf8o11CZoXdZkl3sRHrsvQ00Bs8YPczh++aD9hlO6mtuPdmqM
         3mFIk/ipQVke/GjmIA0sqvbv9LP65svCAn9X0S1ez2X7HEv1ikLOi5NRGeS69vUcB8
         Fgllq3G0leQ52guX1/LHZR8NxGPGp3rzz7N6jhuCs3oYgb72p9Yz265EAg/zpu8VGL
         5BedoxckC0uOxn1Z5pU7MTWpXytQdzDQWnBtzf62wZ3zP8nUcUopudZu0ZgDp6DVFh
         flvltNaJr0lsw==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1mIVPQ-00052G-Dp; Tue, 24 Aug 2021 14:20:05 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Johan Hovold <johan@kernel.org>
Cc:     linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Paul=20Gr=C3=B6=C3=9Fel?= <pb.g@gmx.de>,
        stable@vger.kernel.org, Willy Tarreau <w@1wt.eu>
Subject: [PATCH] Revert "USB: serial: ch341: fix character loss at high transfer rates"
Date:   Tue, 24 Aug 2021 14:19:26 +0200
Message-Id: <20210824121926.19311-1-johan@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This reverts commit 3c18e9baee0ef97510dcda78c82285f52626764b.

These devices do not appear to send a zero-length packet when the
transfer size is a multiple of the bulk-endpoint max-packet size. This
means that incoming data may not be processed by the driver until a
short packet is received or the receive buffer is full.

Revert back to using endpoint-sized receive buffers to avoid stalled
reads.

Reported-by: Paul Größel <pb.g@gmx.de>
Link: https://bugzilla.kernel.org/show_bug.cgi?id=214131
Fixes: 3c18e9baee0e ("USB: serial: ch341: fix character loss at high transfer rates")
Cc: stable@vger.kernel.org
Cc: Willy Tarreau <w@1wt.eu>
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/usb/serial/ch341.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/usb/serial/ch341.c b/drivers/usb/serial/ch341.c
index 8a521b5ea769..2db917eab799 100644
--- a/drivers/usb/serial/ch341.c
+++ b/drivers/usb/serial/ch341.c
@@ -851,7 +851,6 @@ static struct usb_serial_driver ch341_device = {
 		.owner	= THIS_MODULE,
 		.name	= "ch341-uart",
 	},
-	.bulk_in_size      = 512,
 	.id_table          = id_table,
 	.num_ports         = 1,
 	.open              = ch341_open,
-- 
2.31.1

