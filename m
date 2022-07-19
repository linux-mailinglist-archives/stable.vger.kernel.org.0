Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20982579DC6
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 14:55:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239052AbiGSMy7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 08:54:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242456AbiGSMyf (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 08:54:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BE1F97A1A;
        Tue, 19 Jul 2022 05:21:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1B22C618F4;
        Tue, 19 Jul 2022 12:21:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2DF0C341CF;
        Tue, 19 Jul 2022 12:21:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658233298;
        bh=wq5LS4JHOJWWJMM6YSTKJp2K1XVCUQrIjJ+BrHZeLKI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TBNDeBUdf8OqPUOPRDbZEAfYJZK/wpibku2A8ybQQuj0yBtl8GJNOe8a+l3+jbrdv
         milY2XOKOhrkFdSAUFRDWQy3yp4W4mqQjPsEEk7MJDke1auaOhioYlc2nGSXD3V9XC
         AvxYNIETa5bXXps4AzEhMmbr2XRFCpVdz4W0PpKA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kuniyuki Iwashima <kuniyu@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 075/231] tcp: Fix a data-race around sysctl_tcp_max_orphans.
Date:   Tue, 19 Jul 2022 13:52:40 +0200
Message-Id: <20220719114721.012013257@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719114714.247441733@linuxfoundation.org>
References: <20220719114714.247441733@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kuniyuki Iwashima <kuniyu@amazon.com>

[ Upstream commit 47e6ab24e8c6e3ca10ceb5835413f401f90de4bf ]

While reading sysctl_tcp_max_orphans, it can be changed concurrently.
So, we need to add READ_ONCE() to avoid a data-race.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index e31cf137c614..f2fd1779d925 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -2735,7 +2735,8 @@ static void tcp_orphan_update(struct timer_list *unused)
 
 static bool tcp_too_many_orphans(int shift)
 {
-	return READ_ONCE(tcp_orphan_cache) << shift > sysctl_tcp_max_orphans;
+	return READ_ONCE(tcp_orphan_cache) << shift >
+		READ_ONCE(sysctl_tcp_max_orphans);
 }
 
 bool tcp_check_oom(struct sock *sk, int shift)
-- 
2.35.1



