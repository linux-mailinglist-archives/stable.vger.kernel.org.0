Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D006A2F6EE
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 07:01:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727623AbfE3FAV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 01:00:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:44432 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727615AbfE3DJc (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:09:32 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 19FA824481;
        Thu, 30 May 2019 03:09:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559185772;
        bh=aNQ7m6pVjPpcwkmbpDyRhE8MoPoAKBxGV94to5iTdfE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xFFzJIJZkRiUwwn0ctTXA0Hmp+ryb6WPHmtqwtO0tjfiP4txTFOBlKxgu8uuF3O/p
         /GpgZzg8J9y8HwvYQqnuuDJ+9VvboJLsfInKi4AWW4++etG+w0fbzpo77Isev/xYUq
         KI5GbbY+aAwUUoLVm+1apAnuEXqVaMp4oXMHQve8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johnny Chang <johnnyc@synology.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.1 024/405] btrfs: Check the compression level before getting a workspace
Date:   Wed, 29 May 2019 20:00:22 -0700
Message-Id: <20190530030541.864967520@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030540.291644921@linuxfoundation.org>
References: <20190530030540.291644921@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johnny Chang <johnnyc@synology.com>

commit 2b90883c561ddcc641741c2e4df1f702a4f2acb8 upstream.

When a file's compression property is set as zlib or zstd but leave
the compression mount option not be set, that means btrfs will try
to compress the file with default compression level. But in
btrfs_compress_pages(), it calls get_workspace() with level = 0.
This will return a workspace with a wrong compression level.
For zlib, the compression level in the workspace will be 0
(that means "store only"). And for zstd, the compression in the
workspace will be 1, not the default level 3.

How to reproduce:
  mkfs -t btrfs /dev/sdb
  mount /dev/sdb /mnt/
  mkdir /mnt/zlib
  btrfs property set /mnt/zlib/ compression zlib
  dd if=/dev/zero of=/mnt/zlib/compression-friendly-file-10M bs=1M count=10
  sync
  btrfs-debugfs -f /mnt/zlib/compression-friendly-file-10M

btrfs-debugfs output:
* before:
  ...
  (258 9961472): ram 524288 disk 1106247680 disk_size 524288
  file: ... extents 20 disk size 10485760 logical size 10485760 ratio 1.00

* after:
 ...
 (258 10354688): ram 131072 disk 14217216 disk_size 4096
 file: ... extents 80 disk size 327680 logical size 10485760 ratio 32.00

The steps for zstd are similar, but need to put a debugging message to
show the level of the return workspace in zstd_get_workspace().

This commit adds a check of the compression level before getting a
workspace by set_level().

CC: stable@vger.kernel.org # 5.1+
Signed-off-by: Johnny Chang <johnnyc@synology.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/compression.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -1009,6 +1009,7 @@ int btrfs_compress_pages(unsigned int ty
 	struct list_head *workspace;
 	int ret;
 
+	level = btrfs_compress_op[type]->set_level(level);
 	workspace = get_workspace(type, level);
 	ret = btrfs_compress_op[type]->compress_pages(workspace, mapping,
 						      start, pages,


