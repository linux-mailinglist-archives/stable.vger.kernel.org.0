Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24EF5676EE4
	for <lists+stable@lfdr.de>; Sun, 22 Jan 2023 16:15:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230491AbjAVPPe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Jan 2023 10:15:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230486AbjAVPPb (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Jan 2023 10:15:31 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A0A622023
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 07:15:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D84C7B80B1B
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 15:15:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C11AC433EF;
        Sun, 22 Jan 2023 15:15:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674400527;
        bh=3gQfJid2aWfbnc/lTaC+ne5dZRJiKd8t3N7n3/1zhY0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xEtiRKjQ/tVA0dJG/jnXlGxU1twYqn0u4dwrlGU97mP3CSRBIR3lC0/goL21Wixeq
         qyy4IPn0ALLBFhtUKa+CLJ1AGGUYhN+nd5j3PZ79rgpNPIdKY5rjMmPArTOw+Of5be
         5XCUtv7kjkymYrPsi96z7Y6wGdT6Yx1Q+arKmCSs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Anand Jain <anand.jain@oracle.com>,
        Qu Wenruo <wqu@suse.com>, David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 010/117] btrfs: always report error in run_one_delayed_ref()
Date:   Sun, 22 Jan 2023 16:03:20 +0100
Message-Id: <20230122150233.151349070@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150232.736358800@linuxfoundation.org>
References: <20230122150232.736358800@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qu Wenruo <wqu@suse.com>

[ Upstream commit 39f501d68ec1ed5cd5c66ac6ec2a7131c517bb92 ]

Currently we have a btrfs_debug() for run_one_delayed_ref() failure, but
if end users hit such problem, there will be no chance that
btrfs_debug() is enabled.  This can lead to very little useful info for
debugging.

This patch will:

- Add extra info for error reporting
  Including:
  * logical bytenr
  * num_bytes
  * type
  * action
  * ref_mod

- Replace the btrfs_debug() with btrfs_err()

- Move the error reporting into run_one_delayed_ref()
  This is to avoid use-after-free, the @node can be freed in the caller.

This error should only be triggered at most once.

As if run_one_delayed_ref() failed, we trigger the error message, then
causing the call chain to error out:

btrfs_run_delayed_refs()
`- btrfs_run_delayed_refs()
   `- btrfs_run_delayed_refs_for_head()
      `- run_one_delayed_ref()

And we will abort the current transaction in btrfs_run_delayed_refs().
If we have to run delayed refs for the abort transaction,
run_one_delayed_ref() will just cleanup the refs and do nothing, thus no
new error messages would be output.

Reviewed-by: Anand Jain <anand.jain@oracle.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/extent-tree.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index e72973f7c2cd..750c1ff9947d 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -1717,6 +1717,11 @@ static int run_one_delayed_ref(struct btrfs_trans_handle *trans,
 		BUG();
 	if (ret && insert_reserved)
 		btrfs_pin_extent(trans, node->bytenr, node->num_bytes, 1);
+	if (ret < 0)
+		btrfs_err(trans->fs_info,
+"failed to run delayed ref for logical %llu num_bytes %llu type %u action %u ref_mod %d: %d",
+			  node->bytenr, node->num_bytes, node->type,
+			  node->action, node->ref_mod, ret);
 	return ret;
 }
 
@@ -1955,8 +1960,6 @@ static int btrfs_run_delayed_refs_for_head(struct btrfs_trans_handle *trans,
 		if (ret) {
 			unselect_delayed_ref_head(delayed_refs, locked_ref);
 			btrfs_put_delayed_ref(ref);
-			btrfs_debug(fs_info, "run_one_delayed_ref returned %d",
-				    ret);
 			return ret;
 		}
 
-- 
2.35.1



