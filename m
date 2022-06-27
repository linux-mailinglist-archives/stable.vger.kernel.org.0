Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F33FD55DA59
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:23:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235803AbiF0Lfu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 07:35:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235859AbiF0Lek (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 07:34:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E499CE9;
        Mon, 27 Jun 2022 04:31:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3A31260929;
        Mon, 27 Jun 2022 11:31:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 171A2C341C7;
        Mon, 27 Jun 2022 11:31:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656329485;
        bh=/eEdYIYtH/PtEylqtnmlVB4DCSajApuye58PGqvuQsM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IMFEJjF4Ry89QyiVIpWFVcPyQQa8jLMjqcj9JrE+kN0No8ynYMW4oPiPxUY20SzrD
         aXX1LEwWExWlrzdn5Lp641sVEABBnRp78LcJLfUPVglm7zjR1150GRNI7DqIxIhYi8
         8UfQf/s4oop/GEsNHwQnWb1LpXtZpdHcXoRA5N70=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qu Wenruo <wqu@suse.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.15 015/135] btrfs: prevent remounting to v1 space cache for subpage mount
Date:   Mon, 27 Jun 2022 13:20:22 +0200
Message-Id: <20220627111938.601933459@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220627111938.151743692@linuxfoundation.org>
References: <20220627111938.151743692@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qu Wenruo <wqu@suse.com>

commit 0591f04036218d572d54349ea8c7914ad9c82b2b upstream.

Upstream commit 9f73f1aef98b ("btrfs: force v2 space cache usage for
subpage mount") forces subpage mount to use v2 cache, to avoid
deprecated v1 cache which doesn't support subpage properly.

But there is a loophole that user can still remount to v1 cache.

The existing check will only give users a warning, but does not really
prevent to do the remount.

Although remounting to v1 will not cause any problems since the v1 cache
will always be marked invalid when mounted with a different page size,
it's still better to prevent v1 cache at all for subpage mounts.

Fixes: 9f73f1aef98b ("btrfs: force v2 space cache usage for subpage mount")
CC: stable@vger.kernel.org # 5.15+
Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/super.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1917,6 +1917,14 @@ static int btrfs_remount(struct super_bl
 	if (ret)
 		goto restore;
 
+	/* V1 cache is not supported for subpage mount. */
+	if (fs_info->sectorsize < PAGE_SIZE && btrfs_test_opt(fs_info, SPACE_CACHE)) {
+		btrfs_warn(fs_info,
+	"v1 space cache is not supported for page size %lu with sectorsize %u",
+			   PAGE_SIZE, fs_info->sectorsize);
+		ret = -EINVAL;
+		goto restore;
+	}
 	btrfs_remount_begin(fs_info, old_opts, *flags);
 	btrfs_resize_thread_pool(fs_info,
 		fs_info->thread_pool_size, old_thread_pool_size);


