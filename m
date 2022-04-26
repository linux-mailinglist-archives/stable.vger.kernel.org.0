Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8428450F66C
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 10:58:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242264AbiDZIsv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 04:48:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345710AbiDZIrP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 04:47:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 711A892D19;
        Tue, 26 Apr 2022 01:37:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F0409B81D0B;
        Tue, 26 Apr 2022 08:37:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D00CC385AC;
        Tue, 26 Apr 2022 08:37:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650962258;
        bh=bvhqsEbkDYaKpMcE1ev3Jt21CwVF4ZE9B9Viij96CTo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QQbZW3KMO+wQTC9LYZYsqtYfhoIBzx7ZeoYo3Tn4L87lRO5+QUJde7s9a4HQwiGgS
         OEl6uavVCAJ8RcyGCUKIBMD+xxIibF6tHl/tglHSjDrELZSNzPY4sKCHES/jYuNd+Y
         eVXK34xsojJPT++IAbxKygubRbILnKm9isRKslCw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Darrick J. Wong" <djwong@kernel.org>,
        Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@lst.de>,
        Christian Brauner <brauner@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 005/124] xfs: return errors in xfs_fs_sync_fs
Date:   Tue, 26 Apr 2022 10:20:06 +0200
Message-Id: <20220426081747.446618645@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220426081747.286685339@linuxfoundation.org>
References: <20220426081747.286685339@linuxfoundation.org>
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

From: Darrick J. Wong <djwong@kernel.org>

[ Upstream commit 2d86293c70750e4331e9616aded33ab6b47c299d ]

Now that the VFS will do something with the return values from
->sync_fs, make ours pass on error codes.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Acked-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/xfs_super.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -729,6 +729,7 @@ xfs_fs_sync_fs(
 	int			wait)
 {
 	struct xfs_mount	*mp = XFS_M(sb);
+	int			error;
 
 	trace_xfs_fs_sync_fs(mp, __return_address);
 
@@ -738,7 +739,10 @@ xfs_fs_sync_fs(
 	if (!wait)
 		return 0;
 
-	xfs_log_force(mp, XFS_LOG_SYNC);
+	error = xfs_log_force(mp, XFS_LOG_SYNC);
+	if (error)
+		return error;
+
 	if (laptop_mode) {
 		/*
 		 * The disk must be active because we're syncing.


