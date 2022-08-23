Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F17759DFE4
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:36:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355766AbiHWKsC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 06:48:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355770AbiHWKoR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 06:44:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99C2B868B6;
        Tue, 23 Aug 2022 02:10:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 884E260DF6;
        Tue, 23 Aug 2022 09:10:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93645C433D6;
        Tue, 23 Aug 2022 09:10:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661245831;
        bh=3fugVo6TbpnGxFPfuFIJRDl1aYklh6ri5IkSSvgTZ0c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CQHOkOIVX9OMZXd9YEy3B2rZRFgWpYTvp4avVKAQOtSFi1Yr3z6Ibsa9z+8wHfXO5
         1+fhsmk29k3M4qdbyS9ea3J/6fqj0XxAY+NdfWmR0Firt4q5CxaWvnXHNS2EiL2I4z
         JDMYoUsNrlTcXs4brKy+B7+CQKsvTlybxlGX46wk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qu Wenruo <wqu@suse.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 4.19 202/287] btrfs: reject log replay if there is unsupported RO compat flag
Date:   Tue, 23 Aug 2022 10:26:11 +0200
Message-Id: <20220823080107.675539451@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080100.268827165@linuxfoundation.org>
References: <20220823080100.268827165@linuxfoundation.org>
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

commit dc4d31684974d140250f3ee612c3f0cab13b3146 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/disk-io.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2920,6 +2920,20 @@ int open_ctree(struct super_block *sb,
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


