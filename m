Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3AAAF171D56
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 15:20:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389685AbgB0OTy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 09:19:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:59226 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389902AbgB0OSg (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 09:18:36 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6A32624690;
        Thu, 27 Feb 2020 14:18:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582813115;
        bh=wrQyzlkTVJsIuG6RhczZKrYJFH7Mb49YCuVssq9BS0U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fe707PaRnl3v++ukWOq3Sgesdhh2JG72cTpk6IjFglXBeHspG1SANx8mz3fmTzigQ
         HRwQ65snBPc0wLOUQ0zZfm+/RVykIXbEhptg9HhfFSUyYlt1HBxshgR1Fn6DSfVTXh
         E9K5e4n4HEhrzzdn2WMxptnTDNYkc7ZpnZrDJJZc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nikolay Borisov <nborisov@suse.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Qu Wenruo <wqu@suse.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.5 106/150] btrfs: reset fs_root to NULL on error in open_ctree
Date:   Thu, 27 Feb 2020 14:37:23 +0100
Message-Id: <20200227132248.442137596@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200227132232.815448360@linuxfoundation.org>
References: <20200227132232.815448360@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josef Bacik <josef@toxicpanda.com>

commit 315bf8ef914f31d51d084af950703aa1e09a728c upstream.

While running my error injection script I hit a panic when we tried to
clean up the fs_root when freeing the fs_root.  This is because
fs_info->fs_root == PTR_ERR(-EIO), which isn't great.  Fix this by
setting fs_info->fs_root = NULL; if we fail to read the root.

CC: stable@vger.kernel.org # 4.4+
Reviewed-by: Nikolay Borisov <nborisov@suse.com>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/disk-io.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3200,6 +3200,7 @@ int __cold open_ctree(struct super_block
 	if (IS_ERR(fs_info->fs_root)) {
 		err = PTR_ERR(fs_info->fs_root);
 		btrfs_warn(fs_info, "failed to read fs tree: %d", err);
+		fs_info->fs_root = NULL;
 		goto fail_qgroup;
 	}
 


