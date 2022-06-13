Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 977A05487F1
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:00:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378450AbiFMNlf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 09:41:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379116AbiFMNjw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 09:39:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E8467A453;
        Mon, 13 Jun 2022 04:28:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AA95761036;
        Mon, 13 Jun 2022 11:28:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4DF7C34114;
        Mon, 13 Jun 2022 11:28:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655119722;
        bh=yRjoz7WQZ8rS3SzcadpZzio7LtuJZcOWf3VV+O2JBU4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Cw0qVlw9ZP4rBTIW8YRGfXixIAPGuVEquWrRBkzkjaBtn+bd7pYe9mzw6zuyHcBeT
         52FDnIT/9Rup/KbrtbI66axI8ciMtmIUsmYsy5BvHBoS/7ueB04KAJhLxzeyFvPBux
         /sSTGQyr+wz39GagPfLhc5P3ciHkVASDCnKptxGA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Taehee Yoo <ap420073@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 087/339] amt: fix possible memory leak in amt_rcv()
Date:   Mon, 13 Jun 2022 12:08:32 +0200
Message-Id: <20220613094929.155305498@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094926.497929857@linuxfoundation.org>
References: <20220613094926.497929857@linuxfoundation.org>
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
index d376ed89f836..22d7da749a24 100644
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



