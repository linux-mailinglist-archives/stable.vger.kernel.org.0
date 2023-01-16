Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B66FA66CA04
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:58:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231160AbjAPQ6x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:58:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233908AbjAPQ54 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:57:56 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 124BF55B0
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:40:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4CEB361089
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:40:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A9DBC433EF;
        Mon, 16 Jan 2023 16:40:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673887255;
        bh=ggP3ajWo0nwgC6SmpC9atidOUR1X+2poO113chbmYws=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zGsj0qszsauXWseh6Cb4/DDIf29aSUCxejTNTDROhKng/aqKDLkroXtDoqUyxkm0F
         AVsOHvBS0cZKv5DtXNZqrW7zmKVO2f6/zg2ZWeUsnD5Aq0t07XZSXaxv3HgMxsyiEI
         5aaOVUEgtHHbtle/5dg0bsZEmiJyjB1zI9qEaN+8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Fedor Pchelkin <pchelkin@ispras.ru>,
        Alexey Khoroshilov <khoroshilov@ispras.ru>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
        Kalle Valo <quic_kvalo@quicinc.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 080/521] wifi: ath9k: hif_usb: fix memory leak of urbs in ath9k_hif_usb_dealloc_tx_urbs()
Date:   Mon, 16 Jan 2023 16:45:42 +0100
Message-Id: <20230116154850.812565138@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154847.246743274@linuxfoundation.org>
References: <20230116154847.246743274@linuxfoundation.org>
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

[ Upstream commit c2a94de38c74e86f49124ac14f093d6a5c377a90 ]

Syzkaller reports a long-known leak of urbs in
ath9k_hif_usb_dealloc_tx_urbs().

The cause of the leak is that usb_get_urb() is called but usb_free_urb()
(or usb_put_urb()) is not called inside usb_kill_urb() as urb->dev or
urb->ep fields have not been initialized and usb_kill_urb() returns
immediately.

The patch removes trying to kill urbs located in hif_dev->tx.tx_buf
because hif_dev->tx.tx_buf is not supposed to contain urbs which are in
pending state (the pending urbs are stored in hif_dev->tx.tx_pending).
The tx.tx_lock is acquired so there should not be any changes in the list.

Found by Linux Verification Center (linuxtesting.org) with Syzkaller.

Fixes: 03fb92a432ea ("ath9k: hif_usb: fix race condition between usb_get_urb() and usb_kill_anchored_urbs()")
Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
Acked-by: Toke Høiland-Jørgensen <toke@toke.dk>
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://lore.kernel.org/r/20220725151359.283704-1-pchelkin@ispras.ru
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath9k/hif_usb.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hif_usb.c b/drivers/net/wireless/ath/ath9k/hif_usb.c
index c8c7afe0e343..4290753a2002 100644
--- a/drivers/net/wireless/ath/ath9k/hif_usb.c
+++ b/drivers/net/wireless/ath/ath9k/hif_usb.c
@@ -781,14 +781,10 @@ static void ath9k_hif_usb_dealloc_tx_urbs(struct hif_device_usb *hif_dev)
 	spin_lock_irqsave(&hif_dev->tx.tx_lock, flags);
 	list_for_each_entry_safe(tx_buf, tx_buf_tmp,
 				 &hif_dev->tx.tx_buf, list) {
-		usb_get_urb(tx_buf->urb);
-		spin_unlock_irqrestore(&hif_dev->tx.tx_lock, flags);
-		usb_kill_urb(tx_buf->urb);
 		list_del(&tx_buf->list);
 		usb_free_urb(tx_buf->urb);
 		kfree(tx_buf->buf);
 		kfree(tx_buf);
-		spin_lock_irqsave(&hif_dev->tx.tx_lock, flags);
 	}
 	spin_unlock_irqrestore(&hif_dev->tx.tx_lock, flags);
 
-- 
2.35.1



