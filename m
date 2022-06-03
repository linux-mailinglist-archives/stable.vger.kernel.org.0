Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B32B653D028
	for <lists+stable@lfdr.de>; Fri,  3 Jun 2022 20:01:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346131AbiFCR7y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jun 2022 13:59:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346124AbiFCR7E (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jun 2022 13:59:04 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE7B7580D4;
        Fri,  3 Jun 2022 10:55:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7AC72B8241E;
        Fri,  3 Jun 2022 17:55:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC598C385A9;
        Fri,  3 Jun 2022 17:55:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654278908;
        bh=+jKGu2m+qotB5j1a1TjLLakeDpMh01+5nUzTVxMt6Vo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ippTYbmxJiPI0i9GcGItoy5hJfp1NKRhd0ZGcv834adl7p4XnWjasdz7S/W3xy+0R
         3PkbsM5DOe8XFgdiKVql8vTkJ9bKOxUnVEvSon7ALXQE4u4hUoKI92e8vyHfLormtf
         yshyRr+ZHDGbtX8UrpYd5rpyujsTOVJygxL/D5mU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+793a590957d9c1b96620@syzkaller.appspotmail.com,
        Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 5.17 25/75] netfilter: conntrack: re-fetch conntrack after insertion
Date:   Fri,  3 Jun 2022 19:43:09 +0200
Message-Id: <20220603173822.461919057@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220603173821.749019262@linuxfoundation.org>
References: <20220603173821.749019262@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

commit 56b14ecec97f39118bf85c9ac2438c5a949509ed upstream.

In case the conntrack is clashing, insertion can free skb->_nfct and
set skb->_nfct to the already-confirmed entry.

This wasn't found before because the conntrack entry and the extension
space used to free'd after an rcu grace period, plus the race needs
events enabled to trigger.

Reported-by: <syzbot+793a590957d9c1b96620@syzkaller.appspotmail.com>
Fixes: 71d8c47fc653 ("netfilter: conntrack: introduce clash resolution on insertion race")
Fixes: 2ad9d7747c10 ("netfilter: conntrack: free extension area immediately")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/netfilter/nf_conntrack_core.h |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/include/net/netfilter/nf_conntrack_core.h
+++ b/include/net/netfilter/nf_conntrack_core.h
@@ -58,8 +58,13 @@ static inline int nf_conntrack_confirm(s
 	int ret = NF_ACCEPT;
 
 	if (ct) {
-		if (!nf_ct_is_confirmed(ct))
+		if (!nf_ct_is_confirmed(ct)) {
 			ret = __nf_conntrack_confirm(skb);
+
+			if (ret == NF_ACCEPT)
+				ct = (struct nf_conn *)skb_nfct(skb);
+		}
+
 		if (likely(ret == NF_ACCEPT))
 			nf_ct_deliver_cached_events(ct);
 	}


