Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5954F6ECEFB
	for <lists+stable@lfdr.de>; Mon, 24 Apr 2023 15:37:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232727AbjDXNhK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Apr 2023 09:37:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232680AbjDXNga (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Apr 2023 09:36:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A79B93ED
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 06:36:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0A701623BC
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 13:36:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D8B8C4339B;
        Mon, 24 Apr 2023 13:36:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1682343370;
        bh=B9J5YQ8IBO2/Boe1gZNu1/MyMDEdfPBedYWCDUsidLE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D2QrXwTQOcUrbAdtS7aCLyV6yE+is407xRxf/UVmo6ZlByIhjenAHlX2iA2d7zuXW
         KqQbjcMOrnQLxztYlNgVMFCHxUINF4E4gSatH9Xcn0hGu7AOeQMCedibK0H1qcYXxn
         YhaE5ydTdRmZ78Rjfoif3zt0uKwPCsVPxckz0arc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Miklos Szeredi <mszeredi@redhat.com>,
        Yang Bo <yb203166@antfin.com>
Subject: [PATCH 5.10 51/68] fuse: check s_root when destroying sb
Date:   Mon, 24 Apr 2023 15:18:22 +0200
Message-Id: <20230424131129.624164183@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230424131127.653885914@linuxfoundation.org>
References: <20230424131127.653885914@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miklos Szeredi <mszeredi@redhat.com>

commit d534d31d6a45d71de61db22090b4820afb68fddc upstream.

Checking "fm" works because currently sb->s_fs_info is cleared on error
paths; however, sb->s_root is what generic_shutdown_super() checks to
determine whether the sb was fully initialized or not.

This change will allow cleanup of sb setup error paths.

Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Yang Bo <yb203166@antfin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/fuse/inode.c     |    2 +-
 fs/fuse/virtio_fs.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -1596,7 +1596,7 @@ static void fuse_kill_sb_blk(struct supe
 	struct fuse_mount *fm = get_fuse_mount_super(sb);
 	bool last;
 
-	if (fm) {
+	if (sb->s_root) {
 		last = fuse_mount_remove(fm);
 		if (last)
 			fuse_conn_destroy(fm);
--- a/fs/fuse/virtio_fs.c
+++ b/fs/fuse/virtio_fs.c
@@ -1399,7 +1399,7 @@ static void virtio_kill_sb(struct super_
 	bool last;
 
 	/* If mount failed, we can still be called without any fc */
-	if (fm) {
+	if (sb->s_root) {
 		last = fuse_mount_remove(fm);
 		if (last)
 			virtio_fs_conn_destroy(fm);


