Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B18C7604149
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 12:42:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231574AbiJSKl7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 06:41:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232075AbiJSKlI (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 06:41:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE509B857;
        Wed, 19 Oct 2022 03:19:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 165C9B824CF;
        Wed, 19 Oct 2022 09:14:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DAE6C433D6;
        Wed, 19 Oct 2022 09:14:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666170871;
        bh=9rEkCfPGF7aTg6XEIPGPG0g/5ewXXcWrs+BmJMl5KNE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TUy8aRCyWwgGZsaFO+dIqZK3VxXyDzDdZu9E8uTSRg2teFs87X45fnFcwc5B9CwN3
         Mi9lGAerIl4zyWoiZ4QAP5cml+H+Icw0KNG+/uqsGH9DLIUrHQU7HiHzH61PT0bsYj
         C/J4RqFdhL0Ya1XvIke89k7OrifWuYnJCjAHqUDE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 786/862] btrfs: dont print information about space cache or tree every remount
Date:   Wed, 19 Oct 2022 10:34:33 +0200
Message-Id: <20221019083324.642593394@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>

[ Upstream commit dbecac26630014d336a8e5ea67096ff18210fb9c ]

btrfs currently prints information about space cache or free space tree
being in use on every remount, regardless whether such remount actually
enabled or disabled one of these features.

This is actually unnecessary since providing remount options changing the
state of these features will explicitly print the appropriate notice.

Let's instead print such unconditional information just on an initial mount
to avoid filling the kernel log when, for example, laptop-mode-tools
remount the fs on some events.

Signed-off-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/super.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 6eeb3402b4a2..ad3ce9700eaf 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -626,6 +626,7 @@ int btrfs_parse_options(struct btrfs_fs_info *info, char *options,
 	int saved_compress_level;
 	bool saved_compress_force;
 	int no_compress = 0;
+	const bool remounting = test_bit(BTRFS_FS_STATE_REMOUNTING, &info->fs_state);
 
 	if (btrfs_fs_compat_ro(info, FREE_SPACE_TREE))
 		btrfs_set_opt(info->mount_opt, FREE_SPACE_TREE);
@@ -1137,10 +1138,12 @@ int btrfs_parse_options(struct btrfs_fs_info *info, char *options,
 	}
 	if (!ret)
 		ret = btrfs_check_mountopts_zoned(info);
-	if (!ret && btrfs_test_opt(info, SPACE_CACHE))
-		btrfs_info(info, "disk space caching is enabled");
-	if (!ret && btrfs_test_opt(info, FREE_SPACE_TREE))
-		btrfs_info(info, "using free space tree");
+	if (!ret && !remounting) {
+		if (btrfs_test_opt(info, SPACE_CACHE))
+			btrfs_info(info, "disk space caching is enabled");
+		if (btrfs_test_opt(info, FREE_SPACE_TREE))
+			btrfs_info(info, "using free space tree");
+	}
 	return ret;
 }
 
-- 
2.35.1



