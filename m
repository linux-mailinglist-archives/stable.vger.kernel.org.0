Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE9EA5B713E
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 16:43:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233464AbiIMOmd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 10:42:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230192AbiIMOly (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 10:41:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CEDE6DF91;
        Tue, 13 Sep 2022 07:22:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0F162614AE;
        Tue, 13 Sep 2022 14:22:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B798C433D6;
        Tue, 13 Sep 2022 14:22:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663078945;
        bh=GAAakixd9QHCOAzXIK28uqAuuAGFTRr34Ymi7tr2on4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FX3GFR9Dh4fXll+OOShZhgKLwq6MXaQ8qnR6+Owd1uubjpRgTw3Ol1orA/ZW2xKyx
         9u+nm4vv4HR86fm/hfGWR7KWdlipdCtZNP62bpjoc5uy8iYQjZqmuRN/Y/4KsDn+qg
         cbo9aO8sC/QAr9A5ykV4b+H8jcYB+KFuKx5DOZgg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Li Zhong <floridsleeves@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 21/79] net/core/skbuff: Check the return value of skb_copy_bits()
Date:   Tue, 13 Sep 2022 16:04:26 +0200
Message-Id: <20220913140351.321635587@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140350.291927556@linuxfoundation.org>
References: <20220913140350.291927556@linuxfoundation.org>
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

From: lily <floridsleeves@gmail.com>

[ Upstream commit c624c58e08b15105662b9ab9be23d14a6b945a49 ]

skb_copy_bits() could fail, which requires a check on the return
value.

Signed-off-by: Li Zhong <floridsleeves@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/skbuff.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 635cabcf8794f..7bdcdad58dc86 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -3986,9 +3986,8 @@ struct sk_buff *skb_segment(struct sk_buff *head_skb,
 				SKB_GSO_CB(nskb)->csum_start =
 					skb_headroom(nskb) + doffset;
 			} else {
-				skb_copy_bits(head_skb, offset,
-					      skb_put(nskb, len),
-					      len);
+				if (skb_copy_bits(head_skb, offset, skb_put(nskb, len), len))
+					goto err;
 			}
 			continue;
 		}
-- 
2.35.1



