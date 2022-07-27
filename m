Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE850582B43
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 18:30:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236461AbiG0Qay (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 12:30:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236502AbiG0Qac (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 12:30:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DC22205EC;
        Wed, 27 Jul 2022 09:25:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 43401B821BB;
        Wed, 27 Jul 2022 16:25:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82905C433C1;
        Wed, 27 Jul 2022 16:24:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658939099;
        bh=bSwEOEpsY25YU1kuF2UzXaIWJQ9XzvhLMp13mR3AYZ4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1p3wN9v3qFDmLx0y9NUH59BKB7AixQlWcOdAIHudzvqPZRGNpr9Qzmxy07jyYIOkr
         R0XaqrxLBsbb+YcaJMpYQmnMOZZiqVr+UPDMI96qArHEd32ihb+2QOLuSPBCBYLXYk
         wLxyffn3zCWm50zPmSav2QyRb3t9a7BGcfp4KTgo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kuniyuki Iwashima <kuniyu@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 13/62] tcp: Fix a data-race around sysctl_tcp_probe_interval.
Date:   Wed, 27 Jul 2022 18:10:22 +0200
Message-Id: <20220727161004.701546594@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727161004.175638564@linuxfoundation.org>
References: <20220727161004.175638564@linuxfoundation.org>
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
index 0e0f7803cf4e..33f9a486661c 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -2030,7 +2030,7 @@ static inline void tcp_mtu_check_reprobe(struct sock *sk)
 	u32 interval;
 	s32 delta;
 
-	interval = net->ipv4.sysctl_tcp_probe_interval;
+	interval = READ_ONCE(net->ipv4.sysctl_tcp_probe_interval);
 	delta = tcp_jiffies32 - icsk->icsk_mtup.probe_timestamp;
 	if (unlikely(delta >= interval * HZ)) {
 		int mss = tcp_current_mss(sk);
-- 
2.35.1



