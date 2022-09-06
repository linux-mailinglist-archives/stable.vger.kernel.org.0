Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D4665AEBCF
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 16:27:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240493AbiIFOAa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 10:00:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241057AbiIFN7a (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 09:59:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 341DC82D09;
        Tue,  6 Sep 2022 06:43:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 96717B818D0;
        Tue,  6 Sep 2022 13:43:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBDC8C43470;
        Tue,  6 Sep 2022 13:43:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662471816;
        bh=2c4sK96gPhhn0UxdxSLKiRmQ0B3TvCjIJ8xBNJf7qDc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q05f9PoAKBtHUPmGUrEAowZVREqzpemsH7hnaujYCRzyRtZ5KS2s9JBoaNQthgIxv
         0J/BRuECMGuIOZLiC3ZGCLL/ZV5DDU0sq8WXuROSBt94VnNQumJRpi2qF/zhcEPC8i
         5HT5j0a79JxzCL+284NGJeSS8slUjfv6VTFHm1VU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, syzbot <syzkaller@googlegroups.com>,
        Eric Dumazet <edumazet@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 049/155] tcp: annotate data-race around challenge_timestamp
Date:   Tue,  6 Sep 2022 15:29:57 +0200
Message-Id: <20220906132831.501509826@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220906132829.417117002@linuxfoundation.org>
References: <20220906132829.417117002@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 8c70521238b7863c2af607e20bcba20f974c969b ]

challenge_timestamp can be read an written by concurrent threads.

This was expected, but we need to annotate the race to avoid potential issues.

Following patch moves challenge_timestamp and challenge_count
to per-netns storage to provide better isolation.

Fixes: 354e4aa391ed ("tcp: RFC 5961 5.2 Blind Data Injection Attack Mitigation")
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Acked-by: Neal Cardwell <ncardwell@google.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp_input.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index b1637990d5708..e5435156e545d 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -3630,11 +3630,11 @@ static void tcp_send_challenge_ack(struct sock *sk)
 
 	/* Then check host-wide RFC 5961 rate limit. */
 	now = jiffies / HZ;
-	if (now != challenge_timestamp) {
+	if (now != READ_ONCE(challenge_timestamp)) {
 		u32 ack_limit = READ_ONCE(net->ipv4.sysctl_tcp_challenge_ack_limit);
 		u32 half = (ack_limit + 1) >> 1;
 
-		challenge_timestamp = now;
+		WRITE_ONCE(challenge_timestamp, now);
 		WRITE_ONCE(challenge_count, half + prandom_u32_max(ack_limit));
 	}
 	count = READ_ONCE(challenge_count);
-- 
2.35.1



