Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5FE7529096
	for <lists+stable@lfdr.de>; Mon, 16 May 2022 22:45:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346294AbiEPTzn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 May 2022 15:55:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347022AbiEPTvf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 May 2022 15:51:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6D753EF1B;
        Mon, 16 May 2022 12:46:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 81E636090A;
        Mon, 16 May 2022 19:46:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCE90C385AA;
        Mon, 16 May 2022 19:46:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652730398;
        bh=K0e//h/6PydWP4sS4t8OnODJz9/3dzWamQ2oJbLLZmc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ECt13bLL6wSHDmJK8T2xGvvf5o38RbablhcgoTOvilhLcbkUjqoVULt87gKyVthXT
         9uW8BPGQVOi2KghJJsfBhl2KmHcFWFckGwee12HzeNc0NwOwX2kctdBKPY81YdjmPk
         jGPXHzyugeVgg4l++IYI6H7EdGUPsTkneQVdn8YQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, John Fortin <fortinj66@gmail.com>,
        Sri Ramanujam <sri@ramanujam.io>,
        Jeff Layton <jlayton@kernel.org>, Xiubo Li <xiubli@redhat.com>,
        Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 5.10 52/66] ceph: fix setting of xattrs on async created inodes
Date:   Mon, 16 May 2022 21:36:52 +0200
Message-Id: <20220516193620.911783173@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220516193619.400083785@linuxfoundation.org>
References: <20220516193619.400083785@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jeff Layton <jlayton@kernel.org>

commit 620239d9a32e9fe27c9204ec11e40058671aeeb6 upstream.

Currently when we create a file, we spin up an xattr buffer to send
along with the create request. If we end up doing an async create
however, then we currently pass down a zero-length xattr buffer.

Fix the code to send down the xattr buffer in req->r_pagelist. If the
xattrs span more than a page, however give up and don't try to do an
async create.

Cc: stable@vger.kernel.org
URL: https://bugzilla.redhat.com/show_bug.cgi?id=2063929
Fixes: 9a8d03ca2e2c ("ceph: attempt to do async create when possible")
Reported-by: John Fortin <fortinj66@gmail.com>
Reported-by: Sri Ramanujam <sri@ramanujam.io>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Reviewed-by: Xiubo Li <xiubli@redhat.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ceph/file.c |   16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -592,9 +592,15 @@ static int ceph_finish_async_create(stru
 	iinfo.change_attr = 1;
 	ceph_encode_timespec64(&iinfo.btime, &now);
 
-	iinfo.xattr_len = ARRAY_SIZE(xattr_buf);
-	iinfo.xattr_data = xattr_buf;
-	memset(iinfo.xattr_data, 0, iinfo.xattr_len);
+	if (req->r_pagelist) {
+		iinfo.xattr_len = req->r_pagelist->length;
+		iinfo.xattr_data = req->r_pagelist->mapped_tail;
+	} else {
+		/* fake it */
+		iinfo.xattr_len = ARRAY_SIZE(xattr_buf);
+		iinfo.xattr_data = xattr_buf;
+		memset(iinfo.xattr_data, 0, iinfo.xattr_len);
+	}
 
 	in.ino = cpu_to_le64(vino.ino);
 	in.snapid = cpu_to_le64(CEPH_NOSNAP);
@@ -706,6 +712,10 @@ int ceph_atomic_open(struct inode *dir,
 		err = ceph_security_init_secctx(dentry, mode, &as_ctx);
 		if (err < 0)
 			goto out_ctx;
+		/* Async create can't handle more than a page of xattrs */
+		if (as_ctx.pagelist &&
+		    !list_is_singular(&as_ctx.pagelist->head))
+			try_async = false;
 	} else if (!d_in_lookup(dentry)) {
 		/* If it's not being looked up, it's negative */
 		return -ENOENT;


