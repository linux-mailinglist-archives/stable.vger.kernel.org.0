Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E3526578B9
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 15:53:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233155AbiL1Oxi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 09:53:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233172AbiL1Ox3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 09:53:29 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46CAA29B
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 06:53:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0237AB8171C
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 14:53:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70058C433D2;
        Wed, 28 Dec 2022 14:53:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672239205;
        bh=VJxPKKHubdRnS3rmVeCDm342MKvsm8V72IQ0QfMalNo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SbGSgovfMH0deIfGFdSRlXR8XO4cyduXRBMEqqal3onkUMPK/Uy9waF7iJL2J2IRC
         TMdmogROJ9ISO1tsToevDaoDmxbfeq0NTwUJYbLeRVBvjPZUFLTF6/cDPE+Rfohsj1
         L5T7oN80CXdUsrv3NRvEN566Xr9el8jaDoUhd4aQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Fedor Pchelkin <pchelkin@ispras.ru>,
        Alexey Khoroshilov <khoroshilov@ispras.ru>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
        Kalle Valo <quic_kvalo@quicinc.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 141/731] wifi: ath9k: hif_usb: fix memory leak of urbs in ath9k_hif_usb_dealloc_tx_urbs()
Date:   Wed, 28 Dec 2022 15:34:08 +0100
Message-Id: <20221228144300.636480751@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
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
index f06eec99de68..e66518d86882 100644
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



