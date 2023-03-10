Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F47E6B43B2
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:16:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232093AbjCJOQx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:16:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232013AbjCJOQU (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:16:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E037811786A
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:15:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 99751B822B5
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:15:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF6A3C4339E;
        Fri, 10 Mar 2023 14:15:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678457737;
        bh=5AqFIXHo3XPoCCjNXubvIOZGKq2Wd7n5trrl0V2l9lY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EuWCapOHexCAIGq6tozLoRxQbwLeI8JPuLqOeFzCGOOzHHw88WFnH3S1Fpm4jLU3E
         aP0gv5b575xZGtjJB5oov9dxZRcm6Q4RLHqFYtVW/DsPXW7mvRXI0jhQADU41U4IC3
         A8XnqvaUjVQ9SA99r6Ic9Kj5cxHWTXD+xk4XtJmU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        syzbot+e008dccab31bd3647609@syzkaller.appspotmail.com,
        syzbot+6692c72009680f7c4eb2@syzkaller.appspotmail.com,
        Fedor Pchelkin <pchelkin@ispras.ru>,
        Alexey Khoroshilov <khoroshilov@ispras.ru>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
        Kalle Valo <quic_kvalo@quicinc.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 040/252] wifi: ath9k: htc_hst: free skb in ath9k_htc_rx_msg() if there is no callback function
Date:   Fri, 10 Mar 2023 14:36:50 +0100
Message-Id: <20230310133720.037424073@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133718.803482157@linuxfoundation.org>
References: <20230310133718.803482157@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fedor Pchelkin <pchelkin@ispras.ru>

[ Upstream commit 9b25e3985477ac3f02eca5fc1e0cc6850a3f7e69 ]

It is stated that ath9k_htc_rx_msg() either frees the provided skb or
passes its management to another callback function. However, the skb is
not freed in case there is no another callback function, and Syzkaller was
able to cause a memory leak. Also minor comment fix.

Found by Linux Verification Center (linuxtesting.org) with Syzkaller.

Fixes: fb9987d0f748 ("ath9k_htc: Support for AR9271 chipset.")
Reported-by: syzbot+e008dccab31bd3647609@syzkaller.appspotmail.com
Reported-by: syzbot+6692c72009680f7c4eb2@syzkaller.appspotmail.com
Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
Acked-by: Toke Høiland-Jørgensen <toke@toke.dk>
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://lore.kernel.org/r/20230104123546.51427-1-pchelkin@ispras.ru
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath9k/htc_hst.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc_hst.c b/drivers/net/wireless/ath/ath9k/htc_hst.c
index 6d69cf69fd86e..6331c98088e03 100644
--- a/drivers/net/wireless/ath/ath9k/htc_hst.c
+++ b/drivers/net/wireless/ath/ath9k/htc_hst.c
@@ -394,7 +394,7 @@ static void ath9k_htc_fw_panic_report(struct htc_target *htc_handle,
  * HTC Messages are handled directly here and the obtained SKB
  * is freed.
  *
- * Service messages (Data, WMI) passed to the corresponding
+ * Service messages (Data, WMI) are passed to the corresponding
  * endpoint RX handlers, which have to free the SKB.
  */
 void ath9k_htc_rx_msg(struct htc_target *htc_handle,
@@ -481,6 +481,8 @@ void ath9k_htc_rx_msg(struct htc_target *htc_handle,
 		if (endpoint->ep_callbacks.rx)
 			endpoint->ep_callbacks.rx(endpoint->ep_callbacks.priv,
 						  skb, epid);
+		else
+			goto invalid;
 	}
 }
 
-- 
2.39.2



