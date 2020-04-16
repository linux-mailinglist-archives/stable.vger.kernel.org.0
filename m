Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0863D1ACA82
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 17:36:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2894500AbgDPPfn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 11:35:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:52674 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2898063AbgDPNkH (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 09:40:07 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B2650218AC;
        Thu, 16 Apr 2020 13:40:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587044407;
        bh=T4BN4e03GBFcEvPAPYiVqCCxujczy7T1jTuFHTAa5a0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TxqWCa3qcLWfT1WI8OqCw1kknwBAyBSfxM7FeAveGSxGiSbDih8hw/9n3s/ZxMs72
         Mnf2n6MGOB3DHrQTYn4cFprVHyhM6vIKoF505Fu+TMFsfQ/+Dxu16nqCPYPFaJilfj
         cK7UbW2l8t36odz/UC9MZ4B8MLV3zwaTgoHnV8vM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qu Wenruo <wqu@suse.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.5 164/257] btrfs: unset reloc control if we fail to recover
Date:   Thu, 16 Apr 2020 15:23:35 +0200
Message-Id: <20200416131347.032136250@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200416131325.891903893@linuxfoundation.org>
References: <20200416131325.891903893@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josef Bacik <josef@toxicpanda.com>

commit fb2d83eefef4e1c717205bac71cb1941edf8ae11 upstream.

If we fail to load an fs root, or fail to start a transaction we can
bail without unsetting the reloc control, which leads to problems later
when we free the reloc control but still have it attached to the file
system.

In the normal path we'll end up calling unset_reloc_control() twice, but
all it does is set fs_info->reloc_control = NULL, and we can only have
one balance at a time so it's not racey.

CC: stable@vger.kernel.org # 5.4+
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/relocation.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -4581,9 +4581,8 @@ int btrfs_recover_relocation(struct btrf
 
 	trans = btrfs_join_transaction(rc->extent_root);
 	if (IS_ERR(trans)) {
-		unset_reloc_control(rc);
 		err = PTR_ERR(trans);
-		goto out_free;
+		goto out_unset;
 	}
 
 	rc->merge_reloc_tree = 1;
@@ -4603,7 +4602,7 @@ int btrfs_recover_relocation(struct btrf
 		if (IS_ERR(fs_root)) {
 			err = PTR_ERR(fs_root);
 			list_add_tail(&reloc_root->root_list, &reloc_roots);
-			goto out_free;
+			goto out_unset;
 		}
 
 		err = __add_reloc_root(reloc_root);
@@ -4613,7 +4612,7 @@ int btrfs_recover_relocation(struct btrf
 
 	err = btrfs_commit_transaction(trans);
 	if (err)
-		goto out_free;
+		goto out_unset;
 
 	merge_reloc_roots(rc);
 
@@ -4629,7 +4628,8 @@ out_clean:
 	ret = clean_dirty_subvols(rc);
 	if (ret < 0 && !err)
 		err = ret;
-out_free:
+out_unset:
+	unset_reloc_control(rc);
 	kfree(rc);
 out:
 	if (!list_empty(&reloc_roots))


