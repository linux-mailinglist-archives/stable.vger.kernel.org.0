Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D42305B6F35
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 16:11:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232483AbiIMOKS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 10:10:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232659AbiIMOJP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 10:09:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF5615AA22;
        Tue, 13 Sep 2022 07:09:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F1899B80EFA;
        Tue, 13 Sep 2022 14:08:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B541C433C1;
        Tue, 13 Sep 2022 14:08:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663078137;
        bh=TP1PAUh22etwcVEsjLpwRR+RTa1C6UM/k0FrZreC9Q0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=plxs2MEg1+QjfXuGZJv5xkzRBvdtTaX/05eALV3dGZrSIy34l9+oHDIBcAdNVuN15
         8E+izwFVIcSyHYtHYnaGxsGkNJKm90qv9UrKw1/jgaSLPZD7BmqnrFZYwz+J1U9BRo
         BETTRQFaLMPsAzbue/wliaCWfim98BepeJosniz8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Li Zhong <floridsleeves@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 027/192] net/core/skbuff: Check the return value of skb_copy_bits()
Date:   Tue, 13 Sep 2022 16:02:13 +0200
Message-Id: <20220913140411.264395978@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140410.043243217@linuxfoundation.org>
References: <20220913140410.043243217@linuxfoundation.org>
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
index bebf58464d667..4b2b07a9422cf 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -4179,9 +4179,8 @@ struct sk_buff *skb_segment(struct sk_buff *head_skb,
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



