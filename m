Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25A61657F48
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:03:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234369AbiL1QDa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:03:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234309AbiL1QDH (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:03:07 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9891B9FD0
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:03:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 54B50B81719
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:03:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACAC3C433F0;
        Wed, 28 Dec 2022 16:03:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672243384;
        bh=t3CtAzI82G208fSu4Z0V68kEslNx8BsDpEWr2JYkzJ4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eyIJoJR4LScuil3ZDwUdV65AjR54o1n/uIQmx83pJ0QaiyPUj0VJvE9ysRh0AmM+Z
         YekkSWS8mdziIDUh9zGXf3cMTO8nMMhDQlNpv9y7+mzW73+br2pNRmj4hGvZfrxlVf
         jq83pyY9SpYb7lL5seNG7hKee3zgie0s3cpgva8w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        syzbot+8f1060e2aaf8ca55220b@syzkaller.appspotmail.com,
        Schspa Shi <schspa@gmail.com>,
        Christian Schoenebeck <linux_oss@crudebyte.com>,
        Dominique Martinet <asmadeus@codewreck.org>
Subject: [PATCH 5.15 715/731] 9p: set req refcount to zero to avoid uninitialized usage
Date:   Wed, 28 Dec 2022 15:43:42 +0100
Message-Id: <20221228144317.168397490@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Schspa Shi <schspa@gmail.com>

commit 26273ade77f54716e30dfd40ac6e85ceb54ac0f9 upstream.

When a new request is allocated, the refcount will be zero if it is
reused, but if the request is newly allocated from slab, it is not fully
initialized before being added to idr.

If the p9_read_work got a response before the refcount initiated. It will
use a uninitialized req, which will result in a bad request data struct.

Here is the logs from syzbot.

Corrupted memory at 0xffff88807eade00b [ 0xff 0x07 0x00 0x00 0x00 0x00
0x00 0x00 . . . . . . . . ] (in kfence-#110):
 p9_fcall_fini net/9p/client.c:248 [inline]
 p9_req_put net/9p/client.c:396 [inline]
 p9_req_put+0x208/0x250 net/9p/client.c:390
 p9_client_walk+0x247/0x540 net/9p/client.c:1165
 clone_fid fs/9p/fid.h:21 [inline]
 v9fs_fid_xattr_set+0xe4/0x2b0 fs/9p/xattr.c:118
 v9fs_xattr_set fs/9p/xattr.c:100 [inline]
 v9fs_xattr_handler_set+0x6f/0x120 fs/9p/xattr.c:159
 __vfs_setxattr+0x119/0x180 fs/xattr.c:182
 __vfs_setxattr_noperm+0x129/0x5f0 fs/xattr.c:216
 __vfs_setxattr_locked+0x1d3/0x260 fs/xattr.c:277
 vfs_setxattr+0x143/0x340 fs/xattr.c:309
 setxattr+0x146/0x160 fs/xattr.c:617
 path_setxattr+0x197/0x1c0 fs/xattr.c:636
 __do_sys_setxattr fs/xattr.c:652 [inline]
 __se_sys_setxattr fs/xattr.c:648 [inline]
 __ia32_sys_setxattr+0xc0/0x160 fs/xattr.c:648
 do_syscall_32_irqs_on arch/x86/entry/common.c:112 [inline]
 __do_fast_syscall_32+0x65/0xf0 arch/x86/entry/common.c:178
 do_fast_syscall_32+0x33/0x70 arch/x86/entry/common.c:203
 entry_SYSENTER_compat_after_hwframe+0x70/0x82

Below is a similar scenario, the scenario in the syzbot log looks more
complicated than this one, but this patch can fix it.

     T21124                   p9_read_work
======================== second trans =================================
p9_client_walk
  p9_client_rpc
    p9_client_prepare_req
      p9_tag_alloc
        req = kmem_cache_alloc(p9_req_cache, GFP_NOFS);
        tag = idr_alloc
        << preempted >>
        req->tc.tag = tag;
                            /* req->[refcount/tag] == uninitialized */
                            m->rreq = p9_tag_lookup(m->client, m->rc.tag);
                              /* increments uninitalized refcount */

        refcount_set(&req->refcount, 2);
                            /* cb drops one ref */
                            p9_client_cb(req)
                            /* reader thread drops its ref:
                               request is incorrectly freed */
                            p9_req_put(req)
    /* use after free and ref underflow */
    p9_req_put(req)

To fix it, we can initialize the refcount to zero before add to idr.

Link: https://lkml.kernel.org/r/20221201033310.18589-1-schspa@gmail.com
Cc: stable@vger.kernel.org # 6.0+ due to 6cda12864cb0 ("9p: Drop kref usage")
Fixes: 728356dedeff ("9p: Add refcount to p9_req_t")
Reported-by: syzbot+8f1060e2aaf8ca55220b@syzkaller.appspotmail.com
Signed-off-by: Schspa Shi <schspa@gmail.com>
Reviewed-by: Christian Schoenebeck <linux_oss@crudebyte.com>
Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/9p/client.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/net/9p/client.c
+++ b/net/9p/client.c
@@ -281,6 +281,11 @@ p9_tag_alloc(struct p9_client *c, int8_t
 	p9pdu_reset(&req->rc);
 	req->t_err = 0;
 	req->status = REQ_STATUS_ALLOC;
+	/* refcount needs to be set to 0 before inserting into the idr
+	 * so p9_tag_lookup does not accept a request that is not fully
+	 * initialized. refcount_set to 2 below will mark request ready.
+	 */
+	refcount_set(&req->refcount, 0);
 	init_waitqueue_head(&req->wq);
 	INIT_LIST_HEAD(&req->req_list);
 


