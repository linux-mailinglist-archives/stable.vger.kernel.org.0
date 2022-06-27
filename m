Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1524F55CF05
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:05:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236020AbiF0LfL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 07:35:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235264AbiF0Lds (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 07:33:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E4A8BDE;
        Mon, 27 Jun 2022 04:31:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 14766B8111B;
        Mon, 27 Jun 2022 11:31:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3768AC3411D;
        Mon, 27 Jun 2022 11:31:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656329473;
        bh=1vs+4O73ZkfN8D3Bvz76KHOfCkHKRBezAWm1iAsVk0o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FLRbh6NnnW//aOSm9+vYtrX+vhevA1huohThrrmNKKc3WBPuAMUf7pGTp1DWURWfI
         WU4TdMBqT1uSah0tFM0MLFJ0zFI+hoU4TIoxDB/c6iA5yVR+PIRhKwUqiZUJWJxzZP
         PR6txZVVTY5JTWRv3SKKkPMWe1JNzR9kqBu6Ym4U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tyler Hicks <tyhicks@linux.microsoft.com>,
        Christian Schoenebeck <linux_oss@crudebyte.com>,
        Dominique Martinet <asmadeus@codewreck.org>
Subject: [PATCH 5.15 011/135] 9p: Fix refcounting during full path walks for fid lookups
Date:   Mon, 27 Jun 2022 13:20:18 +0200
Message-Id: <20220627111938.486779755@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220627111938.151743692@linuxfoundation.org>
References: <20220627111938.151743692@linuxfoundation.org>
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

From: Tyler Hicks <tyhicks@linux.microsoft.com>

commit 2a3dcbccd64ba35c045fac92272ff981c4cbef44 upstream.

Decrement the refcount of the parent dentry's fid after walking
each path component during a full path walk for a lookup. Failure to do
so can lead to fids that are not clunked until the filesystem is
unmounted, as indicated by this warning:

 9pnet: found fid 3 not clunked

The improper refcounting after walking resulted in open(2) returning
-EIO on any directories underneath the mount point when using the virtio
transport. When using the fd transport, there's no apparent issue until
the filesytem is unmounted and the warning above is emitted to the logs.

In some cases, the user may not yet be attached to the filesystem and a
new root fid, associated with the user, is created and attached to the
root dentry before the full path walk is performed. Increment the new
root fid's refcount to two in that situation so that it can be safely
decremented to one after it is used for the walk operation. The new fid
will still be attached to the root dentry when
v9fs_fid_lookup_with_uid() returns so a final refcount of one is
correct/expected.

Link: https://lkml.kernel.org/r/20220527000003.355812-2-tyhicks@linux.microsoft.com
Link: https://lkml.kernel.org/r/20220612085330.1451496-4-asmadeus@codewreck.org
Fixes: 6636b6dcc3db ("9p: add refcount to p9_fid struct")
Cc: stable@vger.kernel.org
Signed-off-by: Tyler Hicks <tyhicks@linux.microsoft.com>
Reviewed-by: Christian Schoenebeck <linux_oss@crudebyte.com>
[Dominique: fix clunking fid multiple times discussed in second link]
Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/9p/fid.c |   22 +++++++++-------------
 1 file changed, 9 insertions(+), 13 deletions(-)

--- a/fs/9p/fid.c
+++ b/fs/9p/fid.c
@@ -151,7 +151,7 @@ static struct p9_fid *v9fs_fid_lookup_wi
 	const unsigned char **wnames, *uname;
 	int i, n, l, clone, access;
 	struct v9fs_session_info *v9ses;
-	struct p9_fid *fid, *old_fid = NULL;
+	struct p9_fid *fid, *old_fid;
 
 	v9ses = v9fs_dentry2v9ses(dentry);
 	access = v9ses->flags & V9FS_ACCESS_MASK;
@@ -193,13 +193,12 @@ static struct p9_fid *v9fs_fid_lookup_wi
 		if (IS_ERR(fid))
 			return fid;
 
+		refcount_inc(&fid->count);
 		v9fs_fid_add(dentry->d_sb->s_root, fid);
 	}
 	/* If we are root ourself just return that */
-	if (dentry->d_sb->s_root == dentry) {
-		refcount_inc(&fid->count);
+	if (dentry->d_sb->s_root == dentry)
 		return fid;
-	}
 	/*
 	 * Do a multipath walk with attached root.
 	 * When walking parent we need to make sure we
@@ -211,6 +210,7 @@ static struct p9_fid *v9fs_fid_lookup_wi
 		fid = ERR_PTR(n);
 		goto err_out;
 	}
+	old_fid = fid;
 	clone = 1;
 	i = 0;
 	while (i < n) {
@@ -220,19 +220,15 @@ static struct p9_fid *v9fs_fid_lookup_wi
 		 * walk to ensure none of the patch component change
 		 */
 		fid = p9_client_walk(fid, l, &wnames[i], clone);
+		/* non-cloning walk will return the same fid */
+		if (fid != old_fid) {
+			p9_client_clunk(old_fid);
+			old_fid = fid;
+		}
 		if (IS_ERR(fid)) {
-			if (old_fid) {
-				/*
-				 * If we fail, clunk fid which are mapping
-				 * to path component and not the last component
-				 * of the path.
-				 */
-				p9_client_clunk(old_fid);
-			}
 			kfree(wnames);
 			goto err_out;
 		}
-		old_fid = fid;
 		i += l;
 		clone = 0;
 	}


