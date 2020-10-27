Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B097A29B9A2
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:11:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1802666AbgJ0Pup (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:50:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:35568 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1801732AbgJ0PnQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:43:16 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8FAFE22202;
        Tue, 27 Oct 2020 15:43:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603813396;
        bh=89eOMXG00ZpTuYUlULtwbjR6X+WEBo4UU7NKkhxzjE4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yr9OQbm4Xaj63v8gXHbPwDocs0X4qN3edWLi1X2AqRa+ALQgBhKBkd9RpTtPrEvb+
         HpRDbQ7dOkej5jlnJK4vbX3URr1d/tgcG6lpT5xC3xQqVXxJCSPy+Jm6XXYW8OvH8X
         RaZ1SlOYRJSzPS854CPDLQN0Pw1Q9zoPXu4LoWmo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chuck Lever <chuck.lever@oracle.com>,
        "J. Bruce Fields" <bfields@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 536/757] nfsd: Cache R, RW, and W opens separately
Date:   Tue, 27 Oct 2020 14:53:06 +0100
Message-Id: <20201027135515.642163638@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: J. Bruce Fields <bfields@redhat.com>

[ Upstream commit ae3c57b5ca47665dc3416447a5534a9796096d86 ]

The nfsd open code has always kept separate read-only, read-write, and
write-only opens as necessary to ensure that when a client closes or
downgrades, we don't retain more access than necessary.

Also, I didn't realize the cache behaved this way when I wrote
94415b06eb8a "nfsd4: a client's own opens needn't prevent delegations".
There I assumed fi_fds[O_WRONLY] and fi_fds[O_RDWR] would always be
distinct.  The violation of that assumption is triggering a
WARN_ON_ONCE() and could also cause the server to give out a delegation
when it shouldn't.

Fixes: 94415b06eb8a ("nfsd4: a client's own opens needn't prevent delegations")
Tested-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/filecache.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/nfsd/filecache.c b/fs/nfsd/filecache.c
index c8b9d2667ee6f..3c6c2f7d1688b 100644
--- a/fs/nfsd/filecache.c
+++ b/fs/nfsd/filecache.c
@@ -889,7 +889,7 @@ nfsd_file_find_locked(struct inode *inode, unsigned int may_flags,
 
 	hlist_for_each_entry_rcu(nf, &nfsd_file_hashtbl[hashval].nfb_head,
 				 nf_node, lockdep_is_held(&nfsd_file_hashtbl[hashval].nfb_lock)) {
-		if ((need & nf->nf_may) != need)
+		if (nf->nf_may != need)
 			continue;
 		if (nf->nf_inode != inode)
 			continue;
-- 
2.25.1



