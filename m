Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 205B76DEEC5
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 10:45:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230489AbjDLIpA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 04:45:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231161AbjDLIoh (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 04:44:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 869AA8A50
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 01:44:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A2418630A5
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 08:44:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B50A6C433EF;
        Wed, 12 Apr 2023 08:43:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681289040;
        bh=Wgc+uXACuvOJerjVPlegHD8mMmjz8y+qUt0YA9WlrwI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Af9m3cTIlsbT6ouy1vBJLEak/ajAluBRL62mJP6je6I2B8WRzvKWCMzW73SoqYpuU
         ZUdpxDz4CcPRIL6XfxPQpNnEFNnAFCIheODEEU+cpb7QzrCzsHO8Qo71Cp+k77ran2
         m8wensC55GLC+g9gGdvmVq8MvYQsprsZVM1t7RoY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Ryusuke Konishi <konishi.ryusuke@gmail.com>,
        syzbot+979fa7f9c0d086fdc282@syzkaller.appspotmail.com,
        syzbot+5b7d542076d9bddc3c6a@syzkaller.appspotmail.com,
        Viacheslav Dubeyko <slava@dubeyko.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.1 083/164] nilfs2: fix sysfs interface lifetime
Date:   Wed, 12 Apr 2023 10:33:25 +0200
Message-Id: <20230412082840.273279080@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082836.695875037@linuxfoundation.org>
References: <20230412082836.695875037@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ryusuke Konishi <konishi.ryusuke@gmail.com>

commit 42560f9c92cc43dce75dbf06cc0d840dced39b12 upstream.

The current nilfs2 sysfs support has issues with the timing of creation
and deletion of sysfs entries, potentially leading to null pointer
dereferences, use-after-free, and lockdep warnings.

Some of the sysfs attributes for nilfs2 per-filesystem instance refer to
metadata file "cpfile", "sufile", or "dat", but
nilfs_sysfs_create_device_group that creates those attributes is executed
before the inodes for these metadata files are loaded, and
nilfs_sysfs_delete_device_group which deletes these sysfs entries is
called after releasing their metadata file inodes.

Therefore, access to some of these sysfs attributes may occur outside of
the lifetime of these metadata files, resulting in inode NULL pointer
dereferences or use-after-free.

In addition, the call to nilfs_sysfs_create_device_group() is made during
the locking period of the semaphore "ns_sem" of nilfs object, so the
shrinker call caused by the memory allocation for the sysfs entries, may
derive lock dependencies "ns_sem" -> (shrinker) -> "locks acquired in
nilfs_evict_inode()".

Since nilfs2 may acquire "ns_sem" deep in the call stack holding other
locks via its error handler __nilfs_error(), this causes lockdep to report
circular locking.  This is a false positive and no circular locking
actually occurs as no inodes exist yet when
nilfs_sysfs_create_device_group() is called.  Fortunately, the lockdep
warnings can be resolved by simply moving the call to
nilfs_sysfs_create_device_group() out of "ns_sem".

This fixes these sysfs issues by revising where the device's sysfs
interface is created/deleted and keeping its lifetime within the lifetime
of the metadata files above.

Link: https://lkml.kernel.org/r/20230330205515.6167-1-konishi.ryusuke@gmail.com
Fixes: dd70edbde262 ("nilfs2: integrate sysfs support into driver")
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Reported-by: syzbot+979fa7f9c0d086fdc282@syzkaller.appspotmail.com
  Link: https://lkml.kernel.org/r/0000000000003414b505f7885f7e@google.com
Reported-by: syzbot+5b7d542076d9bddc3c6a@syzkaller.appspotmail.com
  Link: https://lkml.kernel.org/r/0000000000006ac86605f5f44eb9@google.com
Cc: Viacheslav Dubeyko <slava@dubeyko.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nilfs2/super.c     |    2 ++
 fs/nilfs2/the_nilfs.c |   12 +++++++-----
 2 files changed, 9 insertions(+), 5 deletions(-)

--- a/fs/nilfs2/super.c
+++ b/fs/nilfs2/super.c
@@ -482,6 +482,7 @@ static void nilfs_put_super(struct super
 		up_write(&nilfs->ns_sem);
 	}
 
+	nilfs_sysfs_delete_device_group(nilfs);
 	iput(nilfs->ns_sufile);
 	iput(nilfs->ns_cpfile);
 	iput(nilfs->ns_dat);
@@ -1105,6 +1106,7 @@ nilfs_fill_super(struct super_block *sb,
 	nilfs_put_root(fsroot);
 
  failed_unload:
+	nilfs_sysfs_delete_device_group(nilfs);
 	iput(nilfs->ns_sufile);
 	iput(nilfs->ns_cpfile);
 	iput(nilfs->ns_dat);
--- a/fs/nilfs2/the_nilfs.c
+++ b/fs/nilfs2/the_nilfs.c
@@ -87,7 +87,6 @@ void destroy_nilfs(struct the_nilfs *nil
 {
 	might_sleep();
 	if (nilfs_init(nilfs)) {
-		nilfs_sysfs_delete_device_group(nilfs);
 		brelse(nilfs->ns_sbh[0]);
 		brelse(nilfs->ns_sbh[1]);
 	}
@@ -305,6 +304,10 @@ int load_nilfs(struct the_nilfs *nilfs,
 		goto failed;
 	}
 
+	err = nilfs_sysfs_create_device_group(sb);
+	if (unlikely(err))
+		goto sysfs_error;
+
 	if (valid_fs)
 		goto skip_recovery;
 
@@ -366,6 +369,9 @@ int load_nilfs(struct the_nilfs *nilfs,
 	goto failed;
 
  failed_unload:
+	nilfs_sysfs_delete_device_group(nilfs);
+
+ sysfs_error:
 	iput(nilfs->ns_cpfile);
 	iput(nilfs->ns_sufile);
 	iput(nilfs->ns_dat);
@@ -697,10 +703,6 @@ int init_nilfs(struct the_nilfs *nilfs,
 	if (err)
 		goto failed_sbh;
 
-	err = nilfs_sysfs_create_device_group(sb);
-	if (err)
-		goto failed_sbh;
-
 	set_nilfs_init(nilfs);
 	err = 0;
  out:


