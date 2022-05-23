Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96ECF531B20
	for <lists+stable@lfdr.de>; Mon, 23 May 2022 22:56:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240863AbiEWRa1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 13:30:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242696AbiEWR14 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 13:27:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4746C81488;
        Mon, 23 May 2022 10:24:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 50B47B81215;
        Mon, 23 May 2022 17:23:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABABFC385AA;
        Mon, 23 May 2022 17:23:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653326625;
        bh=2OzM6rEcWN/cA/RcLcQIr0U+4Ibha4TEetcG9LyMk2E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ryCiWfIc/dNovL5I93xWRQpekZn+1/sWEWL+irV/2Kn6yIzuoVNJ9ijLPtYWs7x61
         cMklXHR/z7HjNymuHorqK/5cZ7GxPudMhPV4XMoFTiy9Is4qfFzWkVgK9Ko2/qKakm
         tsiN48mrKM1yKET7/6DyXxcx5JIcLHbBl58RyaAY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Markus Suvanto <markus.suvanto@gmail.com>,
        David Howells <dhowells@redhat.com>,
        Marc Dionne <marc.dionne@auristor.com>,
        linux-afs@lists.infradead.org,
        kafs-testing+fedora34_64checkkafs-build-496@auristor.com,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 132/132] afs: Fix afs_getattr() to refetch file status if callback break occurred
Date:   Mon, 23 May 2022 19:05:41 +0200
Message-Id: <20220523165845.636166274@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220523165823.492309987@linuxfoundation.org>
References: <20220523165823.492309987@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Howells <dhowells@redhat.com>

[ Upstream commit 2aeb8c86d49967552394d5e723f87454cb53f501 ]

If a callback break occurs (change notification), afs_getattr() needs to
issue an FS.FetchStatus RPC operation to update the status of the file
being examined by the stat-family of system calls.

Fix afs_getattr() to do this if AFS_VNODE_CB_PROMISED has been cleared
on a vnode by a callback break.  Skip this if AT_STATX_DONT_SYNC is set.

This can be tested by appending to a file on one AFS client and then
using "stat -L" to examine its length on a machine running kafs.  This
can also be watched through tracing on the kafs machine.  The callback
break is seen:

     kworker/1:1-46      [001] .....   978.910812: afs_cb_call: c=0000005f YFSCB.CallBack
     kworker/1:1-46      [001] ...1.   978.910829: afs_cb_break: 100058:23b4c:242d2c2 b=2 s=1 break-cb
     kworker/1:1-46      [001] .....   978.911062: afs_call_done:    c=0000005f ret=0 ab=0 [0000000082994ead]

And then the stat command generated no traffic if unpatched, but with
this change a call to fetch the status can be observed:

            stat-4471    [000] .....   986.744122: afs_make_fs_call: c=000000ab 100058:023b4c:242d2c2 YFS.FetchStatus
            stat-4471    [000] .....   986.745578: afs_call_done:    c=000000ab ret=0 ab=0 [0000000087fc8c84]

Fixes: 08e0e7c82eea ("[AF_RXRPC]: Make the in-kernel AFS filesystem use AF_RXRPC.")
Reported-by: Markus Suvanto <markus.suvanto@gmail.com>
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
Tested-by: Markus Suvanto <markus.suvanto@gmail.com>
Tested-by: kafs-testing+fedora34_64checkkafs-build-496@auristor.com
Link: https://bugzilla.kernel.org/show_bug.cgi?id=216010
Link: https://lore.kernel.org/r/165308359800.162686.14122417881564420962.stgit@warthog.procyon.org.uk/ # v1
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/afs/inode.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/fs/afs/inode.c b/fs/afs/inode.c
index 8fcffea2daf5..a47666ba48f5 100644
--- a/fs/afs/inode.c
+++ b/fs/afs/inode.c
@@ -728,10 +728,22 @@ int afs_getattr(struct user_namespace *mnt_userns, const struct path *path,
 {
 	struct inode *inode = d_inode(path->dentry);
 	struct afs_vnode *vnode = AFS_FS_I(inode);
-	int seq = 0;
+	struct key *key;
+	int ret, seq = 0;
 
 	_enter("{ ino=%lu v=%u }", inode->i_ino, inode->i_generation);
 
+	if (!(query_flags & AT_STATX_DONT_SYNC) &&
+	    !test_bit(AFS_VNODE_CB_PROMISED, &vnode->flags)) {
+		key = afs_request_key(vnode->volume->cell);
+		if (IS_ERR(key))
+			return PTR_ERR(key);
+		ret = afs_validate(vnode, key);
+		key_put(key);
+		if (ret < 0)
+			return ret;
+	}
+
 	do {
 		read_seqbegin_or_lock(&vnode->cb_lock, &seq);
 		generic_fillattr(&init_user_ns, inode, stat);
-- 
2.35.1



