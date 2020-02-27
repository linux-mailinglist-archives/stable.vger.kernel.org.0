Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B06931713ED
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 10:17:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728643AbgB0JRb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 04:17:31 -0500
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:53843 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728555AbgB0JRb (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Feb 2020 04:17:31 -0500
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id 68C01766;
        Thu, 27 Feb 2020 04:17:30 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Thu, 27 Feb 2020 04:17:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=Ayb/wz
        nmOX6RgOrlaD+a8wsUcyIN9tNSDFqbZDf7Olg=; b=JeKqtmexApBaei6fg0mWGA
        4nAltcsOyt4ze8l5lVfJu2boAw2pH7+TkLz2jiUWD2YhWrh8jioW6vu+d+C1myCb
        sG/WtNpLak96ieBP8LobAXf4LtReVe++yL8DkMybmGfpPRKjx2xWTFa+Pvoh5+AY
        uH9ZKpf94/1pqjF1N+P/r98Qb/l2MgtZQvEJCD+VfcG7mhDGUT4IqQrawvmQOc6M
        45RulYz5FXKedPI+7Xd+7wCtE2/DDv790K8wfJlBHBWSGgOJLlSvJtK4RzgStsPw
        OJViq6Oa7VZPlxZhyfjjIQ6Gqsv/hrCFYfNDqv9vaptQ2OgKwNklbNnEEi4PxHPg
        ==
X-ME-Sender: <xms:KolXXrOGBhptSc3hC0P0-sSbWIMNnsYE-HpP9AuloTAYYn1x9ToJjg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrleeigddtfecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepkeefrdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgepgeenuc
    frrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:KolXXuvCTTfH-l5_ZXGrk0CXbUYGnoBeA3XpuCzyKV-sLcyNfbY0MQ>
    <xmx:KolXXvsgKlNAaMr9oPcK5WDa8tcpJLYt978GipvzpJ5KacvSpvmlrQ>
    <xmx:KolXXjYV3m8ln2PpzlP2ESjOyx5y07N-Jfq9DcRcou2-VvD8pCrueA>
    <xmx:KolXXsHQQU977IFnOsMRS9mYMEtsxJbDWafMLPkHhkFJfadWoc_QTw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id B038C328005E;
        Thu, 27 Feb 2020 04:17:29 -0500 (EST)
Subject: FAILED: patch "[PATCH] btrfs: reset fs_root to NULL on error in open_ctree" failed to apply to 4.4-stable tree
To:     josef@toxicpanda.com, dsterba@suse.com, johannes.thumshirn@wdc.com,
        nborisov@suse.com, wqu@suse.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 27 Feb 2020 10:17:19 +0100
Message-ID: <158279503941201@kroah.com>
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

From 315bf8ef914f31d51d084af950703aa1e09a728c Mon Sep 17 00:00:00 2001
From: Josef Bacik <josef@toxicpanda.com>
Date: Thu, 13 Feb 2020 10:47:28 -0500
Subject: [PATCH] btrfs: reset fs_root to NULL on error in open_ctree

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

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index d7fec89974cb..197352f23534 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3200,6 +3200,7 @@ int __cold open_ctree(struct super_block *sb,
 	if (IS_ERR(fs_info->fs_root)) {
 		err = PTR_ERR(fs_info->fs_root);
 		btrfs_warn(fs_info, "failed to read fs tree: %d", err);
+		fs_info->fs_root = NULL;
 		goto fail_qgroup;
 	}
 

