Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B04E2548735
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 17:58:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382226AbiFMOQ7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 10:16:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383078AbiFMOPS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 10:15:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07DAA9BAEC;
        Mon, 13 Jun 2022 04:42:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DE427B80EDF;
        Mon, 13 Jun 2022 11:42:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DDAFC34114;
        Mon, 13 Jun 2022 11:42:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655120562;
        bh=D27Pr3GuMl20TQ8/GTGuFIMN/gCZCy7tPMWRbhSOrvY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g6AizjLFZVdOSaqWIBGb0RdpCYu6JSIV8V8NnGd7ZZTjwOhNcIbWpBt75AZGapOLH
         KiPPvas23VksJxCk8guNndg2GPMiL//wfdknKreJkfM46YFQJh5akTh4xQG2W10nBM
         nfYKQOJqofVqfKCh3t8lCLRN/jir9nLm2Ei5fW04=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Taehee Yoo <ap420073@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 078/298] amt: fix possible memory leak in amt_rcv()
Date:   Mon, 13 Jun 2022 12:09:32 +0200
Message-Id: <20220613094927.311543716@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094924.913340374@linuxfoundation.org>
References: <20220613094924.913340374@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Taehee Yoo <ap420073@gmail.com>

[ Upstream commit 1a1a0e80e005cbdc2c250fc858e1d8570f4e4acb ]

If an amt receives packets and it finds socket.
If it can't find a socket, it should free a received skb.
But it doesn't.
So, a memory leak would possibly occur.

Fixes: cbc21dc1cfe9 ("amt: add data plane of amt interface")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/amt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/amt.c b/drivers/net/amt.c
index 6205282a09e5..d23eac9ce858 100644
--- a/drivers/net/amt.c
+++ b/drivers/net/amt.c
@@ -2679,7 +2679,7 @@ static int amt_rcv(struct sock *sk, struct sk_buff *skb)
 	amt = rcu_dereference_sk_user_data(sk);
 	if (!amt) {
 		err = true;
-		goto out;
+		goto drop;
 	}
 
 	skb->dev = amt->dev;
-- 
2.35.1



