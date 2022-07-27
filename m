Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36576582E01
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 19:06:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233389AbiG0RGQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 13:06:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233068AbiG0REs (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 13:04:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 183A75A2C1;
        Wed, 27 Jul 2022 09:39:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 94EC8B8200C;
        Wed, 27 Jul 2022 16:39:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA5B5C433D7;
        Wed, 27 Jul 2022 16:39:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658939965;
        bh=dKxg26OoA3nUfbPZ8osDPGwHpVFBvL21XATFAJ+7CZ8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PtDQxORWSSkZhEZfwp1lj7e7vlPSk3Wa7gVjSB6sCCsHOnEonYXqEKEeUa0GtzGCz
         uPfz9xsrbA1ORKbX1dQmRQsokqiEHj1cQj6pTwLUxB4ZMDayqRAlnVvTOZ6uIFX7wg
         PUP6cFHEbknzDkTySkGL+PMK7zzefpek9byZpR9U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kuniyuki Iwashima <kuniyu@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 058/201] ip: Fix a data-race around sysctl_ip_autobind_reuse.
Date:   Wed, 27 Jul 2022 18:09:22 +0200
Message-Id: <20220727161029.325785703@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727161026.977588183@linuxfoundation.org>
References: <20220727161026.977588183@linuxfoundation.org>
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

[ Upstream commit 0db232765887d9807df8bcb7b6f29b2871539eab ]

While reading sysctl_ip_autobind_reuse, it can be changed concurrently.
Thus, we need to add READ_ONCE() to its reader.

Fixes: 4b01a9674231 ("tcp: bind(0) remove the SO_REUSEADDR restriction when ephemeral ports are exhausted.")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/inet_connection_sock.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
index 62a67fdc344c..d3bbb344bbe1 100644
--- a/net/ipv4/inet_connection_sock.c
+++ b/net/ipv4/inet_connection_sock.c
@@ -259,7 +259,7 @@ inet_csk_find_open_port(struct sock *sk, struct inet_bind_bucket **tb_ret, int *
 		goto other_half_scan;
 	}
 
-	if (net->ipv4.sysctl_ip_autobind_reuse && !relax) {
+	if (READ_ONCE(net->ipv4.sysctl_ip_autobind_reuse) && !relax) {
 		/* We still have a chance to connect to different destinations */
 		relax = true;
 		goto ports_exhausted;
-- 
2.35.1



