Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D31D150516D
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 14:32:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239171AbiDRMeq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 08:34:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239451AbiDRMdD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 08:33:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9378326AEE;
        Mon, 18 Apr 2022 05:24:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A105560FB0;
        Mon, 18 Apr 2022 12:24:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1900C385A1;
        Mon, 18 Apr 2022 12:24:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650284677;
        bh=41f3L+KWlQpUhp8T1RZqJOl6hTJ05WVA7/JAMZdnwWA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2lSsysgHCvdDSSGp2xDmUkzPxsC4ONmWZHx6xs4kSs6PpRo/iyI6/uh5oyIv41u2c
         IkXnT5+IgtRUSaNYPgW+lsPxFUDuPgmZS4aImZnz9YMR5DEM9OIVeCUNZBdSTVfbwr
         XEi8DhmxbtQzkoBCmelWbc8NvI2rXUS+N6R7+wOw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, TOTE Robot <oslab@tsinghua.edu.cn>,
        Jia-Ju Bai <baijiaju1990@gmail.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.17 192/219] btrfs: fix root ref counts in error handling in btrfs_get_root_ref
Date:   Mon, 18 Apr 2022 14:12:41 +0200
Message-Id: <20220418121212.249736255@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121203.462784814@linuxfoundation.org>
References: <20220418121203.462784814@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jia-Ju Bai <baijiaju1990@gmail.com>

commit 168a2f776b9762f4021421008512dd7ab7474df1 upstream.

In btrfs_get_root_ref(), when btrfs_insert_fs_root() fails,
btrfs_put_root() can happen for two reasons:

- the root already exists in the tree, in that case it returns the
  reference obtained in btrfs_lookup_fs_root()

- another error so the cleanup is done in the fail label

Calling btrfs_put_root() unconditionally would lead to double decrement
of the root reference possibly freeing it in the second case.

Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>
Fixes: bc44d7c4b2b1 ("btrfs: push btrfs_grab_fs_root into btrfs_get_fs_root")
CC: stable@vger.kernel.org # 5.10+
Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/disk-io.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1826,9 +1826,10 @@ again:
 
 	ret = btrfs_insert_fs_root(fs_info, root);
 	if (ret) {
-		btrfs_put_root(root);
-		if (ret == -EEXIST)
+		if (ret == -EEXIST) {
+			btrfs_put_root(root);
 			goto again;
+		}
 		goto fail;
 	}
 	return root;


