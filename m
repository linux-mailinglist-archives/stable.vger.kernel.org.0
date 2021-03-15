Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CD9C33B73D
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:01:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231206AbhCON7z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 09:59:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:35904 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232452AbhCON65 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 09:58:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E12F064F50;
        Mon, 15 Mar 2021 13:58:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816717;
        bh=cwa9O6gcJyxFsf7aw8GCQXL7kgj6DFA1kw0CV3UWM0I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kSyUm8Zwk/i2xdiDhPiR4wLD3/0RBtXEDZazlwZFsgCusNFaIZDyvL5HlhZ1Al1nR
         7cK9H1OuDFFnzIWgxUYGodHikbZ5IoHpIE1V0eGqXP8hZ12DxGUSfkj42MsbxsQY53
         xoxOK6MP0yp4GsObUHfR8q5DcRC/9bddHDLv6tNw=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+9ec037722d2603a9f52e@syzkaller.appspotmail.com,
        Paul Moore <paul@paul-moore.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 024/120] cipso,calipso: resolve a number of problems with the DOI refcounts
Date:   Mon, 15 Mar 2021 14:56:15 +0100
Message-Id: <20210315135720.784778867@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135720.002213995@linuxfoundation.org>
References: <20210315135720.002213995@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/cipso_ipv4.c            |   11 +----------
 net/ipv6/calipso.c               |   14 +++++---------
 net/netlabel/netlabel_cipso_v4.c |    3 +++
 3 files changed, 9 insertions(+), 19 deletions(-)

--- a/net/ipv4/cipso_ipv4.c
+++ b/net/ipv4/cipso_ipv4.c
@@ -533,16 +533,10 @@ int cipso_v4_doi_remove(u32 doi, struct
 		ret_val = -ENOENT;
 		goto doi_remove_return;
 	}
-	if (!refcount_dec_and_test(&doi_def->refcount)) {
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
@@ -599,9 +593,6 @@ void cipso_v4_doi_putdef(struct cipso_v4
 
 	if (!refcount_dec_and_test(&doi_def->refcount))
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
-	if (!refcount_dec_and_test(&doi_def->refcount)) {
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
 
 	if (!refcount_dec_and_test(&doi_def->refcount))
 		return;
-	spin_lock(&calipso_doi_list_lock);
-	list_del_rcu(&doi_def->list);
-	spin_unlock(&calipso_doi_list_lock);
 
+	calipso_cache_invalidate();
 	call_rcu(&doi_def->rcu, calipso_doi_free_rcu);
 }
 
--- a/net/netlabel/netlabel_cipso_v4.c
+++ b/net/netlabel/netlabel_cipso_v4.c
@@ -581,6 +581,7 @@ list_start:
 
 		break;
 	}
+	cipso_v4_doi_putdef(doi_def);
 	rcu_read_unlock();
 
 	genlmsg_end(ans_skb, data);
@@ -589,12 +590,14 @@ list_start:
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


