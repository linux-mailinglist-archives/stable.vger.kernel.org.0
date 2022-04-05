Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9807A4F28B0
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 10:21:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234759AbiDEIVU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:21:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233752AbiDEIIw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:08:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 097296AA4E;
        Tue,  5 Apr 2022 01:02:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 23C14B81B16;
        Tue,  5 Apr 2022 08:02:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AD78C385A3;
        Tue,  5 Apr 2022 08:02:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649145728;
        bh=6teVxoPhBawGeWELxNYk1AiLJDt6H6dR+P6fL/PEkA8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X75CPJ7DtyUWc/5B9tOITFl1tgj09Q2LXCAbXUSkXbGUpYlnAlLC65g5oVdHjgkUi
         tI6Xdg5b0qnxhHqkK3P2/sQkDsc7bzDxmVQ/A7tcGPS+l152gcktVk292rqmdECl3f
         j9WuqgjJHLQQH9IPoqdQcYytrTQr1X0hj1aY8ggI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+f83a1df1ed4f67e8d8ad@syzkaller.appspotmail.com,
        Pavel Skripkin <paskripkin@gmail.com>,
        Kalle Valo <quic_kvalo@quicinc.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0470/1126] ath9k_htc: fix uninit value bugs
Date:   Tue,  5 Apr 2022 09:20:17 +0200
Message-Id: <20220405070421.423045719@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index 510e61e97dbc..994ec48b2f66 100644
--- a/drivers/net/wireless/ath/ath9k/htc_hst.c
+++ b/drivers/net/wireless/ath/ath9k/htc_hst.c
@@ -30,6 +30,7 @@ static int htc_issue_send(struct htc_target *target, struct sk_buff* skb,
 	hdr->endpoint_id = epid;
 	hdr->flags = flags;
 	hdr->payload_len = cpu_to_be16(len);
+	memset(hdr->control, 0, sizeof(hdr->control));
 
 	status = target->hif->send(target->hif_dev, endpoint->ul_pipeid, skb);
 
@@ -272,6 +273,10 @@ int htc_connect_service(struct htc_target *target,
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



