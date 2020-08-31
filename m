Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 484652576AF
	for <lists+stable@lfdr.de>; Mon, 31 Aug 2020 11:39:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725972AbgHaJjY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Aug 2020 05:39:24 -0400
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:43321 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725915AbgHaJjW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Aug 2020 05:39:22 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id 29496734;
        Mon, 31 Aug 2020 05:39:21 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Mon, 31 Aug 2020 05:39:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=OqQsn1
        dsRoIYfgVnCRCB2pvK53zClttkoMBfW6LMbvY=; b=IscmiefDVTKGBID8VoQR2x
        w+fw2aHgKwugqofvYFISZBSQW0wJV1L9B59xZ1xGrtp5iLqd1FbnP6bmGcFDYo6s
        vaEpyM8t+IbixSzW+h01XoI9xOBOPexH19sTLpupQkTZL1WMsNM0eHiO9yGXS/Ub
        lTz5GXi87AcdkjRNw4JB+1DxpOH5iuHjyF1NfcDYxssnd0CXz1qF1NrfZ8Ta7GL4
        A+MpRZsr6Af6375TXUcUm5hlS5Cv5Dfl5860wsGO8aTmwRKIIgcvU9UGItCfIOWa
        9UZVeXwzhR4YiUJ8Lvaib+RfZZw76HCRZ7RsbCTkFQ+aRPwDrwBcL651NQnsAg+g
        ==
X-ME-Sender: <xms:SMVMX1eZEJPjRygxmTrqWX2P8Hmcz1jilix_h8bl_qf499Uo-3nefA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrudefhedgudeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:SMVMXzOQ_53I-T4YnOOS4-4MVWei4bgwx-ijTvHqRfhxEmX8hcuz1w>
    <xmx:SMVMX-iPwgG6iET-hOeXNwJGvCy8ZyHy5fJYG1VzyVM7hrfPX42cqQ>
    <xmx:SMVMX-8h5atVFh5m-T2fI9t9Oqjoi2XIb5IikSH-Yv-irlOJ56loQA>
    <xmx:SMVMX252pAztlSNMG-UVClIjgBa7JSyj5UC326tNj-xGbirFdrQKcSJKHp4>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 2CAA43280065;
        Mon, 31 Aug 2020 05:39:20 -0400 (EDT)
Subject: FAILED: patch "[PATCH] btrfs: reset compression level for lzo on remount" failed to apply to 4.4-stable tree
To:     mpdesouza@suse.com, dsterba@suse.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 31 Aug 2020 11:39:29 +0200
Message-ID: <15988667697225@kroah.com>
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

From 282dd7d7718444679b046b769d872b188818ca35 Mon Sep 17 00:00:00 2001
From: Marcos Paulo de Souza <mpdesouza@suse.com>
Date: Mon, 3 Aug 2020 16:55:01 -0300
Subject: [PATCH] btrfs: reset compression level for lzo on remount

Currently a user can set mount "-o compress" which will set the
compression algorithm to zlib, and use the default compress level for
zlib (3):

  relatime,compress=zlib:3,space_cache

If the user remounts the fs using "-o compress=lzo", then the old
compress_level is used:

  relatime,compress=lzo:3,space_cache

But lzo does not expose any tunable compression level. The same happens
if we set any compress argument with different level, also with zstd.

Fix this by resetting the compress_level when compress=lzo is
specified.  With the fix applied, lzo is shown without compress level:

  relatime,compress=lzo,space_cache

CC: stable@vger.kernel.org # 4.4+
Signed-off-by: Marcos Paulo de Souza <mpdesouza@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index e529ddb35b87..25967ecaaf0a 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -625,6 +625,7 @@ int btrfs_parse_options(struct btrfs_fs_info *info, char *options,
 			} else if (strncmp(args[0].from, "lzo", 3) == 0) {
 				compress_type = "lzo";
 				info->compress_type = BTRFS_COMPRESS_LZO;
+				info->compress_level = 0;
 				btrfs_set_opt(info->mount_opt, COMPRESS);
 				btrfs_clear_opt(info->mount_opt, NODATACOW);
 				btrfs_clear_opt(info->mount_opt, NODATASUM);

