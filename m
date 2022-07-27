Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C9FA582CE5
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 18:51:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240665AbiG0Qvu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 12:51:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240708AbiG0QvW (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 12:51:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B3415466C;
        Wed, 27 Jul 2022 09:33:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8667361A24;
        Wed, 27 Jul 2022 16:33:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98E3DC433D6;
        Wed, 27 Jul 2022 16:33:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658939607;
        bh=Qt+4++QvuptAP4vx78cOhCxhdzXsQPCiQwrKHJ8j574=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fs1TQhlSdk73X3821deg2xTmZCO682I6CSFTAHLPzeb/e6u6KTsE2R6KXKthabrPs
         y/TxtuSlWWAwYlSFvXFbVniDnEoM79OHJSob5L6vxOr8tby20KTIJ6RtveQ/rjys8F
         s0Rf0Hk8kag55DGmp1oFhgnXrSWEku4aRatWUGAA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kuniyuki Iwashima <kuniyu@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 040/105] tcp: Fix a data-race around sysctl_tcp_probe_interval.
Date:   Wed, 27 Jul 2022 18:10:26 +0200
Message-Id: <20220727161013.700318682@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727161012.056867467@linuxfoundation.org>
References: <20220727161012.056867467@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kuniyuki Iwashima <kuniyu@amazon.com>

[ Upstream commit 2a85388f1d94a9f8b5a529118a2c5eaa0520d85c ]

While reading sysctl_tcp_probe_interval, it can be changed concurrently.
Thus, we need to add READ_ONCE() to its reader.

Fixes: 05cbc0db03e8 ("ipv4: Create probe timer for tcp PMTU as per RFC4821")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp_output.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 7a8c8de45818..b58697336bd4 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -2278,7 +2278,7 @@ static inline void tcp_mtu_check_reprobe(struct sock *sk)
 	u32 interval;
 	s32 delta;
 
-	interval = net->ipv4.sysctl_tcp_probe_interval;
+	interval = READ_ONCE(net->ipv4.sysctl_tcp_probe_interval);
 	delta = tcp_jiffies32 - icsk->icsk_mtup.probe_timestamp;
 	if (unlikely(delta >= interval * HZ)) {
 		int mss = tcp_current_mss(sk);
-- 
2.35.1



