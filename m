Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 410C4582CC7
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 18:51:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240652AbiG0Que (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 12:50:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240786AbiG0QtZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 12:49:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 295954E86A;
        Wed, 27 Jul 2022 09:32:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6E9ADB81F90;
        Wed, 27 Jul 2022 16:32:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6204C433C1;
        Wed, 27 Jul 2022 16:32:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658939573;
        bh=U7SjzZ87V97EDXdPPtKXqWDbu9YvGTtPAJ7iSO2QroU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w6AQp3hxrMixzMpF9VZsnflX2N11FrqXWPZZKaKKX4s6F4o5zkJ8/oS0saaTV9Wbx
         RGfHhVe3HPeMju0qdHNwyX4JW+0K/41ICqQMMUQ/qQnPkiN0YmvYip/KBADz1v8rL8
         0Z+U6TqRCVCgohZeGvLugedl83x+jfu8c+vOJr78=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kuniyuki Iwashima <kuniyu@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 029/105] ip: Fix data-races around sysctl_ip_fwd_use_pmtu.
Date:   Wed, 27 Jul 2022 18:10:15 +0200
Message-Id: <20220727161013.272212651@linuxfoundation.org>
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

[ Upstream commit 60c158dc7b1f0558f6cadd5b50d0386da0000d50 ]

While reading sysctl_ip_fwd_use_pmtu, it can be changed concurrently.
Thus, we need to add READ_ONCE() to its readers.

Fixes: f87c10a8aa1e ("ipv4: introduce ip_dst_mtu_maybe_forward and protect forwarding path against pmtu spoofing")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/ip.h | 2 +-
 net/ipv4/route.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/net/ip.h b/include/net/ip.h
index 76aaa7eb5b82..a7e40ef02732 100644
--- a/include/net/ip.h
+++ b/include/net/ip.h
@@ -440,7 +440,7 @@ static inline unsigned int ip_dst_mtu_maybe_forward(const struct dst_entry *dst,
 	struct net *net = dev_net(dst->dev);
 	unsigned int mtu;
 
-	if (net->ipv4.sysctl_ip_fwd_use_pmtu ||
+	if (READ_ONCE(net->ipv4.sysctl_ip_fwd_use_pmtu) ||
 	    ip_mtu_locked(dst) ||
 	    !forwarding)
 		return dst_mtu(dst);
diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index aab8ac383d5d..374647693d7a 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -1442,7 +1442,7 @@ u32 ip_mtu_from_fib_result(struct fib_result *res, __be32 daddr)
 	struct fib_info *fi = res->fi;
 	u32 mtu = 0;
 
-	if (dev_net(dev)->ipv4.sysctl_ip_fwd_use_pmtu ||
+	if (READ_ONCE(dev_net(dev)->ipv4.sysctl_ip_fwd_use_pmtu) ||
 	    fi->fib_metrics->metrics[RTAX_LOCK - 1] & (1 << RTAX_MTU))
 		mtu = fi->fib_mtu;
 
-- 
2.35.1



