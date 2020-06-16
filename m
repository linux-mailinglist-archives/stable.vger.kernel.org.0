Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D1FA1FB660
	for <lists+stable@lfdr.de>; Tue, 16 Jun 2020 17:38:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729547AbgFPPgk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Jun 2020 11:36:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:47542 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729546AbgFPPgj (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Jun 2020 11:36:39 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E0BA020B1F;
        Tue, 16 Jun 2020 15:36:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592321798;
        bh=KZN4esAhNn4tE9475bsicHCYB2W4CJffoDW1qFb/rn8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ADiKfhIDY+rlDlD2Y9+vpQ3fShnZGZT6vTxFXpgEmD4m5Rqb/A2XWcOt0uaszir+s
         WbxDikWvzUhi9Q0MVDHUas9mrqi/8ptQxCEa9NDTdr9cPK6wNqEDg/KaF52f+UARuT
         ekLjZYLDVtLeleTBqQSYpa7I04aDRKad1x7y+o2s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Denis <pro.denis@protonmail.com>,
        Masashi Honma <masashi.honma@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 020/134] ath9k_htc: Silence undersized packet warnings
Date:   Tue, 16 Jun 2020 17:33:24 +0200
Message-Id: <20200616153101.683796019@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200616153100.633279950@linuxfoundation.org>
References: <20200616153100.633279950@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masashi Honma <masashi.honma@gmail.com>

[ Upstream commit 450edd2805982d14ed79733a82927d2857b27cac ]

Some devices like TP-Link TL-WN722N produces this kind of messages
frequently.

kernel: ath: phy0: Short RX data len, dropping (dlen: 4)

This warning is useful for developers to recognize that the device
(Wi-Fi dongle or USB hub etc) is noisy but not for general users. So
this patch make this warning to debug message.

Reported-By: Denis <pro.denis@protonmail.com>
Ref: https://bugzilla.kernel.org/show_bug.cgi?id=207539
Fixes: cd486e627e67 ("ath9k_htc: Discard undersized packets")
Signed-off-by: Masashi Honma <masashi.honma@gmail.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20200504214443.4485-1-masashi.honma@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
index 9cec5c216e1f..118e5550b10c 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
@@ -999,9 +999,9 @@ static bool ath9k_rx_prepare(struct ath9k_htc_priv *priv,
 	 * which are not PHY_ERROR (short radar pulses have a length of 3)
 	 */
 	if (unlikely(!rs_datalen || (rs_datalen < 10 && !is_phyerr))) {
-		ath_warn(common,
-			 "Short RX data len, dropping (dlen: %d)\n",
-			 rs_datalen);
+		ath_dbg(common, ANY,
+			"Short RX data len, dropping (dlen: %d)\n",
+			rs_datalen);
 		goto rx_next;
 	}
 
-- 
2.25.1



