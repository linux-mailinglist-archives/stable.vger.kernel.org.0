Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F514137E00
	for <lists+stable@lfdr.de>; Sat, 11 Jan 2020 11:04:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729333AbgAKKD5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jan 2020 05:03:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:35726 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728850AbgAKKD5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Jan 2020 05:03:57 -0500
Received: from localhost (unknown [62.119.166.9])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 148A320848;
        Sat, 11 Jan 2020 10:03:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578737037;
        bh=fGuciEcsdfsX09LD7VTdPj3qRBcgigr8Fz+R5DKgs6A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Qay2B+h5hTkXj1Q83lN2d7T0QZ+BzqLb6eyJNLsJgogFqJtjSysP4ua0zlDbJybU+
         Wp95xHktwg+VlPHMTX/DJIXrXx8fEfKLliZnKfSLaoPHO/Wu42dSG83j42ZuoulKds
         gRshfJO6Wl5YhBbp0vVjeWnxNzWl/254woAMWN58=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Masashi Honma <masashi.honma@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 50/91] ath9k_htc: Modify byte order for an error message
Date:   Sat, 11 Jan 2020 10:49:43 +0100
Message-Id: <20200111094903.848661114@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200111094844.748507863@linuxfoundation.org>
References: <20200111094844.748507863@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masashi Honma <masashi.honma@gmail.com>

[ Upstream commit e01fddc19d215f6ad397894ec2a851d99bf154e2 ]

rs_datalen is be16 so we need to convert it before printing.

Signed-off-by: Masashi Honma <masashi.honma@gmail.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
index f333ef1e3e7b..92156e519168 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
@@ -985,7 +985,7 @@ static bool ath9k_rx_prepare(struct ath9k_htc_priv *priv,
 	    (skb->len - HTC_RX_FRAME_HEADER_SIZE) != 0) {
 		ath_err(common,
 			"Corrupted RX data len, dropping (dlen: %d, skblen: %d)\n",
-			rxstatus->rs_datalen, skb->len);
+			be16_to_cpu(rxstatus->rs_datalen), skb->len);
 		goto rx_next;
 	}
 
-- 
2.20.1



