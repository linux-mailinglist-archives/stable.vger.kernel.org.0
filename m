Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5C4B6E625B
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 14:32:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230173AbjDRMcE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 08:32:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231574AbjDRMcC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 08:32:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 152ED10247
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 05:31:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3263763218
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 12:31:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41789C433D2;
        Tue, 18 Apr 2023 12:31:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681821090;
        bh=N21wMtQn63NagOixZ4zAZGnlBBW8v+o+UP864siyKn0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eiedJKJn6MsPCbBjMEFhAB1mDfay5ldr4f0PZD/pHGdI4sJ0hsv8fDgGyCEKdwFh/
         u+Zve0vZeY9GYCOY3MH/M15uQhyUbKkWB5YVXGh0zZvJbDIWnsm5xsM722g6ICalNI
         fNa5h6OZ9UclmvE/j2bEscTh2GIAfY0dm0QRWjcU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Jeffrey Mitchell <jeffrey.mitchell@starlab.io>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Brian Foster <bfoster@redhat.com>,
        Amir Goldstein <amir73il@gmail.com>,
        Chandan Babu R <chandan.babu@oracle.com>
Subject: [PATCH 5.4 87/92] xfs: set inode size after creating symlink
Date:   Tue, 18 Apr 2023 14:22:02 +0200
Message-Id: <20230418120307.829460760@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120304.658273364@linuxfoundation.org>
References: <20230418120304.658273364@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jeffrey Mitchell <jeffrey.mitchell@starlab.io>

commit 8aa921a95335d0a8c8e2be35a44467e7c91ec3e4 upstream.

When XFS creates a new symlink, it writes its size to disk but not to the
VFS inode. This causes i_size_read() to return 0 for that symlink until
it is re-read from disk, for example when the system is rebooted.

I found this inconsistency while protecting directories with eCryptFS.
The command "stat path/to/symlink/in/ecryptfs" will report "Size: 0" if
the symlink was created after the last reboot on an XFS root.

Call i_size_write() in xfs_symlink()

Signed-off-by: Jeffrey Mitchell <jeffrey.mitchell@starlab.io>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_symlink.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/xfs/xfs_symlink.c
+++ b/fs/xfs/xfs_symlink.c
@@ -314,6 +314,7 @@ xfs_symlink(
 		}
 		ASSERT(pathlen == 0);
 	}
+	i_size_write(VFS_I(ip), ip->i_d.di_size);
 
 	/*
 	 * Create the directory entry for the symlink.


