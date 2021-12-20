Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5410647AB8A
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 15:37:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234099AbhLTOha (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 09:37:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234001AbhLTOhN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 09:37:13 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 161F3C061748;
        Mon, 20 Dec 2021 06:37:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CB16DB80EDF;
        Mon, 20 Dec 2021 14:37:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 238E5C36AE7;
        Mon, 20 Dec 2021 14:37:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640011030;
        bh=+VbiNoV3uC4e2nm4ERyklkSCq0nqBCoaF+uqfzl/0aY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VQfyt0lwNSBgtS1LqOduRRe8YqS4TVGZKv+QogVZyWw2uLYQ1bT7kCYEJOmwZCWZ7
         6KQEkp8ff9d6OSiYfBmjoMJkIJVxduUXHMYfF/O+l+9O+s3sDBfQsdCdi7Y548k9zd
         NBjqzSja3oP9MOdVJMYbj6wPywbkhgi3iK147WsY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "J. Bruce Fields" <bfields@redhat.com>,
        Salvatore Bonaccorso <carnil@debian.org>
Subject: [PATCH 4.9 11/31] nfsd: fix use-after-free due to delegation race
Date:   Mon, 20 Dec 2021 15:34:11 +0100
Message-Id: <20211220143020.348679826@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143019.974513085@linuxfoundation.org>
References: <20211220143019.974513085@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: J. Bruce Fields <bfields@redhat.com>

commit 548ec0805c399c65ed66c6641be467f717833ab5 upstream.

A delegation break could arrive as soon as we've called vfs_setlease.  A
delegation break runs a callback which immediately (in
nfsd4_cb_recall_prepare) adds the delegation to del_recall_lru.  If we
then exit nfs4_set_delegation without hashing the delegation, it will be
freed as soon as the callback is done with it, without ever being
removed from del_recall_lru.

Symptoms show up later as use-after-free or list corruption warnings,
usually in the laundromat thread.

I suspect aba2072f4523 "nfsd: grant read delegations to clients holding
writes" made this bug easier to hit, but I looked as far back as v3.0
and it looks to me it already had the same problem.  So I'm not sure
where the bug was introduced; it may have been there from the beginning.

Cc: stable@vger.kernel.org
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
[Salvatore Bonaccorso: Backport for context changes to versions which do
not have 20b7d86f29d3 ("nfsd: use boottime for lease expiry calculation")]
Signed-off-by: Salvatore Bonaccorso <carnil@debian.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfs4state.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -955,6 +955,11 @@ hash_delegation_locked(struct nfs4_deleg
 	return 0;
 }
 
+static bool delegation_hashed(struct nfs4_delegation *dp)
+{
+	return !(list_empty(&dp->dl_perfile));
+}
+
 static bool
 unhash_delegation_locked(struct nfs4_delegation *dp)
 {
@@ -962,7 +967,7 @@ unhash_delegation_locked(struct nfs4_del
 
 	lockdep_assert_held(&state_lock);
 
-	if (list_empty(&dp->dl_perfile))
+	if (!delegation_hashed(dp))
 		return false;
 
 	dp->dl_stid.sc_type = NFS4_CLOSED_DELEG_STID;
@@ -3882,7 +3887,7 @@ static void nfsd4_cb_recall_prepare(stru
 	 * queued for a lease break. Don't queue it again.
 	 */
 	spin_lock(&state_lock);
-	if (dp->dl_time == 0) {
+	if (delegation_hashed(dp) && dp->dl_time == 0) {
 		dp->dl_time = get_seconds();
 		list_add_tail(&dp->dl_recall_lru, &nn->del_recall_lru);
 	}


