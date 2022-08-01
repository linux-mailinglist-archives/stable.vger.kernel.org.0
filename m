Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 117EA586922
	for <lists+stable@lfdr.de>; Mon,  1 Aug 2022 13:57:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232253AbiHAL5m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Aug 2022 07:57:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232229AbiHAL4T (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Aug 2022 07:56:19 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0B5B481F5;
        Mon,  1 Aug 2022 04:51:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 98DC2CE1385;
        Mon,  1 Aug 2022 11:51:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 950F8C433D6;
        Mon,  1 Aug 2022 11:51:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1659354704;
        bh=LqRV4ZfOcB+6/pOcYqDRRNAtvrtMClIZXZmClq7SeBo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hbEEkqeD2Zx1uOyC5MfxhpRs7qUBdK0QiQ5fhtAleUUlv0ZyhoZl5Hfj5w4bLbhLh
         slOxGEtvKbTx/j+v9TQIJinVmZE7av4aPPpA77QijxjZZobSyODnesR+7BOE/24f+d
         JCA12tb63IiDjmpJDkvdRSbV8pLQJ9SNrAXkvoS8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Darrick J. Wong" <djwong@kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 5.10 56/65] xfs: fix log intent recovery ENOSPC shutdowns when inactivating inodes
Date:   Mon,  1 Aug 2022 13:47:13 +0200
Message-Id: <20220801114136.025531893@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220801114133.641770326@linuxfoundation.org>
References: <20220801114133.641770326@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Darrick J. Wong" <djwong@kernel.org>

commit 81ed94751b1513fcc5978dcc06eb1f5b4e55a785 upstream.

During regular operation, the xfs_inactive operations create
transactions with zero block reservation because in general we're
freeing space, not asking for more.  The per-AG space reservations
created at mount time enable us to handle expansions of the refcount
btree without needing to reserve blocks to the transaction.

Unfortunately, log recovery doesn't create the per-AG space reservations
when intent items are being recovered.  This isn't an issue for intent
item recovery itself because they explicitly request blocks, but any
inode inactivation that can happen during log recovery uses the same
xfs_inactive paths as regular runtime.  If a refcount btree expansion
happens, the transaction will fail due to blk_res_used > blk_res, and we
shut down the filesystem unnecessarily.

Fix this problem by making per-AG reservations temporarily so that we
can handle the inactivations, and releasing them at the end.  This
brings the recovery environment closer to the runtime environment.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_mount.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -968,9 +968,17 @@ xfs_mountfs(
 	/*
 	 * Finish recovering the file system.  This part needed to be delayed
 	 * until after the root and real-time bitmap inodes were consistently
-	 * read in.
+	 * read in.  Temporarily create per-AG space reservations for metadata
+	 * btree shape changes because space freeing transactions (for inode
+	 * inactivation) require the per-AG reservation in lieu of reserving
+	 * blocks.
 	 */
+	error = xfs_fs_reserve_ag_blocks(mp);
+	if (error && error == -ENOSPC)
+		xfs_warn(mp,
+	"ENOSPC reserving per-AG metadata pool, log recovery may fail.");
 	error = xfs_log_mount_finish(mp);
+	xfs_fs_unreserve_ag_blocks(mp);
 	if (error) {
 		xfs_warn(mp, "log mount finish failed");
 		goto out_rtunmount;


