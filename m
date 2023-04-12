Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F0156DEEA7
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 10:44:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231219AbjDLIoO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 04:44:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229806AbjDLIn6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 04:43:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F171340FB
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 01:43:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 390BB63093
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 08:42:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49859C433D2;
        Wed, 12 Apr 2023 08:42:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681288953;
        bh=I44o5K3/fVFmDAqmxZRhB37N9DMHiXe/wyi0gEi+8v0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yQ9aVECfI8y8eeFYoLjKkwIhqhwXYMlJV73SJqob+lHaHzsWePtCi2PeBvp9MLtqm
         MUf3w/nOK3y77IORmOh3EiDqV6tCE1/bnklogaAR7x6aaJHpqliuh3GedPcifOpN/4
         hwx+ELijv3x0KZoyevh2YSE1zQW4uC6ADzUvgrXA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Kuniyuki Iwashima <kuniyu@amazon.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 050/164] ping: Fix potentail NULL deref for /proc/net/icmp.
Date:   Wed, 12 Apr 2023 10:32:52 +0200
Message-Id: <20230412082838.965021122@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082836.695875037@linuxfoundation.org>
References: <20230412082836.695875037@linuxfoundation.org>
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

From: Kuniyuki Iwashima <kuniyu@amazon.com>

[ Upstream commit ab5fb73ffa01072b4d8031cc05801fa1cb653bee ]

After commit dbca1596bbb0 ("ping: convert to RCU lookups, get rid
of rwlock"), we use RCU for ping sockets, but we should use spinlock
for /proc/net/icmp to avoid a potential NULL deref mentioned in
the previous patch.

Let's go back to using spinlock there.

Note we can convert ping sockets to use hlist instead of hlist_nulls
because we do not use SLAB_TYPESAFE_BY_RCU for ping sockets.

Fixes: dbca1596bbb0 ("ping: convert to RCU lookups, get rid of rwlock")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/ping.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/ping.c b/net/ipv4/ping.c
index 409ec2a1f95b0..5178a3f3cb537 100644
--- a/net/ipv4/ping.c
+++ b/net/ipv4/ping.c
@@ -1089,13 +1089,13 @@ static struct sock *ping_get_idx(struct seq_file *seq, loff_t pos)
 }
 
 void *ping_seq_start(struct seq_file *seq, loff_t *pos, sa_family_t family)
-	__acquires(RCU)
+	__acquires(ping_table.lock)
 {
 	struct ping_iter_state *state = seq->private;
 	state->bucket = 0;
 	state->family = family;
 
-	rcu_read_lock();
+	spin_lock(&ping_table.lock);
 
 	return *pos ? ping_get_idx(seq, *pos-1) : SEQ_START_TOKEN;
 }
@@ -1121,9 +1121,9 @@ void *ping_seq_next(struct seq_file *seq, void *v, loff_t *pos)
 EXPORT_SYMBOL_GPL(ping_seq_next);
 
 void ping_seq_stop(struct seq_file *seq, void *v)
-	__releases(RCU)
+	__releases(ping_table.lock)
 {
-	rcu_read_unlock();
+	spin_unlock(&ping_table.lock);
 }
 EXPORT_SYMBOL_GPL(ping_seq_stop);
 
-- 
2.39.2



