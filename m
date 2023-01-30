Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBE6068130A
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 15:27:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236159AbjA3O1z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 09:27:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236382AbjA3O10 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 09:27:26 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCB17269B
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 06:25:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 61AE861015
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 14:25:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4454FC433EF;
        Mon, 30 Jan 2023 14:25:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675088751;
        bh=wWBuH0f3BkbjCXVoZPliqaKw8ibD4iE3JVQWKxZ7BEU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cIOIDhFO7I3FZKahsecETbYTPj3/hL6oRVwJfqgH2lR0mE4efSXhBJDj+FrzA96dk
         u99NgdlKN5XvPCie8P+T93mmjmylMOh7h5RYIguYvKwPJ+AZSn/MOwIEoi4EnKqX6f
         YZjfC8WAY6E6dFD3ZK0/mFezRbd3swIIXjxrtooo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 124/143] ipv4: prevent potential spectre v1 gadget in fib_metrics_match()
Date:   Mon, 30 Jan 2023 14:53:01 +0100
Message-Id: <20230130134311.957967597@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134306.862721518@linuxfoundation.org>
References: <20230130134306.862721518@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 5e9398a26a92fc402d82ce1f97cc67d832527da0 ]

if (!type)
        continue;
    if (type > RTAX_MAX)
        return false;
    ...
    fi_val = fi->fib_metrics->metrics[type - 1];

@type being used as an array index, we need to prevent
cpu speculation or risk leaking kernel memory content.

Fixes: 5f9ae3d9e7e4 ("ipv4: do metrics match when looking up and deleting a route")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Link: https://lore.kernel.org/r/20230120133140.3624204-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/fib_semantics.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/ipv4/fib_semantics.c b/net/ipv4/fib_semantics.c
index ab9fcc6231b8..4e94796ccdbd 100644
--- a/net/ipv4/fib_semantics.c
+++ b/net/ipv4/fib_semantics.c
@@ -30,6 +30,7 @@
 #include <linux/slab.h>
 #include <linux/netlink.h>
 #include <linux/hash.h>
+#include <linux/nospec.h>
 
 #include <net/arp.h>
 #include <net/ip.h>
@@ -1021,6 +1022,7 @@ bool fib_metrics_match(struct fib_config *cfg, struct fib_info *fi)
 		if (type > RTAX_MAX)
 			return false;
 
+		type = array_index_nospec(type, RTAX_MAX + 1);
 		if (type == RTAX_CC_ALGO) {
 			char tmp[TCP_CA_NAME_MAX];
 			bool ecn_ca = false;
-- 
2.39.0



