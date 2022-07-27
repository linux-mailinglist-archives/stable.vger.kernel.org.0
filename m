Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FC41582C1A
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 18:42:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238660AbiG0Qlz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 12:41:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239452AbiG0QlY (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 12:41:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1A5E5B068;
        Wed, 27 Jul 2022 09:29:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 63EF361A1E;
        Wed, 27 Jul 2022 16:29:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70A64C433C1;
        Wed, 27 Jul 2022 16:29:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658939377;
        bh=BWlv9WhHqHjZUjHfPVXIuG4fj36+jf4NC1pmkcWguiU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dfxPRgXb+yYKXf8KMChbaHjcr3OYL1E0vzWvnfsgzv0IjIYS4uS2Eqwwb+3vgI45M
         +VxUpl07H7eMZLEDx8MzQjT58WOS3QA+p2iKmxf46gA2aVxA8+UdbDXub6X94XykXX
         qdLhcdf5tV3TQ0M/B1ab9IAjIS1my9HajnNy+rc0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kuniyuki Iwashima <kuniyu@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 17/87] ip: Fix data-races around sysctl_ip_fwd_use_pmtu.
Date:   Wed, 27 Jul 2022 18:10:10 +0200
Message-Id: <20220727161009.708989076@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727161008.993711844@linuxfoundation.org>
References: <20220727161008.993711844@linuxfoundation.org>
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
index 3f3ea86b2173..21fc0a29a8d4 100644
--- a/include/net/ip.h
+++ b/include/net/ip.h
@@ -442,7 +442,7 @@ static inline unsigned int ip_dst_mtu_maybe_forward(const struct dst_entry *dst,
 	struct net *net = dev_net(dst->dev);
 	unsigned int mtu;
 
-	if (net->ipv4.sysctl_ip_fwd_use_pmtu ||
+	if (READ_ONCE(net->ipv4.sysctl_ip_fwd_use_pmtu) ||
 	    ip_mtu_locked(dst) ||
 	    !forwarding)
 		return dst_mtu(dst);
diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index 9280e5087159..7004e379c325 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -1423,7 +1423,7 @@ u32 ip_mtu_from_fib_result(struct fib_result *res, __be32 daddr)
 	struct fib_info *fi = res->fi;
 	u32 mtu = 0;
 
-	if (dev_net(dev)->ipv4.sysctl_ip_fwd_use_pmtu ||
+	if (READ_ONCE(dev_net(dev)->ipv4.sysctl_ip_fwd_use_pmtu) ||
 	    fi->fib_metrics->metrics[RTAX_LOCK - 1] & (1 << RTAX_MTU))
 		mtu = fi->fib_mtu;
 
-- 
2.35.1



