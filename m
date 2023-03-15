Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8151D6BB215
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 13:32:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232582AbjCOMcm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 08:32:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232636AbjCOMcU (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 08:32:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 756589AFCF
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 05:31:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 943B1B81E07
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 12:31:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE191C433D2;
        Wed, 15 Mar 2023 12:31:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678883499;
        bh=ERpzxbU+SOozA21adsbkNltdn7p8b1ULPUYkfYvRTjI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mCwT5tRxtIpxpg8zahnSbSU0G3NEZ21PUVY2aP7QGwKqKg5SYOUCpAe8ncgwT0Pbs
         XHa+bh9A0M2srE0l6GBGoQS6yG6zuyCXAS5fA8b3AeaDhS8HX/j8ugNy+6n1513lA/
         qPtbuiZEFTjd1/VxlU2BVddvHATRcERYKDQEv8b0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, stable@kernel.org,
        Zhihao Cheng <chengzhihao1@huawei.com>,
        Theodore Tso <tytso@mit.edu>
Subject: [PATCH 6.1 022/143] ext4: zero i_disksize when initializing the bootloader inode
Date:   Wed, 15 Mar 2023 13:11:48 +0100
Message-Id: <20230315115741.181471624@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115740.429574234@linuxfoundation.org>
References: <20230315115740.429574234@linuxfoundation.org>
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

From: Zhihao Cheng <chengzhihao1@huawei.com>

commit f5361da1e60d54ec81346aee8e3d8baf1be0b762 upstream.

If the boot loader inode has never been used before, the
EXT4_IOC_SWAP_BOOT inode will initialize it, including setting the
i_size to 0.  However, if the "never before used" boot loader has a
non-zero i_size, then i_disksize will be non-zero, and the
inconsistency between i_size and i_disksize can trigger a kernel
warning:

 WARNING: CPU: 0 PID: 2580 at fs/ext4/file.c:319
 CPU: 0 PID: 2580 Comm: bb Not tainted 6.3.0-rc1-00004-g703695902cfa
 RIP: 0010:ext4_file_write_iter+0xbc7/0xd10
 Call Trace:
  vfs_write+0x3b1/0x5c0
  ksys_write+0x77/0x160
  __x64_sys_write+0x22/0x30
  do_syscall_64+0x39/0x80

Reproducer:
 1. create corrupted image and mount it:
       mke2fs -t ext4 /tmp/foo.img 200
       debugfs -wR "sif <5> size 25700" /tmp/foo.img
       mount -t ext4 /tmp/foo.img /mnt
       cd /mnt
       echo 123 > file
 2. Run the reproducer program:
       posix_memalign(&buf, 1024, 1024)
       fd = open("file", O_RDWR | O_DIRECT);
       ioctl(fd, EXT4_IOC_SWAP_BOOT);
       write(fd, buf, 1024);

Fix this by setting i_disksize as well as i_size to zero when
initiaizing the boot loader inode.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=217159
Cc: stable@kernel.org
Signed-off-by: Zhihao Cheng <chengzhihao1@huawei.com>
Link: https://lore.kernel.org/r/20230308032643.641113-1-chengzhihao1@huawei.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/ioctl.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -434,6 +434,7 @@ static long swap_inode_boot_loader(struc
 		ei_bl->i_flags = 0;
 		inode_set_iversion(inode_bl, 1);
 		i_size_write(inode_bl, 0);
+		EXT4_I(inode_bl)->i_disksize = inode_bl->i_size;
 		inode_bl->i_mode = S_IFREG;
 		if (ext4_has_feature_extents(sb)) {
 			ext4_set_inode_flag(inode_bl, EXT4_INODE_EXTENTS);


