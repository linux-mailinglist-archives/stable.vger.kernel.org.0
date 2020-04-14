Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5F901A7F91
	for <lists+stable@lfdr.de>; Tue, 14 Apr 2020 16:22:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389892AbgDNOWC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Apr 2020 10:22:02 -0400
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:50943 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389893AbgDNOV5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Apr 2020 10:21:57 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id 20C35A8D;
        Tue, 14 Apr 2020 10:21:56 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Tue, 14 Apr 2020 10:21:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=ZBdR+j
        iYPHesqld0AahIOw3aUaL6KfAtadlZAiNbgus=; b=mQHjTvwk08UAakdS7bQvmr
        gngIsH96SKiq9it7TEYRPO/A0xUWC2WHu1ND9GIKOLDOs4MbQTD+NhSeBULb6B5U
        959S4885SW5frpQay5ls6JqmGxIg5WUiKZ73t3GJzCOuiolezMM9m/GEUCKn3YmG
        ncBnioVcRzck7RRUmRfJWXvzL5kmm39SMmjfxR4pGUO5sJofradO0JiQHv+mvhlR
        YGVnB2tmHttKKqx/WBN7IpKG/Qch/TV70rXlcWZ7v1O6Pm/lakxP3szcPBDyzuER
        DHJuYchH5cn7nC3JC5dEconswNlJha/JeGHoHF12pJSz8ANTsm9ci8MhAk2kDMRQ
        ==
X-ME-Sender: <xms:A8eVXoK-6IvynnM6fEt816LA5uHntc9PQ7Ta4-QeonQemdTH58BPYA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrfedugdejgecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepkeefrdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgepudenuc
    frrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:A8eVXieQx5vQd3mCLy4etSk56X-CktcRO5dL0DhthUWyk0dJ8tFzHw>
    <xmx:A8eVXgNbApgrrWxpuwmcU3LaIZhKE7Uxq00IEwQ0LbebuHtVsRP7jQ>
    <xmx:A8eVXkKnOSsO6KvMwlg3gpZ-6rJQadPbD5FcixbklMhhxig3rtPQNA>
    <xmx:A8eVXjZMoq6P-PKrlll5VkxNTIRHFXyJ8LSCWmzG1EyfCsmlZ7CyZw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 61F5B3280069;
        Tue, 14 Apr 2020 10:21:55 -0400 (EDT)
Subject: FAILED: patch "[PATCH] btrfs: handle logged extent failure properly" failed to apply to 5.6-stable tree
To:     josef@toxicpanda.com, dsterba@suse.com, johannes.thumshirn@wdc.com,
        nborisov@suse.com, wqu@suse.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 14 Apr 2020 16:21:45 +0200
Message-ID: <158687410512288@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.6-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From ab9b2c7b32e6be53cac2e23f5b2db66815a7d972 Mon Sep 17 00:00:00 2001
From: Josef Bacik <josef@toxicpanda.com>
Date: Thu, 13 Feb 2020 10:47:30 -0500
Subject: [PATCH] btrfs: handle logged extent failure properly

If we're allocating a logged extent we attempt to insert an extent
record for the file extent directly.  We increase
space_info->bytes_reserved, because the extent entry addition will call
btrfs_update_block_group(), which will convert the ->bytes_reserved to
->bytes_used.  However if we fail at any point while inserting the
extent entry we will bail and leave space on ->bytes_reserved, which
will trigger a WARN_ON() on umount.  Fix this by pinning the space if we
fail to insert, which is what happens in every other failure case that
involves adding the extent entry.

CC: stable@vger.kernel.org # 5.4+
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: Nikolay Borisov <nborisov@suse.com>
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 136fffb76428..7eef91d6c2b6 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4422,7 +4422,7 @@ int btrfs_alloc_logged_file_extent(struct btrfs_trans_handle *trans,
 	ret = alloc_reserved_file_extent(trans, 0, root_objectid, 0, owner,
 					 offset, ins, 1);
 	if (ret)
-		btrfs_pin_extent(fs_info, ins->objectid, ins->offset, 1);
+		btrfs_pin_extent(trans, ins->objectid, ins->offset, 1);
 	btrfs_put_block_group(block_group);
 	return ret;
 }

