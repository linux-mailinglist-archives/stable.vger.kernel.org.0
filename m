Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 296493031C0
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 03:26:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727192AbhAYSow (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jan 2021 13:44:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:60764 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728040AbhAYSoh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Jan 2021 13:44:37 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7343720758;
        Mon, 25 Jan 2021 18:43:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611600237;
        bh=RhzwLtnDE5FYMSL52bsFp4GT6bIh7O1VY6Ks7gi9ZAs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uPta/DicONsCpw3GyNpeca6bYWWMS8/5PYc4SPEn42UMLQloRYgDEv04bNt0+B4hC
         ZIXsEQEy3aTww7QLTssF6rlhs6Ki3+hmga5OX5Pgl7DCTaraSVWhFq/JFSZcbWqNqg
         K0Sz+GAp+/vD0vzPMOeCyDKEgmyTEThQH2KWRLpc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.4 07/86] btrfs: dont get an EINTR during drop_snapshot for reloc
Date:   Mon, 25 Jan 2021 19:38:49 +0100
Message-Id: <20210125183201.349265277@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210125183201.024962206@linuxfoundation.org>
References: <20210125183201.024962206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josef Bacik <josef@toxicpanda.com>

commit 18d3bff411c8d46d40537483bdc0b61b33ce0371 upstream.

This was partially fixed by f3e3d9cc3525 ("btrfs: avoid possible signal
interruption of btrfs_drop_snapshot() on relocation tree"), however it
missed a spot when we restart a trans handle because we need to end the
transaction.  The fix is the same, simply use btrfs_join_transaction()
instead of btrfs_start_transaction() when deleting reloc roots.

Fixes: f3e3d9cc3525 ("btrfs: avoid possible signal interruption of btrfs_drop_snapshot() on relocation tree")
CC: stable@vger.kernel.org # 5.4+
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/extent-tree.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -5390,7 +5390,15 @@ int btrfs_drop_snapshot(struct btrfs_roo
 				goto out_free;
 			}
 
-			trans = btrfs_start_transaction(tree_root, 0);
+		       /*
+			* Use join to avoid potential EINTR from transaction
+			* start. See wait_reserve_ticket and the whole
+			* reservation callchain.
+			*/
+			if (for_reloc)
+				trans = btrfs_join_transaction(tree_root);
+			else
+				trans = btrfs_start_transaction(tree_root, 0);
 			if (IS_ERR(trans)) {
 				err = PTR_ERR(trans);
 				goto out_free;


