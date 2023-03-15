Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2078E6BB316
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 13:41:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233038AbjCOMl3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 08:41:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233002AbjCOMlC (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 08:41:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B11BB3B67E
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 05:39:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C2864B81E1B
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 12:39:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D4B7C433EF;
        Wed, 15 Mar 2023 12:39:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678883989;
        bh=kFgOJ7D371dxryx5DwiU2D9Yt091mq2CLyzln4RljJI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zNKNVKuoVkvLFOW2Ej79ay/RYXSZ84jXTkBNgJIjWfasVh/Ec93aeVdfXIlWvyvQX
         mzErYbAe7TLHk7A04yoc10ClC145Pk/tAoc1zxfqGcI74hu5ulJsUXrWYqzTo10L9k
         Ybi8w/Lza0SI86BnxoQVWhWBjELqYtFT8LYrlKb8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Florian Westphal <fw@strlen.de>,
        Brian Vazquez <brianvv@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 063/141] net: use indirect calls helpers for sk_exit_memory_pressure()
Date:   Wed, 15 Mar 2023 13:12:46 +0100
Message-Id: <20230315115741.875759445@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115739.932786806@linuxfoundation.org>
References: <20230315115739.932786806@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Brian Vazquez <brianvv@google.com>

[ Upstream commit 5c1ebbfabcd61142a4551bfc0e51840f9bdae7af ]

Florian reported a regression and sent a patch with the following
changelog:

<quote>
 There is a noticeable tcp performance regression (loopback or cross-netns),
 seen with iperf3 -Z (sendfile mode) when generic retpolines are needed.

 With SK_RECLAIM_THRESHOLD checks gone number of calls to enter/leave
 memory pressure happen much more often. For TCP indirect calls are
 used.

 We can't remove the if-set-return short-circuit check in
 tcp_enter_memory_pressure because there are callers other than
 sk_enter_memory_pressure.  Doing a check in the sk wrapper too
 reduces the indirect calls enough to recover some performance.

 Before,
 0.00-60.00  sec   322 GBytes  46.1 Gbits/sec                  receiver

 After:
 0.00-60.04  sec   359 GBytes  51.4 Gbits/sec                  receiver

 "iperf3 -c $peer -t 60 -Z -f g", connected via veth in another netns.
</quote>

It seems we forgot to upstream this indirect call mitigation we
had for years, lets do this instead.

[edumazet] - It seems we forgot to upstream this indirect call
             mitigation we had for years, let's do this instead.
           - Changed to INDIRECT_CALL_INET_1() to avoid bots reports.

Fixes: 4890b686f408 ("net: keep sk->sk_forward_alloc as small as possible")
Reported-by: Florian Westphal <fw@strlen.de>
Link: https://lore.kernel.org/netdev/20230227152741.4a53634b@kernel.org/T/
Signed-off-by: Brian Vazquez <brianvv@google.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Link: https://lore.kernel.org/r/20230301133247.2346111-1-edumazet@google.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/sock.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/core/sock.c b/net/core/sock.c
index 63680f999bf6d..9796a5fa6ceaa 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -2827,7 +2827,8 @@ static void sk_enter_memory_pressure(struct sock *sk)
 static void sk_leave_memory_pressure(struct sock *sk)
 {
 	if (sk->sk_prot->leave_memory_pressure) {
-		sk->sk_prot->leave_memory_pressure(sk);
+		INDIRECT_CALL_INET_1(sk->sk_prot->leave_memory_pressure,
+				     tcp_leave_memory_pressure, sk);
 	} else {
 		unsigned long *memory_pressure = sk->sk_prot->memory_pressure;
 
-- 
2.39.2



