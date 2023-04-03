Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE9D96D46B1
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 16:12:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230044AbjDCOMo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 10:12:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232774AbjDCOMg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 10:12:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44B387A8B
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 07:12:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D245661C4E
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 14:12:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E775EC433D2;
        Mon,  3 Apr 2023 14:12:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680531145;
        bh=RP6y+Id1OQBK6p8YpNMT1vkhWQR+KWxDMinrRBlcPXI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tDEG0xete/4Vl/qrPqT3A4tJ74TXBcKgPyRu9QKi95FOJOro2elSSh9QOVU9n27XW
         seWcCKRI7g/gJvVxW0KugiPe0t38ADxwofINMzdDz+YyjYIVEmjsdsfdWueO4bfVOQ
         KRLPJmt6BrT/ihv8oD4dnYNPzoXxgPNEDxtE/WU0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Ryusuke Konishi <konishi.ryusuke@gmail.com>,
        syzbot+132fdd2f1e1805fdc591@syzkaller.appspotmail.com,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 4.14 36/66] nilfs2: fix kernel-infoleak in nilfs_ioctl_wrap_copy()
Date:   Mon,  3 Apr 2023 16:08:44 +0200
Message-Id: <20230403140353.155571558@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140351.636471867@linuxfoundation.org>
References: <20230403140351.636471867@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ryusuke Konishi <konishi.ryusuke@gmail.com>

commit 003587000276f81d0114b5ce773d80c119d8cb30 upstream.

The ioctl helper function nilfs_ioctl_wrap_copy(), which exchanges a
metadata array to/from user space, may copy uninitialized buffer regions
to user space memory for read-only ioctl commands NILFS_IOCTL_GET_SUINFO
and NILFS_IOCTL_GET_CPINFO.

This can occur when the element size of the user space metadata given by
the v_size member of the argument nilfs_argv structure is larger than the
size of the metadata element (nilfs_suinfo structure or nilfs_cpinfo
structure) on the file system side.

KMSAN-enabled kernels detect this issue as follows:

 BUG: KMSAN: kernel-infoleak in instrument_copy_to_user
 include/linux/instrumented.h:121 [inline]
 BUG: KMSAN: kernel-infoleak in _copy_to_user+0xc0/0x100 lib/usercopy.c:33
  instrument_copy_to_user include/linux/instrumented.h:121 [inline]
  _copy_to_user+0xc0/0x100 lib/usercopy.c:33
  copy_to_user include/linux/uaccess.h:169 [inline]
  nilfs_ioctl_wrap_copy+0x6fa/0xc10 fs/nilfs2/ioctl.c:99
  nilfs_ioctl_get_info fs/nilfs2/ioctl.c:1173 [inline]
  nilfs_ioctl+0x2402/0x4450 fs/nilfs2/ioctl.c:1290
  nilfs_compat_ioctl+0x1b8/0x200 fs/nilfs2/ioctl.c:1343
  __do_compat_sys_ioctl fs/ioctl.c:968 [inline]
  __se_compat_sys_ioctl+0x7dd/0x1000 fs/ioctl.c:910
  __ia32_compat_sys_ioctl+0x93/0xd0 fs/ioctl.c:910
  do_syscall_32_irqs_on arch/x86/entry/common.c:112 [inline]
  __do_fast_syscall_32+0xa2/0x100 arch/x86/entry/common.c:178
  do_fast_syscall_32+0x37/0x80 arch/x86/entry/common.c:203
  do_SYSENTER_32+0x1f/0x30 arch/x86/entry/common.c:246
  entry_SYSENTER_compat_after_hwframe+0x70/0x82

 Uninit was created at:
  __alloc_pages+0x9f6/0xe90 mm/page_alloc.c:5572
  alloc_pages+0xab0/0xd80 mm/mempolicy.c:2287
  __get_free_pages+0x34/0xc0 mm/page_alloc.c:5599
  nilfs_ioctl_wrap_copy+0x223/0xc10 fs/nilfs2/ioctl.c:74
  nilfs_ioctl_get_info fs/nilfs2/ioctl.c:1173 [inline]
  nilfs_ioctl+0x2402/0x4450 fs/nilfs2/ioctl.c:1290
  nilfs_compat_ioctl+0x1b8/0x200 fs/nilfs2/ioctl.c:1343
  __do_compat_sys_ioctl fs/ioctl.c:968 [inline]
  __se_compat_sys_ioctl+0x7dd/0x1000 fs/ioctl.c:910
  __ia32_compat_sys_ioctl+0x93/0xd0 fs/ioctl.c:910
  do_syscall_32_irqs_on arch/x86/entry/common.c:112 [inline]
  __do_fast_syscall_32+0xa2/0x100 arch/x86/entry/common.c:178
  do_fast_syscall_32+0x37/0x80 arch/x86/entry/common.c:203
  do_SYSENTER_32+0x1f/0x30 arch/x86/entry/common.c:246
  entry_SYSENTER_compat_after_hwframe+0x70/0x82

 Bytes 16-127 of 3968 are uninitialized
 ...

This eliminates the leak issue by initializing the page allocated as
buffer using get_zeroed_page().

Link: https://lkml.kernel.org/r/20230307085548.6290-1-konishi.ryusuke@gmail.com
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Reported-by: syzbot+132fdd2f1e1805fdc591@syzkaller.appspotmail.com
  Link: https://lkml.kernel.org/r/000000000000a5bd2d05f63f04ae@google.com
Tested-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nilfs2/ioctl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/nilfs2/ioctl.c
+++ b/fs/nilfs2/ioctl.c
@@ -79,7 +79,7 @@ static int nilfs_ioctl_wrap_copy(struct
 	if (argv->v_index > ~(__u64)0 - argv->v_nmembs)
 		return -EINVAL;
 
-	buf = (void *)__get_free_pages(GFP_NOFS, 0);
+	buf = (void *)get_zeroed_page(GFP_NOFS);
 	if (unlikely(!buf))
 		return -ENOMEM;
 	maxmembs = PAGE_SIZE / argv->v_size;


