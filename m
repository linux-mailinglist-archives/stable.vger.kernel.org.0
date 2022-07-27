Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48FA9582D32
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 18:55:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240517AbiG0Qxc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 12:53:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240844AbiG0Qw3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 12:52:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C60B45061;
        Wed, 27 Jul 2022 09:34:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CCCD161A94;
        Wed, 27 Jul 2022 16:34:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D58B9C433C1;
        Wed, 27 Jul 2022 16:34:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658939675;
        bh=UNdIwmeFR+X2tGp88fRtXow2FT7zbH9mXPKbFKuQrTg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kKiqkOvPTd+5+xClmqjSbqWJC5LmQTX3QprqbkP+HyO9RF8pfHRU3WRKSKZpvSAwG
         s0U5+BruDANO+ODMgWnZAOAfWP8civylGXGE5RPVddplfqGhSt/9iz2qL6hqBQLdm/
         JLu7t/EyLWm2bkNwyZbgLA5FAvpS+1WcKM4eVd7M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kuniyuki Iwashima <kuniyu@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 065/105] ipv4: Fix a data-race around sysctl_fib_multipath_use_neigh.
Date:   Wed, 27 Jul 2022 18:10:51 +0200
Message-Id: <20220727161014.664949445@linuxfoundation.org>
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

[ Upstream commit 87507bcb4f5de16bb419e9509d874f4db6c0ad0f ]

While reading sysctl_fib_multipath_use_neigh, it can be changed
concurrently.  Thus, we need to add READ_ONCE() to its reader.

Fixes: a6db4494d218 ("net: ipv4: Consider failed nexthops in multipath routes")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/fib_semantics.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/fib_semantics.c b/net/ipv4/fib_semantics.c
index 70c866308abe..3824b7abecf7 100644
--- a/net/ipv4/fib_semantics.c
+++ b/net/ipv4/fib_semantics.c
@@ -2232,7 +2232,7 @@ void fib_select_multipath(struct fib_result *res, int hash)
 	}
 
 	change_nexthops(fi) {
-		if (net->ipv4.sysctl_fib_multipath_use_neigh) {
+		if (READ_ONCE(net->ipv4.sysctl_fib_multipath_use_neigh)) {
 			if (!fib_good_nh(nexthop_nh))
 				continue;
 			if (!first) {
-- 
2.35.1



