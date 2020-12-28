Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11E592E67B3
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 17:28:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730787AbgL1NH1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:07:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:35040 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730776AbgL1NHZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:07:25 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3492B208D5;
        Mon, 28 Dec 2020 13:06:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609160804;
        bh=/i6sFlmN61X0wPI49xuMfIOqhc5hoE42yAtMu2XvkTg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AE5+uLLcewRIwpNqoLDYW+ErTd8WMEdN64+tIHc0xICo1yZgSFdfJ+HOkjttJfcxT
         3sVw/aVjwbApjS+v6xbfB9xWRs2jVJB3yf3o6ofryy4VQF/ErsyiPOxCTTLvxKVZDq
         GYhPR9iiYnEiozNzhmJU5MkNoZAAgXC9ls4Y8/ic=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nikolay Borisov <nborisov@suse.com>,
        "Pavel Machek (CIP)" <pavel@denx.de>,
        David Sterba <dsterba@suse.com>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: [PATCH 4.9 154/175] btrfs: fix return value mixup in btrfs_get_extent
Date:   Mon, 28 Dec 2020 13:50:07 +0100
Message-Id: <20201228124900.718807653@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124853.216621466@linuxfoundation.org>
References: <20201228124853.216621466@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Machek <pavel@denx.de>

commit 881a3a11c2b858fe9b69ef79ac5ee9978a266dc9 upstream

btrfs_get_extent() sets variable ret, but out: error path expect error
to be in variable err so the error code is lost.

Fixes: 6bf9e4bd6a27 ("btrfs: inode: Verify inode mode to avoid NULL pointer dereference")
CC: stable@vger.kernel.org # 5.4+
Reviewed-by: Nikolay Borisov <nborisov@suse.com>
Signed-off-by: Pavel Machek (CIP) <pavel@denx.de>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
[sudip: adjust context]
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -7000,7 +7000,7 @@ again:
 	    found_type == BTRFS_FILE_EXTENT_PREALLOC) {
 		/* Only regular file could have regular/prealloc extent */
 		if (!S_ISREG(inode->i_mode)) {
-			ret = -EUCLEAN;
+			err = -EUCLEAN;
 			btrfs_crit(root->fs_info,
 		"regular/prealloc extent found for non-regular inode %llu",
 				   btrfs_ino(inode));


