Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C0402F1410
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 14:20:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733276AbhAKNT3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 08:19:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:37792 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729395AbhAKNT1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Jan 2021 08:19:27 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1696622AAF;
        Mon, 11 Jan 2021 13:18:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610371126;
        bh=DlM0LE88xUdrg3zLOdefm+q9D1U5twwMobrnzwH5+ws=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qEI3a1eaXvAr9R9KLMp/jqdinBkB24XJp2lcUK+3RRbDMFfX7lmOL0Iw9kmtF3CrW
         CX2I8mRm8mf9K0Zj3jf+UCz45c8PLWSBv6Yl5/xsslVmnk8wYGAjxFFgrig/rZYyTW
         PFDLeZTsKz00XNFNGK6B+Mmc8C+6/KzFGxygbu9I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Filipe Manana <fdmanana@suse.com>,
        Qu Wenruo <wqu@suse.com>, David Sterba <dsterba@suse.com>
Subject: [PATCH 5.10 125/145] btrfs: qgroup: dont try to wait flushing if were already holding a transaction
Date:   Mon, 11 Jan 2021 14:02:29 +0100
Message-Id: <20210111130054.514634756@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210111130048.499958175@linuxfoundation.org>
References: <20210111130048.499958175@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qu Wenruo <wqu@suse.com>

commit ae5e070eaca9dbebde3459dd8f4c2756f8c097d0 upstream.

There is a chance of racing for qgroup flushing which may lead to
deadlock:

	Thread A		|	Thread B
   (not holding trans handle)	|  (holding a trans handle)
--------------------------------+--------------------------------
__btrfs_qgroup_reserve_meta()   | __btrfs_qgroup_reserve_meta()
|- try_flush_qgroup()		| |- try_flush_qgroup()
   |- QGROUP_FLUSHING bit set   |    |
   |				|    |- test_and_set_bit()
   |				|    |- wait_event()
   |- btrfs_join_transaction()	|
   |- btrfs_commit_transaction()|

			!!! DEAD LOCK !!!

Since thread A wants to commit transaction, but thread B is holding a
transaction handle, blocking the commit.
At the same time, thread B is waiting for thread A to finish its commit.

This is just a hot fix, and would lead to more EDQUOT when we're near
the qgroup limit.

The proper fix would be to make all metadata/data reservations happen
without holding a transaction handle.

CC: stable@vger.kernel.org # 5.9+
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/qgroup.c |   30 ++++++++++++++++++++----------
 1 file changed, 20 insertions(+), 10 deletions(-)

--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -3565,16 +3565,6 @@ static int try_flush_qgroup(struct btrfs
 	bool can_commit = true;
 
 	/*
-	 * We don't want to run flush again and again, so if there is a running
-	 * one, we won't try to start a new flush, but exit directly.
-	 */
-	if (test_and_set_bit(BTRFS_ROOT_QGROUP_FLUSHING, &root->state)) {
-		wait_event(root->qgroup_flush_wait,
-			!test_bit(BTRFS_ROOT_QGROUP_FLUSHING, &root->state));
-		return 0;
-	}
-
-	/*
 	 * If current process holds a transaction, we shouldn't flush, as we
 	 * assume all space reservation happens before a transaction handle is
 	 * held.
@@ -3588,6 +3578,26 @@ static int try_flush_qgroup(struct btrfs
 	    current->journal_info != BTRFS_SEND_TRANS_STUB)
 		can_commit = false;
 
+	/*
+	 * We don't want to run flush again and again, so if there is a running
+	 * one, we won't try to start a new flush, but exit directly.
+	 */
+	if (test_and_set_bit(BTRFS_ROOT_QGROUP_FLUSHING, &root->state)) {
+		/*
+		 * We are already holding a transaction, thus we can block other
+		 * threads from flushing.  So exit right now. This increases
+		 * the chance of EDQUOT for heavy load and near limit cases.
+		 * But we can argue that if we're already near limit, EDQUOT is
+		 * unavoidable anyway.
+		 */
+		if (!can_commit)
+			return 0;
+
+		wait_event(root->qgroup_flush_wait,
+			!test_bit(BTRFS_ROOT_QGROUP_FLUSHING, &root->state));
+		return 0;
+	}
+
 	ret = btrfs_start_delalloc_snapshot(root);
 	if (ret < 0)
 		goto out;


