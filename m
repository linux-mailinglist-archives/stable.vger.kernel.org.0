Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 80D39167042
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 08:43:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726853AbgBUHnn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 02:43:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:38120 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726045AbgBUHnm (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 02:43:42 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8E7C020801;
        Fri, 21 Feb 2020 07:43:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582271021;
        bh=gnFCA0YLoSCVotL7bGApUYDpuF8NUTKSgkzZLI+u9qg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zWvWYgTzt7gh2zT/M1JPcQCqweImff96AmmvCMqIcoeFK1XxF9F8BbTtxiTR3EtgO
         qCPiXmuBsnxNqOEsr8Hx5GzQAfzwJeQvMjed/ncrKJiZ3mFd44DZ+zc7GfWy0nGDlQ
         2dHU3R5fPkqQjhop2Mfcx9O13NrTRNoek0JXams0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Maya Erez <merez@codeaurora.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.5 010/399] wil6210: fix break that is never reached because of zeroing of a retry counter
Date:   Fri, 21 Feb 2020 08:35:35 +0100
Message-Id: <20200221072403.316856665@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221072402.315346745@linuxfoundation.org>
References: <20200221072402.315346745@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

[ Upstream commit 5b1413f00b5beb9f5fed94e43ea0c497d5db9633 ]

There is a check on the retry counter invalid_buf_id_retry that is always
false because invalid_buf_id_retry is initialized to zero on each iteration
of a while-loop.  Fix this by initializing the retry counter before the
while-loop starts.

Addresses-Coverity: ("Logically dead code")
Fixes: b4a967b7d0f5 ("wil6210: reset buff id in status message after completion")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Reviewed-by: Maya Erez <merez@codeaurora.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/wil6210/txrx_edma.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/wil6210/txrx_edma.c b/drivers/net/wireless/ath/wil6210/txrx_edma.c
index 778b63be6a9a4..02548d40253c7 100644
--- a/drivers/net/wireless/ath/wil6210/txrx_edma.c
+++ b/drivers/net/wireless/ath/wil6210/txrx_edma.c
@@ -869,6 +869,7 @@ static struct sk_buff *wil_sring_reap_rx_edma(struct wil6210_priv *wil,
 	u8 data_offset;
 	struct wil_rx_status_extended *s;
 	u16 sring_idx = sring - wil->srings;
+	int invalid_buff_id_retry;
 
 	BUILD_BUG_ON(sizeof(struct wil_rx_status_extended) > sizeof(skb->cb));
 
@@ -882,9 +883,9 @@ again:
 	/* Extract the buffer ID from the status message */
 	buff_id = le16_to_cpu(wil_rx_status_get_buff_id(msg));
 
+	invalid_buff_id_retry = 0;
 	while (!buff_id) {
 		struct wil_rx_status_extended *s;
-		int invalid_buff_id_retry = 0;
 
 		wil_dbg_txrx(wil,
 			     "buff_id is not updated yet by HW, (swhead 0x%x)\n",
-- 
2.20.1



