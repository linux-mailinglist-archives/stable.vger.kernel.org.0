Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69CBE582D38
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 18:55:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240777AbiG0QyF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 12:54:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240867AbiG0Qwp (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 12:52:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E66E4D4D6;
        Wed, 27 Jul 2022 09:34:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2DA3561A3F;
        Wed, 27 Jul 2022 16:34:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13F61C433D6;
        Wed, 27 Jul 2022 16:34:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658939695;
        bh=vxPJPnvPSpdpqJTN8v+43mt7W4CL1/GrqoBK8VR7Mak=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hM4oMiczewenRMIalFGvjV+ejEY241MbmeWnYOIVgxId5nC6+xpbNRttJcbj1dp4K
         WX3Rsn/63V5LGTOlx9hyUbODW795f4svlUshSDrxq6KXichPC4A6CjiWGOvMF3vtLJ
         0yYPIi7HL0rvipoO5efxIjyo/AHetu1uhb3hVepo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kuniyuki Iwashima <kuniyu@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 054/105] tcp: Fix data-races around sysctl_max_syn_backlog.
Date:   Wed, 27 Jul 2022 18:10:40 +0200
Message-Id: <20220727161014.250317229@linuxfoundation.org>
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

[ Upstream commit 79539f34743d3e14cc1fa6577d326a82cc64d62f ]

While reading sysctl_max_syn_backlog, it can be changed concurrently.
Thus, we need to add READ_ONCE() to its readers.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp_input.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 070e7015e9c9..5cbabe0e42c9 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -6847,10 +6847,12 @@ int tcp_conn_request(struct request_sock_ops *rsk_ops,
 		goto drop_and_free;
 
 	if (!want_cookie && !isn) {
+		int max_syn_backlog = READ_ONCE(net->ipv4.sysctl_max_syn_backlog);
+
 		/* Kill the following clause, if you dislike this way. */
 		if (!syncookies &&
-		    (net->ipv4.sysctl_max_syn_backlog - inet_csk_reqsk_queue_len(sk) <
-		     (net->ipv4.sysctl_max_syn_backlog >> 2)) &&
+		    (max_syn_backlog - inet_csk_reqsk_queue_len(sk) <
+		     (max_syn_backlog >> 2)) &&
 		    !tcp_peer_is_proven(req, dst)) {
 			/* Without syncookies last quarter of
 			 * backlog is filled with destinations,
-- 
2.35.1



