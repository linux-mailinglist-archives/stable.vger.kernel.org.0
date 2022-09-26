Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C9DB5E9F67
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 12:25:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235282AbiIZKZ1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 06:25:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235503AbiIZKYB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 06:24:01 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3792E24976;
        Mon, 26 Sep 2022 03:17:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id D94A1CE10E7;
        Mon, 26 Sep 2022 10:17:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC024C433D6;
        Mon, 26 Sep 2022 10:17:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664187429;
        bh=HVuPhUn9njpNSbwTg1K0crLg+rxgha7VzQvBYb2G5sI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kP9j6m3z1MYhxycDERsiETYEgOCx3V2ZaLijN6hDTyYM2w7x3+5Cr8oDCnIZ09R+9
         EphrIpg96Ktp4NF9vrGtygrFTMQQ7NSn9Ywp7aj8F3BUNeO+WSDydtZfkdwJtvbDU3
         jqBwYjYY2g9nxDeMhHHaaA54Th6ZAi88epW2A2Uw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        Sasha Levin <sashal@kernel.org>,
        syzbot+a24c5252f3e3ab733464@syzkaller.appspotmail.com
Subject: [PATCH 4.14 31/40] netfilter: ebtables: fix memory leak when blob is malformed
Date:   Mon, 26 Sep 2022 12:11:59 +0200
Message-Id: <20220926100739.486380208@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100738.148626940@linuxfoundation.org>
References: <20220926100738.148626940@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 62ce44c4fff947eebdf10bb582267e686e6835c9 ]

The bug fix was incomplete, it "replaced" crash with a memory leak.
The old code had an assignment to "ret" embedded into the conditional,
restore this.

Fixes: 7997eff82828 ("netfilter: ebtables: reject blobs that don't provide all entry points")
Reported-and-tested-by: syzbot+a24c5252f3e3ab733464@syzkaller.appspotmail.com
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bridge/netfilter/ebtables.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/bridge/netfilter/ebtables.c b/net/bridge/netfilter/ebtables.c
index a54149f10f7e..84d4b4a0b053 100644
--- a/net/bridge/netfilter/ebtables.c
+++ b/net/bridge/netfilter/ebtables.c
@@ -991,8 +991,10 @@ static int do_replace_finish(struct net *net, struct ebt_replace *repl,
 		goto free_iterate;
 	}
 
-	if (repl->valid_hooks != t->valid_hooks)
+	if (repl->valid_hooks != t->valid_hooks) {
+		ret = -EINVAL;
 		goto free_unlock;
+	}
 
 	if (repl->num_counters && repl->num_counters != t->private->nentries) {
 		ret = -EINVAL;
-- 
2.35.1



