Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EAF46EEDCB
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 23:10:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389452AbfKDWJ6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 17:09:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:43102 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387458AbfKDWJ4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Nov 2019 17:09:56 -0500
Received: from localhost (6.204-14-84.ripe.coltfrance.com [84.14.204.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 25A4E205C9;
        Mon,  4 Nov 2019 22:09:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572905395;
        bh=H86na4SwTHD42al8jI4omt8W7BwlKnekQUgfHXUlBbY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oUwjBCH62r0R7VGir0w/jXWNCi++GL7oRYHhY+Vrh9PfEcZUq/jvZIhnSe/TuAKxo
         Rr0XVWg8tlFIAyi6wCpYT0gusL7J69zbiinMA9gUWQxbLMqEkM9KU5jbRTV6PcOafy
         1huo47QnVmm8Gz0oGS8y5MA73H5zHtsf7D2e4BLk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Larry Finger <Larry.Finger@lwfinger.net>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH 5.3 130/163] rtlwifi: rtl_pci: Fix problem of too small skb->len
Date:   Mon,  4 Nov 2019 22:45:20 +0100
Message-Id: <20191104212149.737476048@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191104212140.046021995@linuxfoundation.org>
References: <20191104212140.046021995@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Larry Finger <Larry.Finger@lwfinger.net>

commit b43f4a169f220e459edf3ea8f8cd3ec4ae7fa82d upstream.

In commit 8020919a9b99 ("mac80211: Properly handle SKB with radiotap
only"), buffers whose length is too short cause a WARN_ON(1) to be
executed. This change exposed a fault in rtlwifi drivers, which is fixed
by regarding packets with skb->len <= FCS_LEN as though they are in error
and dropping them. The test is now annotated as likely.

Cc: Stable <stable@vger.kernel.org> # v5.0+
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/realtek/rtlwifi/pci.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/net/wireless/realtek/rtlwifi/pci.c
+++ b/drivers/net/wireless/realtek/rtlwifi/pci.c
@@ -822,7 +822,7 @@ static void _rtl_pci_rx_interrupt(struct
 		hdr = rtl_get_hdr(skb);
 		fc = rtl_get_fc(skb);
 
-		if (!stats.crc && !stats.hwerror) {
+		if (!stats.crc && !stats.hwerror && (skb->len > FCS_LEN)) {
 			memcpy(IEEE80211_SKB_RXCB(skb), &rx_status,
 			       sizeof(rx_status));
 
@@ -859,6 +859,7 @@ static void _rtl_pci_rx_interrupt(struct
 				_rtl_pci_rx_to_mac80211(hw, skb, rx_status);
 			}
 		} else {
+			/* drop packets with errors or those too short */
 			dev_kfree_skb_any(skb);
 		}
 new_trx_end:


