Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EBF02B66A9
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 15:06:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729298AbgKQNIg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:08:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:32890 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728708AbgKQNGi (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:06:38 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2D5E92225B;
        Tue, 17 Nov 2020 13:06:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605618397;
        bh=UqX3J/RJVNYfzm/ipwXr6y2gSN/rI6H90ExlfyC06Z8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QJSSB42hUyQFtLl9s/XZIx9VZcGBRfFfjgCL0WLZZwodV30RiTm9bFZA7paUJ2Ygf
         TDyvWN/j3Uj0OKVk8Z2K/0IBbFecghaACEmxSg1Unb/FLx6jpKrZGCGlRRlEXKyDBv
         ne26fbK9xdVniuGWEgza/7P9OdDD0J2cGdPTHLUc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Masashi Honma <masashi.honma@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH 4.4 19/64] ath9k_htc: Use appropriate rs_datalen type
Date:   Tue, 17 Nov 2020 14:04:42 +0100
Message-Id: <20201117122107.077116163@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122106.144800239@linuxfoundation.org>
References: <20201117122106.144800239@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masashi Honma <masashi.honma@gmail.com>

commit 5024f21c159f8c1668f581fff37140741c0b1ba9 upstream.

kernel test robot says:
drivers/net/wireless/ath/ath9k/htc_drv_txrx.c:987:20: sparse: warning: incorrect type in assignment (different base types)
drivers/net/wireless/ath/ath9k/htc_drv_txrx.c:987:20: sparse:    expected restricted __be16 [usertype] rs_datalen
drivers/net/wireless/ath/ath9k/htc_drv_txrx.c:987:20: sparse:    got unsigned short [usertype]
drivers/net/wireless/ath/ath9k/htc_drv_txrx.c:988:13: sparse: warning: restricted __be16 degrades to integer
drivers/net/wireless/ath/ath9k/htc_drv_txrx.c:1001:13: sparse: warning: restricted __be16 degrades to integer

Indeed rs_datalen has host byte order, so modify it's own type.

Reported-by: kernel test robot <lkp@intel.com>
Fixes: cd486e627e67 ("ath9k_htc: Discard undersized packets")
Signed-off-by: Masashi Honma <masashi.honma@gmail.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20200808233258.4596-1-masashi.honma@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
@@ -972,7 +972,7 @@ static bool ath9k_rx_prepare(struct ath9
 	struct ath_htc_rx_status *rxstatus;
 	struct ath_rx_status rx_stats;
 	bool decrypt_error = false;
-	__be16 rs_datalen;
+	u16 rs_datalen;
 	bool is_phyerr;
 
 	if (skb->len < HTC_RX_FRAME_HEADER_SIZE) {


