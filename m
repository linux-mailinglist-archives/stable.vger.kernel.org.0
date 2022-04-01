Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABD874EEB3F
	for <lists+stable@lfdr.de>; Fri,  1 Apr 2022 12:28:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237785AbiDAK3v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Apr 2022 06:29:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245687AbiDAK3r (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Apr 2022 06:29:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D92826E566
        for <stable@vger.kernel.org>; Fri,  1 Apr 2022 03:27:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BD3596171A
        for <stable@vger.kernel.org>; Fri,  1 Apr 2022 10:27:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB52CC2BBE4;
        Fri,  1 Apr 2022 10:27:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1648808876;
        bh=cSQVXvQEB/fq6d5cQ0mJZCHb/rvTofqM4Lh2jM7N8rw=;
        h=Subject:To:Cc:From:Date:From;
        b=Dwwvv0684ePhMXa02XtIb3z3l5h7uEY+PO4/+WEKAZYiBg3RkETBGAbqUtACV9iK6
         d+rhrG6ZQOJCrYmEHaW3GvaHyYtqVPDHarfOSwihx7tdU9wsWrAi4Y/vJHAQCLP6XQ
         ajDOTGboWJKitO2YY4paeAfBO4IklVDoLrDwlOL4=
Subject: FAILED: patch "[PATCH] NFS: NFSv2/v3 clients should never be setting NFS_CAP_XATTR" failed to apply to 5.10-stable tree
To:     trond.myklebust@hammerspace.com, kolga@netapp.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 01 Apr 2022 12:27:53 +0200
Message-ID: <1648808873102253@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From b622ffe1d9ecbac71f0cddb52ff0831efdf8fb83 Mon Sep 17 00:00:00 2001
From: Trond Myklebust <trond.myklebust@hammerspace.com>
Date: Tue, 22 Feb 2022 18:20:38 -0500
Subject: [PATCH] NFS: NFSv2/v3 clients should never be setting NFS_CAP_XATTR

Ensure that we always initialise the 'xattr_support' field in struct
nfs_fsinfo, so that nfs_server_set_fsinfo() doesn't declare our NFSv2/v3
client to be capable of supporting the NFSv4.2 xattr protocol by setting
the NFS_CAP_XATTR capability.

This configuration can cause nfs_do_access() to set access mode bits
that are unsupported by the NFSv3 ACCESS call, which may confuse
spec-compliant servers.

Reported-by: Olga Kornievskaia <kolga@netapp.com>
Fixes: b78ef845c35d ("NFSv4.2: query the server for extended attribute support")
Cc: stable@vger.kernel.org
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>

diff --git a/fs/nfs/nfs3xdr.c b/fs/nfs/nfs3xdr.c
index 9274c9c5efea..54a1d21cbcc6 100644
--- a/fs/nfs/nfs3xdr.c
+++ b/fs/nfs/nfs3xdr.c
@@ -2228,6 +2228,7 @@ static int decode_fsinfo3resok(struct xdr_stream *xdr,
 	/* ignore properties */
 	result->lease_time = 0;
 	result->change_attr_type = NFS4_CHANGE_TYPE_IS_UNDEFINED;
+	result->xattr_support = 0;
 	return 0;
 }
 
diff --git a/fs/nfs/proc.c b/fs/nfs/proc.c
index 73dcaa99fa9b..e3570c656b0f 100644
--- a/fs/nfs/proc.c
+++ b/fs/nfs/proc.c
@@ -92,6 +92,7 @@ nfs_proc_get_root(struct nfs_server *server, struct nfs_fh *fhandle,
 	info->maxfilesize = 0x7FFFFFFF;
 	info->lease_time = 0;
 	info->change_attr_type = NFS4_CHANGE_TYPE_IS_UNDEFINED;
+	info->xattr_support = 0;
 	return 0;
 }
 

