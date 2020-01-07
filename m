Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50B941333DD
	for <lists+stable@lfdr.de>; Tue,  7 Jan 2020 22:22:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726916AbgAGVV6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jan 2020 16:21:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:43404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727674AbgAGVCw (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jan 2020 16:02:52 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 53F7C2087F;
        Tue,  7 Jan 2020 21:02:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578430971;
        bh=fMxU4Ji23dscU2HFhQSo69r/RFx8TnxmeDLa/9VrNCk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uucKK7wxP4/NDFZf3tfA6iiUp5ZUxm0t7LztvFdfAyshltt45+o7jYQPvKp3WY+bI
         RrT63vlNj1eiOi/wAjif/vo6oV0X0t3YUbYSImbJMyxtWiy6c9hb3N6QT91wEIUrTp
         xoylGtakvqt9/IBgboRh+46k6fbwkF/6DPL8AtYg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Masashi Honma <masashi.honma@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 173/191] ath9k_htc: Modify byte order for an error message
Date:   Tue,  7 Jan 2020 21:54:53 +0100
Message-Id: <20200107205342.258317105@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200107205332.984228665@linuxfoundation.org>
References: <20200107205332.984228665@linuxfoundation.org>
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
index 4e8e80ac8341..aba0d454c381 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
@@ -986,7 +986,7 @@ static bool ath9k_rx_prepare(struct ath9k_htc_priv *priv,
 	    (skb->len - HTC_RX_FRAME_HEADER_SIZE) != 0) {
 		ath_err(common,
 			"Corrupted RX data len, dropping (dlen: %d, skblen: %d)\n",
-			rxstatus->rs_datalen, skb->len);
+			be16_to_cpu(rxstatus->rs_datalen), skb->len);
 		goto rx_next;
 	}
 
-- 
2.20.1



