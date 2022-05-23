Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30A4D53173D
	for <lists+stable@lfdr.de>; Mon, 23 May 2022 22:52:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240640AbiEWRaP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 13:30:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242409AbiEWR1n (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 13:27:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE9C07CB42;
        Mon, 23 May 2022 10:23:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EB951B811FF;
        Mon, 23 May 2022 17:23:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D37DC385A9;
        Mon, 23 May 2022 17:23:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653326580;
        bh=rAZen7RQzLM1AtPnxO+QsytUnBXywbtMIxIy+YJqXqo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OV4xBtC1VB5KJuR6TxVdpGbrGpMd7AqOVUA0R5h9piKY4StS1wk33OvdvJbJvwsv1
         +EX6Yo4apo57Vyljj5Lc8WuqFTRK0rrp5i+Rp2Gbw7akn2hWnJAIqZzmqqlDyXV1PT
         KUJX+w0nGHRJjbMTCRi187TjOQq8WCe7mqKBuOdU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aashay Shringarpure <aashay@google.com>,
        Yi Chou <yich@google.com>,
        Shervin Oloumi <enlightened@google.com>,
        Grant Grundler <grundler@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 125/132] net: atlantic: add check for MAX_SKB_FRAGS
Date:   Mon, 23 May 2022 19:05:34 +0200
Message-Id: <20220523165844.367829071@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220523165823.492309987@linuxfoundation.org>
References: <20220523165823.492309987@linuxfoundation.org>
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

From: Grant Grundler <grundler@chromium.org>

[ Upstream commit 6aecbba12b5c90b26dc062af3b9de8c4b3a2f19f ]

Enforce that the CPU can not get stuck in an infinite loop.

Reported-by: Aashay Shringarpure <aashay@google.com>
Reported-by: Yi Chou <yich@google.com>
Reported-by: Shervin Oloumi <enlightened@google.com>
Signed-off-by: Grant Grundler <grundler@chromium.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/aquantia/atlantic/aq_ring.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_ring.c b/drivers/net/ethernet/aquantia/atlantic/aq_ring.c
index 339efdfb1d49..e9c6f1fa0b1a 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_ring.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_ring.c
@@ -362,6 +362,7 @@ int aq_ring_rx_clean(struct aq_ring_s *self,
 			continue;
 
 		if (!buff->is_eop) {
+			unsigned int frag_cnt = 0U;
 			buff_ = buff;
 			do {
 				bool is_rsc_completed = true;
@@ -370,6 +371,8 @@ int aq_ring_rx_clean(struct aq_ring_s *self,
 					err = -EIO;
 					goto err_exit;
 				}
+
+				frag_cnt++;
 				next_ = buff_->next,
 				buff_ = &self->buff_ring[next_];
 				is_rsc_completed =
@@ -377,7 +380,8 @@ int aq_ring_rx_clean(struct aq_ring_s *self,
 							    next_,
 							    self->hw_head);
 
-				if (unlikely(!is_rsc_completed)) {
+				if (unlikely(!is_rsc_completed) ||
+						frag_cnt > MAX_SKB_FRAGS) {
 					err = 0;
 					goto err_exit;
 				}
-- 
2.35.1



