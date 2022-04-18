Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6E18504E46
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 11:14:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237424AbiDRJQm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 05:16:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232095AbiDRJQm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 05:16:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BEBF6444
        for <stable@vger.kernel.org>; Mon, 18 Apr 2022 02:14:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DE29CB80DAE
        for <stable@vger.kernel.org>; Mon, 18 Apr 2022 09:14:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35DEAC385A7;
        Mon, 18 Apr 2022 09:14:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650273241;
        bh=l4Dho8OTCDDmtnPRbARwxM+Q30+qHt4bchfX4Pw3IqI=;
        h=Subject:To:Cc:From:Date:From;
        b=MHq+80YlCeIigkuFAR3BYeDFhJQybt01RRae0IYkB3DD9p0Y4J6zKKCRn1QiAuZ3+
         /S34qTBoLoVV1+StPWJTy6GK6fNGFC9FTkkUzoCNwodjOfnohYvQa2BKlCVMfTCodj
         3ee5Y4Wzr7AbwICFWxhQdeDdFklgf3/lkqB1sLqA=
Subject: FAILED: patch "[PATCH] btrfs: mark resumed async balance as writing" failed to apply to 4.19-stable tree
To:     naohiro.aota@wdc.com, dsterba@suse.com, fdmanana@suse.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 18 Apr 2022 11:13:47 +0200
Message-ID: <1650273227161125@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
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

From a690e5f2db4d1dca742ce734aaff9f3112d63764 Mon Sep 17 00:00:00 2001
From: Naohiro Aota <naohiro.aota@wdc.com>
Date: Tue, 29 Mar 2022 15:55:58 +0900
Subject: [PATCH] btrfs: mark resumed async balance as writing

When btrfs balance is interrupted with umount, the background balance
resumes on the next mount. There is a potential deadlock with FS freezing
here like as described in commit 26559780b953 ("btrfs: zoned: mark
relocation as writing"). Mark the process as sb_writing to avoid it.

Reviewed-by: Filipe Manana <fdmanana@suse.com>
CC: stable@vger.kernel.org # 4.9+
Signed-off-by: Naohiro Aota <naohiro.aota@wdc.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 2cfbc74a3b4e..a8cc736731fd 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -4430,10 +4430,12 @@ static int balance_kthread(void *data)
 	struct btrfs_fs_info *fs_info = data;
 	int ret = 0;
 
+	sb_start_write(fs_info->sb);
 	mutex_lock(&fs_info->balance_mutex);
 	if (fs_info->balance_ctl)
 		ret = btrfs_balance(fs_info, fs_info->balance_ctl, NULL);
 	mutex_unlock(&fs_info->balance_mutex);
+	sb_end_write(fs_info->sb);
 
 	return ret;
 }

