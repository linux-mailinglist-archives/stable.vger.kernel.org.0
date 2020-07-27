Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE8C122EFBE
	for <lists+stable@lfdr.de>; Mon, 27 Jul 2020 16:19:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731295AbgG0OSx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jul 2020 10:18:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:46662 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731313AbgG0OSw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Jul 2020 10:18:52 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9775B2070A;
        Mon, 27 Jul 2020 14:18:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595859532;
        bh=sDEnlAlhFB/QP2r2vRPVPqWMEAb7Ot7M+9SnlkSmfxE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2qmXsq1YzsMeTHKCfjSNfS13TEY03IRNtiAwhnTgTe8lf2GhcSHKuDu2d0+kmT1AD
         ASn4vPzSHfJcE5rLGiIsMdSVbtXhZrN5/WsUG6sTEtT/FEnLnqO8uIH6Ou8Tvqq/us
         Y5o7TOatKfQa1m5RsWASttpm95wK2wKdC2/tJWs4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mark ODonovan <shiftee@posteo.net>,
        Roman Mamedov <rm@romanrm.net>,
        =?UTF-8?q?Viktor=20J=C3=A4gersk=C3=BCpper?= 
        <viktor_jaegerskuepper@freenet.de>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH 5.4 138/138] ath9k: Fix regression with Atheros 9271
Date:   Mon, 27 Jul 2020 16:05:33 +0200
Message-Id: <20200727134932.314172471@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200727134925.228313570@linuxfoundation.org>
References: <20200727134925.228313570@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mark O'Donovan <shiftee@posteo.net>

commit 92f53e2fda8bb9a559ad61d57bfb397ce67ed0ab upstream.

This fix allows ath9k_htc modules to connect to WLAN once again.

Fixes: 2bbcaaee1fcb ("ath9k: Fix general protection fault in ath9k_hif_usb_rx_cb")
Link: https://bugzilla.kernel.org/show_bug.cgi?id=208251
Signed-off-by: Mark O'Donovan <shiftee@posteo.net>
Reported-by: Roman Mamedov <rm@romanrm.net>
Tested-by: Viktor Jägersküpper <viktor_jaegerskuepper@freenet.de>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20200711043324.8079-1-shiftee@posteo.net
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/ath/ath9k/hif_usb.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/net/wireless/ath/ath9k/hif_usb.c
+++ b/drivers/net/wireless/ath/ath9k/hif_usb.c
@@ -733,11 +733,13 @@ static void ath9k_hif_usb_reg_in_cb(stru
 			return;
 		}
 
+		rx_buf->skb = nskb;
+
 		usb_fill_int_urb(urb, hif_dev->udev,
 				 usb_rcvintpipe(hif_dev->udev,
 						 USB_REG_IN_PIPE),
 				 nskb->data, MAX_REG_IN_BUF_SIZE,
-				 ath9k_hif_usb_reg_in_cb, nskb, 1);
+				 ath9k_hif_usb_reg_in_cb, rx_buf, 1);
 	}
 
 resubmit:


