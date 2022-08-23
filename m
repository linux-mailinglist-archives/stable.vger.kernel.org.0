Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8534C59D71A
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 11:59:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350308AbiHWJb4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 05:31:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350273AbiHWJ3M (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 05:29:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B510915E8;
        Tue, 23 Aug 2022 01:37:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4BEB2614E7;
        Tue, 23 Aug 2022 08:36:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D4C8C433D7;
        Tue, 23 Aug 2022 08:36:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661243794;
        bh=8OjWaQrQ6n/R9pZg1uxFuSmosI8D28c28OyBd/Bvl8Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hTVxVhLzuecpebgpJrreT9YUHDPqPnS+fve4ke5tgU3Ez0zDa4gbIyKuZJHw0tZwQ
         5ti5v9cGKi5AdVmfs9fwsfrgsJYr8H+iaBix7QVAYNFwetm7je/on5MQNG8/R6dk6z
         SmTRna9qs9vYigw+1X63qZvfMKes5+WkriY1IWW0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Howells <dhowells@redhat.com>,
        Jeff Layton <jlayton@kernel.org>,
        Namjae Jeon <linkinjeon@kernel.org>, stable@kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Steve French <sfrench@samba.org>,
        Hyunchul Lee <hyc.lee@gmail.com>,
        Chuck Lever <chuck.lever@oracle.com>,
        Dave Wysochanski <dwysocha@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.14 023/229] vfs: Check the truncate maximum size in inode_newsize_ok()
Date:   Tue, 23 Aug 2022 10:23:04 +0200
Message-Id: <20220823080054.269554753@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080053.202747790@linuxfoundation.org>
References: <20220823080053.202747790@linuxfoundation.org>
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

From: David Howells <dhowells@redhat.com>

commit e2ebff9c57fe4eb104ce4768f6ebcccf76bef849 upstream.

If something manages to set the maximum file size to MAX_OFFSET+1, this
can cause the xfs and ext4 filesystems at least to become corrupt.

Ordinarily, the kernel protects against userspace trying this by
checking the value early in the truncate() and ftruncate() system calls
calls - but there are at least two places that this check is bypassed:

 (1) Cachefiles will round up the EOF of the backing file to DIO block
     size so as to allow DIO on the final block - but this might push
     the offset negative. It then calls notify_change(), but this
     inadvertently bypasses the checking. This can be triggered if
     someone puts an 8EiB-1 file on a server for someone else to try and
     access by, say, nfs.

 (2) ksmbd doesn't check the value it is given in set_end_of_file_info()
     and then calls vfs_truncate() directly - which also bypasses the
     check.

In both cases, it is potentially possible for a network filesystem to
cause a disk filesystem to be corrupted: cachefiles in the client's
cache filesystem; ksmbd in the server's filesystem.

nfsd is okay as it checks the value, but we can then remove this check
too.

Fix this by adding a check to inode_newsize_ok(), as called from
setattr_prepare(), thereby catching the issue as filesystems set up to
perform the truncate with minimal opportunity for bypassing the new
check.

Fixes: 1f08c925e7a3 ("cachefiles: Implement backing file wrangling")
Fixes: f44158485826 ("cifsd: add file operations")
Signed-off-by: David Howells <dhowells@redhat.com>
Reported-by: Jeff Layton <jlayton@kernel.org>
Tested-by: Jeff Layton <jlayton@kernel.org>
Reviewed-by: Namjae Jeon <linkinjeon@kernel.org>
Cc: stable@kernel.org
Acked-by: Alexander Viro <viro@zeniv.linux.org.uk>
cc: Steve French <sfrench@samba.org>
cc: Hyunchul Lee <hyc.lee@gmail.com>
cc: Chuck Lever <chuck.lever@oracle.com>
cc: Dave Wysochanski <dwysocha@redhat.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/attr.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/attr.c
+++ b/fs/attr.c
@@ -113,6 +113,8 @@ EXPORT_SYMBOL(setattr_prepare);
  */
 int inode_newsize_ok(const struct inode *inode, loff_t offset)
 {
+	if (offset < 0)
+		return -EINVAL;
 	if (inode->i_size < offset) {
 		unsigned long limit;
 


