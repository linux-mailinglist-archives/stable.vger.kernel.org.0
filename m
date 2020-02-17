Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2DE36161B3E
	for <lists+stable@lfdr.de>; Mon, 17 Feb 2020 20:09:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728529AbgBQTI7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Feb 2020 14:08:59 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:39573 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728448AbgBQTI7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Feb 2020 14:08:59 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 4AAB6210D8;
        Mon, 17 Feb 2020 14:08:58 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Mon, 17 Feb 2020 14:08:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=1zNHyA
        7CkFal77T1+pLius9wdpuaMpOkYEXMiH4Rmfw=; b=p0AaZDve8BOHbSbJLApkgp
        9tMDBARl5gJuy/azSbZT5zRvPJZR9MoIIFPS6lS3cytxV9ySrgHhwOoLHAsxdTSX
        wUUVZlTfcbbxwOENLXExowMn5ur4u5EktFun2qra3AL5LA2sSkIPNO0vABcMs7Fz
        Uk8DdrGxZuDRgi2aWQ2o/QOfHaXXwhbLKnaPhiQwtuoZ0qZNs8uCpdTfCSC7k2Ie
        x/G1m/KR2NyNYJHOJfEgPa8dACPfT16DbAkJgih2JcTxqZqA9qEZGY7jydwFv76t
        FANK9WuYTm+3OEM5JjDilyFmk3rw8GusuonVU6lvR+NDL707sjt2H98wkD6knywA
        ==
X-ME-Sender: <xms:yuRKXtOFYBYmVmnV62hZaR1FBuMZmADN0DBM5hEvznZx9TNw4qwVCQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrjeeigdduvddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekfedrkeeirdekledruddtjeenucevlhhushhtvghrufhiiigvpedune
    curfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:yuRKXsrnumec1I9jc2n6YeJEzXPFB2B0vJewi8F0vt3nzFHpyEUftg>
    <xmx:yuRKXlWCd02p7MMmusT7kBdw48IOxrqQt8fVZIxVUkxK88kMmMY5tg>
    <xmx:yuRKXusJj5kaEb6WoyXDRP80RJE9ORPW4jgAabi2JXK941X9fI5rcg>
    <xmx:yuRKXkgwqe7MdfLHGJpecrax1Wy5hCWXtkNjE0CPbEqJx76xhCY8EQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id BD7953060BE4;
        Mon, 17 Feb 2020 14:08:57 -0500 (EST)
Subject: FAILED: patch "[PATCH] btrfs: print message when tree-log replay starts" failed to apply to 4.9-stable tree
To:     dsterba@suse.com, anand.jain@oracle.com,
        johannes.thumshirn@wdc.com, lists@colorremedies.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 17 Feb 2020 20:08:48 +0100
Message-ID: <1581966528133167@kroah.com>
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

From e8294f2f6aa6208ed0923aa6d70cea3be178309a Mon Sep 17 00:00:00 2001
From: David Sterba <dsterba@suse.com>
Date: Wed, 5 Feb 2020 17:12:16 +0100
Subject: [PATCH] btrfs: print message when tree-log replay starts

There's no logged information about tree-log replay although this is
something that points to previous unclean unmount. Other filesystems
report that as well.

Suggested-by: Chris Murphy <lists@colorremedies.com>
CC: stable@vger.kernel.org # 4.4+
Reviewed-by: Anand Jain <anand.jain@oracle.com>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: David Sterba <dsterba@suse.com>

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 7fa9bb79ad08..89422aa8e9d1 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3164,6 +3164,7 @@ int __cold open_ctree(struct super_block *sb,
 	/* do not make disk changes in broken FS or nologreplay is given */
 	if (btrfs_super_log_root(disk_super) != 0 &&
 	    !btrfs_test_opt(fs_info, NOLOGREPLAY)) {
+		btrfs_info(fs_info, "start tree-log replay");
 		ret = btrfs_replay_log(fs_info, fs_devices);
 		if (ret) {
 			err = ret;

