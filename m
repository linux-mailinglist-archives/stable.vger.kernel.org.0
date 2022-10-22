Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D9C06085F5
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 09:42:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230380AbiJVHmO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 03:42:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231126AbiJVHls (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 03:41:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C127543E2;
        Sat, 22 Oct 2022 00:39:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5D460B82DFA;
        Sat, 22 Oct 2022 07:38:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2E19C433C1;
        Sat, 22 Oct 2022 07:38:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666424332;
        bh=ecbJtZtbTxTy0Xaol6OENYdH2Dt+6dzVljS18GKzyfU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iEzGLTg8kNz3MxHKDmfd2im+pD9sb3wh3MI45pdB0xljEmpFUtgpGqTI/CcEFCtmj
         n3AiuxKJxxk+8hP/Api/AR9RQWaKgxRUGVN6qZdvbQ/AyCuZV9V7+SzgoLhR4nuCVD
         iJAb00Mzed5I0lJzGam1FvQyoQK+QrX/WaGh+h18=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexander Zhu <alexlzhu@fb.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.19 107/717] btrfs: fix alignment of VMA for memory mapped files on THP
Date:   Sat, 22 Oct 2022 09:19:46 +0200
Message-Id: <20221022072434.370971359@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221022072415.034382448@linuxfoundation.org>
References: <20221022072415.034382448@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Zhu <alexlzhu@fb.com>

commit b0c582233a8563f3c4228df838cdc67a8807ec78 upstream.

With CONFIG_READ_ONLY_THP_FOR_FS, the Linux kernel supports using THPs for
read-only mmapped files, such as shared libraries. However, the kernel
makes no attempt to actually align those mappings on 2MB boundaries,
which makes it impossible to use those THPs most of the time. This issue
applies to general file mapping THP as well as existing setups using
CONFIG_READ_ONLY_THP_FOR_FS. This is easily fixed by using
thp_get_unmapped_area for the unmapped_area function in btrfs, which
is what ext2, ext4, fuse, and xfs all use.

Initially btrfs had been left out in commit 8c07fc452ac0 ("btrfs: fix
alignment of VMA for memory mapped files on THP") as btrfs does not support
DAX. However, commit 1854bc6e2420 ("mm/readahead: Align file mappings
for non-DAX") removed the DAX requirement. We should now be able to call
thp_get_unmapped_area() for btrfs.

The problem can be seen in /proc/PID/smaps where THPeligible is set to 0
on mappings to eligible shared object files as shown below.

Before this patch:

  7fc6a7e18000-7fc6a80cc000 r-xp 00000000 00:1e 199856
  /usr/lib64/libcrypto.so.1.1.1k
  Size:               2768 kB
  THPeligible:    0
  VmFlags: rd ex mr mw me

With this patch the library is mapped at a 2MB aligned address:

  fbdfe200000-7fbdfe4b4000 r-xp 00000000 00:1e 199856
  /usr/lib64/libcrypto.so.1.1.1k
  Size:               2768 kB
  THPeligible:    1
  VmFlags: rd ex mr mw me

This fixes the alignment of VMAs for any mmap of a file that has the
rd and ex permissions and size >= 2MB. The VMA alignment and
THPeligible field for anonymous memory is handled separately and
is thus not effected by this change.

CC: stable@vger.kernel.org # 5.18+
Signed-off-by: Alexander Zhu <alexlzhu@fb.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/file.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 5a3f6e0d9688..8dfce1c40b5f 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -3810,6 +3810,7 @@ const struct file_operations btrfs_file_operations = {
 	.mmap		= btrfs_file_mmap,
 	.open		= btrfs_file_open,
 	.release	= btrfs_release_file,
+	.get_unmapped_area = thp_get_unmapped_area,
 	.fsync		= btrfs_sync_file,
 	.fallocate	= btrfs_fallocate,
 	.unlocked_ioctl	= btrfs_ioctl,
-- 
2.38.0



