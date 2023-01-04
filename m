Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E797F65D6DC
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 16:07:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233514AbjADPHK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 10:07:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239500AbjADPHF (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 10:07:05 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB34BEE30
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 07:07:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 53B6DB81339
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 15:07:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8329BC433F0;
        Wed,  4 Jan 2023 15:07:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672844822;
        bh=gW3mdZKUaRV2rcB+jC71tsaLyg3T/pwti9h8fLOyMCc=;
        h=Subject:To:Cc:From:Date:From;
        b=QQwcW7DSn3t+g4vMDq1gL0EKBWkg2tQ55XpyyCW2PQYP3ODX6frPOvK0sDJ/xwGr5
         PV1EacVsB2zZ+7C1QBYw5Y1HILTzEJRxtQIWA9jwPOcqeG2UjhAc2g9zZZhVbxIDNW
         69Kn9p7N4wMqqSBiKlQ7g+TEt31D14XvyKQZLbHs=
Subject: FAILED: patch "[PATCH] ext4: dont return EINVAL from GETFSUUID when reporting UUID" failed to apply to 4.9-stable tree
To:     djwong@kernel.org, catherine.hoang@oracle.com, tytso@mit.edu
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 04 Jan 2023 16:06:49 +0100
Message-ID: <1672844809117130@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

b76abb515746 ("ext4: dont return EINVAL from GETFSUUID when reporting UUID length")
d95efb14c0b8 ("ext4: add ioctls to get/set the ext4 superblock uuid")
bbc605cdb1e1 ("ext4: implement support for get/set fs label")
351a0a3fbc35 ("ext4: add ioctl EXT4_IOC_CHECKPOINT")
4db5c2e6236f ("ext4: convert to fileattr")
7d6beb71da3c ("Merge tag 'idmapped-mounts-v5.12' of git://git.kernel.org/pub/scm/linux/kernel/git/brauner/linux")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From b76abb5157468756163fe7e3431c9fe32cba57ca Mon Sep 17 00:00:00 2001
From: "Darrick J. Wong" <djwong@kernel.org>
Date: Thu, 10 Nov 2022 12:16:29 -0800
Subject: [PATCH] ext4: dont return EINVAL from GETFSUUID when reporting UUID
 length

If userspace calls this ioctl with fsu_length (the length of the
fsuuid.fsu_uuid array) set to zero, ext4 copies the desired uuid length
out to userspace.  The kernel call returned a result from a valid input,
so the return value here should be zero, not EINVAL.

While we're at it, fix the copy_to_user call to make it clear that we're
only copying out fsu_len.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Catherine Hoang <catherine.hoang@oracle.com>
Link: https://lore.kernel.org/r/166811138914.327006.9241306894437166566.stgit@magnolia
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: stable@kernel.org

diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index e5f60057db5b..beedaebab21c 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -1154,9 +1154,10 @@ static int ext4_ioctl_getuuid(struct ext4_sb_info *sbi,
 
 	if (fsuuid.fsu_len == 0) {
 		fsuuid.fsu_len = UUID_SIZE;
-		if (copy_to_user(ufsuuid, &fsuuid, sizeof(fsuuid.fsu_len)))
+		if (copy_to_user(&ufsuuid->fsu_len, &fsuuid.fsu_len,
+					sizeof(fsuuid.fsu_len)))
 			return -EFAULT;
-		return -EINVAL;
+		return 0;
 	}
 
 	if (fsuuid.fsu_len != UUID_SIZE || fsuuid.fsu_flags != 0)

