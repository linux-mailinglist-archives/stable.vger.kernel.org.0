Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C278966C513
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:01:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231984AbjAPQBe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:01:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231950AbjAPQBO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:01:14 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13572144B3
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:01:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A4A2C61046
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:01:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC2D8C433EF;
        Mon, 16 Jan 2023 16:01:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673884872;
        bh=5bVf8AfvZtU0d3byqWmqRMr9golDSxvft2wOswkGnx8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IdqCJf16dFh0zyZhbGBJBEMoN54ONcj2oxvfK275BKO+3RiXICryIZlr/znfV94RK
         hoJgHA/K4AWSpUAui8jTdRshe3nVU4ZX+bvBDvsfxvdoZVWhuyf6rxEl/mlzakfrZT
         Rf858shZtzjUjAd5Plp43RR5oqCwEsP9PzH8Is88=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Eric Dumazet <edumazet@google.com>,
        Coco Li <lixiaoyan@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>,
        Jaroslav Pulchart <jaroslav.pulchart@gooddata.com>
Subject: [PATCH 6.1 133/183] gro: take care of DODGY packets
Date:   Mon, 16 Jan 2023 16:50:56 +0100
Message-Id: <20230116154808.994962053@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154803.321528435@linuxfoundation.org>
References: <20230116154803.321528435@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 7871f54e3deed68a27111dda162c4fe9b9c65f8f ]

Jaroslav reported a recent throughput regression with virtio_net
caused by blamed commit.

It is unclear if DODGY GSO packets coming from user space
can be accepted by GRO engine in the future with minimal
changes, and if there is any expected gain from it.

In the meantime, make sure to detect and flush DODGY packets.

Fixes: 5eddb24901ee ("gro: add support of (hw)gro packets to gro stack")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-and-bisected-by: Jaroslav Pulchart <jaroslav.pulchart@gooddata.com>
Cc: Coco Li <lixiaoyan@google.com>
Cc: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/gro.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/core/gro.c b/net/core/gro.c
index 8e0fe85a647d..1b4abfb9a7a1 100644
--- a/net/core/gro.c
+++ b/net/core/gro.c
@@ -507,8 +507,9 @@ static enum gro_result dev_gro_receive(struct napi_struct *napi, struct sk_buff
 	NAPI_GRO_CB(skb)->count = 1;
 	if (unlikely(skb_is_gso(skb))) {
 		NAPI_GRO_CB(skb)->count = skb_shinfo(skb)->gso_segs;
-		/* Only support TCP at the moment. */
-		if (!skb_is_gso_tcp(skb))
+		/* Only support TCP and non DODGY users. */
+		if (!skb_is_gso_tcp(skb) ||
+		    (skb_shinfo(skb)->gso_type & SKB_GSO_DODGY))
 			NAPI_GRO_CB(skb)->flush = 1;
 	}
 
-- 
2.35.1



