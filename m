Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07BDF60A6FE
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 14:43:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234078AbiJXMnf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 08:43:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234081AbiJXMlz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 08:41:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 720C28A7FB;
        Mon, 24 Oct 2022 05:08:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B0581612B9;
        Mon, 24 Oct 2022 11:56:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C03D2C433D6;
        Mon, 24 Oct 2022 11:56:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666612609;
        bh=2Q21U+OZtgQgt7+d3W97F/pzkhbw11NkEC8p2AfJ2q0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=urhT5ZuajtL4XZ+Y1udKcnzab0aupcjTfsS6nF4Pp4F923OghplBappwQTQWHI0Fl
         om6tsh963BgZ9juqga7Q9Hg3gFSoI6rzFB38SBhRG9kJsm7iEcyQJ2BED8/hSmSDms
         0BI1/8FNIpzfzaZopawAjIRFZCSZfwoTL6g/av3w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hu Weiwen <sehuww@mail.scut.edu.cn>,
        Xiubo Li <xiubli@redhat.com>, Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 4.19 021/229] ceph: dont truncate file in atomic_open
Date:   Mon, 24 Oct 2022 13:29:00 +0200
Message-Id: <20221024112959.826609588@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024112959.085534368@linuxfoundation.org>
References: <20221024112959.085534368@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
@@ -446,6 +446,12 @@ int ceph_atomic_open(struct inode *dir,
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
@@ -478,9 +484,7 @@ int ceph_atomic_open(struct inode *dir,
 
 	req->r_parent = dir;
 	set_bit(CEPH_MDS_R_PARENT_LOCKED, &req->r_req_flags);
-	err = ceph_mdsc_do_request(mdsc,
-				   (flags & (O_CREAT|O_TRUNC)) ? dir : NULL,
-				   req);
+	err = ceph_mdsc_do_request(mdsc, (flags & O_CREAT) ? dir : NULL, req);
 	err = ceph_handle_snapdir(req, dentry, err);
 	if (err)
 		goto out_req;


