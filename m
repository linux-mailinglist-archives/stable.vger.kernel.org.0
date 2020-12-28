Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D60E22E6912
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 17:47:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728142AbgL1M5Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 07:57:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:53214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728936AbgL1M5W (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 07:57:22 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0F18A224D2;
        Mon, 28 Dec 2020 12:57:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609160226;
        bh=xoS1gGlZGtbQ9H4f3limOVfEYztFpbPBEeiB41h2g8A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GNm7xSUasCDzUxzzqG9Wn0Q36IN2TzACTOhkoWSKuqsq5GXaYiEQ12TYfuwnSBfIq
         FPHjCzef6mEjACd4dOgIQkKVBCr1jMeN25xGKPO6DyYmXLV6NlU+HyC6ZgJRN7iB56
         z++wcBm9l2AXcrxV4b30SAWBcCRWfG8S+HqhvMiw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 4.4 111/132] USB: serial: keyspan_pda: fix stalled writes
Date:   Mon, 28 Dec 2020 13:49:55 +0100
Message-Id: <20201228124851.783454636@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124846.409999325@linuxfoundation.org>
References: <20201228124846.409999325@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

commit c01d2c58698f710c9e13ba3e2d296328606f74fd upstream.

Make sure to clear the write-busy flag also in case no new data was
submitted due to lack of device buffer space so that writing is
resumed once space again becomes available.

Fixes: 507ca9bc0476 ("[PATCH] USB: add ability for usb-serial drivers to determine if their write urb is currently being used.")
Cc: stable <stable@vger.kernel.org>     # 2.6.13
Acked-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/keyspan_pda.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/serial/keyspan_pda.c
+++ b/drivers/usb/serial/keyspan_pda.c
@@ -552,7 +552,7 @@ static int keyspan_pda_write(struct tty_
 
 	rc = count;
 exit:
-	if (rc < 0)
+	if (rc <= 0)
 		set_bit(0, &port->write_urbs_free);
 	return rc;
 }


