Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60F1865D6D1
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 16:05:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232026AbjADPFp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 10:05:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239246AbjADPFl (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 10:05:41 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 468C6126
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 07:05:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EBC56B8169F
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 15:05:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F616C433EF;
        Wed,  4 Jan 2023 15:05:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672844737;
        bh=fxUFi0dJE1Dzrr6jSfjja7gvYkQOK/r+hcdUDvx+n/0=;
        h=Subject:To:Cc:From:Date:From;
        b=QmhXrZ+jjDgiGHvm+PvcDe6U+ZxwRS5nObEoRlv/ODrWJXVHrHGV5zB9qd+BZHohW
         5gYZpVHLxBygONsMNUpzxhyQzdlD5XXyHBmQw3/vKmMs/qRnJ6lz0W4s7RTMQEWwRG
         4T0r2Da4hN7QwRzlp31Ao0TG7tz54VtDZHOPbhj8=
Subject: FAILED: patch "[PATCH] ext4: don't fail GETFSUUID when the caller provides a long" failed to apply to 5.15-stable tree
To:     djwong@kernel.org, catherine.hoang@oracle.com, tytso@mit.edu
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 04 Jan 2023 16:05:34 +0100
Message-ID: <167284473410228@kroah.com>
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


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

a7e9d977e031 ("ext4: don't fail GETFSUUID when the caller provides a long buffer")
d95efb14c0b8 ("ext4: add ioctls to get/set the ext4 superblock uuid")
bbc605cdb1e1 ("ext4: implement support for get/set fs label")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From a7e9d977e031fceefe1e7cd69ebd7202d5758b56 Mon Sep 17 00:00:00 2001
From: "Darrick J. Wong" <djwong@kernel.org>
Date: Thu, 10 Nov 2022 12:16:34 -0800
Subject: [PATCH] ext4: don't fail GETFSUUID when the caller provides a long
 buffer

If userspace provides a longer UUID buffer than is required, we
shouldn't fail the call with EINVAL -- rather, we can fill the caller's
buffer with the bytes we /can/ fill, and update the length field to
reflect what we copied.  This doesn't break the UAPI since we're
enabling a case that currently fails, and so far Ted hasn't released a
version of e2fsprogs that uses the new ext4 ioctl.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Catherine Hoang <catherine.hoang@oracle.com>
Link: https://lore.kernel.org/r/166811139478.327006.13879198441587445544.stgit@magnolia
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: stable@kernel.org

diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index beedaebab21c..202953b5db49 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -1160,14 +1160,16 @@ static int ext4_ioctl_getuuid(struct ext4_sb_info *sbi,
 		return 0;
 	}
 
-	if (fsuuid.fsu_len != UUID_SIZE || fsuuid.fsu_flags != 0)
+	if (fsuuid.fsu_len < UUID_SIZE || fsuuid.fsu_flags != 0)
 		return -EINVAL;
 
 	lock_buffer(sbi->s_sbh);
 	memcpy(uuid, sbi->s_es->s_uuid, UUID_SIZE);
 	unlock_buffer(sbi->s_sbh);
 
-	if (copy_to_user(&ufsuuid->fsu_uuid[0], uuid, UUID_SIZE))
+	fsuuid.fsu_len = UUID_SIZE;
+	if (copy_to_user(ufsuuid, &fsuuid, sizeof(fsuuid)) ||
+	    copy_to_user(&ufsuuid->fsu_uuid[0], uuid, UUID_SIZE))
 		return -EFAULT;
 	return 0;
 }

