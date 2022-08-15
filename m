Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5CBB592E77
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 13:49:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229445AbiHOLtn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 07:49:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229612AbiHOLtn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 07:49:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABEA224F28
        for <stable@vger.kernel.org>; Mon, 15 Aug 2022 04:49:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4BBCE61168
        for <stable@vger.kernel.org>; Mon, 15 Aug 2022 11:49:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5190AC433C1;
        Mon, 15 Aug 2022 11:49:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660564180;
        bh=Y6WinIdTT9Snb/J8bETp1+vx7pa+4nuYdl3PhQyuE84=;
        h=Subject:To:Cc:From:Date:From;
        b=oOUwhdSRzMy7fYuicBkVcmgVP4xSdNIgbXeLS1qFUcXkqkikrQsKbp4IMPmhSjxX+
         T0pGCqObP9bvU6TmSXE3868T93WHG/mvwYU6TOnBoAeCbZNBJWtF9xidY3K97MpEE8
         uiE9PHhqEB0gS0Hdb5lcu+Iv/3LOOpVPSwfbeT4I=
Subject: FAILED: patch "[PATCH] net/9p: Initialize the iounit field during fid creation" failed to apply to 4.19-stable tree
To:     tyhicks@linux.microsoft.com, asmadeus@codewreck.org,
        linux_oss@crudebyte.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 15 Aug 2022 13:49:33 +0200
Message-ID: <166056417320135@kroah.com>
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


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From aa7aeee169480e98cf41d83c01290a37e569be6d Mon Sep 17 00:00:00 2001
From: Tyler Hicks <tyhicks@linux.microsoft.com>
Date: Sun, 10 Jul 2022 09:14:02 -0500
Subject: [PATCH] net/9p: Initialize the iounit field during fid creation

Ensure that the fid's iounit field is set to zero when a new fid is
created. Certain 9P operations, such as OPEN and CREATE, allow the
server to reply with an iounit size which the client code assigns to the
p9_fid struct shortly after the fid is created by p9_fid_create(). On
the other hand, an XATTRWALK operation doesn't allow for the server to
specify an iounit value. The iounit field of the newly allocated p9_fid
struct remained uninitialized in that case. Depending on allocation
patterns, the iounit value could have been something reasonable that was
carried over from previously freed fids or, in the worst case, could
have been arbitrary values from non-fid related usages of the memory
location.

The bug was detected in the Windows Subsystem for Linux 2 (WSL2) kernel
after the uninitialized iounit field resulted in the typical sequence of
two getxattr(2) syscalls, one to get the size of an xattr and another
after allocating a sufficiently sized buffer to fit the xattr value, to
hit an unexpected ERANGE error in the second call to getxattr(2). An
uninitialized iounit field would sometimes force rsize to be smaller
than the xattr value size in p9_client_read_once() and the 9P server in
WSL refused to chunk up the READ on the attr_fid and, instead, returned
ERANGE to the client. The virtfs server in QEMU seems happy to chunk up
the READ and this problem goes undetected there.

Link: https://lkml.kernel.org/r/20220710141402.803295-1-tyhicks@linux.microsoft.com
Fixes: ebf46264a004 ("fs/9p: Add support user. xattr")
Cc: stable@vger.kernel.org
Signed-off-by: Tyler Hicks <tyhicks@linux.microsoft.com>
Reviewed-by: Christian Schoenebeck <linux_oss@crudebyte.com>
Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>

diff --git a/net/9p/client.c b/net/9p/client.c
index 89c5aeb00076..3c145a64dc2b 100644
--- a/net/9p/client.c
+++ b/net/9p/client.c
@@ -887,16 +887,13 @@ static struct p9_fid *p9_fid_create(struct p9_client *clnt)
 	struct p9_fid *fid;
 
 	p9_debug(P9_DEBUG_FID, "clnt %p\n", clnt);
-	fid = kmalloc(sizeof(*fid), GFP_KERNEL);
+	fid = kzalloc(sizeof(*fid), GFP_KERNEL);
 	if (!fid)
 		return NULL;
 
-	memset(&fid->qid, 0, sizeof(fid->qid));
 	fid->mode = -1;
 	fid->uid = current_fsuid();
 	fid->clnt = clnt;
-	fid->rdir = NULL;
-	fid->fid = 0;
 	refcount_set(&fid->count, 1);
 
 	idr_preload(GFP_KERNEL);

