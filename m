Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C36D259BC70
	for <lists+stable@lfdr.de>; Mon, 22 Aug 2022 11:13:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230131AbiHVJNM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Aug 2022 05:13:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234102AbiHVJMo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Aug 2022 05:12:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC20A2F39D
        for <stable@vger.kernel.org>; Mon, 22 Aug 2022 02:12:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3384760EDC
        for <stable@vger.kernel.org>; Mon, 22 Aug 2022 09:12:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BDAFC433C1;
        Mon, 22 Aug 2022 09:12:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661159531;
        bh=48RncARRBZPseE8XtzquU9MGMF0sqxNdNf71MkD2oSI=;
        h=Subject:To:Cc:From:Date:From;
        b=sPpTsYL7i8aPBoa+frnjQhj34ccUnCyu1mOk7fS5l9UA/LwVyLipEvtlIlbMF5fU7
         /fp2vF8OJU0K5GPEk/TKo8xFIUM8spI65cFXQmo/ZFs8IDr0yhjqGrj1b6FzK8A9uJ
         Vl9hO23kgqtZFlBETyq2QvAZ+ingtB+T9uIC76uI=
Subject: FAILED: patch "[PATCH] ceph: don't truncate file in atomic_open" failed to apply to 4.14-stable tree
To:     sehuww@mail.scut.edu.cn, idryomov@gmail.com, xiubli@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 22 Aug 2022 11:11:20 +0200
Message-ID: <1661159480205199@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 7cb9994754f8a36ae9e5ec4597c5c4c2d6c03832 Mon Sep 17 00:00:00 2001
From: Hu Weiwen <sehuww@mail.scut.edu.cn>
Date: Fri, 1 Jul 2022 10:52:27 +0800
Subject: [PATCH] ceph: don't truncate file in atomic_open

Clear O_TRUNC from the flags sent in the MDS create request.

`atomic_open' is called before permission check. We should not do any
modification to the file here. The caller will do the truncation
afterward.

Fixes: 124e68e74099 ("ceph: file operations")
Signed-off-by: Hu Weiwen <sehuww@mail.scut.edu.cn>
Reviewed-by: Xiubo Li <xiubli@redhat.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>

diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index cd025ff25bf0..b4e978420802 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -749,6 +749,11 @@ int ceph_atomic_open(struct inode *dir, struct dentry *dentry,
 	err = ceph_wait_on_conflict_unlink(dentry);
 	if (err)
 		return err;
+	/*
+	 * Do not truncate the file, since atomic_open is called before the
+	 * permission check. The caller will do the truncation afterward.
+	 */
+	flags &= ~O_TRUNC;
 
 	if (flags & O_CREAT) {
 		if (ceph_quota_is_max_files_exceeded(dir))
@@ -824,9 +829,7 @@ int ceph_atomic_open(struct inode *dir, struct dentry *dentry,
 	}
 
 	set_bit(CEPH_MDS_R_PARENT_LOCKED, &req->r_req_flags);
-	err = ceph_mdsc_do_request(mdsc,
-				   (flags & (O_CREAT|O_TRUNC)) ? dir : NULL,
-				   req);
+	err = ceph_mdsc_do_request(mdsc, (flags & O_CREAT) ? dir : NULL, req);
 	if (err == -ENOENT) {
 		dentry = ceph_handle_snapdir(req, dentry);
 		if (IS_ERR(dentry)) {

