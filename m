Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94C7659D667
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 11:12:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243036AbiHWI1I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 04:27:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243532AbiHWIZf (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 04:25:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C31FF5EDDA;
        Tue, 23 Aug 2022 01:13:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 646EEB81C39;
        Tue, 23 Aug 2022 08:13:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB50AC433D6;
        Tue, 23 Aug 2022 08:13:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661242388;
        bh=7VVa0jMI40XAqw0ec5vegBfGZZUkDAlrWifIwxJk7WI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pugy4Irp9+uZkZaZRoLUD/VKgxUCK75QmHKmr+2Q7uzj3qspLdR1w5bHGKMyyueCY
         /pGJMY5LpYiFTZr8LfHgQtz1rHZdt/R1QNpgd24ow7xYTZ3bEIva8J5KnxzOWbdN9T
         TmKjUcHgYOYfS92psYDpzSqpje5XNhy6HaVwwzpQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tyler Hicks <tyhicks@linux.microsoft.com>,
        Christian Schoenebeck <linux_oss@crudebyte.com>,
        Dominique Martinet <asmadeus@codewreck.org>
Subject: [PATCH 4.9 064/101] net/9p: Initialize the iounit field during fid creation
Date:   Tue, 23 Aug 2022 10:03:37 +0200
Message-Id: <20220823080037.026540537@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080034.579196046@linuxfoundation.org>
References: <20220823080034.579196046@linuxfoundation.org>
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

From: Tyler Hicks <tyhicks@linux.microsoft.com>

commit aa7aeee169480e98cf41d83c01290a37e569be6d upstream.

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
[tyhicks: Adjusted context due to:
 - Lack of fid refcounting introduced in v5.11 commit 6636b6dcc3db ("9p:
   add refcount to p9_fid struct")
 - Difference in how buffer sizes are specified v5.16 commit
   6e195b0f7c8e ("9p: fix a bunch of checkpatch warnings")
 - Reimplementation of the fidlist as an IDR in v4.19 commit
   f28cdf0430fc ("9p: Replace the fidlist with an IDR")]
Signed-off-by: Tyler Hicks <tyhicks@linux.microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/9p/client.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/net/9p/client.c
+++ b/net/9p/client.c
@@ -891,7 +891,7 @@ static struct p9_fid *p9_fid_create(stru
 	unsigned long flags;
 
 	p9_debug(P9_DEBUG_FID, "clnt %p\n", clnt);
-	fid = kmalloc(sizeof(struct p9_fid), GFP_KERNEL);
+	fid = kzalloc(sizeof(struct p9_fid), GFP_KERNEL);
 	if (!fid)
 		return ERR_PTR(-ENOMEM);
 
@@ -902,11 +902,9 @@ static struct p9_fid *p9_fid_create(stru
 	}
 	fid->fid = ret;
 
-	memset(&fid->qid, 0, sizeof(struct p9_qid));
 	fid->mode = -1;
 	fid->uid = current_fsuid();
 	fid->clnt = clnt;
-	fid->rdir = NULL;
 	spin_lock_irqsave(&clnt->lock, flags);
 	list_add(&fid->flist, &clnt->fidlist);
 	spin_unlock_irqrestore(&clnt->lock, flags);


