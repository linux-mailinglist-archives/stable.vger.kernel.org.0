Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66E45450AE0
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 18:12:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232398AbhKORP2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 12:15:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:49400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236781AbhKOROS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 12:14:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 46E0E63247;
        Mon, 15 Nov 2021 17:10:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636996254;
        bh=PiJotiG7E8HB4ISsbhYdcpDQF7jUouKuV9qQJNfTihw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s3GgfgFrjtIPJ77BZYOeiVhRzdR6Cn4f8ujMH/DMmiMblxJtgAdjwegh1EUezerAb
         3PHiV10tXQtD4/4fu2LZZgwAsRHStkV0QJjeOBO53bEMn+YYfSi4vCIZJ4vb9Z+Ymf
         aUFmOmOwNWHTcbqNnxCwQOvs02ZACl72EqwpvFPA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Erik Stromdahl <erik.stromdahl@gmail.com>,
        Johan Hovold <johan@kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH 5.4 073/355] ath10k: fix division by zero in send path
Date:   Mon, 15 Nov 2021 17:59:57 +0100
Message-Id: <20211115165316.167019020@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165313.549179499@linuxfoundation.org>
References: <20211115165313.549179499@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

commit a006acb931317aad3a8dd41333ebb0453caf49b8 upstream.

Add the missing endpoint max-packet sanity check to probe() to avoid
division by zero in ath10k_usb_hif_tx_sg() in case a malicious device
has broken descriptors (or when doing descriptor fuzz testing).

Note that USB core will reject URBs submitted for endpoints with zero
wMaxPacketSize but that drivers doing packet-size calculations still
need to handle this (cf. commit 2548288b4fb0 ("USB: Fix: Don't skip
endpoint descriptors with maxpacket=0")).

Fixes: 4db66499df91 ("ath10k: add initial USB support")
Cc: stable@vger.kernel.org      # 4.14
Cc: Erik Stromdahl <erik.stromdahl@gmail.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20211027080819.6675-2-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/ath/ath10k/usb.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/net/wireless/ath/ath10k/usb.c
+++ b/drivers/net/wireless/ath/ath10k/usb.c
@@ -865,6 +865,11 @@ static int ath10k_usb_setup_pipe_resourc
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


