Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B8FF3A61F2
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 12:51:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234069AbhFNKx3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 06:53:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:59166 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233418AbhFNKva (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 06:51:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3C8D761468;
        Mon, 14 Jun 2021 10:39:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623667143;
        bh=PJCHUOnPsfmfTKawRglE0mNQZYvumCPzUssiOqy18PE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s+Kknzn63FfU2fioysroTZs9Qp/eXsLCfNed2sgEbDnMSwu2OHyx08PZrZm7SryTZ
         6hWEZvu3fV60GMhFIoSaY327cV4rTumEfAgK70ujXthC7wnoLBorPBMJF11aJgwjpU
         gDRRit4TId7Va2a6Piw2iRfOgjhR5CdpheZwu2no=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ritesh Harjani <riteshh@linux.ibm.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.4 43/84] btrfs: return value from btrfs_mark_extent_written() in case of error
Date:   Mon, 14 Jun 2021 12:27:21 +0200
Message-Id: <20210614102647.828704712@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210614102646.341387537@linuxfoundation.org>
References: <20210614102646.341387537@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ritesh Harjani <riteshh@linux.ibm.com>

commit e7b2ec3d3d4ebeb4cff7ae45cf430182fa6a49fb upstream.

We always return 0 even in case of an error in btrfs_mark_extent_written().
Fix it to return proper error value in case of a failure. All callers
handle it.

CC: stable@vger.kernel.org # 4.4+
Signed-off-by: Ritesh Harjani <riteshh@linux.ibm.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/file.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1163,7 +1163,7 @@ int btrfs_mark_extent_written(struct btr
 	int del_nr = 0;
 	int del_slot = 0;
 	int recow;
-	int ret;
+	int ret = 0;
 	u64 ino = btrfs_ino(inode);
 
 	path = btrfs_alloc_path();
@@ -1384,7 +1384,7 @@ again:
 	}
 out:
 	btrfs_free_path(path);
-	return 0;
+	return ret;
 }
 
 /*


