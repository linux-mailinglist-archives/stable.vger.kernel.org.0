Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 897A049A8D4
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 05:16:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349798AbiAYDQh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 22:16:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345731AbiAXTJS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:09:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D430C061359;
        Mon, 24 Jan 2022 11:02:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9FA9460E8D;
        Mon, 24 Jan 2022 19:02:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D289C340E5;
        Mon, 24 Jan 2022 19:02:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643050936;
        bh=/21cnJbkG4LiQeLMdTF15F+v5kVgRMWcxYcW/eO6v+4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oQuYxTqezyjmotmt6jGWhRbtTdZBbyWREdV5ZMMcOO61LeIwCRWWOsy1FgpO8cwCW
         FnkDg6xnw0/r8Enr5U469CWDvr+RAvqjCQ5DhcrzfLQacJcEa9ts4b/rS1ZkdfPZ93
         7PzVo9EzwNZXNtmhtlGVKvqBiJKQng4bkgQ6u2Tg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Paul Moore <paul@paul-moore.com>,
        syzbot+9ec037722d2603a9f52e@syzkaller.appspotmail.com,
        "David S. Miller" <davem@davemloft.net>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 4.9 151/157] cipso,calipso: resolve a number of problems with the DOI refcounts
Date:   Mon, 24 Jan 2022 19:44:01 +0100
Message-Id: <20220124183937.549864875@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183932.787526760@linuxfoundation.org>
References: <20220124183932.787526760@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paul Moore <paul@paul-moore.com>

commit ad5d07f4a9cd671233ae20983848874731102c08 upstream.

The current CIPSO and CALIPSO refcounting scheme for the DOI
definitions is a bit flawed in that we:

1. Don't correctly match gets/puts in netlbl_cipsov4_list().
2. Decrement the refcount on each attempt to remove the DOI from the
   DOI list, only removing it from the list once the refcount drops
   to zero.

This patch fixes these problems by adding the missing "puts" to
netlbl_cipsov4_list() and introduces a more conventional, i.e.
not-buggy, refcounting mechanism to the DOI definitions.  Upon the
addition of a DOI to the DOI list, it is initialized with a refcount
of one, removing a DOI from the list removes it from the list and
drops the refcount by one; "gets" and "puts" behave as expected with
respect to refcounts, increasing and decreasing the DOI's refcount by
one.

Fixes: b1edeb102397 ("netlabel: Replace protocol/NetLabel linking with refrerence counts")
Fixes: d7cce01504a0 ("netlabel: Add support for removing a CALIPSO DOI.")
Reported-by: syzbot+9ec037722d2603a9f52e@syzkaller.appspotmail.com
Signed-off-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
[bwh: Backported to 4.9: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/cipso_ipv4.c            |   11 +----------
 net/ipv6/calipso.c               |   14 +++++---------
 net/netlabel/netlabel_cipso_v4.c |    3 +++
 3 files changed, 9 insertions(+), 19 deletions(-)

--- a/net/ipv4/cipso_ipv4.c
+++ b/net/ipv4/cipso_ipv4.c
@@ -534,16 +534,10 @@ int cipso_v4_doi_remove(u32 doi, struct
 		ret_val = -ENOENT;
 		goto doi_remove_return;
 	}
-	if (!atomic_dec_and_test(&doi_def->refcount)) {
-		spin_unlock(&cipso_v4_doi_list_lock);
-		ret_val = -EBUSY;
-		goto doi_remove_return;
-	}
 	list_del_rcu(&doi_def->list);
 	spin_unlock(&cipso_v4_doi_list_lock);
 
-	cipso_v4_cache_invalidate();
-	call_rcu(&doi_def->rcu, cipso_v4_doi_free_rcu);
+	cipso_v4_doi_putdef(doi_def);
 	ret_val = 0;
 
 doi_remove_return:
@@ -600,9 +594,6 @@ void cipso_v4_doi_putdef(struct cipso_v4
 
 	if (!atomic_dec_and_test(&doi_def->refcount))
 		return;
-	spin_lock(&cipso_v4_doi_list_lock);
-	list_del_rcu(&doi_def->list);
-	spin_unlock(&cipso_v4_doi_list_lock);
 
 	cipso_v4_cache_invalidate();
 	call_rcu(&doi_def->rcu, cipso_v4_doi_free_rcu);
--- a/net/ipv6/calipso.c
+++ b/net/ipv6/calipso.c
@@ -97,6 +97,9 @@ struct calipso_map_cache_entry {
 
 static struct calipso_map_cache_bkt *calipso_cache;
 
+static void calipso_cache_invalidate(void);
+static void calipso_doi_putdef(struct calipso_doi *doi_def);
+
 /* Label Mapping Cache Functions
  */
 
@@ -458,15 +461,10 @@ static int calipso_doi_remove(u32 doi, s
 		ret_val = -ENOENT;
 		goto doi_remove_return;
 	}
-	if (!atomic_dec_and_test(&doi_def->refcount)) {
-		spin_unlock(&calipso_doi_list_lock);
-		ret_val = -EBUSY;
-		goto doi_remove_return;
-	}
 	list_del_rcu(&doi_def->list);
 	spin_unlock(&calipso_doi_list_lock);
 
-	call_rcu(&doi_def->rcu, calipso_doi_free_rcu);
+	calipso_doi_putdef(doi_def);
 	ret_val = 0;
 
 doi_remove_return:
@@ -522,10 +520,8 @@ static void calipso_doi_putdef(struct ca
 
 	if (!atomic_dec_and_test(&doi_def->refcount))
 		return;
-	spin_lock(&calipso_doi_list_lock);
-	list_del_rcu(&doi_def->list);
-	spin_unlock(&calipso_doi_list_lock);
 
+	calipso_cache_invalidate();
 	call_rcu(&doi_def->rcu, calipso_doi_free_rcu);
 }
 
--- a/net/netlabel/netlabel_cipso_v4.c
+++ b/net/netlabel/netlabel_cipso_v4.c
@@ -587,6 +587,7 @@ list_start:
 
 		break;
 	}
+	cipso_v4_doi_putdef(doi_def);
 	rcu_read_unlock();
 
 	genlmsg_end(ans_skb, data);
@@ -595,12 +596,14 @@ list_start:
 list_retry:
 	/* XXX - this limit is a guesstimate */
 	if (nlsze_mult < 4) {
+		cipso_v4_doi_putdef(doi_def);
 		rcu_read_unlock();
 		kfree_skb(ans_skb);
 		nlsze_mult *= 2;
 		goto list_start;
 	}
 list_failure_lock:
+	cipso_v4_doi_putdef(doi_def);
 	rcu_read_unlock();
 list_failure:
 	kfree_skb(ans_skb);


