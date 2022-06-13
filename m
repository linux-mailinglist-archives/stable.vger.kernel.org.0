Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8DB9548A78
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:07:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355254AbiFMLkU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 07:40:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355615AbiFMLjU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 07:39:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 333A92408D;
        Mon, 13 Jun 2022 03:49:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C565A6112A;
        Mon, 13 Jun 2022 10:49:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7A63C34114;
        Mon, 13 Jun 2022 10:49:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655117353;
        bh=umwNkXTx7sDT3ai+IsIbt1bhi7bdx1N7XGvJqxUXjCA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UJfI4HPSMyI3CCSgrOYE/TEmcjONfMO7JZbkAzYS68uwLXuWuoeL/tOFLn73bR/O0
         pTQdW+jianpnw1nVBWMOYdhh02A6bUZZzSGsGfTYwQ2qV+UBDHIwKImQgrygxi1wca
         Ad0e+JLzk62R/tooWssoNyQLlLhD1b3vRMMheEMs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kuniyuki Iwashima <kuniyu@amazon.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 352/411] af_unix: Fix a data-race in unix_dgram_peer_wake_me().
Date:   Mon, 13 Jun 2022 12:10:25 +0200
Message-Id: <20220613094939.258047663@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094928.482772422@linuxfoundation.org>
References: <20220613094928.482772422@linuxfoundation.org>
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
index 05470ca91bd9..f33e90bd0683 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -440,7 +440,7 @@ static int unix_dgram_peer_wake_me(struct sock *sk, struct sock *other)
 	 * -ECONNREFUSED. Otherwise, if we haven't queued any skbs
 	 * to other and its full, we will hang waiting for POLLOUT.
 	 */
-	if (unix_recvq_full(other) && !sock_flag(other, SOCK_DEAD))
+	if (unix_recvq_full_lockless(other) && !sock_flag(other, SOCK_DEAD))
 		return 1;
 
 	if (connected)
-- 
2.35.1



