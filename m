Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 64B4B171C47
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 15:10:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388040AbgB0OKp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 09:10:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:48928 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388577AbgB0OKn (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 09:10:43 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A3C4C20578;
        Thu, 27 Feb 2020 14:10:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582812643;
        bh=S8kkFcnazwWVF8uP0OHba4L9Z36wgeNNzJnd4ccx7ew=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qVWn9CSs9JVe9t59ixbnWEUnMk3c1Z6fippAOqgLpEEsgYdbSqYOl+cdtcQ3nJqNR
         LBoJFl7xdpme2N3x5Kqx3uNBNFi/8B8Mlbrf3BmtLNEYGvt9w7ZBJkB+vidS8XZTMj
         gEDUrL8OriR7i2uKQLYQ+EsvYIotW6/EcWQIjgjE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Nikolay Borisov <nborisov@suse.com>, Qu Wenruo <wqu@suse.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.4 095/135] btrfs: do not check delayed items are empty for single transaction cleanup
Date:   Thu, 27 Feb 2020 14:37:15 +0100
Message-Id: <20200227132243.527366487@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200227132228.710492098@linuxfoundation.org>
References: <20200227132228.710492098@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josef Bacik <josef@toxicpanda.com>

commit 1e90315149f3fe148e114a5de86f0196d1c21fa5 upstream.

btrfs_assert_delayed_root_empty() will check if the delayed root is
completely empty, but this is a filesystem-wide check.  On cleanup we
may have allowed other transactions to begin, for whatever reason, and
thus the delayed root is not empty.

So remove this check from cleanup_one_transation().  This however can
stay in btrfs_cleanup_transaction(), because it checks only after all of
the transactions have been properly cleaned up, and thus is valid.

CC: stable@vger.kernel.org # 4.4+
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: Nikolay Borisov <nborisov@suse.com>
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/disk-io.c |    1 -
 1 file changed, 1 deletion(-)

--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -4520,7 +4520,6 @@ void btrfs_cleanup_one_transaction(struc
 	wake_up(&fs_info->transaction_wait);
 
 	btrfs_destroy_delayed_inodes(fs_info);
-	btrfs_assert_delayed_root_empty(fs_info);
 
 	btrfs_destroy_marked_extents(fs_info, &cur_trans->dirty_pages,
 				     EXTENT_DIRTY);


