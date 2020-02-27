Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 566301713EE
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 10:17:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728646AbgB0JRk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 04:17:40 -0500
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:43037 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728555AbgB0JRk (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Feb 2020 04:17:40 -0500
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id 12F0A5B8;
        Thu, 27 Feb 2020 04:17:39 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Thu, 27 Feb 2020 04:17:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=jszSg2
        45V5rZDhckndGDN05i5oGWr45t3r5Q6cqbQMg=; b=OvU2l8M6vPomDulZukvtyP
        i7TRSGA//IiAc71zPFNQd1co2cG+1PCywsR5qbYa/XQtk1vBr2FwA/GQQfW3saeV
        GVuY8OBUNxoHwlpgH27zWH77aLTgXGPOuF/rKx3iazruZCjYOGoXUOx97Fqz+qUY
        aHYluJj1uWycPQYCdy4HvswMAxvqUlQCWH8H/epKAflgs28RIYWVaBgIr1juahm/
        PIX0WImM4Aw/YMq7TRFs6D2RBJ+vRnbfcoFng+2sxsji+wLKsAU1tf8pJzh7n5Yv
        5ABogu1xiUM5p2hnrqMeT9ROCCKlFQRXgZS7ax0WOng3JeX/OYPa9RfN6jYRWGoA
        ==
X-ME-Sender: <xms:MolXXn-x1_MZt9w2ZifoERtS_AyUkNmp0GmlsmQq9h_ciHyC_p4NFQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrleeigddtfecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepkeefrdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgepheenuc
    frrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:MolXXox7ZEx3Gb-hqkh-pn3ZmqT_IlUKHoouZomLoQqNq9ZH76mn2w>
    <xmx:MolXXiCo_gUlJajshh-tlwbSKesJzhXhg-pNxjYlGH-cZK0HMjzWlA>
    <xmx:MolXXhL3KIsjgVn6_8wbNIbe0bn4vdmBuqSmtPpiQBYIRiwEf5EMVg>
    <xmx:MolXXkfG90Kg6x1A26RLg41t2jVwHRJP05fdDSgfuSLW7IZlD5PrQg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 510373060BD1;
        Thu, 27 Feb 2020 04:17:38 -0500 (EST)
Subject: FAILED: patch "[PATCH] btrfs: do not check delayed items are empty for single" failed to apply to 4.9-stable tree
To:     josef@toxicpanda.com, dsterba@suse.com, johannes.thumshirn@wdc.com,
        nborisov@suse.com, wqu@suse.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 27 Feb 2020 10:17:37 +0100
Message-ID: <1582795057233137@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
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

