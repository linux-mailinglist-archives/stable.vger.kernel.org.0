Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7F02471A51
	for <lists+stable@lfdr.de>; Sun, 12 Dec 2021 14:11:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230499AbhLLNLf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 12 Dec 2021 08:11:35 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:46938 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229739AbhLLNLe (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 12 Dec 2021 08:11:34 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id B8E06CE09E6
        for <stable@vger.kernel.org>; Sun, 12 Dec 2021 13:11:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F8C1C341C6;
        Sun, 12 Dec 2021 13:11:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639314690;
        bh=l4DDPBqfmcxkmE8GTrv4chlvdHCKrviyGHPRJu199LY=;
        h=Subject:To:Cc:From:Date:From;
        b=sKjLK0gku9ABNHPiibHZ5umF8YM3O6D+4Q7FgC60u79nqgAhcUAyLrWch8P3270sd
         Fd8okrsUWYMXX0RK4C8dGc3EHvQhNyIBJ8+GhBWUwPK2EXJcCHL5iUClBTl2j6okKZ
         JUibI0s2YUNAfAZyyfIR3ZUQaPiG+2dhaZ+Hfqms=
Subject: FAILED: patch "[PATCH] nfsd: fix use-after-free due to delegation race" failed to apply to 4.4-stable tree
To:     bfields@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 12 Dec 2021 14:11:28 +0100
Message-ID: <16393146883208@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 548ec0805c399c65ed66c6641be467f717833ab5 Mon Sep 17 00:00:00 2001
From: "J. Bruce Fields" <bfields@redhat.com>
Date: Mon, 29 Nov 2021 15:08:00 -0500
Subject: [PATCH] nfsd: fix use-after-free due to delegation race

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

diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index bfad94c70b84..1956d377d1a6 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -1207,6 +1207,11 @@ hash_delegation_locked(struct nfs4_delegation *dp, struct nfs4_file *fp)
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
@@ -1214,7 +1219,7 @@ unhash_delegation_locked(struct nfs4_delegation *dp)
 
 	lockdep_assert_held(&state_lock);
 
-	if (list_empty(&dp->dl_perfile))
+	if (!delegation_hashed(dp))
 		return false;
 
 	dp->dl_stid.sc_type = NFS4_CLOSED_DELEG_STID;
@@ -4598,7 +4603,7 @@ static void nfsd4_cb_recall_prepare(struct nfsd4_callback *cb)
 	 * queued for a lease break. Don't queue it again.
 	 */
 	spin_lock(&state_lock);
-	if (dp->dl_time == 0) {
+	if (delegation_hashed(dp) && dp->dl_time == 0) {
 		dp->dl_time = ktime_get_boottime_seconds();
 		list_add_tail(&dp->dl_recall_lru, &nn->del_recall_lru);
 	}

