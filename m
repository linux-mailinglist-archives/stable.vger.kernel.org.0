Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A71407F3A6
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 11:59:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406401AbfHBJ4C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 05:56:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:34782 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406660AbfHBJ4B (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 2 Aug 2019 05:56:01 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6E0022064A;
        Fri,  2 Aug 2019 09:56:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564739760;
        bh=fh67569taokks1NPrgvCBZB0YNH4cT+KhsOvC3qqKTI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ld94uKc/7MTfwojI/kFbzHJCFm83Nv6G3IU+NHBJWc2fp35mwHNwKRUU0ETaeGyzj
         ARb8yxaQyO7ZtWnc2lby370WtTx2Q5MCvQbrx48MzyBYENweP7uHQOiCTL5TuOxl1u
         HyuxplrwGwQbmEOqcSO0tVZM22Y+CRYx8Qu2/w7k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stan Hu <stanhu@gmail.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Qian Lu <luqia@amazon.com>
Subject: [PATCH 4.19 03/32] NFS: Fix dentry revalidation on NFSv4 lookup
Date:   Fri,  2 Aug 2019 11:39:37 +0200
Message-Id: <20190802092102.892371637@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190802092101.913646560@linuxfoundation.org>
References: <20190802092101.913646560@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Trond Myklebust <trond.myklebust@hammerspace.com>

commit be189f7e7f03de35887e5a85ddcf39b91b5d7fc1 upstream.

We need to ensure that inode and dentry revalidation occurs correctly
on reopen of a file that is already open. Currently, we can end up
not revalidating either in the case of NFSv4.0, due to the 'cached open'
path.
Let's fix that by ensuring that we only do cached open for the special
cases of open recovery and delegation return.

Reported-by: Stan Hu <stanhu@gmail.com>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Qian Lu <luqia@amazon.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfs/nfs4proc.c |   15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -1355,12 +1355,20 @@ static bool nfs4_mode_match_open_stateid
 	return false;
 }
 
-static int can_open_cached(struct nfs4_state *state, fmode_t mode, int open_mode)
+static int can_open_cached(struct nfs4_state *state, fmode_t mode,
+		int open_mode, enum open_claim_type4 claim)
 {
 	int ret = 0;
 
 	if (open_mode & (O_EXCL|O_TRUNC))
 		goto out;
+	switch (claim) {
+	case NFS4_OPEN_CLAIM_NULL:
+	case NFS4_OPEN_CLAIM_FH:
+		goto out;
+	default:
+		break;
+	}
 	switch (mode & (FMODE_READ|FMODE_WRITE)) {
 		case FMODE_READ:
 			ret |= test_bit(NFS_O_RDONLY_STATE, &state->flags) != 0
@@ -1753,7 +1761,7 @@ static struct nfs4_state *nfs4_try_open_
 
 	for (;;) {
 		spin_lock(&state->owner->so_lock);
-		if (can_open_cached(state, fmode, open_mode)) {
+		if (can_open_cached(state, fmode, open_mode, claim)) {
 			update_open_stateflags(state, fmode);
 			spin_unlock(&state->owner->so_lock);
 			goto out_return_state;
@@ -2282,7 +2290,8 @@ static void nfs4_open_prepare(struct rpc
 	if (data->state != NULL) {
 		struct nfs_delegation *delegation;
 
-		if (can_open_cached(data->state, data->o_arg.fmode, data->o_arg.open_flags))
+		if (can_open_cached(data->state, data->o_arg.fmode,
+					data->o_arg.open_flags, claim))
 			goto out_no_action;
 		rcu_read_lock();
 		delegation = rcu_dereference(NFS_I(data->state->inode)->delegation);


