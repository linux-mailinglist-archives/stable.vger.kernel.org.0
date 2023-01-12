Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAD276674CB
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 15:13:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232770AbjALONJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 09:13:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234784AbjALOMD (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 09:12:03 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34CD259D30
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 06:05:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3F573B81DCC
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 14:05:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70FE1C433EF;
        Thu, 12 Jan 2023 14:05:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673532345;
        bh=IM5erb54z568krpX8fyJGzyCmMOBc6hLPqgUwXnQVyc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lbG/JCv+0fE0wE6Axa2hvOTTEyvnStQg44C/bkn1rhFHgvHJlmmsSxXsjjbzrD3Jv
         u+c2bYxlfW4dV4s7tBJGOez/O/wRi2fSwu+jofH+n2XUmQfc5DTRJ7P8UdFSRtQeGU
         ya0JdzZXGsS/N/UZTXvJ5RIrrxg5zLQZgLLchMb0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Fedor Pchelkin <pchelkin@ispras.ru>,
        Alexey Khoroshilov <khoroshilov@ispras.ru>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
        Kalle Valo <quic_kvalo@quicinc.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 104/783] wifi: ath9k: hif_usb: Fix use-after-free in ath9k_hif_usb_reg_in_cb()
Date:   Thu, 12 Jan 2023 14:47:00 +0100
Message-Id: <20230112135529.022044428@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fedor Pchelkin <pchelkin@ispras.ru>

[ Upstream commit dd95f2239fc846795fc926787c3ae0ca701c9840 ]

It is possible that skb is freed in ath9k_htc_rx_msg(), then
usb_submit_urb() fails and we try to free skb again. It causes
use-after-free bug. Moreover, if alloc_skb() fails, urb->context becomes
NULL but rx_buf is not freed and there can be a memory leak.

The patch removes unnecessary nskb and makes skb processing more clear: it
is supposed that ath9k_htc_rx_msg() either frees old skb or passes its
managing to another callback function.

Found by Linux Verification Center (linuxtesting.org) with Syzkaller.

Fixes: 3deff76095c4 ("ath9k_htc: Increase URB count for REG_IN pipe")
Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
Acked-by: Toke Høiland-Jørgensen <toke@toke.dk>
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://lore.kernel.org/r/20221008114917.21404-1-pchelkin@ispras.ru
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath9k/hif_usb.c | 28 +++++++++++++-----------
 1 file changed, 15 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hif_usb.c b/drivers/net/wireless/ath/ath9k/hif_usb.c
index e66518d86882..e5d5b0761881 100644
--- a/drivers/net/wireless/ath/ath9k/hif_usb.c
+++ b/drivers/net/wireless/ath/ath9k/hif_usb.c
@@ -709,14 +709,13 @@ static void ath9k_hif_usb_reg_in_cb(struct urb *urb)
 	struct rx_buf *rx_buf = (struct rx_buf *)urb->context;
 	struct hif_device_usb *hif_dev = rx_buf->hif_dev;
 	struct sk_buff *skb = rx_buf->skb;
-	struct sk_buff *nskb;
 	int ret;
 
 	if (!skb)
 		return;
 
 	if (!hif_dev)
-		goto free;
+		goto free_skb;
 
 	switch (urb->status) {
 	case 0:
@@ -725,7 +724,7 @@ static void ath9k_hif_usb_reg_in_cb(struct urb *urb)
 	case -ECONNRESET:
 	case -ENODEV:
 	case -ESHUTDOWN:
-		goto free;
+		goto free_skb;
 	default:
 		skb_reset_tail_pointer(skb);
 		skb_trim(skb, 0);
@@ -736,25 +735,27 @@ static void ath9k_hif_usb_reg_in_cb(struct urb *urb)
 	if (likely(urb->actual_length != 0)) {
 		skb_put(skb, urb->actual_length);
 
-		/* Process the command first */
+		/*
+		 * Process the command first.
+		 * skb is either freed here or passed to be
+		 * managed to another callback function.
+		 */
 		ath9k_htc_rx_msg(hif_dev->htc_handle, skb,
 				 skb->len, USB_REG_IN_PIPE);
 
-
-		nskb = alloc_skb(MAX_REG_IN_BUF_SIZE, GFP_ATOMIC);
-		if (!nskb) {
+		skb = alloc_skb(MAX_REG_IN_BUF_SIZE, GFP_ATOMIC);
+		if (!skb) {
 			dev_err(&hif_dev->udev->dev,
 				"ath9k_htc: REG_IN memory allocation failure\n");
-			urb->context = NULL;
-			return;
+			goto free_rx_buf;
 		}
 
-		rx_buf->skb = nskb;
+		rx_buf->skb = skb;
 
 		usb_fill_int_urb(urb, hif_dev->udev,
 				 usb_rcvintpipe(hif_dev->udev,
 						 USB_REG_IN_PIPE),
-				 nskb->data, MAX_REG_IN_BUF_SIZE,
+				 skb->data, MAX_REG_IN_BUF_SIZE,
 				 ath9k_hif_usb_reg_in_cb, rx_buf, 1);
 	}
 
@@ -763,12 +764,13 @@ static void ath9k_hif_usb_reg_in_cb(struct urb *urb)
 	ret = usb_submit_urb(urb, GFP_ATOMIC);
 	if (ret) {
 		usb_unanchor_urb(urb);
-		goto free;
+		goto free_skb;
 	}
 
 	return;
-free:
+free_skb:
 	kfree_skb(skb);
+free_rx_buf:
 	kfree(rx_buf);
 	urb->context = NULL;
 }
-- 
2.35.1



