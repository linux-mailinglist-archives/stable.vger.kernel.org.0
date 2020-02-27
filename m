Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D0D4C1713EA
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 10:17:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728621AbgB0JRV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 04:17:21 -0500
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:42739 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728555AbgB0JRV (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Feb 2020 04:17:21 -0500
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id 1E611777;
        Thu, 27 Feb 2020 04:17:20 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Thu, 27 Feb 2020 04:17:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=ZJH8cL
        QDoFmmkSDgUyQJalSLoME6QylO3BGn1727y2E=; b=HRW4quEw4ywlic/kn5f1E9
        VS+ztZkobEjYEeopoTvG9J7Re85k6fgKFVBjNrg1MuR3aXB2VtUenjP0/tvIFrLF
        ZgLicKRIjm7t2WMra1F6BgHeDEy+u/aFM8xM3+YB7tYIt6v6rxyAcMLMVnwwe36s
        oK6xFTMNIGZQpu7ebMzd4T4F2/KMRbdwCaYq8e7ZBoLxlClpcjlK5tp9RkLfgoVI
        xTWfr3ycCDUmbHLW317e9FjDpkjrbBkdmrSYe1yjisuZDjtHIqf2wyy/uwQJt7+E
        2CiIFa+2P/tOe80/626qrfpBj+nVcAz6UlEdRWWRR82U4NhNj9If0UbvN3NKGNDQ
        ==
X-ME-Sender: <xms:H4lXXsTMnRSDkZaCfm5W8D0LOuqf6CRGfhoHFHNs7IUtWB69GyRUsQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrleeigddtfecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepkeefrdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgepvdenuc
    frrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:H4lXXopuSE1iiXFiA2qXxuoI3O2Kjbq-UIx7V8vRGuDH4nOIsxjgzw>
    <xmx:H4lXXqOY1XMRJsvYCi2x7q6jUv1ixLkNBWtlbGdVHTEOhou3NqBkVQ>
    <xmx:H4lXXlB4nXRNMlj6U8RN1KCYBB0UdGufiEcJhVIKMjejeCWl7J0Afg>
    <xmx:H4lXXm0X2ydGRudWhiAipBm3GOCxUOynqqEsz-HcjO3u4M8SHUAtjA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 468CF30610E9;
        Thu, 27 Feb 2020 04:17:19 -0500 (EST)
Subject: FAILED: patch "[PATCH] btrfs: reset fs_root to NULL on error in open_ctree" failed to apply to 4.14-stable tree
To:     josef@toxicpanda.com, dsterba@suse.com, johannes.thumshirn@wdc.com,
        nborisov@suse.com, wqu@suse.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 27 Feb 2020 10:17:18 +0100
Message-ID: <1582795038129111@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
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
 

