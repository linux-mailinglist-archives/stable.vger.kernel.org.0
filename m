Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70E9350580B
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 15:56:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244538AbiDRN71 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 09:59:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244651AbiDRN5J (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 09:57:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D13B02AC6E;
        Mon, 18 Apr 2022 06:06:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6CA3D60EF6;
        Mon, 18 Apr 2022 13:06:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B7A9C385A1;
        Mon, 18 Apr 2022 13:06:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650287195;
        bh=tYhwpHAAbEJTRnjWi+1xyQiT2rwpUUSSZnyi6C/dVvw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nYnqmvcBfaUybroC4vYF3wB2DKZ+8bXGlZqp2PyX8WTiPjTajkez8oZnidYfKQ6OU
         onzP2Yb32cW6JxXux3Ae5hNMVJXbPjbIdxWB55EIjVPt01Zuz+pW5Z1FMoqnfdRvZm
         NSjy8CjKDRwoRyQnh29CbptymOMyfxU9nHHVAE4k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+f83a1df1ed4f67e8d8ad@syzkaller.appspotmail.com,
        Pavel Skripkin <paskripkin@gmail.com>,
        Kalle Valo <quic_kvalo@quicinc.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 079/218] ath9k_htc: fix uninit value bugs
Date:   Mon, 18 Apr 2022 14:12:25 +0200
Message-Id: <20220418121201.867248006@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121158.636999985@linuxfoundation.org>
References: <20220418121158.636999985@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Skripkin <paskripkin@gmail.com>

[ Upstream commit d1e0df1c57bd30871dd1c855742a7c346dbca853 ]

Syzbot reported 2 KMSAN bugs in ath9k. All of them are caused by missing
field initialization.

In htc_connect_service() svc_meta_len and pad are not initialized. Based
on code it looks like in current skb there is no service data, so simply
initialize svc_meta_len to 0.

htc_issue_send() does not initialize htc_frame_hdr::control array. Based
on firmware code, it will initialize it by itself, so simply zero whole
array to make KMSAN happy

Fail logs:

BUG: KMSAN: kernel-usb-infoleak in usb_submit_urb+0x6c1/0x2aa0 drivers/usb/core/urb.c:430
 usb_submit_urb+0x6c1/0x2aa0 drivers/usb/core/urb.c:430
 hif_usb_send_regout drivers/net/wireless/ath/ath9k/hif_usb.c:127 [inline]
 hif_usb_send+0x5f0/0x16f0 drivers/net/wireless/ath/ath9k/hif_usb.c:479
 htc_issue_send drivers/net/wireless/ath/ath9k/htc_hst.c:34 [inline]
 htc_connect_service+0x143e/0x1960 drivers/net/wireless/ath/ath9k/htc_hst.c:275
...

Uninit was created at:
 slab_post_alloc_hook mm/slab.h:524 [inline]
 slab_alloc_node mm/slub.c:3251 [inline]
 __kmalloc_node_track_caller+0xe0c/0x1510 mm/slub.c:4974
 kmalloc_reserve net/core/skbuff.c:354 [inline]
 __alloc_skb+0x545/0xf90 net/core/skbuff.c:426
 alloc_skb include/linux/skbuff.h:1126 [inline]
 htc_connect_service+0x1029/0x1960 drivers/net/wireless/ath/ath9k/htc_hst.c:258
...

Bytes 4-7 of 18 are uninitialized
Memory access of size 18 starts at ffff888027377e00

BUG: KMSAN: kernel-usb-infoleak in usb_submit_urb+0x6c1/0x2aa0 drivers/usb/core/urb.c:430
 usb_submit_urb+0x6c1/0x2aa0 drivers/usb/core/urb.c:430
 hif_usb_send_regout drivers/net/wireless/ath/ath9k/hif_usb.c:127 [inline]
 hif_usb_send+0x5f0/0x16f0 drivers/net/wireless/ath/ath9k/hif_usb.c:479
 htc_issue_send drivers/net/wireless/ath/ath9k/htc_hst.c:34 [inline]
 htc_connect_service+0x143e/0x1960 drivers/net/wireless/ath/ath9k/htc_hst.c:275
...

Uninit was created at:
 slab_post_alloc_hook mm/slab.h:524 [inline]
 slab_alloc_node mm/slub.c:3251 [inline]
 __kmalloc_node_track_caller+0xe0c/0x1510 mm/slub.c:4974
 kmalloc_reserve net/core/skbuff.c:354 [inline]
 __alloc_skb+0x545/0xf90 net/core/skbuff.c:426
 alloc_skb include/linux/skbuff.h:1126 [inline]
 htc_connect_service+0x1029/0x1960 drivers/net/wireless/ath/ath9k/htc_hst.c:258
...

Bytes 16-17 of 18 are uninitialized
Memory access of size 18 starts at ffff888027377e00

Fixes: fb9987d0f748 ("ath9k_htc: Support for AR9271 chipset.")
Reported-by: syzbot+f83a1df1ed4f67e8d8ad@syzkaller.appspotmail.com
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://lore.kernel.org/r/20220115122733.11160-1-paskripkin@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath9k/htc_hst.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/htc_hst.c b/drivers/net/wireless/ath/ath9k/htc_hst.c
index 625823e45d8f..06a6e7443550 100644
--- a/drivers/net/wireless/ath/ath9k/htc_hst.c
+++ b/drivers/net/wireless/ath/ath9k/htc_hst.c
@@ -31,6 +31,7 @@ static int htc_issue_send(struct htc_target *target, struct sk_buff* skb,
 	hdr->endpoint_id = epid;
 	hdr->flags = flags;
 	hdr->payload_len = cpu_to_be16(len);
+	memset(hdr->control, 0, sizeof(hdr->control));
 
 	status = target->hif->send(target->hif_dev, endpoint->ul_pipeid, skb);
 
@@ -278,6 +279,10 @@ int htc_connect_service(struct htc_target *target,
 	conn_msg->dl_pipeid = endpoint->dl_pipeid;
 	conn_msg->ul_pipeid = endpoint->ul_pipeid;
 
+	/* To prevent infoleak */
+	conn_msg->svc_meta_len = 0;
+	conn_msg->pad = 0;
+
 	ret = htc_issue_send(target, skb, skb->len, 0, ENDPOINT0);
 	if (ret)
 		goto err;
-- 
2.34.1



