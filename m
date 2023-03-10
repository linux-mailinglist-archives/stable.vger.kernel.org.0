Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B64E06B48DE
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 16:07:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233898AbjCJPHd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 10:07:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233245AbjCJPGy (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 10:06:54 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BAA3132BDF
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:59:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F326AB822E7
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:49:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B69CC433A4;
        Fri, 10 Mar 2023 14:49:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678459784;
        bh=15lCairjuDCXT9WXgaZgAbXo7gBsFE795r8YDTFqEkY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ErkXaOwZNVVP+vEpMDOJBwY1p/kQp5U8oQF3kgT++R9xsNYsPsokK2bTgifEjJUQc
         3wJfx61hp5rlBKU1mVp+G3RlQqQoPsCYhs4gXxVr6uTCuESVALSu4rFqPdJaDffEap
         g8ccOz67FA/GxGtJP3aMvQZ3zRZUaVjx2ezsFx8k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Wan Jiabing <wanjiabing@vivo.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
        Kalle Valo <quic_kvalo@quicinc.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 088/529] ath9k: hif_usb: simplify if-if to if-else
Date:   Fri, 10 Mar 2023 14:33:51 +0100
Message-Id: <20230310133809.054529465@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133804.978589368@linuxfoundation.org>
References: <20230310133804.978589368@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wan Jiabing <wanjiabing@vivo.com>

[ Upstream commit 2950833f10cfa601813262e1d9c8473f9415681b ]

Use if and else instead of if(A) and if (!A).

Signed-off-by: Wan Jiabing <wanjiabing@vivo.com>
Acked-by: Toke Høiland-Jørgensen <toke@toke.dk>
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://lore.kernel.org/r/20220424094441.104937-1-wanjiabing@vivo.com
Stable-dep-of: 0af54343a762 ("wifi: ath9k: hif_usb: clean up skbs if ath9k_hif_usb_rx_stream() fails")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath9k/hif_usb.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hif_usb.c b/drivers/net/wireless/ath/ath9k/hif_usb.c
index f938ac1a4abd4..f54380fb6c9e5 100644
--- a/drivers/net/wireless/ath/ath9k/hif_usb.c
+++ b/drivers/net/wireless/ath/ath9k/hif_usb.c
@@ -368,10 +368,9 @@ static int __hif_usb_tx(struct hif_device_usb *hif_dev)
 		__skb_queue_head_init(&tx_buf->skb_queue);
 		list_move_tail(&tx_buf->list, &hif_dev->tx.tx_buf);
 		hif_dev->tx.tx_buf_cnt++;
-	}
-
-	if (!ret)
+	} else {
 		TX_STAT_INC(buf_queued);
+	}
 
 	return ret;
 }
-- 
2.39.2



