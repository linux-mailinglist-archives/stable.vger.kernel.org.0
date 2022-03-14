Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5421F4D8223
	for <lists+stable@lfdr.de>; Mon, 14 Mar 2022 12:59:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240038AbiCNMAi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Mar 2022 08:00:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240004AbiCNMAX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Mar 2022 08:00:23 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 587482719;
        Mon, 14 Mar 2022 04:58:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 4A4A1CE1265;
        Mon, 14 Mar 2022 11:58:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 227B7C340E9;
        Mon, 14 Mar 2022 11:58:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647259097;
        bh=M8ax33quUGmZY4WEvx5nH5KNIApyPzylG8aYXe9hmrg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1PUygYS/+71FTFKMEelV2/12H69RUsMtRzMoywNk4PP6xQoIlD/VPSYUyKL5p21ch
         WvCzeSqD9wBJOVl0nGkpyGvfacEdH9ftVDByJ/g/nW8R93MsIGGDuE5r1CpxYMf9ko
         dX21fcMB+84ZY6CQt1S+AlYI/flsQyVJ3zTBDtNQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josh Triplett <josh@joshtriplett.org>,
        Theodore Tso <tytso@mit.edu>
Subject: [PATCH 5.4 39/43] ext4: add check to prevent attempting to resize an fs with sparse_super2
Date:   Mon, 14 Mar 2022 12:53:50 +0100
Message-Id: <20220314112735.516023170@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220314112734.415677317@linuxfoundation.org>
References: <20220314112734.415677317@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josh Triplett <josh@joshtriplett.org>

commit b1489186cc8391e0c1e342f9fbc3eedf6b944c61 upstream.

The in-kernel ext4 resize code doesn't support filesystem with the
sparse_super2 feature. It fails with errors like this and doesn't finish
the resize:
EXT4-fs (loop0): resizing filesystem from 16640 to 7864320 blocks
EXT4-fs warning (device loop0): verify_reserved_gdb:760: reserved GDT 2 missing grp 1 (32770)
EXT4-fs warning (device loop0): ext4_resize_fs:2111: error (-22) occurred during file system resize
EXT4-fs (loop0): resized filesystem to 2097152

To reproduce:
mkfs.ext4 -b 4096 -I 256 -J size=32 -E resize=$((256*1024*1024)) -O sparse_super2 ext4.img 65M
truncate -s 30G ext4.img
mount ext4.img /mnt
python3 -c 'import fcntl, os, struct ; fd = os.open("/mnt", os.O_RDONLY | os.O_DIRECTORY) ; fcntl.ioctl(fd, 0x40086610, struct.pack("Q", 30 * 1024 * 1024 * 1024 // 4096), False) ; os.close(fd)'
dmesg | tail
e2fsck ext4.img

The userspace resize2fs tool has a check for this case: it checks if the
filesystem has sparse_super2 set and if the kernel provides
/sys/fs/ext4/features/sparse_super2. However, the former check requires
manually reading and parsing the filesystem superblock.

Detect this case in ext4_resize_begin and error out early with a clear
error message.

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
Link: https://lore.kernel.org/r/74b8ae78405270211943cd7393e65586c5faeed1.1623093259.git.josh@joshtriplett.org
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/resize.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -74,6 +74,11 @@ int ext4_resize_begin(struct super_block
 		return -EPERM;
 	}
 
+	if (ext4_has_feature_sparse_super2(sb)) {
+		ext4_msg(sb, KERN_ERR, "Online resizing not supported with sparse_super2");
+		return -EOPNOTSUPP;
+	}
+
 	if (test_and_set_bit_lock(EXT4_FLAGS_RESIZING,
 				  &EXT4_SB(sb)->s_ext4_flags))
 		ret = -EBUSY;


