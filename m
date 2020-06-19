Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 786EE201381
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 18:07:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391978AbgFSPJx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 11:09:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:39656 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391973AbgFSPJv (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:09:51 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EEC8D21941;
        Fri, 19 Jun 2020 15:09:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592579390;
        bh=8DZyfMBj+GQYqoHgKvdO7+JnquptPSQNnrzE88QIKoc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NibE0LNvBhdulqksjjuITGrNtcTiBgJ2jEPOP1+c6GYHyuc8FHxiX94sZh2dP8hTH
         GA5mttl5ddSSvZj9I6hXWIh0Qzu0YefXmiG4nq/IGw8JIU0ePT71XM535SOavwc0eB
         xi1sywGDUJ8dj+zz3XHfdwnWQM1kgsDcrweNtSlM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 117/261] rtlwifi: Fix a double free in _rtl_usb_tx_urb_setup()
Date:   Fri, 19 Jun 2020 16:32:08 +0200
Message-Id: <20200619141655.480886333@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141649.878808811@linuxfoundation.org>
References: <20200619141649.878808811@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit beb12813bc75d4a23de43b85ad1c7cb28d27631e ]

Seven years ago we tried to fix a leak but actually introduced a double
free instead.  It was an understandable mistake because the code was a
bit confusing and the free was done in the wrong place.  The "skb"
pointer is freed in both _rtl_usb_tx_urb_setup() and _rtl_usb_transmit().
The free belongs _rtl_usb_transmit() instead of _rtl_usb_tx_urb_setup()
and I've cleaned the code up a bit to hopefully make it more clear.

Fixes: 36ef0b473fbf ("rtlwifi: usb: add missing freeing of skbuff")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20200513093951.GD347693@mwanda
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtlwifi/usb.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/usb.c b/drivers/net/wireless/realtek/rtlwifi/usb.c
index 348b0072cdd6..c66c6dc00378 100644
--- a/drivers/net/wireless/realtek/rtlwifi/usb.c
+++ b/drivers/net/wireless/realtek/rtlwifi/usb.c
@@ -881,10 +881,8 @@ static struct urb *_rtl_usb_tx_urb_setup(struct ieee80211_hw *hw,
 
 	WARN_ON(NULL == skb);
 	_urb = usb_alloc_urb(0, GFP_ATOMIC);
-	if (!_urb) {
-		kfree_skb(skb);
+	if (!_urb)
 		return NULL;
-	}
 	_rtl_install_trx_info(rtlusb, skb, ep_num);
 	usb_fill_bulk_urb(_urb, rtlusb->udev, usb_sndbulkpipe(rtlusb->udev,
 			  ep_num), skb->data, skb->len, _rtl_tx_complete, skb);
@@ -898,7 +896,6 @@ static void _rtl_usb_transmit(struct ieee80211_hw *hw, struct sk_buff *skb,
 	struct rtl_usb *rtlusb = rtl_usbdev(rtl_usbpriv(hw));
 	u32 ep_num;
 	struct urb *_urb = NULL;
-	struct sk_buff *_skb = NULL;
 
 	WARN_ON(NULL == rtlusb->usb_tx_aggregate_hdl);
 	if (unlikely(IS_USB_STOP(rtlusb))) {
@@ -907,8 +904,7 @@ static void _rtl_usb_transmit(struct ieee80211_hw *hw, struct sk_buff *skb,
 		return;
 	}
 	ep_num = rtlusb->ep_map.ep_mapping[qnum];
-	_skb = skb;
-	_urb = _rtl_usb_tx_urb_setup(hw, _skb, ep_num);
+	_urb = _rtl_usb_tx_urb_setup(hw, skb, ep_num);
 	if (unlikely(!_urb)) {
 		pr_err("Can't allocate urb. Drop skb!\n");
 		kfree_skb(skb);
-- 
2.25.1



