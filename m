Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 122284989D1
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 19:59:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245387AbiAXS63 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 13:58:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344435AbiAXSyk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 13:54:40 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30BA1C06175E;
        Mon, 24 Jan 2022 10:53:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EC80DB8121A;
        Mon, 24 Jan 2022 18:53:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0944C340E5;
        Mon, 24 Jan 2022 18:53:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643050405;
        bh=Jp1D2HXeEPJRnII3/fBMon8Hpv+73Bm1AarWOZp1Gfk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y2BmY5eP6H6QWMBaHrzR8O12LysqN1gSfdU4/UOGODfNXehAzoPSLjDDtbvjrr62d
         W3gqdV0ihohjwYhA/Un1IDHMBOFHkWt8FblNb2i75WKDM/or4YKEyWjZ5n2cjCiQ1m
         GpaKD0pajuqwF77sPMxSxBhauMtXL84rViL9sWeQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.4 107/114] netns: add schedule point in ops_exit_list()
Date:   Mon, 24 Jan 2022 19:43:22 +0100
Message-Id: <20220124183930.408812024@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183927.095545464@linuxfoundation.org>
References: <20220124183927.095545464@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

commit 2836615aa22de55b8fca5e32fe1b27a67cda625e upstream.

When under stress, cleanup_net() can have to dismantle
netns in big numbers. ops_exit_list() currently calls
many helpers [1] that have no schedule point, and we can
end up with soft lockups, particularly on hosts
with many cpus.

Even for moderate amount of netns processed by cleanup_net()
this patch avoids latency spikes.

[1] Some of these helpers like fib_sync_up() and fib_sync_down_dev()
are very slow because net/ipv4/fib_semantics.c uses host-wide hash tables,
and ifindex is used as the only input of two hash functions.
    ifindexes tend to be the same for all netns (lo.ifindex==1 per instance)
    This will be fixed in a separate patch.

Fixes: 72ad937abd0a ("net: Add support for batching network namespace cleanups")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/net_namespace.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/net/core/net_namespace.c
+++ b/net/core/net_namespace.c
@@ -130,8 +130,10 @@ static void ops_exit_list(const struct p
 {
 	struct net *net;
 	if (ops->exit) {
-		list_for_each_entry(net, net_exit_list, exit_list)
+		list_for_each_entry(net, net_exit_list, exit_list) {
 			ops->exit(net);
+			cond_resched();
+		}
 	}
 	if (ops->exit_batch)
 		ops->exit_batch(net_exit_list);


