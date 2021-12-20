Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D00147ACB4
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 15:46:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236903AbhLTOqc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 09:46:32 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:51476 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235927AbhLTOn2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 09:43:28 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 943D7B80EB3;
        Mon, 20 Dec 2021 14:43:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDDEAC36AE7;
        Mon, 20 Dec 2021 14:43:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640011406;
        bh=vo9aJDg3cE7KVNvWvEbr8nXiXtxVSONQAjOm8blIKVI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZcEznmNuvpnOtT0UccUeFA9+BokuAaXmRQwUe9aVE8zQVOdwUjHr3j+sqavd7w2zL
         4q3G0VKQTWwQiCOqG3uiuOoprwiOkEE9Yb9uMM25ev21caylJZqRXa20OwpR8TAkwa
         sF+eFIAZwf2gHmFKbjAs1kJH1ha0OrWGGVpxGfLc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "J. Bruce Fields" <bfields@redhat.com>,
        Salvatore Bonaccorso <carnil@debian.org>
Subject: [PATCH 5.4 10/71] nfsd: fix use-after-free due to delegation race
Date:   Mon, 20 Dec 2021 15:33:59 +0100
Message-Id: <20211220143026.039333231@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143025.683747691@linuxfoundation.org>
References: <20211220143025.683747691@linuxfoundation.org>
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
@@ -1041,6 +1041,11 @@ hash_delegation_locked(struct nfs4_deleg
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
@@ -1048,7 +1053,7 @@ unhash_delegation_locked(struct nfs4_del
 
 	lockdep_assert_held(&state_lock);
 
-	if (list_empty(&dp->dl_perfile))
+	if (!delegation_hashed(dp))
 		return false;
 
 	dp->dl_stid.sc_type = NFS4_CLOSED_DELEG_STID;
@@ -4406,7 +4411,7 @@ static void nfsd4_cb_recall_prepare(stru
 	 * queued for a lease break. Don't queue it again.
 	 */
 	spin_lock(&state_lock);
-	if (dp->dl_time == 0) {
+	if (delegation_hashed(dp) && dp->dl_time == 0) {
 		dp->dl_time = get_seconds();
 		list_add_tail(&dp->dl_recall_lru, &nn->del_recall_lru);
 	}


