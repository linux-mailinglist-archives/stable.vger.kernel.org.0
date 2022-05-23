Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A73E531670
	for <lists+stable@lfdr.de>; Mon, 23 May 2022 22:51:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241640AbiEWRjl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 13:39:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242402AbiEWRhi (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 13:37:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3848050057;
        Mon, 23 May 2022 10:31:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9F0E561262;
        Mon, 23 May 2022 17:31:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CB72C385AA;
        Mon, 23 May 2022 17:31:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653327079;
        bh=di/0u1pfyt5gJ4peynH3b3jQYS0oAszZJH+iUQ2G0Ic=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D6CIGSFRN37/XJNA9UXCfnwhn8Fh2TO1Jnk9aZ4s8JT2DC6PnSgwFbtuLReASxCs4
         mhHREU2fE7dTRPKVISBZ+LjSekk0aI45PTvnBg3NbV5Rv72FbY0PImXlvElbNyzk8+
         /iBvc8RajCoGPd/H5wD/cTtLqpQVH+w1Kt5bBZrw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aashay Shringarpure <aashay@google.com>,
        Yi Chou <yich@google.com>,
        Shervin Oloumi <enlightened@google.com>,
        Grant Grundler <grundler@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 150/158] net: atlantic: fix "frag[0] not initialized"
Date:   Mon, 23 May 2022 19:05:07 +0200
Message-Id: <20220523165855.043512482@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220523165830.581652127@linuxfoundation.org>
References: <20220523165830.581652127@linuxfoundation.org>
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

[ Upstream commit 62e0ae0f4020250f961cf8d0103a4621be74e077 ]

In aq_ring_rx_clean(), if buff->is_eop is not set AND
buff->len < AQ_CFG_RX_HDR_SIZE, then hdr_len remains equal to
buff->len and skb_add_rx_frag(xxx, *0*, ...) is not called.

The loop following this code starts calling skb_add_rx_frag() starting
with i=1 and thus frag[0] is never initialized. Since i is initialized
to zero at the top of the primary loop, we can just reference and
post-increment i instead of hardcoding the 0 when calling
skb_add_rx_frag() the first time.

Reported-by: Aashay Shringarpure <aashay@google.com>
Reported-by: Yi Chou <yich@google.com>
Reported-by: Shervin Oloumi <enlightened@google.com>
Signed-off-by: Grant Grundler <grundler@chromium.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/aquantia/atlantic/aq_ring.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_ring.c b/drivers/net/ethernet/aquantia/atlantic/aq_ring.c
index 77e76c9efd32..440423b0e8ea 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_ring.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_ring.c
@@ -446,7 +446,7 @@ int aq_ring_rx_clean(struct aq_ring_s *self,
 		       ALIGN(hdr_len, sizeof(long)));
 
 		if (buff->len - hdr_len > 0) {
-			skb_add_rx_frag(skb, 0, buff->rxdata.page,
+			skb_add_rx_frag(skb, i++, buff->rxdata.page,
 					buff->rxdata.pg_off + hdr_len,
 					buff->len - hdr_len,
 					AQ_CFG_RX_FRAME_MAX);
@@ -455,7 +455,6 @@ int aq_ring_rx_clean(struct aq_ring_s *self,
 
 		if (!buff->is_eop) {
 			buff_ = buff;
-			i = 1U;
 			do {
 				next_ = buff_->next;
 				buff_ = &self->buff_ring[next_];
-- 
2.35.1



