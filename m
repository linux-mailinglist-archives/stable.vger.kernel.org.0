Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 036605A4841
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 13:07:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230263AbiH2LHk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 07:07:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229646AbiH2LHQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 07:07:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA40711C22;
        Mon, 29 Aug 2022 04:05:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5D41FB80EFC;
        Mon, 29 Aug 2022 11:03:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE416C433D7;
        Mon, 29 Aug 2022 11:03:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661771017;
        bh=1DXxsGH8T/db2sgGF+1eQuMxjREEw9B8J1bXMaBHUEU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XfNtV9fATiH5u8rlECAKk8zYe9b7D3T4fjJ8QihWs5EmbJJoM48DPvaudU2cyUGlt
         OzcEj/vKveIqB7Cy3kBpZSlG9O6fDzGddIdGbWAbA+JGedw/mP+UfAfXVPmXaQ65ei
         E+3O6UjSXd9+Tzdm1RCWUL/VLP/haPi/yUU2/naY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Darrick J. Wong" <djwong@kernel.org>,
        Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@lst.de>,
        Christian Brauner <brauner@kernel.org>,
        Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 5.10 08/86] vfs: make sync_filesystem return errors from ->sync_fs
Date:   Mon, 29 Aug 2022 12:58:34 +0200
Message-Id: <20220829105756.882417989@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220829105756.500128871@linuxfoundation.org>
References: <20220829105756.500128871@linuxfoundation.org>
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

From: "Darrick J. Wong" <djwong@kernel.org>

commit 5679897eb104cec9e99609c3f045a0c20603da4c upstream.

[backport to 5.10 only differs in __sync_blockdev helper]

Strangely, sync_filesystem ignores the return code from the ->sync_fs
call, which means that syscalls like syncfs(2) never see the error.
This doesn't seem right, so fix that.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Acked-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/sync.c |   18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

--- a/fs/sync.c
+++ b/fs/sync.c
@@ -28,7 +28,7 @@
  */
 int sync_filesystem(struct super_block *sb)
 {
-	int ret;
+	int ret = 0;
 
 	/*
 	 * We need to be protected against the filesystem going from
@@ -51,15 +51,21 @@ int sync_filesystem(struct super_block *
 	 * at a time.
 	 */
 	writeback_inodes_sb(sb, WB_REASON_SYNC);
-	if (sb->s_op->sync_fs)
-		sb->s_op->sync_fs(sb, 0);
+	if (sb->s_op->sync_fs) {
+		ret = sb->s_op->sync_fs(sb, 0);
+		if (ret)
+			return ret;
+	}
 	ret = __sync_blockdev(sb->s_bdev, 0);
-	if (ret < 0)
+	if (ret)
 		return ret;
 
 	sync_inodes_sb(sb);
-	if (sb->s_op->sync_fs)
-		sb->s_op->sync_fs(sb, 1);
+	if (sb->s_op->sync_fs) {
+		ret = sb->s_op->sync_fs(sb, 1);
+		if (ret)
+			return ret;
+	}
 	return __sync_blockdev(sb->s_bdev, 1);
 }
 EXPORT_SYMBOL(sync_filesystem);


