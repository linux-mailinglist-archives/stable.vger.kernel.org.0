Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD69E4FDB23
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 12:55:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235473AbiDLIAw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 04:00:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357683AbiDLHki (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:40:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EC5837A2B;
        Tue, 12 Apr 2022 00:16:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B792F6171C;
        Tue, 12 Apr 2022 07:16:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C45C1C385A5;
        Tue, 12 Apr 2022 07:16:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649747800;
        bh=5FCLa8SESKUYBJ4ATRRqzp9RiCWwoTSFcXkravvhKjg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zw4olPOLZrsVCcfDOlxexaW/zcADpB3nuXEOOfceycSPi1Ds7tT/XGTDEFSVuigZo
         MjdVoRAYzanLCV5HHDTaV0WeTRS4afSro7MS75c2pd6Ic6vjBqmHwJlzDHNSb101R3
         L8OCXe1XCYgWi9DEhWy3GDU15EhYMq1DeiiymQ2s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Matt Johnston <matt@codeconstruct.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 211/343] mctp: Fix check for dev_hard_header() result
Date:   Tue, 12 Apr 2022 08:30:29 +0200
Message-Id: <20220412062957.437294374@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062951.095765152@linuxfoundation.org>
References: <20220412062951.095765152@linuxfoundation.org>
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
index 05fbd318eb98..d47438f5233d 100644
--- a/net/mctp/route.c
+++ b/net/mctp/route.c
@@ -507,7 +507,7 @@ static int mctp_route_output(struct mctp_route *route, struct sk_buff *skb)
 
 	rc = dev_hard_header(skb, skb->dev, ntohs(skb->protocol),
 			     daddr, skb->dev->dev_addr, skb->len);
-	if (rc) {
+	if (rc < 0) {
 		kfree_skb(skb);
 		return -EHOSTUNREACH;
 	}
-- 
2.35.1



