Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD25E59A3FB
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 20:04:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353775AbiHSQq3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 12:46:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353929AbiHSQp3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 12:45:29 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBB0A111C1C;
        Fri, 19 Aug 2022 09:11:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 610C5CE26AC;
        Fri, 19 Aug 2022 16:10:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 497E6C433C1;
        Fri, 19 Aug 2022 16:10:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660925449;
        bh=Jj7BE93EO4t47Rj72h+wRXR/JqsbRUJh7QiZ1mhpCqs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HU4NoMLmATi/7dWAK2E6nwlxCRX9smCt0jJX2Lwa8aN2ujUXRtVQhhRj1RTtrh1zJ
         oCShZd+BO2MI53//oUyKRYEprx7BcPTjaCZ72Roj66k+tGvR5ud6KNoepeouH4YMb0
         U4cUBVDJ+H0RUBF4Gn+CvUUAWAVPVNTRRuPT3flw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qu Wenruo <wqu@suse.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 494/545] btrfs: reject log replay if there is unsupported RO compat flag
Date:   Fri, 19 Aug 2022 17:44:24 +0200
Message-Id: <20220819153851.570309033@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220819153829.135562864@linuxfoundation.org>
References: <20220819153829.135562864@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qu Wenruo <wqu@suse.com>

[ Upstream commit dc4d31684974d140250f3ee612c3f0cab13b3146 ]

[BUG]
If we have a btrfs image with dirty log, along with an unsupported RO
compatible flag:

log_root		30474240
...
compat_flags		0x0
compat_ro_flags		0x40000003
			( FREE_SPACE_TREE |
			  FREE_SPACE_TREE_VALID |
			  unknown flag: 0x40000000 )

Then even if we can only mount it RO, we will still cause metadata
update for log replay:

  BTRFS info (device dm-1): flagging fs with big metadata feature
  BTRFS info (device dm-1): using free space tree
  BTRFS info (device dm-1): has skinny extents
  BTRFS info (device dm-1): start tree-log replay

This is definitely against RO compact flag requirement.

[CAUSE]
RO compact flag only forces us to do RO mount, but we will still do log
replay for plain RO mount.

Thus this will result us to do log replay and update metadata.

This can be very problematic for new RO compat flag, for example older
kernel can not understand v2 cache, and if we allow metadata update on
RO mount and invalidate/corrupt v2 cache.

[FIX]
Just reject the mount unless rescue=nologreplay is provided:

  BTRFS error (device dm-1): cannot replay dirty log with unsupport optional features (0x40000000), try rescue=nologreplay instead

We don't want to set rescue=nologreply directly, as this would make the
end user to read the old data, and cause confusion.

Since the such case is really rare, we're mostly fine to just reject the
mount with an error message, which also includes the proper workaround.

CC: stable@vger.kernel.org #4.9+
Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/disk-io.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 35acdab56a1c..2c7e50980a70 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3104,6 +3104,20 @@ int __cold open_ctree(struct super_block *sb, struct btrfs_fs_devices *fs_device
 		err = -EINVAL;
 		goto fail_alloc;
 	}
+	/*
+	 * We have unsupported RO compat features, although RO mounted, we
+	 * should not cause any metadata write, including log replay.
+	 * Or we could screw up whatever the new feature requires.
+	 */
+	if (unlikely(features && btrfs_super_log_root(disk_super) &&
+		     !btrfs_test_opt(fs_info, NOLOGREPLAY))) {
+		btrfs_err(fs_info,
+"cannot replay dirty log with unsupported compat_ro features (0x%llx), try rescue=nologreplay",
+			  features);
+		err = -EINVAL;
+		goto fail_alloc;
+	}
+
 
 	ret = btrfs_init_workqueues(fs_info, fs_devices);
 	if (ret) {
-- 
2.35.1



