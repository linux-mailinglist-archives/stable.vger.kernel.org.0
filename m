Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A743E5A4AD6
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 13:59:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229828AbiH2L7L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 07:59:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229633AbiH2L6n (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 07:58:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C21D295E4E;
        Mon, 29 Aug 2022 04:43:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 67B7E61211;
        Mon, 29 Aug 2022 11:16:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62A24C433D6;
        Mon, 29 Aug 2022 11:16:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661771771;
        bh=O8q1De+bzMCYeAwIjgcjjJwFQrRcxH44Kc2fs3jgwtY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LAiOr5YGSUXJvFMFFzsoqiFUHwzg+tPESg179ln0+tHmSspZVqItT2Bm5J2tX+k/h
         y+yS5r1EiTcJqxN3tv1/urp2F7/YK91n6E6mlZW0jB3TnkdYNz0mI0Z7681rSDhPJe
         qVJHakjcBggBi4bPKrCqI+byvNmF9PeaHq2KyIX8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aleksander Jan Bajkowski <olek2@wp.pl>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 093/158] net: lantiq_xrx200: restore buffer if memory allocation failed
Date:   Mon, 29 Aug 2022 12:59:03 +0200
Message-Id: <20220829105812.960262913@linuxfoundation.org>
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

[ Upstream commit c9c3b1775f80fa21f5bff874027d2ccb10f5d90c ]

In a situation where memory allocation fails, an invalid buffer address
is stored. When this descriptor is used again, the system panics in the
build_skb() function when accessing memory.

Fixes: 7ea6cd16f159 ("lantiq: net: fix duplicated skb in rx descriptor ring")
Signed-off-by: Aleksander Jan Bajkowski <olek2@wp.pl>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/lantiq_xrx200.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/lantiq_xrx200.c b/drivers/net/ethernet/lantiq_xrx200.c
index 25adce7f0c7c0..57f27cc7724e7 100644
--- a/drivers/net/ethernet/lantiq_xrx200.c
+++ b/drivers/net/ethernet/lantiq_xrx200.c
@@ -193,6 +193,7 @@ static int xrx200_alloc_buf(struct xrx200_chan *ch, void *(*alloc)(unsigned int
 
 	ch->rx_buff[ch->dma.desc] = alloc(priv->rx_skb_size);
 	if (!ch->rx_buff[ch->dma.desc]) {
+		ch->rx_buff[ch->dma.desc] = buf;
 		ret = -ENOMEM;
 		goto skip;
 	}
-- 
2.35.1



