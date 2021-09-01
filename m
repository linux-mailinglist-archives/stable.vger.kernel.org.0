Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3438D3FDA57
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 15:16:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244814AbhIAMb4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 08:31:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:33492 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244553AbhIAMbR (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Sep 2021 08:31:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 735EF60ED4;
        Wed,  1 Sep 2021 12:30:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630499420;
        bh=ruLLpsZ3Tr9dJthoFc07VLF+kVx6VIGCCXpLxxFwBys=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sAun4PUMrGT8W7Y4J4SsYaL7AxrEexnQ3LI01IKgi8MQjZ3g4Wwg9tdUx3kt7KcDc
         7UuC2+iBuhk8AwitIO8TKlBwChIOWmDaeh8T3lhcaeo42yhHtDL8zklXsoXJ+9cUlP
         Sh9xL7JfJxjysx0uLU8d5B7A51CX+yKsYKxzUa24=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Paul=20Gr=C3=B6=C3=9Fel?= <pb.g@gmx.de>,
        Willy Tarreau <w@1wt.eu>, Johan Hovold <johan@kernel.org>
Subject: [PATCH 4.19 09/33] Revert "USB: serial: ch341: fix character loss at high transfer rates"
Date:   Wed,  1 Sep 2021 14:27:58 +0200
Message-Id: <20210901122251.093256277@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210901122250.752620302@linuxfoundation.org>
References: <20210901122250.752620302@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

commit df7b16d1c00ecb3da3a30c999cdb39f273c99a2f upstream.

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
Link: https://lore.kernel.org/r/20210824121926.19311-1-johan@kernel.org
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/ch341.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/usb/serial/ch341.c
+++ b/drivers/usb/serial/ch341.c
@@ -625,7 +625,6 @@ static struct usb_serial_driver ch341_de
 		.owner	= THIS_MODULE,
 		.name	= "ch341-uart",
 	},
-	.bulk_in_size      = 512,
 	.id_table          = id_table,
 	.num_ports         = 1,
 	.open              = ch341_open,


