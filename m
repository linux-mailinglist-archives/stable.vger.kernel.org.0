Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEAF955D731
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:18:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237207AbiF0Lo2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 07:44:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237467AbiF0Lmx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 07:42:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99F6DF67;
        Mon, 27 Jun 2022 04:38:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 370126114D;
        Mon, 27 Jun 2022 11:38:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4864FC341C8;
        Mon, 27 Jun 2022 11:38:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656329898;
        bh=TiybJzSVz8izLkFtpH1FLS4k+JLx8oS7oe9r0JDSkBQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IT+7hB30Lh3/VD/YHoC6cDlMXvDa6aKX/7eVUWV7mriJzVApdqFAlgAA2xlR52v20
         fr4oAU23gC4n4MSgYFWWmAaUEJvpxPTxG6VBTJLbbDJa67cVV5+1znM4aD30yrHIdZ
         pfc0bTVumWRngx/YQ6+zDnuJOFgZY6vsudk14i/o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Howells <dhowells@redhat.com>,
        Christian Schoenebeck <linux_oss@crudebyte.com>,
        Dominique Martinet <asmadeus@codewreck.org>
Subject: [PATCH 5.18 017/181] 9p: fix EBADF errors in cached mode
Date:   Mon, 27 Jun 2022 13:19:50 +0200
Message-Id: <20220627111945.062546213@linuxfoundation.org>
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

From: Dominique Martinet <asmadeus@codewreck.org>

commit b0017602fdf6bd3f344dd49eaee8b6ffeed6dbac upstream.

cached operations sometimes need to do invalid operations (e.g. read
on a write only file)
Historic fscache had added a "writeback fid", a special handle opened
RW as root, for this. The conversion to new fscache missed that bit.

This commit reinstates a slightly lesser variant of the original code
that uses the writeback fid for partial pages backfills if the regular
user fid had been open as WRONLY, and thus would lack read permissions.

Link: https://lkml.kernel.org/r/20220614033802.1606738-1-asmadeus@codewreck.org
Fixes: eb497943fa21 ("9p: Convert to using the netfs helper lib to do reads and caching")
Cc: stable@vger.kernel.org
Cc: David Howells <dhowells@redhat.com>
Reported-By: Christian Schoenebeck <linux_oss@crudebyte.com>
Reviewed-by: Christian Schoenebeck <linux_oss@crudebyte.com>
Tested-by: Christian Schoenebeck <linux_oss@crudebyte.com>
Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/9p/vfs_addr.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- a/fs/9p/vfs_addr.c
+++ b/fs/9p/vfs_addr.c
@@ -58,8 +58,21 @@ static void v9fs_issue_read(struct netfs
  */
 static int v9fs_init_request(struct netfs_io_request *rreq, struct file *file)
 {
+	struct inode *inode = file_inode(file);
+	struct v9fs_inode *v9inode = V9FS_I(inode);
 	struct p9_fid *fid = file->private_data;
 
+	BUG_ON(!fid);
+
+	/* we might need to read from a fid that was opened write-only
+	 * for read-modify-write of page cache, use the writeback fid
+	 * for that */
+	if (rreq->origin == NETFS_READ_FOR_WRITE &&
+			(fid->mode & O_ACCMODE) == O_WRONLY) {
+		fid = v9inode->writeback_fid;
+		BUG_ON(!fid);
+	}
+
 	refcount_inc(&fid->count);
 	rreq->netfs_priv = fid;
 	return 0;


