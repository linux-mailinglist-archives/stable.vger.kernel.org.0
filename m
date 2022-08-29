Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 267DF5A4B68
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 14:18:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229691AbiH2MSO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 08:18:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230488AbiH2MRu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 08:17:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3206AA2232;
        Mon, 29 Aug 2022 05:01:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0FC73B80F93;
        Mon, 29 Aug 2022 11:16:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40A7BC433D7;
        Mon, 29 Aug 2022 11:16:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661771765;
        bh=AlpP6Cppu3aOPE3+U7DODj6l+USJkVNajExw8Z7AmVw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n5TKkEZuqA+Ts0WPN0fsAH2r3fvjAzrM3/o3rD/DZSWyCkqKp6Ef84VjZNbghXTmD
         8UpJxV/aqLez1DLFVLBLEvwienr3xvwhkeu/CNmjxSH9Z7qgkqeKYtTwNb+D7lKYV7
         6a0lLb9+qW5TgT71/UrE+gNH4VTDQZ/kKLr0JM18=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Aleksander Jan Bajkowski <olek2@wp.pl>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 091/158] net: lantiq_xrx200: confirm skb is allocated before using
Date:   Mon, 29 Aug 2022 12:59:01 +0200
Message-Id: <20220829105812.881721584@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220829105808.828227973@linuxfoundation.org>
References: <20220829105808.828227973@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Aleksander Jan Bajkowski <olek2@wp.pl>

[ Upstream commit c8b043702dc0894c07721c5b019096cebc8c798f ]

xrx200_hw_receive() assumes build_skb() always works and goes straight
to skb_reserve(). However, build_skb() can fail under memory pressure.

Add a check in case build_skb() failed to allocate and return NULL.

Fixes: e015593573b3 ("net: lantiq_xrx200: convert to build_skb")
Reported-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Aleksander Jan Bajkowski <olek2@wp.pl>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/lantiq_xrx200.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/lantiq_xrx200.c b/drivers/net/ethernet/lantiq_xrx200.c
index 5edb68a8aab1e..89314b645c822 100644
--- a/drivers/net/ethernet/lantiq_xrx200.c
+++ b/drivers/net/ethernet/lantiq_xrx200.c
@@ -239,6 +239,12 @@ static int xrx200_hw_receive(struct xrx200_chan *ch)
 	}
 
 	skb = build_skb(buf, priv->rx_skb_size);
+	if (!skb) {
+		skb_free_frag(buf);
+		net_dev->stats.rx_dropped++;
+		return -ENOMEM;
+	}
+
 	skb_reserve(skb, NET_SKB_PAD);
 	skb_put(skb, len);
 
-- 
2.35.1



