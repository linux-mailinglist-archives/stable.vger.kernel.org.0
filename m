Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6A0640D200
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 05:22:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234155AbhIPDYD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Sep 2021 23:24:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:45700 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234037AbhIPDYC (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 Sep 2021 23:24:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BFE6A60F23;
        Thu, 16 Sep 2021 03:22:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631762563;
        bh=Nn4kCYOP6+SbigDcdcy9E2qRkqLYD8kP33/Pjy99rO0=;
        h=Date:From:To:Subject:From;
        b=HUnm1OcdR3HhyJHKSySDvVPxXyqtjqm3Yg5haeXfOBjevOz9UASVxKQ3Seo1fQrci
         bBEdCPz3+fwwTZ5JfMPddWa+EtqFkfhQ/wh/eiQ8ImFA+aCwcXTEtcHBpyifJo8jRY
         +nWWHIk9vBpLALxy2nca+/qHAXIvU9JX9lCHMxv4=
Date:   Wed, 15 Sep 2021 20:22:42 -0700
From:   akpm@linux-foundation.org
To:     gechangwei@live.cn, ghe@suse.com, jlbec@evilplan.org,
        joseph.qi@linux.alibaba.com, junxiao.bi@oracle.com,
        mark@fasheh.com, mm-commits@vger.kernel.org, piaojun@huawei.com,
        stable@vger.kernel.org, wen.gang.wang@oracle.com
Subject:  + ocfs2-drop-acl-cache-for-directories-too.patch added to
 -mm tree
Message-ID: <20210916032242.v5I_Wzn6n%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: ocfs2: drop acl cache for directories too
has been added to the -mm tree.  Its filename is
     ocfs2-drop-acl-cache-for-directories-too.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/ocfs2-drop-acl-cache-for-directories-too.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-drop-acl-cache-for-directories-too.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Wengang Wang <wen.gang.wang@oracle.com>
Subject: ocfs2: drop acl cache for directories too

ocfs2_data_convert_worker() is currently dropping any cached acl info for
FILE before down-converting meta lock.  It should also drop for DIRECTORY.
Otherwise the second acl lookup returns the cached one (from VFS layer)
which could be already stale.

The problem we are seeing is that the acl changes on one node doesn't get
refreshed on other nodes in the following case:

  Node 1                    Node 2
--------------            ----------------
getfacl dir1

			  getfacl dir1    <-- this is OK

setfacl -m u:user1:rwX dir1
getfacl dir1   <-- see the change for user1

			  getfacl dir1    <-- can't see change for user1

Link: https://lkml.kernel.org/r/20210903012631.6099-1-wen.gang.wang@oracle.com
Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Jun Piao <piaojun@huawei.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dlmglue.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/ocfs2/dlmglue.c~ocfs2-drop-acl-cache-for-directories-too
+++ a/fs/ocfs2/dlmglue.c
@@ -3951,7 +3951,7 @@ static int ocfs2_data_convert_worker(str
 		oi = OCFS2_I(inode);
 		oi->ip_dir_lock_gen++;
 		mlog(0, "generation: %u\n", oi->ip_dir_lock_gen);
-		goto out;
+		goto out_forget;
 	}
 
 	if (!S_ISREG(inode->i_mode))
@@ -3982,6 +3982,7 @@ static int ocfs2_data_convert_worker(str
 		filemap_fdatawait(mapping);
 	}
 
+out_forget:
 	forget_all_cached_acls(inode);
 
 out:
_

Patches currently in -mm which might be from wen.gang.wang@oracle.com are

ocfs2-drop-acl-cache-for-directories-too.patch

