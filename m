Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BF7F259CE6
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 19:21:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728688AbgIAPMV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 11:12:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:54522 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728621AbgIAPMP (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:12:15 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 14065208CA;
        Tue,  1 Sep 2020 15:12:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598973135;
        bh=hHUvp922SWc2IPNph8CU63+DEsuuCprdRe5rKrlA2u8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=idr0BT666SRqbLk6Qc+QhokYEMZO4BmeXDB6Z4eK2oglNTEtXB4InSYTMvBpWESHv
         dDgFc6hQpIRy1C7v/gkM4UzBqvH2VRQ2dtighPg5EEq57g08XZ2IA1mTWfTm8CU2xq
         KPDFon2Mp3kIYps3ipKmHkWujWTZkl6JXOv8V/RA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Reto Schneider <code@reto-schneider.ch>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 20/62] rtlwifi: rtl8192cu: Prevent leaking urb
Date:   Tue,  1 Sep 2020 17:10:03 +0200
Message-Id: <20200901150921.748318082@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901150920.697676718@linuxfoundation.org>
References: <20200901150920.697676718@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Reto Schneider <code@reto-schneider.ch>

[ Upstream commit 03128643eb5453a798db5770952c73dc64fcaf00 ]

If usb_submit_urb fails the allocated urb should be unanchored and
released.

Signed-off-by: Reto Schneider <code@reto-schneider.ch>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20200622132113.14508-3-code@reto-schneider.ch
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtlwifi/usb.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/usb.c b/drivers/net/wireless/realtek/rtlwifi/usb.c
index 9408c1f8e3977..f01ef8ecfaf39 100644
--- a/drivers/net/wireless/realtek/rtlwifi/usb.c
+++ b/drivers/net/wireless/realtek/rtlwifi/usb.c
@@ -755,8 +755,11 @@ static int _rtl_usb_receive(struct ieee80211_hw *hw)
 
 		usb_anchor_urb(urb, &rtlusb->rx_submitted);
 		err = usb_submit_urb(urb, GFP_KERNEL);
-		if (err)
+		if (err) {
+			usb_unanchor_urb(urb);
+			usb_free_urb(urb);
 			goto err_out;
+		}
 		usb_free_urb(urb);
 	}
 	return 0;
-- 
2.25.1



