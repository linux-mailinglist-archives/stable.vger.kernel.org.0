Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8499D2EC63
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 05:22:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729483AbfE3DU0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 23:20:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:58518 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727760AbfE3DUZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:20:25 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6FF4B2490A;
        Thu, 30 May 2019 03:20:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186424;
        bh=qFkxutTbj0TRkageDbkkvxXWLLYOJQBF3JpcacOw0hY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UKs1QtIpmTTwvdmUOGm9NKrfcRegxg+2mR0sLyRodU9vdFsmFKLVShfQ0Cud4I/o3
         MLgeJ0k1zRR4IjuOexKXb86352IIJg0Gi1JKZh36IyXThlhmCDaSZk5cFQR1LhecGG
         ZPDMUn38D2q8WYfI+DJVfZQQkuhc05yUjDhDPNFs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Tobin C. Harding" <tobin@kernel.org>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 4.9 012/128] btrfs: sysfs: dont leak memory when failing add fsid
Date:   Wed, 29 May 2019 20:05:44 -0700
Message-Id: <20190530030436.622023744@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030432.977908967@linuxfoundation.org>
References: <20190530030432.977908967@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tobin C. Harding <tobin@kernel.org>

commit e32773357d5cc271b1d23550b3ed026eb5c2a468 upstream.

A failed call to kobject_init_and_add() must be followed by a call to
kobject_put().  Currently in the error path when adding fs_devices we
are missing this call.  This could be fixed by calling
btrfs_sysfs_remove_fsid() if btrfs_sysfs_add_fsid() returns an error or
by adding a call to kobject_put() directly in btrfs_sysfs_add_fsid().
Here we choose the second option because it prevents the slightly
unusual error path handling requirements of kobject from leaking out
into btrfs functions.

Add a call to kobject_put() in the error path of kobject_add_and_init().
This causes the release method to be called if kobject_init_and_add()
fails.  open_tree() is the function that calls btrfs_sysfs_add_fsid()
and the error code in this function is already written with the
assumption that the release method is called during the error path of
open_tree() (as seen by the call to btrfs_sysfs_remove_fsid() under the
fail_fsdev_sysfs label).

Cc: stable@vger.kernel.org # v4.4+
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Tobin C. Harding <tobin@kernel.org>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/sysfs.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/fs/btrfs/sysfs.c
+++ b/fs/btrfs/sysfs.c
@@ -751,7 +751,12 @@ int btrfs_sysfs_add_fsid(struct btrfs_fs
 	fs_devs->fsid_kobj.kset = btrfs_kset;
 	error = kobject_init_and_add(&fs_devs->fsid_kobj,
 				&btrfs_ktype, parent, "%pU", fs_devs->fsid);
-	return error;
+	if (error) {
+		kobject_put(&fs_devs->fsid_kobj);
+		return error;
+	}
+
+	return 0;
 }
 
 int btrfs_sysfs_add_mounted(struct btrfs_fs_info *fs_info)


