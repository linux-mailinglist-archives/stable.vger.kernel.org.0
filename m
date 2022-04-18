Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 066A75052CE
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 14:51:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237034AbiDRMx2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 08:53:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240311AbiDRMxM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 08:53:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC2852DABC;
        Mon, 18 Apr 2022 05:34:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7A0BB60F0A;
        Mon, 18 Apr 2022 12:34:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71C70C385A7;
        Mon, 18 Apr 2022 12:34:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650285275;
        bh=CLqasHeB3f/9g8TJ+gJn5N0OM8JBTNVFUB299wDmNJw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FlFnuI7PCv1QTz+i1K+7IjqZ+FIebMyKXHf1nVriFmiZqHPV3aOBKcCSNIKF+Zvx8
         QnuQqzkVVVbG9LOrvbLoxGnp7ILvxVZyg+Fql31dN18JBK5jS5gpB9sADziTDd12cs
         3ZwewxHoDUE4JjnSKrBTKw0U6QcttA7chWYmFpV4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, TOTE Robot <oslab@tsinghua.edu.cn>,
        Jia-Ju Bai <baijiaju1990@gmail.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.15 156/189] btrfs: fix root ref counts in error handling in btrfs_get_root_ref
Date:   Mon, 18 Apr 2022 14:12:56 +0200
Message-Id: <20220418121206.544212252@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121200.312988959@linuxfoundation.org>
References: <20220418121200.312988959@linuxfoundation.org>
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
@@ -1738,9 +1738,10 @@ again:
 
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


