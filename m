Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC7E547296B
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 11:24:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242288AbhLMKU2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 05:20:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242331AbhLMKS1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 05:18:27 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2755BC08E886;
        Mon, 13 Dec 2021 01:56:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C6CA3B80E26;
        Mon, 13 Dec 2021 09:56:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12D58C34600;
        Mon, 13 Dec 2021 09:56:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639389392;
        bh=5IoAMcQn2H3A3UidQxzgBEW2ApBoDnVsjy6A0G3P3DA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fMPB8vk5bsMlbemv6uqo0sxUpQA8QY1snK00zI9U48FxxAC2sVJgGDeEFxx/rAEGA
         6Lg9temlqkV40xNaEUY42nKxKOTI1nomz9uvQU4AjJZu8+qf5ZywUG3Y5MY0RJdicV
         LGRlZ4In4K40TaCEtKO2sUzGp8FgiMyoh+fn6Eu0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "J. Bruce Fields" <bfields@redhat.com>
Subject: [PATCH 5.15 084/171] nfsd: fix use-after-free due to delegation race
Date:   Mon, 13 Dec 2021 10:29:59 +0100
Message-Id: <20211213092947.886902966@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092945.091487407@linuxfoundation.org>
References: <20211213092945.091487407@linuxfoundation.org>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfs4state.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -1207,6 +1207,11 @@ hash_delegation_locked(struct nfs4_deleg
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
@@ -1214,7 +1219,7 @@ unhash_delegation_locked(struct nfs4_del
 
 	lockdep_assert_held(&state_lock);
 
-	if (list_empty(&dp->dl_perfile))
+	if (!delegation_hashed(dp))
 		return false;
 
 	dp->dl_stid.sc_type = NFS4_CLOSED_DELEG_STID;
@@ -4598,7 +4603,7 @@ static void nfsd4_cb_recall_prepare(stru
 	 * queued for a lease break. Don't queue it again.
 	 */
 	spin_lock(&state_lock);
-	if (dp->dl_time == 0) {
+	if (delegation_hashed(dp) && dp->dl_time == 0) {
 		dp->dl_time = ktime_get_boottime_seconds();
 		list_add_tail(&dp->dl_recall_lru, &nn->del_recall_lru);
 	}


