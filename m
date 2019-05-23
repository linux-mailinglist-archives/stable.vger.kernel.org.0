Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DEEA5286AC
	for <lists+stable@lfdr.de>; Thu, 23 May 2019 21:15:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388216AbfEWTLl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 May 2019 15:11:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:45036 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387552AbfEWTLh (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 May 2019 15:11:37 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5CEB7217F9;
        Thu, 23 May 2019 19:11:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558638696;
        bh=7/LfuKugaEIw8/6/NwDjKjfYoXPuvCZiob7fBgaTIWQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e/x1vDMZMosjIjcGkiR38NbAEn+xyJZyljGEdIRVaC5B8jVJma0YSioZ7HJ7iYGB6
         U95gshgy0j5LU/da2qaalt9KmWMDkrJaee1baP5NsESqc9Df6M5UJn4y+svnRkO+9w
         PTBBHr0tvCJStU4L8SdJfhxQCxTfwZ+yPx1hvhe0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jeff Layton <jlayton@kernel.org>,
        "Yan, Zheng" <zyan@redhat.com>, Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 4.14 31/77] ceph: flush dirty inodes before proceeding with remount
Date:   Thu, 23 May 2019 21:05:49 +0200
Message-Id: <20190523181724.506434015@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190523181719.982121681@linuxfoundation.org>
References: <20190523181719.982121681@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jeff Layton <jlayton@kernel.org>

commit 00abf69dd24f4444d185982379c5cc3bb7b6d1fc upstream.

xfstest generic/452 was triggering a "Busy inodes after umount" warning.
ceph was allowing the mount to go read-only without first flushing out
dirty inodes in the cache. Ensure we sync out the filesystem before
allowing a remount to proceed.

Cc: stable@vger.kernel.org
Link: http://tracker.ceph.com/issues/39571
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Reviewed-by: "Yan, Zheng" <zyan@redhat.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ceph/super.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/fs/ceph/super.c
+++ b/fs/ceph/super.c
@@ -768,6 +768,12 @@ static void ceph_umount_begin(struct sup
 	return;
 }
 
+static int ceph_remount(struct super_block *sb, int *flags, char *data)
+{
+	sync_filesystem(sb);
+	return 0;
+}
+
 static const struct super_operations ceph_super_ops = {
 	.alloc_inode	= ceph_alloc_inode,
 	.destroy_inode	= ceph_destroy_inode,
@@ -775,6 +781,7 @@ static const struct super_operations cep
 	.drop_inode	= ceph_drop_inode,
 	.sync_fs        = ceph_sync_fs,
 	.put_super	= ceph_put_super,
+	.remount_fs	= ceph_remount,
 	.show_options   = ceph_show_options,
 	.statfs		= ceph_statfs,
 	.umount_begin   = ceph_umount_begin,


