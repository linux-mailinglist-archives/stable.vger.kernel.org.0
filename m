Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25BAF5FE08D
	for <lists+stable@lfdr.de>; Thu, 13 Oct 2022 20:11:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231311AbiJMSLc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Oct 2022 14:11:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231422AbiJMSKx (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Oct 2022 14:10:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2CE6175786;
        Thu, 13 Oct 2022 11:08:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BE4B361909;
        Thu, 13 Oct 2022 17:54:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1730C433D6;
        Thu, 13 Oct 2022 17:54:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665683690;
        bh=0WzNF0L24PGQtCOE+y+KzS6zPy33CwgpeY8JqNIhV9k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vAexPPVYRLi9VpzbOqFMXyX6SlI9iuzhcUrXN06KSFKZjN7DJS6FsQsYXU5xqTKna
         +PGfuyKKQ4ZD1OxQgBwhHeHX2qpwX9HUBoYVlFosh7tvg0V7TeFlkbXhJPWqbvGwud
         WbPga4MBGDCtywdyzLYeYtyNV5GeghlcCtDc10kI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hu Weiwen <sehuww@mail.scut.edu.cn>,
        Xiubo Li <xiubli@redhat.com>, Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 5.10 05/54] ceph: dont truncate file in atomic_open
Date:   Thu, 13 Oct 2022 19:51:59 +0200
Message-Id: <20221013175147.479149277@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221013175147.337501757@linuxfoundation.org>
References: <20221013175147.337501757@linuxfoundation.org>
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

From: Hu Weiwen <sehuww@mail.scut.edu.cn>

commit 7cb9994754f8a36ae9e5ec4597c5c4c2d6c03832 upstream.

Clear O_TRUNC from the flags sent in the MDS create request.

`atomic_open' is called before permission check. We should not do any
modification to the file here. The caller will do the truncation
afterward.

Fixes: 124e68e74099 ("ceph: file operations")
Signed-off-by: Hu Weiwen <sehuww@mail.scut.edu.cn>
Reviewed-by: Xiubo Li <xiubli@redhat.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
[Xiubo: fixed a trivial conflict for 5.10 backport]
Signed-off-by: Xiubo Li <xiubli@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ceph/file.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -703,6 +703,12 @@ int ceph_atomic_open(struct inode *dir,
 	if (dentry->d_name.len > NAME_MAX)
 		return -ENAMETOOLONG;
 
+	/*
+	 * Do not truncate the file, since atomic_open is called before the
+	 * permission check. The caller will do the truncation afterward.
+	 */
+	flags &= ~O_TRUNC;
+
 	if (flags & O_CREAT) {
 		if (ceph_quota_is_max_files_exceeded(dir))
 			return -EDQUOT;
@@ -769,9 +775,7 @@ retry:
 	}
 
 	set_bit(CEPH_MDS_R_PARENT_LOCKED, &req->r_req_flags);
-	err = ceph_mdsc_do_request(mdsc,
-				   (flags & (O_CREAT|O_TRUNC)) ? dir : NULL,
-				   req);
+	err = ceph_mdsc_do_request(mdsc, (flags & O_CREAT) ? dir : NULL, req);
 	err = ceph_handle_snapdir(req, dentry, err);
 	if (err)
 		goto out_req;


