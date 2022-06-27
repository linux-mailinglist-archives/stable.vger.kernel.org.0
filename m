Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5860A55D8B2
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:20:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237357AbiF0Lnq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 07:43:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237447AbiF0Lmw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 07:42:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0F4DB6E;
        Mon, 27 Jun 2022 04:38:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5E50461143;
        Mon, 27 Jun 2022 11:38:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60926C341C7;
        Mon, 27 Jun 2022 11:38:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656329889;
        bh=h5rA93nbs6B0+WXubFOxP0JtaG4uJ3x4StUNmxB6ctk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fodsqUjcECrWsfzbZCNFmQHY1+Rs5B1kJ4wbVp6Do2NJNe2YcfJV7saeiXy5jw29U
         oBgpkvJIbU2Pcy5vLL4dvLuDovEo2PkuPru9+AWGY/Jt523HIcRzjBxBuXNAzq0VJC
         C7uEgZLWyC9ftnP7SVwZiXR7RqsTkyOG5gFuuud8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tyler Hicks <tyhicks@linux.microsoft.com>,
        Christian Schoenebeck <linux_oss@crudebyte.com>,
        Dominique Martinet <asmadeus@codewreck.org>
Subject: [PATCH 5.18 014/181] 9p: Fix refcounting during full path walks for fid lookups
Date:   Mon, 27 Jun 2022 13:19:47 +0200
Message-Id: <20220627111944.976333174@linuxfoundation.org>
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
@@ -152,7 +152,7 @@ static struct p9_fid *v9fs_fid_lookup_wi
 	const unsigned char **wnames, *uname;
 	int i, n, l, clone, access;
 	struct v9fs_session_info *v9ses;
-	struct p9_fid *fid, *old_fid = NULL;
+	struct p9_fid *fid, *old_fid;
 
 	v9ses = v9fs_dentry2v9ses(dentry);
 	access = v9ses->flags & V9FS_ACCESS_MASK;
@@ -194,13 +194,12 @@ static struct p9_fid *v9fs_fid_lookup_wi
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
@@ -212,6 +211,7 @@ static struct p9_fid *v9fs_fid_lookup_wi
 		fid = ERR_PTR(n);
 		goto err_out;
 	}
+	old_fid = fid;
 	clone = 1;
 	i = 0;
 	while (i < n) {
@@ -221,19 +221,15 @@ static struct p9_fid *v9fs_fid_lookup_wi
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


