Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 099BE55D476
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:14:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235092AbiF0Lob (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 07:44:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237497AbiF0Lm7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 07:42:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECAAE10CD;
        Mon, 27 Jun 2022 04:38:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B13D1B8111B;
        Mon, 27 Jun 2022 11:38:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F066C3411D;
        Mon, 27 Jun 2022 11:38:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656329904;
        bh=o/oKP+PClE6ic2Rr0Q5Dzsw99u0cmJEBX6BfIJmBu2g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oWGWATtzQnpacVmBOS1EKg3Hma/v0qdnSvJXN3NDSjM73bUdNHC0YsVHgsE71VguD
         FCUTnbX/AJuoneyyL7sq8cy7nr1KyifXkc3fJsEPdkLxD6xqBOX7KzfGKOGuONGWQI
         ImRBOu5gojHGBfKNyde8gqddu9tBJK6bGx9e0mxg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qu Wenruo <wqu@suse.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.18 019/181] btrfs: prevent remounting to v1 space cache for subpage mount
Date:   Mon, 27 Jun 2022 13:19:52 +0200
Message-Id: <20220627111945.120948579@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220627111944.553492442@linuxfoundation.org>
References: <20220627111944.553492442@linuxfoundation.org>
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
@@ -1986,6 +1986,14 @@ static int btrfs_remount(struct super_bl
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


