Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90FF855CA3F
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 14:58:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235202AbiF0LtN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 07:49:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238469AbiF0Lsa (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 07:48:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF7ECBF56;
        Mon, 27 Jun 2022 04:41:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AD2F8B81126;
        Mon, 27 Jun 2022 11:41:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B8C0C3411D;
        Mon, 27 Jun 2022 11:41:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656330101;
        bh=KelcNy4BlQfdFL5bf3Gj9vnTq3rW4jyrrMITbB3CXBE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Hhgm7gO4Yv/ma4uKsFcI++43+1M8UVfyMkp152l4ARv33fviNFRWWofkvFxs7E3yv
         UAs1x/E+N0szgfk55lDGnnd+PAmFPLU/q66x1kt0F8T/yn1RosteqNhBglBcgLpQAq
         Onn0hpJY0bBSpB2I6NDuENDtdsYVM5hRVxqNSFjY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marc Dionne <marc.dionne@auristor.com>,
        David Howells <dhowells@redhat.com>,
        linux-afs@lists.infradead.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 083/181] afs: Fix dynamic root getattr
Date:   Mon, 27 Jun 2022 13:20:56 +0200
Message-Id: <20220627111946.966978772@linuxfoundation.org>
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

From: David Howells <dhowells@redhat.com>

[ Upstream commit cb78d1b5efffe4cf97e16766329dd7358aed3deb ]

The recent patch to make afs_getattr consult the server didn't account
for the pseudo-inodes employed by the dynamic root-type afs superblock
not having a volume or a server to access, and thus an oops occurs if
such a directory is stat'd.

Fix this by checking to see if the vnode->volume pointer actually points
anywhere before following it in afs_getattr().

This can be tested by stat'ing a directory in /afs.  It may be
sufficient just to do "ls /afs" and the oops looks something like:

        BUG: kernel NULL pointer dereference, address: 0000000000000020
        ...
        RIP: 0010:afs_getattr+0x8b/0x14b
        ...
        Call Trace:
         <TASK>
         vfs_statx+0x79/0xf5
         vfs_fstatat+0x49/0x62

Fixes: 2aeb8c86d499 ("afs: Fix afs_getattr() to refetch file status if callback break occurred")
Reported-by: Marc Dionne <marc.dionne@auristor.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Reviewed-by: Marc Dionne <marc.dionne@auristor.com>
Tested-by: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
Link: https://lore.kernel.org/r/165408450783.1031787.7941404776393751186.stgit@warthog.procyon.org.uk/
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/afs/inode.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/afs/inode.c b/fs/afs/inode.c
index 22811e9eacf5..c4c9f6dff0a2 100644
--- a/fs/afs/inode.c
+++ b/fs/afs/inode.c
@@ -745,7 +745,8 @@ int afs_getattr(struct user_namespace *mnt_userns, const struct path *path,
 
 	_enter("{ ino=%lu v=%u }", inode->i_ino, inode->i_generation);
 
-	if (!(query_flags & AT_STATX_DONT_SYNC) &&
+	if (vnode->volume &&
+	    !(query_flags & AT_STATX_DONT_SYNC) &&
 	    !test_bit(AFS_VNODE_CB_PROMISED, &vnode->flags)) {
 		key = afs_request_key(vnode->volume->cell);
 		if (IS_ERR(key))
-- 
2.35.1



