Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8DB0CF718
	for <lists+stable@lfdr.de>; Tue, 30 Apr 2019 13:56:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730938AbfD3LtG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Apr 2019 07:49:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:35488 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730934AbfD3LtF (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 30 Apr 2019 07:49:05 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EE31D20449;
        Tue, 30 Apr 2019 11:49:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556624944;
        bh=pshKlxxplvR1pLAnd9ve0f3N039W3du/cqrQvApkfX0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T2PTzaOEDoHO9Iv9Ufa+moWLRGaICiFtZxhsJGcBYYTwVXYcsGRedO04sEaV2i365
         sQn6J9LRnnIvPK6YWjsBmoQHXLmNgPmeRb0pO+fJZGug34kzM3lh+RfWeRlGkruUxt
         4+sZrfFCYrNJlxABm5gS8Pq8kPAgCTbdQidx6UIg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Slawomir Pryczek <slawek1211@gmail.com>,
        Neil Brown <neilb@suse.com>, Jeff Layton <jlayton@kernel.org>,
        "J. Bruce Fields" <bfields@redhat.com>
Subject: [PATCH 5.0 31/89] nfsd: wake waiters blocked on file_lock before deleting it
Date:   Tue, 30 Apr 2019 13:38:22 +0200
Message-Id: <20190430113611.383864519@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190430113609.741196396@linuxfoundation.org>
References: <20190430113609.741196396@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jeff Layton <jlayton@kernel.org>

commit 6aaafc43a4ecc5bc8a3f6a2811d5eddc996a97f3 upstream.

After a blocked nfsd file_lock request is deleted, knfsd will send a
callback to the client and then free the request. Commit 16306a61d3b7
("fs/locks: always delete_block after waiting.") changed it such that
locks_delete_block is always called on a request after it is awoken,
but that patch missed fixing up blocked nfsd request handling.

Call locks_delete_block on the block to wake up any locks still blocked
on the nfsd lock request before freeing it. Some of its callers already
do this however, so just remove those calls.

URL: https://bugzilla.kernel.org/show_bug.cgi?id=203363
Fixes: 16306a61d3b7 ("fs/locks: always delete_block after waiting.")
Reported-by: Slawomir Pryczek <slawek1211@gmail.com>
Cc: Neil Brown <neilb@suse.com>
Cc: stable@vger.kernel.org
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfsd/nfs4state.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -265,6 +265,7 @@ find_or_allocate_block(struct nfs4_locko
 static void
 free_blocked_lock(struct nfsd4_blocked_lock *nbl)
 {
+	locks_delete_block(&nbl->nbl_lock);
 	locks_release_private(&nbl->nbl_lock);
 	kfree(nbl);
 }
@@ -293,7 +294,6 @@ remove_blocked_locks(struct nfs4_lockown
 		nbl = list_first_entry(&reaplist, struct nfsd4_blocked_lock,
 					nbl_lru);
 		list_del_init(&nbl->nbl_lru);
-		locks_delete_block(&nbl->nbl_lock);
 		free_blocked_lock(nbl);
 	}
 }
@@ -4863,7 +4863,6 @@ nfs4_laundromat(struct nfsd_net *nn)
 		nbl = list_first_entry(&reaplist,
 					struct nfsd4_blocked_lock, nbl_lru);
 		list_del_init(&nbl->nbl_lru);
-		locks_delete_block(&nbl->nbl_lock);
 		free_blocked_lock(nbl);
 	}
 out:


