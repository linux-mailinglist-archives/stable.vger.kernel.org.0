Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18A56531ADA
	for <lists+stable@lfdr.de>; Mon, 23 May 2022 22:56:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239210AbiEWREV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 13:04:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239214AbiEWREN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 13:04:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EE295A588;
        Mon, 23 May 2022 10:04:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C1408614CA;
        Mon, 23 May 2022 17:04:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C563CC385AA;
        Mon, 23 May 2022 17:04:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653325451;
        bh=eLXtVv/gyCft0m7oLFDOCv2NdFuhvuKKxzvs6PE2RX0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vGN2Hrfx3IBpji1gFZvBFUyp7McKNytgwgvwpII+H8WQn7Sdcra6kdTvV8paqQo8s
         qZi3/4EjJgvqIzK/ipLVv86fsrYhytHcrdYtLEhJ5Rxr2px1gb0R4dFDuXvh9prQF4
         Abpsa3bM5/nT/xMnDrBNU4DnKUxfxAUAt2C9KAX0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Duoming Zhou <duoming@zju.edu.cn>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 16/25] NFC: nci: fix sleep in atomic context bugs caused by nci_skb_alloc
Date:   Mon, 23 May 2022 19:03:34 +0200
Message-Id: <20220523165747.575050147@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220523165743.398280407@linuxfoundation.org>
References: <20220523165743.398280407@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Duoming Zhou <duoming@zju.edu.cn>

[ Upstream commit 23dd4581350d4ffa23d58976ec46408f8f4c1e16 ]

There are sleep in atomic context bugs when the request to secure
element of st-nci is timeout. The root cause is that nci_skb_alloc
with GFP_KERNEL parameter is called in st_nci_se_wt_timeout which is
a timer handler. The call paths that could trigger bugs are shown below:

    (interrupt context 1)
st_nci_se_wt_timeout
  nci_hci_send_event
    nci_hci_send_data
      nci_skb_alloc(..., GFP_KERNEL) //may sleep

   (interrupt context 2)
st_nci_se_wt_timeout
  nci_hci_send_event
    nci_hci_send_data
      nci_send_data
        nci_queue_tx_data_frags
          nci_skb_alloc(..., GFP_KERNEL) //may sleep

This patch changes allocation mode of nci_skb_alloc from GFP_KERNEL to
GFP_ATOMIC in order to prevent atomic context sleeping. The GFP_ATOMIC
flag makes memory allocation operation could be used in atomic context.

Fixes: ed06aeefdac3 ("nfc: st-nci: Rename st21nfcb to st-nci")
Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://lore.kernel.org/r/20220517012530.75714-1-duoming@zju.edu.cn
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/nfc/nci/data.c | 2 +-
 net/nfc/nci/hci.c  | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/nfc/nci/data.c b/net/nfc/nci/data.c
index d20383779710..b8a295dd15d8 100644
--- a/net/nfc/nci/data.c
+++ b/net/nfc/nci/data.c
@@ -130,7 +130,7 @@ static int nci_queue_tx_data_frags(struct nci_dev *ndev,
 
 		skb_frag = nci_skb_alloc(ndev,
 					 (NCI_DATA_HDR_SIZE + frag_len),
-					 GFP_KERNEL);
+					 GFP_ATOMIC);
 		if (skb_frag == NULL) {
 			rc = -ENOMEM;
 			goto free_exit;
diff --git a/net/nfc/nci/hci.c b/net/nfc/nci/hci.c
index 5fae3f064ad0..9c37618f36c6 100644
--- a/net/nfc/nci/hci.c
+++ b/net/nfc/nci/hci.c
@@ -165,7 +165,7 @@ static int nci_hci_send_data(struct nci_dev *ndev, u8 pipe,
 
 	i = 0;
 	skb = nci_skb_alloc(ndev, conn_info->max_pkt_payload_len +
-			    NCI_DATA_HDR_SIZE, GFP_KERNEL);
+			    NCI_DATA_HDR_SIZE, GFP_ATOMIC);
 	if (!skb)
 		return -ENOMEM;
 
@@ -198,7 +198,7 @@ static int nci_hci_send_data(struct nci_dev *ndev, u8 pipe,
 		if (i < data_len) {
 			skb = nci_skb_alloc(ndev,
 					    conn_info->max_pkt_payload_len +
-					    NCI_DATA_HDR_SIZE, GFP_KERNEL);
+					    NCI_DATA_HDR_SIZE, GFP_ATOMIC);
 			if (!skb)
 				return -ENOMEM;
 
-- 
2.35.1



