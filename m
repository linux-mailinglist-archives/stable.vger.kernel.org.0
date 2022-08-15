Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1486593D1F
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 22:40:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229456AbiHOUPN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 16:15:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243590AbiHOUNh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 16:13:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3969F8F976;
        Mon, 15 Aug 2022 11:59:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 76D7CB81109;
        Mon, 15 Aug 2022 18:59:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A60B2C433D6;
        Mon, 15 Aug 2022 18:59:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660589956;
        bh=qW6yXE9ud1P1tuP49WumpWs1UmmGtf+87D75l29Nzf0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bMdV/wBXGzqSYufty5QjmTBb42VIuvTRpzjbMhVLtzQtnzD2oPJhSjRCu/Ch7k6We
         GQP9S7h9Iu+CWJkWYjLZCQs4FKvaPDGue6thLCanLypUegsJEQc0KhISXClCiUeNg0
         1gj3qW6GBc6pBuCBY7YK0/4sF7hjgf+VzF/JOxPA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Christian=20Kohlsch=C3=BCtter?= 
        <christian@kohlschutter.com>, Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 5.18 0104/1095] fuse: ioctl: translate ENOSYS
Date:   Mon, 15 Aug 2022 19:51:43 +0200
Message-Id: <20220815180433.860641078@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Miklos Szeredi <mszeredi@redhat.com>

commit 02c0cab8e7345b06f1c0838df444e2902e4138d3 upstream.

Overlayfs may fail to complete updates when a filesystem lacks
fileattr/xattr syscall support and responds with an ENOSYS error code,
resulting in an unexpected "Function not implemented" error.

This bug may occur with FUSE filesystems, such as davfs2.

Steps to reproduce:

  # install davfs2, e.g., apk add davfs2
  mkdir /test mkdir /test/lower /test/upper /test/work /test/mnt
  yes '' | mount -t davfs -o ro http://some-web-dav-server/path \
    /test/lower
  mount -t overlay -o upperdir=/test/upper,lowerdir=/test/lower \
    -o workdir=/test/work overlay /test/mnt

  # when "some-file" exists in the lowerdir, this fails with "Function
  # not implemented", with dmesg showing "overlayfs: failed to retrieve
  # lower fileattr (/some-file, err=-38)"
  touch /test/mnt/some-file

The underlying cause of this regresion is actually in FUSE, which fails to
translate the ENOSYS error code returned by userspace filesystem (which
means that the ioctl operation is not supported) to ENOTTY.

Reported-by: Christian Kohlschütter <christian@kohlschutter.com>
Fixes: 72db82115d2b ("ovl: copy up sync/noatime fileattr flags")
Fixes: 59efec7b9039 ("fuse: implement ioctl support")
Cc: <stable@vger.kernel.org>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/fuse/ioctl.c |   15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

--- a/fs/fuse/ioctl.c
+++ b/fs/fuse/ioctl.c
@@ -9,6 +9,17 @@
 #include <linux/compat.h>
 #include <linux/fileattr.h>
 
+static ssize_t fuse_send_ioctl(struct fuse_mount *fm, struct fuse_args *args)
+{
+	ssize_t ret = fuse_simple_request(fm, args);
+
+	/* Translate ENOSYS, which shouldn't be returned from fs */
+	if (ret == -ENOSYS)
+		ret = -ENOTTY;
+
+	return ret;
+}
+
 /*
  * CUSE servers compiled on 32bit broke on 64bit kernels because the
  * ABI was defined to be 'struct iovec' which is different on 32bit
@@ -259,7 +270,7 @@ long fuse_do_ioctl(struct file *file, un
 	ap.args.out_pages = true;
 	ap.args.out_argvar = true;
 
-	transferred = fuse_simple_request(fm, &ap.args);
+	transferred = fuse_send_ioctl(fm, &ap.args);
 	err = transferred;
 	if (transferred < 0)
 		goto out;
@@ -393,7 +404,7 @@ static int fuse_priv_ioctl(struct inode
 	args.out_args[1].size = inarg.out_size;
 	args.out_args[1].value = ptr;
 
-	err = fuse_simple_request(fm, &args);
+	err = fuse_send_ioctl(fm, &args);
 	if (!err) {
 		if (outarg.result < 0)
 			err = outarg.result;


