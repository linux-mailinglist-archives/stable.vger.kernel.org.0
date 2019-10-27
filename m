Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D079E6478
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 18:23:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727671AbfJ0RXB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 13:23:01 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:48301 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727667AbfJ0RXB (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 27 Oct 2019 13:23:01 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 35D4722199;
        Sun, 27 Oct 2019 13:23:00 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Sun, 27 Oct 2019 13:23:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=7nVR6A
        Yw0viNfkDXSKnY6kxG9dbFldaZW6z5EJ/8dQk=; b=wHhfy7ScPzYojbRLGUNHcD
        ZYxHqd7WMewYHDt8CmSGWKJAHwdcQt5S9bmR53M8qgnwvprvtZQKBkIxVamVERLa
        BYsdWYhQQYVMQwyIDA3AWGOVOkqMOoB48l0aiBUZICpONswhu+MHkL5n3X1HoZfv
        QvqnglP8aWIlIj89xsRUYmrC9MsH3LFW9Pm1O1qT8BTAZehiwfd90uOsv4d+9WY2
        pcu0inExAtly53D6otf5NuLU06ybV2/bG9N0mpo/jAAuPTiL8oFZhevsAAMQPdBQ
        I77Uja/7FS+NzHhvDWfgvvUQmgmD4dpLl7iF7TSHrTZVTCWM9/A0i5AEanMxeYTg
        ==
X-ME-Sender: <xms:dNK1XTI1r3dxg61OvQAjwQl9QGTUuuRrDpYS2cVHNW-shgtEXOOwTA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrleejgddutdehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeejjedrudehkedrhedtrddutddtnecurfgrrhgrmhepmhgrihhlfhhroh
    hmpehgrhgvgheskhhrohgrhhdrtghomhenucevlhhushhtvghrufhiiigvpeef
X-ME-Proxy: <xmx:dNK1XafWVRoXXvOmNKB6DeHCmF-b_E6WPyIdofTLlFXWxr_MEYOUlw>
    <xmx:dNK1XXhd7P-lqSc104AR_urLkhna8H-wj3yrrniUjozA6Qny57v1Kg>
    <xmx:dNK1XflFdZxLM0sVy1kmo0PTDE_ceSJ00esPDCDQX4GS0R1tE4K24Q>
    <xmx:dNK1XbL1LJS4qDtprxaREhWhEF-DsnxIICz76hIoNSjJreKvMrc1RA>
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        by mail.messagingengine.com (Postfix) with ESMTPA id B6A1380059;
        Sun, 27 Oct 2019 13:22:59 -0400 (EDT)
Subject: FAILED: patch "[PATCH] btrfs: tracepoints: Fix wrong parameter order for qgroup" failed to apply to 4.19-stable tree
To:     wqu@suse.com, dsterba@suse.com, nborisov@suse.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 27 Oct 2019 16:48:16 +0100
Message-ID: <157219129664247@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From fd2b007eaec898564e269d1f478a2da0380ecf51 Mon Sep 17 00:00:00 2001
From: Qu Wenruo <wqu@suse.com>
Date: Thu, 17 Oct 2019 10:38:36 +0800
Subject: [PATCH] btrfs: tracepoints: Fix wrong parameter order for qgroup
 events

[BUG]
For btrfs:qgroup_meta_reserve event, the trace event can output garbage:

  qgroup_meta_reserve: 9c7f6acc-b342-4037-bc47-7f6e4d2232d7: refroot=5(FS_TREE) type=DATA diff=2

The diff should always be alinged to sector size (4k), so there is
definitely something wrong.

[CAUSE]
For the wrong @diff, it's caused by wrong parameter order.
The correct parameters are:

  struct btrfs_root, s64 diff, int type.

However the parameters used are:

  struct btrfs_root, int type, s64 diff.

Fixes: 4ee0d8832c2e ("btrfs: qgroup: Update trace events for metadata reservation")
CC: stable@vger.kernel.org # 4.19+
Reviewed-by: Nikolay Borisov <nborisov@suse.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index c4bb69941c77..3ad151655eb8 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -3629,7 +3629,7 @@ int __btrfs_qgroup_reserve_meta(struct btrfs_root *root, int num_bytes,
 		return 0;
 
 	BUG_ON(num_bytes != round_down(num_bytes, fs_info->nodesize));
-	trace_qgroup_meta_reserve(root, type, (s64)num_bytes);
+	trace_qgroup_meta_reserve(root, (s64)num_bytes, type);
 	ret = qgroup_reserve(root, num_bytes, enforce, type);
 	if (ret < 0)
 		return ret;
@@ -3676,7 +3676,7 @@ void __btrfs_qgroup_free_meta(struct btrfs_root *root, int num_bytes,
 	 */
 	num_bytes = sub_root_meta_rsv(root, num_bytes, type);
 	BUG_ON(num_bytes != round_down(num_bytes, fs_info->nodesize));
-	trace_qgroup_meta_reserve(root, type, -(s64)num_bytes);
+	trace_qgroup_meta_reserve(root, -(s64)num_bytes, type);
 	btrfs_qgroup_free_refroot(fs_info, root->root_key.objectid,
 				  num_bytes, type);
 }

