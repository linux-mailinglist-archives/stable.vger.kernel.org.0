Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68BBB6AC1C4
	for <lists+stable@lfdr.de>; Mon,  6 Mar 2023 14:48:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229568AbjCFNso (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Mar 2023 08:48:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229528AbjCFNso (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Mar 2023 08:48:44 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB02224138
        for <stable@vger.kernel.org>; Mon,  6 Mar 2023 05:48:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 13B93B80E53
        for <stable@vger.kernel.org>; Mon,  6 Mar 2023 13:48:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A0FBC433EF;
        Mon,  6 Mar 2023 13:48:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678110496;
        bh=sGLxr7lGKQgTTu/DZZnFXhAo2PlDpXXWI3DVHgoFLBE=;
        h=Subject:To:Cc:From:Date:From;
        b=nMrqGa4ThF4UlmrXCIraftDTqP1BvJoBlnGzysdVSq4OQL968f5y2WhkKVpvharMs
         Ulfx7Y06QzXWOisaigcOxJut9S+m5W2SEB1KowWRHYQ9GM7weCHXJPZRQBBklskKlY
         EgUbbqOl+wlN42WQI8BIjLQCo2WTMU6/cvEiZjf8=
Subject: FAILED: patch "[PATCH] udf: Detect system inodes linked into directory hierarchy" failed to apply to 4.19-stable tree
To:     jack@suse.cz
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 06 Mar 2023 14:44:22 +0100
Message-ID: <1678110262133121@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

To reproduce the conflict and resubmit, you may use the following commands:

git fetch https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/ linux-4.19.y
git checkout FETCH_HEAD
git cherry-pick -x 85a37983ec69cc9fcd188bc37c4de15ee326355a
# <resolve conflicts, build, test, etc.>
git commit -s
git send-email --to '<stable@vger.kernel.org>' --in-reply-to '1678110262133121@kroah.com' --subject-prefix 'PATCH 4.19.y' HEAD^..

Possible dependencies:

85a37983ec69 ("udf: Detect system inodes linked into directory hierarchy")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 85a37983ec69cc9fcd188bc37c4de15ee326355a Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Tue, 3 Jan 2023 10:03:35 +0100
Subject: [PATCH] udf: Detect system inodes linked into directory hierarchy

When UDF filesystem is corrupted, hidden system inodes can be linked
into directory hierarchy which is an avenue for further serious
corruption of the filesystem and kernel confusion as noticed by syzbot
fuzzed images. Refuse to access system inodes linked into directory
hierarchy and vice versa.

CC: stable@vger.kernel.org
Reported-by: syzbot+38695a20b8addcbc1084@syzkaller.appspotmail.com
Signed-off-by: Jan Kara <jack@suse.cz>

diff --git a/fs/udf/inode.c b/fs/udf/inode.c
index 9ee269d3d546..96873fa2f683 100644
--- a/fs/udf/inode.c
+++ b/fs/udf/inode.c
@@ -1813,8 +1813,13 @@ struct inode *__udf_iget(struct super_block *sb, struct kernel_lb_addr *ino,
 	if (!inode)
 		return ERR_PTR(-ENOMEM);
 
-	if (!(inode->i_state & I_NEW))
+	if (!(inode->i_state & I_NEW)) {
+		if (UDF_I(inode)->i_hidden != hidden_inode) {
+			iput(inode);
+			return ERR_PTR(-EFSCORRUPTED);
+		}
 		return inode;
+	}
 
 	memcpy(&UDF_I(inode)->i_location, ino, sizeof(struct kernel_lb_addr));
 	err = udf_read_inode(inode, hidden_inode);

