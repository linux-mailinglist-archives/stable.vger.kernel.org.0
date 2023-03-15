Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD2F76BB33F
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 13:42:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232883AbjCOMmj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 08:42:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232877AbjCOMmY (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 08:42:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 595FBA5697
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 05:41:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 27BAB61D51
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 12:41:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B757C4339B;
        Wed, 15 Mar 2023 12:41:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678884065;
        bh=EEaSLg5I0mxMPHW2OzHjCNFAD5jE5zPg2goGsXWRWbk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HDpy1rb87PXCUIQLQyvfy8MTUDOnM7sweJudSEMqVa/np+SKht4JrBxSV9pNbdMYM
         DVraIUes8Hc275ltSjdUST1W5u6Nh9P9kjhGR+Yyuj6mFCxGQz1cgjPBvvhxZUjLyE
         3RVBMwaw2v9x/wlBaoT60B0hkfMCedzOsH3uObhc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Eric Dumazet <edumazet@google.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 093/141] netfilter: conntrack: adopt safer max chain length
Date:   Wed, 15 Mar 2023 13:13:16 +0100
Message-Id: <20230315115742.824111283@linuxfoundation.org>
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

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit c77737b736ceb50fdf150434347dbd81ec76dbb1 ]

Customers using GKE 1.25 and 1.26 are facing conntrack issues
root caused to commit c9c3b6811f74 ("netfilter: conntrack: make
max chain length random").

Even if we assume Uniform Hashing, a bucket often reachs 8 chained
items while the load factor of the hash table is smaller than 0.5

With a limit of 16, we reach load factors of 3.
With a limit of 32, we reach load factors of 11.
With a limit of 40, we reach load factors of 15.
With a limit of 50, we reach load factors of 24.

This patch changes MIN_CHAINLEN to 50, to minimize risks.

Ideally, we could in the future add a cushion based on expected
load factor (2 * nf_conntrack_max / nf_conntrack_buckets),
because some setups might expect unusual values.

Fixes: c9c3b6811f74 ("netfilter: conntrack: make max chain length random")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_conntrack_core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index ead11a9c261f3..19e3afb23fdaf 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -96,8 +96,8 @@ static DEFINE_MUTEX(nf_conntrack_mutex);
 #define GC_SCAN_MAX_DURATION	msecs_to_jiffies(10)
 #define GC_SCAN_EXPIRED_MAX	(64000u / HZ)
 
-#define MIN_CHAINLEN	8u
-#define MAX_CHAINLEN	(32u - MIN_CHAINLEN)
+#define MIN_CHAINLEN	50u
+#define MAX_CHAINLEN	(80u - MIN_CHAINLEN)
 
 static struct conntrack_gc_work conntrack_gc_work;
 
-- 
2.39.2



