Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DE274FD1F2
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 09:08:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240837AbiDLHJZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:09:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352634AbiDLHFr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:05:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA6B24832E;
        Mon, 11 Apr 2022 23:48:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 78B886104B;
        Tue, 12 Apr 2022 06:48:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 823F1C385A1;
        Tue, 12 Apr 2022 06:48:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649746104;
        bh=WkrTtnMGaSDyjMz7Ctkvji8CQA8LrQHkGCrbYQCesyE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I5MYG6S/xrlWzUgryBttS6GMv8sBv/sh990Or4yUBWiYFinaSBla7xtbwrwZTwjFD
         bv4kxhLVC0wY1cze3AZIxEhgWxcniEeGVTEaIep2yAEOlA6UbLovZWBxY80EisBm0V
         oBlEjAsI9sFY7amjW+I/moJom6mFqFos1mVOVEk0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Matt Johnston <matt@codeconstruct.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 162/277] mctp: Fix check for dev_hard_header() result
Date:   Tue, 12 Apr 2022 08:29:25 +0200
Message-Id: <20220412062946.726852698@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062942.022903016@linuxfoundation.org>
References: <20220412062942.022903016@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Matt Johnston <matt@codeconstruct.com.au>

[ Upstream commit 60be976ac45137657b7b505d7e0d44d0e51accb7 ]

dev_hard_header() returns the length of the header, so
we need to test for negative errors rather than non-zero.

Fixes: 889b7da23abf ("mctp: Add initial routing framework")
Signed-off-by: Matt Johnston <matt@codeconstruct.com.au>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mctp/route.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mctp/route.c b/net/mctp/route.c
index fb1bf4ec8529..bbb13dbc9227 100644
--- a/net/mctp/route.c
+++ b/net/mctp/route.c
@@ -396,7 +396,7 @@ static int mctp_route_output(struct mctp_route *route, struct sk_buff *skb)
 
 	rc = dev_hard_header(skb, skb->dev, ntohs(skb->protocol),
 			     daddr, skb->dev->dev_addr, skb->len);
-	if (rc) {
+	if (rc < 0) {
 		kfree_skb(skb);
 		return -EHOSTUNREACH;
 	}
-- 
2.35.1



