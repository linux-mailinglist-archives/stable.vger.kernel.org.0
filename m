Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 866951018D1
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 07:11:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728843AbfKSGJF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 01:09:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:47984 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728990AbfKSF3X (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:29:23 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9959621939;
        Tue, 19 Nov 2019 05:29:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574141363;
        bh=v0Q4Snohb0rPBMGpAzHmPvwE44PlPjfHwBHTVwdU0+k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vtJbdPsSAaIquVqAeAzN1aMkbxUZYAF1cBJOoKRAZSQ9ccygzn3uKB0Fi+buI/b4G
         p75X9c+ZWVa8DJz5MyhyZEKP8DN3TubdVfm0PhDdTgCcjtf3t2nzxpoSKWOVN5C7bG
         TznWK7Td6izoFROXhHVOJKbvQWA9Noemi26j7tIw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vidya Dharmaraju <vidyad@marvell.com>,
        Cathy Luo <cluo@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 098/422] mwifex: free rx_cmd skb in suspended state
Date:   Tue, 19 Nov 2019 06:14:55 +0100
Message-Id: <20191119051405.626442318@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119051400.261610025@linuxfoundation.org>
References: <20191119051400.261610025@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ganapathi Bhat <gbhat@marvell.com>

[ Upstream commit 33a164fa8a4c91408e0b7738f754cb1a7827c5f2 ]

USB suspend handler will kill the presubmitted rx_cmd URB. This
triggers a call to the corresponding URB complete handler, which
will free the rx_cmd skb, associated with rx_cmd URB. Due to a
possible race betwen suspend handler and main thread, depicted in
'commit bfcacac6c84b ("mwifiex: do no submit URB in suspended
state")', it is possible that the rx_cmd skb will fail to get
freed. This causes a memory leak, since the resume handler will
always allocate a new rx_cmd skb.

To fix this, free the rx_cmd skb in mwifiex_usb_submit_rx_urb, if
the device is in suspended state.

Signed-off-by: Vidya Dharmaraju <vidyad@marvell.com>
Signed-off-by: Cathy Luo <cluo@marvell.com>
Signed-off-by: Ganapathi Bhat <gbhat@marvell.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/marvell/mwifiex/usb.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/wireless/marvell/mwifiex/usb.c b/drivers/net/wireless/marvell/mwifiex/usb.c
index 76d80fd545236..d445acc4786b7 100644
--- a/drivers/net/wireless/marvell/mwifiex/usb.c
+++ b/drivers/net/wireless/marvell/mwifiex/usb.c
@@ -299,6 +299,12 @@ static int mwifiex_usb_submit_rx_urb(struct urb_context *ctx, int size)
 	struct usb_card_rec *card = (struct usb_card_rec *)adapter->card;
 
 	if (test_bit(MWIFIEX_IS_SUSPENDED, &adapter->work_flags)) {
+		if (card->rx_cmd_ep == ctx->ep) {
+			mwifiex_dbg(adapter, INFO, "%s: free rx_cmd skb\n",
+				    __func__);
+			dev_kfree_skb_any(ctx->skb);
+			ctx->skb = NULL;
+		}
 		mwifiex_dbg(adapter, ERROR,
 			    "%s: card removed/suspended, EP %d rx_cmd URB submit skipped\n",
 			    __func__, ctx->ep);
-- 
2.20.1



