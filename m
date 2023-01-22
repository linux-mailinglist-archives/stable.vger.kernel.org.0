Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 767E2676E86
	for <lists+stable@lfdr.de>; Sun, 22 Jan 2023 16:11:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230350AbjAVPLg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Jan 2023 10:11:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230354AbjAVPLg (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Jan 2023 10:11:36 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E8E02005D
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 07:11:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2860060C60
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 15:11:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38F21C433D2;
        Sun, 22 Jan 2023 15:11:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674400290;
        bh=7Hss4MSbzA2fhZiUvKGEaOQeNLYcUKzBZ5eYzi3NEkY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VQQMVWmibJ/9Y3QqEuSE+wnBMy3xDZ7xyxZWF74Gsa8rZ5TpvI/nR7rONu91ohrny
         E7XzbGppcd6Mn+J0pTdv7EdIBcGNMjDhbuWNOYSn43yN25DbtV0vV4O1X0SB1pSvL1
         4cDVx0Bxtc/aK9rfC1AayWoGMVuqJ3RPzv8b4UD0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Anand Jain <anand.jain@oracle.com>,
        Qu Wenruo <wqu@suse.com>, David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 07/98] btrfs: always report error in run_one_delayed_ref()
Date:   Sun, 22 Jan 2023 16:03:23 +0100
Message-Id: <20230122150229.728073059@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150229.351631432@linuxfoundation.org>
References: <20230122150229.351631432@linuxfoundation.org>
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
index 284294620e9f..7d9b8050b09c 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -1684,6 +1684,11 @@ static int run_one_delayed_ref(struct btrfs_trans_handle *trans,
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
 
@@ -1935,8 +1940,6 @@ static int btrfs_run_delayed_refs_for_head(struct btrfs_trans_handle *trans,
 		if (ret) {
 			unselect_delayed_ref_head(delayed_refs, locked_ref);
 			btrfs_put_delayed_ref(ref);
-			btrfs_debug(fs_info, "run_one_delayed_ref returned %d",
-				    ret);
 			return ret;
 		}
 
-- 
2.35.1



