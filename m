Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F7F6582B08
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 18:26:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236847AbiG0Q0p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 12:26:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236318AbiG0QZr (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 12:25:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B566B4F181;
        Wed, 27 Jul 2022 09:23:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6AF90619DD;
        Wed, 27 Jul 2022 16:23:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 722DCC433D6;
        Wed, 27 Jul 2022 16:23:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658938997;
        bh=c3tV6BAXwRyUF0hyRxeSfe4RgHesWx2wasczt0+YFDU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z6tU3AkuiAQ2YhggJMEb8wfoyOkp+N34t5uF4o7Wa+NbC5ouyKBdE8no8+GRbDUdb
         h6L3tLJtF5Wk4sKQT0qFyRJENTqK5dqzBw/OtuMeM3Rd+9VTCI0FpSWrIbAvf8XXQb
         Chjon2Yd0qbTUksbYoqFYYgwdG323M6/46dGFPuc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kuniyuki Iwashima <kuniyu@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 07/37] tcp: Fix a data-race around sysctl_tcp_probe_threshold.
Date:   Wed, 27 Jul 2022 18:10:33 +0200
Message-Id: <20220727161001.151820081@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727161000.822869853@linuxfoundation.org>
References: <20220727161000.822869853@linuxfoundation.org>
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

[ Upstream commit 92c0aa4175474483d6cf373314343d4e624e882a ]

While reading sysctl_tcp_probe_threshold, it can be changed concurrently.
Thus, we need to add READ_ONCE() to its reader.

Fixes: 6b58e0a5f32d ("ipv4: Use binary search to choose tcp PMTU probe_size")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp_output.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index a231993c81c4..8ac23e8439c3 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -2087,7 +2087,7 @@ static int tcp_mtu_probe(struct sock *sk)
 	 * probing process by not resetting search range to its orignal.
 	 */
 	if (probe_size > tcp_mtu_to_mss(sk, icsk->icsk_mtup.search_high) ||
-		interval < net->ipv4.sysctl_tcp_probe_threshold) {
+	    interval < READ_ONCE(net->ipv4.sysctl_tcp_probe_threshold)) {
 		/* Check whether enough time has elaplased for
 		 * another round of probing.
 		 */
-- 
2.35.1



