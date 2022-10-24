Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93FBF60A410
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 14:05:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232268AbiJXMFR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 08:05:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232608AbiJXMDz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 08:03:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5684D2F649;
        Mon, 24 Oct 2022 04:49:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 23B20B811A6;
        Mon, 24 Oct 2022 11:48:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E5DBC433C1;
        Mon, 24 Oct 2022 11:48:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666612101;
        bh=TMvR2MeejFZ+Q3PY0N79YCpGWHa+6Q5n9P36TzDFrTQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m7OQka/bJGqW3Kqewqd8J/NvhTu2hASYZbIh+s7auPwHwxNMV88Asn4VUoSR9JKtH
         fCurSwy6tY72lQk0IcahVrRsz+PI7xyJLiR0NOwNfMPc7KyvkxSmfSmPObE4DAku7u
         YINyr4mO+7K4d+KhPPtbwNmsDRo8rwyvZxBsN8zA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hu Weiwen <sehuww@mail.scut.edu.cn>,
        Xiubo Li <xiubli@redhat.com>, Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 4.14 039/210] ceph: dont truncate file in atomic_open
Date:   Mon, 24 Oct 2022 13:29:16 +0200
Message-Id: <20221024112958.258391812@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024112956.797777597@linuxfoundation.org>
References: <20221024112956.797777597@linuxfoundation.org>
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
@@ -381,6 +381,12 @@ int ceph_atomic_open(struct inode *dir,
 	if (dentry->d_name.len > NAME_MAX)
 		return -ENAMETOOLONG;
 
+	/*
+	 * Do not truncate the file, since atomic_open is called before the
+	 * permission check. The caller will do the truncation afterward.
+	 */
+	flags &= ~O_TRUNC;
+
 	if (flags & O_CREAT) {
 		err = ceph_pre_init_acls(dir, &mode, &acls);
 		if (err < 0)
@@ -411,9 +417,7 @@ int ceph_atomic_open(struct inode *dir,
 
 	req->r_parent = dir;
 	set_bit(CEPH_MDS_R_PARENT_LOCKED, &req->r_req_flags);
-	err = ceph_mdsc_do_request(mdsc,
-				   (flags & (O_CREAT|O_TRUNC)) ? dir : NULL,
-				   req);
+	err = ceph_mdsc_do_request(mdsc, (flags & O_CREAT) ? dir : NULL, req);
 	err = ceph_handle_snapdir(req, dentry, err);
 	if (err)
 		goto out_req;


