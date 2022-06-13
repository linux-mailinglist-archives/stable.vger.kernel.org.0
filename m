Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CCC4548897
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:02:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358804AbiFMNLp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 09:11:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357548AbiFMNGX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 09:06:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88C3437A99;
        Mon, 13 Jun 2022 04:18:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0B66160F18;
        Mon, 13 Jun 2022 11:18:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 178D4C34114;
        Mon, 13 Jun 2022 11:18:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655119108;
        bh=UArQUhck6Fc5jufA0UWjZnQNQgFHa5m1QG8+p+nZfk8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=00zX5ACwzmBfapae7btg+ioch7drrn7ICVgS5xSE7j4LxRJ5zxa7qETBdlVjvTWYG
         XNxHDpfUlRjIwN/9Iu8ZeAOhgd/UNzlPrRjoqpP5fmyTntMUNYGIcBnO7PEtNFAeHr
         Y/OUPghGaWzll8BPxW5B4irdWY2E6dRJWpk5Av0A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kuniyuki Iwashima <kuniyu@amazon.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 144/247] af_unix: Fix a data-race in unix_dgram_peer_wake_me().
Date:   Mon, 13 Jun 2022 12:10:46 +0200
Message-Id: <20220613094927.322167391@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094922.843438024@linuxfoundation.org>
References: <20220613094922.843438024@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kuniyuki Iwashima <kuniyu@amazon.com>

[ Upstream commit 662a80946ce13633ae90a55379f1346c10f0c432 ]

unix_dgram_poll() calls unix_dgram_peer_wake_me() without `other`'s
lock held and check if its receive queue is full.  Here we need to
use unix_recvq_full_lockless() instead of unix_recvq_full(), otherwise
KCSAN will report a data-race.

Fixes: 7d267278a9ec ("unix: avoid use-after-free in ep_remove_wait_queue")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Link: https://lore.kernel.org/r/20220605232325.11804-1-kuniyu@amazon.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/unix/af_unix.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index 62f47821d783..b7be8d066753 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -446,7 +446,7 @@ static int unix_dgram_peer_wake_me(struct sock *sk, struct sock *other)
 	 * -ECONNREFUSED. Otherwise, if we haven't queued any skbs
 	 * to other and its full, we will hang waiting for POLLOUT.
 	 */
-	if (unix_recvq_full(other) && !sock_flag(other, SOCK_DEAD))
+	if (unix_recvq_full_lockless(other) && !sock_flag(other, SOCK_DEAD))
 		return 1;
 
 	if (connected)
-- 
2.35.1



