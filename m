Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B080541BD5
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:56:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377364AbiFGVyy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:54:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382552AbiFGVve (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:51:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C400623CF69;
        Tue,  7 Jun 2022 12:09:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9F477618D3;
        Tue,  7 Jun 2022 19:09:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE517C34115;
        Tue,  7 Jun 2022 19:08:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654628940;
        bh=tJbaS2XiW41GrXthoYwhtBy7BU2P4TIZhpW73nfPXUw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LnMq1UdGyb8xxML1oTzinz3fXZ3XbQVxcn2insHCATp4iPJnXVXPQOIoFPbVNxf9k
         q9sRl8ZXo/fbTz+aoVATUD9nv5sVa+ForTQjpQ0FvC/aZ7XmuMF3WaCEop7cBtXyVJ
         viBGxMdtC6lebqsIkmnf02qjkXlFBEBddpbE0f8I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Taehee Yoo <ap420073@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 512/879] amt: fix memory leak for advertisement message
Date:   Tue,  7 Jun 2022 19:00:30 +0200
Message-Id: <20220607165017.737618336@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
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

[ Upstream commit fe29794c3585d039fefebaa2b5a4932a627ad4fd ]

When a gateway receives an advertisement message, it extracts relay
information and then it should be freed.
But the advertisement handler doesn't free it.
So, memory leak would occur.

Fixes: cbc21dc1cfe9 ("amt: add data plane of amt interface")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/amt.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/amt.c b/drivers/net/amt.c
index 2b4ce3869f08..de4ea518c793 100644
--- a/drivers/net/amt.c
+++ b/drivers/net/amt.c
@@ -2698,9 +2698,8 @@ static int amt_rcv(struct sock *sk, struct sk_buff *skb)
 				err = true;
 				goto drop;
 			}
-			if (amt_advertisement_handler(amt, skb))
-				amt->dev->stats.rx_dropped++;
-			goto out;
+			err = amt_advertisement_handler(amt, skb);
+			break;
 		case AMT_MSG_MULTICAST_DATA:
 			if (iph->saddr != amt->remote_ip) {
 				netdev_dbg(amt->dev, "Invalid Relay IP\n");
-- 
2.35.1



