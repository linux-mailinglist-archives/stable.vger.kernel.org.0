Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5EEFF531AF8
	for <lists+stable@lfdr.de>; Mon, 23 May 2022 22:56:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242372AbiEWRkd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 13:40:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243627AbiEWRiV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 13:38:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FD37939CA;
        Mon, 23 May 2022 10:32:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1369C61272;
        Mon, 23 May 2022 17:31:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 151CDC385A9;
        Mon, 23 May 2022 17:31:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653327108;
        bh=Dg8kFihg+woz8ZwiZbcbNhSN4KZAfNYqZI9p+T4462Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LPdXMmO94W8CaphX4Oek9BsefECFE58u1riuRddIVOx3TT3gWvN+OkGfjcRBslU5x
         +rJO2oeCp7fvZBrHyDzqzu2ewnqZqga3i5ZUePwJ0hGfMdq0ll3SuNwgNApkT1RkRX
         xN18ZAGmLk9kaIDilxQcf0+WJ3ZCOKHTCfcQB+q0=
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
Subject: [PATCH 5.17 158/158] afs: Fix afs_getattr() to refetch file status if callback break occurred
Date:   Mon, 23 May 2022 19:05:15 +0200
Message-Id: <20220523165856.364774177@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220523165830.581652127@linuxfoundation.org>
References: <20220523165830.581652127@linuxfoundation.org>
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
index 5964f8aee090..0d6c0885b2d7 100644
--- a/fs/afs/inode.c
+++ b/fs/afs/inode.c
@@ -727,10 +727,22 @@ int afs_getattr(struct user_namespace *mnt_userns, const struct path *path,
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



