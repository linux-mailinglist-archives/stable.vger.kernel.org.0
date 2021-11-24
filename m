Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9ED9945B9B6
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 13:02:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242030AbhKXME1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 07:04:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:59164 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242031AbhKXMEB (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 07:04:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 37D1360F90;
        Wed, 24 Nov 2021 12:00:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637755251;
        bh=88fEqXZU4BwNbyM5NCF+1otnSinxSG1Z5ZrzXyALbrc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nda7kAmQrwIVzGn9TDl46aAiJ+8pBtW/CSdLv+i3zxN0+sHhLtxhT3B15m9gmTejE
         LMhCJIzIZtI9VKbrH3ufUFgJI0U8tViEEmPVY3IeeNMvyo0yXYvKm77V4nApcx83N3
         uTCmTRgt6FrmI8PYIqwsd0aMP6rtAWQEFMjIJBvc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH 4.4 027/162] ath6kl: fix division by zero in send path
Date:   Wed, 24 Nov 2021 12:55:30 +0100
Message-Id: <20211124115659.205419920@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115658.328640564@linuxfoundation.org>
References: <20211124115658.328640564@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

commit c1b9ca365deae667192be9fe24db244919971234 upstream.

Add the missing endpoint max-packet sanity check to probe() to avoid
division by zero in ath10k_usb_hif_tx_sg() in case a malicious device
has broken descriptors (or when doing descriptor fuzz testing).

Note that USB core will reject URBs submitted for endpoints with zero
wMaxPacketSize but that drivers doing packet-size calculations still
need to handle this (cf. commit 2548288b4fb0 ("USB: Fix: Don't skip
endpoint descriptors with maxpacket=0")).

Fixes: 9cbee358687e ("ath6kl: add full USB support")
Cc: stable@vger.kernel.org      # 3.5
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20211027080819.6675-3-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/ath/ath6kl/usb.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/net/wireless/ath/ath6kl/usb.c
+++ b/drivers/net/wireless/ath/ath6kl/usb.c
@@ -340,6 +340,11 @@ static int ath6kl_usb_setup_pipe_resourc
 				   le16_to_cpu(endpoint->wMaxPacketSize),
 				   endpoint->bInterval);
 		}
+
+		/* Ignore broken descriptors. */
+		if (usb_endpoint_maxp(endpoint) == 0)
+			continue;
+
 		urbcount = 0;
 
 		pipe_num =


