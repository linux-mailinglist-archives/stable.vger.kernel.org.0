Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 681266AC192
	for <lists+stable@lfdr.de>; Mon,  6 Mar 2023 14:40:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230426AbjCFNkZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Mar 2023 08:40:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229982AbjCFNkY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Mar 2023 08:40:24 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25F052ED59
        for <stable@vger.kernel.org>; Mon,  6 Mar 2023 05:40:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B560A60F21
        for <stable@vger.kernel.org>; Mon,  6 Mar 2023 13:40:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDB43C433D2;
        Mon,  6 Mar 2023 13:40:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678110013;
        bh=KObiHn38whJxahxbvIARy18EsZJlN8MkFNBV4vrOnoM=;
        h=Subject:To:Cc:From:Date:From;
        b=yQm2ATosHVU4xC49DHOsKpqn7tMrVBbC3yxuNiLKEzfIyq0w/LyZmQCgNP3iy3raS
         4o699HZBRv4znvKGWCyAwHIO8lYuPPEXSuLhwSLp7zvW+0BQ28QDjoyFYAV2H2lF6w
         l7uH4rt3aI4oLdHTfzyA4eCs/XLHROXle+smi5jQ=
Subject: FAILED: patch "[PATCH] udf: Fix off-by-one error when discarding preallocation" failed to apply to 5.10-stable tree
To:     jack@suse.cz
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 06 Mar 2023 14:40:06 +0100
Message-ID: <167811000613644@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

To reproduce the conflict and resubmit, you may use the following commands:

git fetch https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/ linux-5.10.y
git checkout FETCH_HEAD
git cherry-pick -x f54aa97fb7e5329a373f9df4e5e213ced4fc8759
# <resolve conflicts, build, test, etc.>
git commit -s
git send-email --to '<stable@vger.kernel.org>' --in-reply-to '167811000613644@kroah.com' --subject-prefix 'PATCH 5.10.y' HEAD^..

Possible dependencies:

f54aa97fb7e5 ("udf: Fix off-by-one error when discarding preallocation")
f3a30be77750 ("udf: Factor out block mapping into udf_map_block()")
a27b2923de7e ("udf: Move udf_expand_dir_adinicb() to its callsite")
57bda9fb169d ("udf: Convert udf_expand_dir_adinicb() to new directory iteration")
16d055656814 ("udf: Discard preallocation before extending file with a hole")
979a6e28dd96 ("udf: Get rid of 0-length arrays in struct fileIdentDesc")
63c9e47a1642 ("udf: fix silent AED tagLocation corruption")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From f54aa97fb7e5329a373f9df4e5e213ced4fc8759 Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Mon, 23 Jan 2023 14:29:15 +0100
Subject: [PATCH] udf: Fix off-by-one error when discarding preallocation

The condition determining whether the preallocation can be used had
an off-by-one error so we didn't discard preallocation when new
allocation was just following it. This can then confuse code in
inode_getblk().

CC: stable@vger.kernel.org
Fixes: 16d055656814 ("udf: Discard preallocation before extending file with a hole")
Signed-off-by: Jan Kara <jack@suse.cz>

diff --git a/fs/udf/inode.c b/fs/udf/inode.c
index 51deada8b928..ee440d16411e 100644
--- a/fs/udf/inode.c
+++ b/fs/udf/inode.c
@@ -361,7 +361,7 @@ static int udf_map_block(struct inode *inode, struct udf_map_rq *map)
 	 * Block beyond EOF and prealloc extents? Just discard preallocation
 	 * as it is not useful and complicates things.
 	 */
-	if (((loff_t)map->lblk) << inode->i_blkbits > iinfo->i_lenExtents)
+	if (((loff_t)map->lblk) << inode->i_blkbits >= iinfo->i_lenExtents)
 		udf_discard_prealloc(inode);
 	udf_clear_extent_cache(inode);
 	err = inode_getblk(inode, map);

