Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B8B6466D82
	for <lists+stable@lfdr.de>; Fri, 12 Jul 2019 14:31:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728246AbfGLMah (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Jul 2019 08:30:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:46552 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729167AbfGLMah (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 12 Jul 2019 08:30:37 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D61A1208E4;
        Fri, 12 Jul 2019 12:30:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562934636;
        bh=mEHwNLg4gK3ziQCCf0esvVZ619U3KOGInEuHUxF4okQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p8m4xNyxOeJEI6C0W+QxT+ipRrDFVh64bl/VChfk4i+ItvVlVPzZA4Z48TBDmLhca
         3P87qVfjkVBF5bL3qRjvlo1JLx4BDiLg5o4ql55zkko3pkYg/QGPCwEW0P+GZbFlpd
         658VWVXn/REqIwSov9tJ9k8b0KSTL77s+L1xX9HE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christian Lamparter <chunkeey@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH 5.1 118/138] p54: fix crash during initialization
Date:   Fri, 12 Jul 2019 14:19:42 +0200
Message-Id: <20190712121633.274431577@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190712121628.731888964@linuxfoundation.org>
References: <20190712121628.731888964@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christian Lamparter <chunkeey@gmail.com>

commit 1645ab931998b39aed5761f095956f0b10a6362f upstream.

This patch fixes a crash that got introduced when the
mentioned patch replaced  the direct list_head access
with skb_peek_tail(). When the device is starting up,
there are  no entries in  the queue, so previously to
"Use skb_peek_tail() instead..." the target_skb would
end up as the  tail and head pointer which then could
be used by __skb_queue_after to fill the empty queue.

With skb_peek_tail() in its place will instead just
return NULL which then causes a crash in the
__skb_queue_after().

| BUG: unable to handle kernel NULL pointer dereference at 000000
| #PF error: [normal kernel read fault]
| PGD 0 P4D 0
| Oops: 0000 [#1] SMP PTI
| CPU: 0 PID: 12 Comm: kworker/0:1 Tainted: GO   5.1.0-rc7-wt+ #218
| Hardware name: MSI MS-7816/Z87-G43 (MS-7816), BIOS V1.11 05/09/2015
| Workqueue: events request_firmware_work_func
| RIP: 0010:p54_tx_pending+0x10f/0x1b0 [p54common]
| Code: 78 06 80 78 28 00 74 6d <48> 8b 07 49 89 7c 24 08 49 89 04 24 4
| RSP: 0018:ffffa81c81927d90 EFLAGS: 00010086
| RAX: ffff9bbaaf131048 RBX: 0000000000020670 RCX: 0000000000020264
| RDX: ffff9bbaa976d660 RSI: 0000000000000202 RDI: 0000000000000000
| RBP: ffff9bbaa976d620 R08: 00000000000006c0 R09: ffff9bbaa976d660
| R10: 0000000000000000 R11: ffffe8480dbc5900 R12: ffff9bbb45e87700
| R13: ffff9bbaa976d648 R14: ffff9bbaa976d674 R15: ffff9bbaaf131048
| FS:  0000000000000000(0000) GS:ffff9bbb5ec00000(0000) knlGS:00000
| CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
| CR2: 0000000000000000 CR3: 00000003695fc003 CR4: 00000000001606f0
| Call Trace:
|  p54_download_eeprom+0xbe/0x120 [p54common]
|  p54_read_eeprom+0x7f/0xc0 [p54common]
|  p54u_load_firmware_cb+0xe0/0x160 [p54usb]
|  request_firmware_work_func+0x42/0x80
|  process_one_work+0x1f5/0x3f0
|  worker_thread+0x28/0x3c0

Cc: stable@vger.kernel.org
Fixes: e3554197fc8f ("p54: Use skb_peek_tail() instead of direct head pointer accesses.")
Signed-off-by: Christian Lamparter <chunkeey@gmail.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/intersil/p54/txrx.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/net/wireless/intersil/p54/txrx.c
+++ b/drivers/net/wireless/intersil/p54/txrx.c
@@ -142,7 +142,10 @@ static int p54_assign_address(struct p54
 	    unlikely(GET_HW_QUEUE(skb) == P54_QUEUE_BEACON))
 		priv->beacon_req_id = data->req_id;
 
-	__skb_queue_after(&priv->tx_queue, target_skb, skb);
+	if (target_skb)
+		__skb_queue_after(&priv->tx_queue, target_skb, skb);
+	else
+		__skb_queue_head(&priv->tx_queue, skb);
 	spin_unlock_irqrestore(&priv->tx_queue.lock, flags);
 	return 0;
 }


