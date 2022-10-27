Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 720DC60FEF7
	for <lists+stable@lfdr.de>; Thu, 27 Oct 2022 19:10:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237096AbiJ0RKK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Oct 2022 13:10:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237099AbiJ0RKI (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Oct 2022 13:10:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F4A43AB08
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 10:10:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3A37562401
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 17:10:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DEE1C433D6;
        Thu, 27 Oct 2022 17:10:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666890605;
        bh=rIaQfx3G8OLvoID2JzviG0H5prli4rwCc1c8biIFC/A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fEvoK9CZILzAcTiBM1hCQ1NYw1vMzjRuAeODMwGnj3+vdAiA884wRA5wYYIGySC//
         7DVDelOaXc1djzL5t1h/gu64leZBnB4IyNhjzTYzBpw+oEHzxUrSa9Ce0QPd9ccN4m
         FrxomwEyGe3GtJCDn49/gEovTRoI8zN8UrdeN7UM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Christoph Hellwig <hch@lst.de>,
        Brian Foster <bfoster@redhat.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Chandan Babu R <chandan.babu@oracle.com>
Subject: [PATCH 5.4 24/53] xfs: reflink should force the log out if mounted with wsync
Date:   Thu, 27 Oct 2022 18:56:12 +0200
Message-Id: <20221027165050.744890946@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221027165049.817124510@linuxfoundation.org>
References: <20221027165049.817124510@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

commit 5833112df7e9a306af9af09c60127b92ed723962 upstream.

Reflink should force the log out to disk if the filesystem was mounted
with wsync, the same as most other operations in xfs.

[Note: XFS_MOUNT_WSYNC is set when the admin mounts the filesystem
with either the 'wsync' or 'sync' mount options, which effectively means
that we're classifying reflink/dedupe as IO operations and making them
synchronous when required.]

Fixes: 3fc9f5e409319 ("xfs: remove xfs_reflink_remap_range")
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
[darrick: add more to the changelog]
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_file.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -1044,7 +1044,11 @@ xfs_file_remap_range(
 
 	ret = xfs_reflink_update_dest(dest, pos_out + len, cowextsize,
 			remap_flags);
+	if (ret)
+		goto out_unlock;
 
+	if (mp->m_flags & XFS_MOUNT_WSYNC)
+		xfs_log_force_inode(dest);
 out_unlock:
 	xfs_reflink_remap_unlock(file_in, file_out);
 	if (ret)


