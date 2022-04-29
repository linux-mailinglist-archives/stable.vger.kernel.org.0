Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5160E51472E
	for <lists+stable@lfdr.de>; Fri, 29 Apr 2022 12:44:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349798AbiD2Kre (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Apr 2022 06:47:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357794AbiD2KrC (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 Apr 2022 06:47:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5E34C90CA;
        Fri, 29 Apr 2022 03:42:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 46FB262347;
        Fri, 29 Apr 2022 10:42:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 497EEC385A4;
        Fri, 29 Apr 2022 10:42:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651228975;
        bh=EGEVJxKSlnUmob6HnZRZpa7KRntmPL+HxdonKBurzWo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DprNt6A+Ky6pPSLmtiOrbq8QjcuwT9I/Zg+makhjiHFyHjeeqer6P1HbOnNDvUlze
         gC9mx3PTd7+KJVUOKhZMIJtA7a9qY4aDIzzzxhgKpSkeq5klqU5fGkKxqokc/GhxGG
         Uyna9Hz/5R+fX0mfzkyVmSmh6veeRTU3/uIXx+es=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Anand Jain <anand.jain@oracle.com>
Subject: [PATCH 5.15 18/33] gfs2: Add wrapper for iomap_file_buffered_write
Date:   Fri, 29 Apr 2022 12:42:05 +0200
Message-Id: <20220429104052.869325697@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220429104052.345760505@linuxfoundation.org>
References: <20220429104052.345760505@linuxfoundation.org>
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

From: Andreas Gruenbacher <agruenba@redhat.com>

commit 2eb7509a05443048fb4df60b782de3f03c6c298b upstream

Add a wrapper around iomap_file_buffered_write.  We'll add code for when
the operation needs to be retried here later.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Anand Jain <anand.jain@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/gfs2/file.c |   27 +++++++++++++++++----------
 1 file changed, 17 insertions(+), 10 deletions(-)

--- a/fs/gfs2/file.c
+++ b/fs/gfs2/file.c
@@ -877,6 +877,20 @@ out_uninit:
 	return written ? written : ret;
 }
 
+static ssize_t gfs2_file_buffered_write(struct kiocb *iocb, struct iov_iter *from)
+{
+	struct file *file = iocb->ki_filp;
+	struct inode *inode = file_inode(file);
+	ssize_t ret;
+
+	current->backing_dev_info = inode_to_bdi(inode);
+	ret = iomap_file_buffered_write(iocb, from, &gfs2_iomap_ops);
+	current->backing_dev_info = NULL;
+	if (ret > 0)
+		iocb->ki_pos += ret;
+	return ret;
+}
+
 /**
  * gfs2_file_write_iter - Perform a write to a file
  * @iocb: The io context
@@ -928,9 +942,7 @@ static ssize_t gfs2_file_write_iter(stru
 			goto out_unlock;
 
 		iocb->ki_flags |= IOCB_DSYNC;
-		current->backing_dev_info = inode_to_bdi(inode);
-		buffered = iomap_file_buffered_write(iocb, from, &gfs2_iomap_ops);
-		current->backing_dev_info = NULL;
+		buffered = gfs2_file_buffered_write(iocb, from);
 		if (unlikely(buffered <= 0)) {
 			if (!ret)
 				ret = buffered;
@@ -944,7 +956,6 @@ static ssize_t gfs2_file_write_iter(stru
 		 * the direct I/O range as we don't know if the buffered pages
 		 * made it to disk.
 		 */
-		iocb->ki_pos += buffered;
 		ret2 = generic_write_sync(iocb, buffered);
 		invalidate_mapping_pages(mapping,
 				(iocb->ki_pos - buffered) >> PAGE_SHIFT,
@@ -952,13 +963,9 @@ static ssize_t gfs2_file_write_iter(stru
 		if (!ret || ret2 > 0)
 			ret += ret2;
 	} else {
-		current->backing_dev_info = inode_to_bdi(inode);
-		ret = iomap_file_buffered_write(iocb, from, &gfs2_iomap_ops);
-		current->backing_dev_info = NULL;
-		if (likely(ret > 0)) {
-			iocb->ki_pos += ret;
+		ret = gfs2_file_buffered_write(iocb, from);
+		if (likely(ret > 0))
 			ret = generic_write_sync(iocb, ret);
-		}
 	}
 
 out_unlock:


