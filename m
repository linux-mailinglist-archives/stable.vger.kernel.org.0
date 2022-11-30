Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7C7F63DD96
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 19:28:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229712AbiK3S2s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 13:28:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229706AbiK3S2r (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 13:28:47 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA2E73E097
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 10:28:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 67D9DB81C9A
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 18:28:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C839BC433D6;
        Wed, 30 Nov 2022 18:28:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669832924;
        bh=g53hb0b6F5F6lbypay0JNJNo0d4BghcPRYihPdWj9Js=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Fk2YaAyVglzB8/hC+SRfy4VCGn2y0iBXQKkUbOBTflqKTa9wkKwxQjUrnHhr6AzTZ
         QiJVUIH97DdGDk/uIRSumadRnSe3gPSvCCPMl/WZR1K0XVN6IuTT+kRYsZlRomXeHg
         hM9Sp3W8n7fZSDlcTmbgb5u1IiRlI8ACOwR3Vmqw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, YueHaibing <yuehaibing@huawei.com>,
        Jon Maloy <jmaloy@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 071/162] tipc: check skb_linearize() return value in tipc_disc_rcv()
Date:   Wed, 30 Nov 2022 19:22:32 +0100
Message-Id: <20221130180530.431332300@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180528.466039523@linuxfoundation.org>
References: <20221130180528.466039523@linuxfoundation.org>
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

From: YueHaibing <yuehaibing@huawei.com>

[ Upstream commit cd0f6421162201e4b22ce757a1966729323185eb ]

If skb_linearize() fails in tipc_disc_rcv(), we need to free the skb instead of
handle it.

Fixes: 25b0b9c4e835 ("tipc: handle collisions of 32-bit node address hash values")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Acked-by: Jon Maloy <jmaloy@redhat.com>
Link: https://lore.kernel.org/r/20221119072832.7896-1-yuehaibing@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tipc/discover.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/tipc/discover.c b/net/tipc/discover.c
index 2ae268b67465..2730310249e3 100644
--- a/net/tipc/discover.c
+++ b/net/tipc/discover.c
@@ -210,7 +210,10 @@ void tipc_disc_rcv(struct net *net, struct sk_buff *skb,
 	u32 self;
 	int err;
 
-	skb_linearize(skb);
+	if (skb_linearize(skb)) {
+		kfree_skb(skb);
+		return;
+	}
 	hdr = buf_msg(skb);
 
 	if (caps & TIPC_NODE_ID128)
-- 
2.35.1



