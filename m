Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 684D31713EF
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 10:17:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728645AbgB0JRu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 04:17:50 -0500
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:41459 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728555AbgB0JRt (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Feb 2020 04:17:49 -0500
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id 92B4D776;
        Thu, 27 Feb 2020 04:17:48 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Thu, 27 Feb 2020 04:17:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=Uz845N
        qT8TBqJXOQVTQi0Fe+5KkKjq39neyQ0ZlObwY=; b=Hmb2xFQFPiVXuFXy/exceV
        4dVLAyn+b97RwmHy+16H/ZKABFN/5pYyZE1RrqSWjU4tvuumBwvnXsKFnmBWZLhi
        +QKoi1/lhs6PdPxu2juuJYFfUA43W0Rvc+Ge3bzWXqFQIFh367jlgVwv2hVzzzBL
        iEzrP+CV0DRx1QTxkeXfb8m0Hmvvbn9tUt5bE14Wn1ryO9ckNJMroaVX6zvI78I9
        UujlG1SbTlFwOk2211RwXCzFUl9iCDw5O6zZWvrNcWIz9ZMCzBl3OPPL6kjwP8Na
        CI6uHEtOy2ZNqvUCOzbSYhM9Y4nG03sw72UseLyGSJA/8KHD6o4crJG4BI1DMepQ
        ==
X-ME-Sender: <xms:PIlXXmEL4Yih7HunYybTIK0exPMnADoNtN15SMcFdQM9o1Gik-kGyQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrleeigddtfecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepkeefrdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgepieenuc
    frrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:PIlXXr7fqyAXuXwQc8Uo8pdKSEgiAKWMz-CQCLxP_4nvE7DlKe_cxg>
    <xmx:PIlXXsDoQdLm4DaQTjTv03GW_dpHxu0A1EiByX5N2A8UcH_WGcFiiw>
    <xmx:PIlXXszJoKVjVrt8fo-Isnq52Z3FFmuKjn3yQ3LFGIlerwq7ffsuQg>
    <xmx:PIlXXmPH7nJFfRKosB1ZcETyHY7J3Y7y7_hv-8ZwDcx-ZEhzQwXt2A>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id E21CC3060D1A;
        Thu, 27 Feb 2020 04:17:47 -0500 (EST)
Subject: FAILED: patch "[PATCH] btrfs: do not check delayed items are empty for single" failed to apply to 4.4-stable tree
To:     josef@toxicpanda.com, dsterba@suse.com, johannes.thumshirn@wdc.com,
        nborisov@suse.com, wqu@suse.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 27 Feb 2020 10:17:37 +0100
Message-ID: <1582795057160246@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 1e90315149f3fe148e114a5de86f0196d1c21fa5 Mon Sep 17 00:00:00 2001
From: Josef Bacik <josef@toxicpanda.com>
Date: Thu, 13 Feb 2020 10:47:29 -0500
Subject: [PATCH] btrfs: do not check delayed items are empty for single
 transaction cleanup

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

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 197352f23534..c6c9a6a8e6c8 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -4503,7 +4503,6 @@ void btrfs_cleanup_one_transaction(struct btrfs_transaction *cur_trans,
 	wake_up(&fs_info->transaction_wait);
 
 	btrfs_destroy_delayed_inodes(fs_info);
-	btrfs_assert_delayed_root_empty(fs_info);
 
 	btrfs_destroy_marked_extents(fs_info, &cur_trans->dirty_pages,
 				     EXTENT_DIRTY);

